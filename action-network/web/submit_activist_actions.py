import requests
import json
import pandas as pd
from time import perf_counter
from threading import Thread
from database import engine, log_activist_actions
from datetime import datetime

sql = f"""
SELECT
    aa.action,
    aa.action_id,
    aa.action_date,
    aa.widget_id,
    aa.mobilization_id,
    aa.community_id,
    aa.email,
    aa.name,
    aa.given_name,
    aa.family_name,
    aa.address_line,
    aa.locality,
    aa.region,
    aa.postal_code,
    aa.phone,
    aa.gender,
    aa.color,
    aa.birthday,
    aa.metadata,
    a.an_action_id,
    a.mobilization_name,
    a.an_resource_name,
    c.an_group_id,
    log_aa.an_response
FROM "analyze".activist_actions aa
INNER JOIN "analyze".actions a ON a.widget_id = aa.widget_id
INNER JOIN "public".communities c ON c.id = a.community_id
FULL OUTER JOIN "analyze".log_activist_actions log_aa ON log_aa.action_id = aa.action_id AND log_aa.action = aa.action
WHERE c.an_group_id = '480c0e20e4543eb9b62eaed6db946d35'
AND log_aa.an_response IS NULL
AND aa.action = 'plip'
"""

themes = pd.read_sql_query(f"""SELECT * FROM "analyze".themes""", engine).to_dict(orient='records')

def submit(query_sql, thread_name):
    print(f"{thread_name}: Starting actions submit")
    df = pd.read_sql_query(query_sql, engine)

    limit_size = int(len(df) * 0.01)
    
    print(f"{thread_name}: Limit size {limit_size} by {len(df)}")
    insert_streaming = []

    for i, item in df.iterrows():
        try:
            payload = dict(
                person=dict(
                    given_name=item['given_name'],
                    family_name=item['family_name'],
                    email_addresses=[dict(address=item['email'])],
                    languages_spoken=['pt-BR']
                )
            )

            if item['action'] == 'donation':
                payload['created_date'] = item.action_date[0:19]
                payload['recipients'] = [dict(
                    display_name=item['mobilization_name'],
                    amount=item['metadata']['amount']
                )]

                if item['metadata']['recurring']:
                    payload['action_network:recurrence'] = dict(
                        recurring=item['metadata']['recurring'],
                        period=item['metadata']['recurring_period']
                    )

            if item['phone']:
                payload['person']['phone_numbers'] = [dict(number=item.phone)]

            address = dict()
            if item['locality']:
                address['locality'] = item['locality']

            if item.region:
                address['region'] = f"BR-{item['region']}"

            address['country'] = 'BR'
            payload['person']['postal_addresses'] = [address]

            custom_fields = dict()
            if item['gender']:
                custom_fields['gender'] = item['gender']

            if item['color']:
                custom_fields['color'] = item['color']

            if item['region']:
                custom_fields['estado'] = item['region']

            if item['locality']:
                custom_fields['cidade'] = item['locality']


            tags = [x['theme'] for x in filter(lambda y: y['mobilization_id'] == item['mobilization_id'], themes)]
            
            if item.action == 'plip':
                custom_fields['assinaturas_esperadas'] = item['metadata']['expected_signatures']
                custom_fields['data_ficha_gerada'] = item.action_date[0:19]
                tags.append(item['metadata']['type_form'])

            if len(custom_fields.keys()) > 0:
                payload['person']['custom_fields'] = custom_fields

            if len(tags) > 0:
                payload['add_tags'] = tags

            endpoint = 'https://actionnetwork.org/api/v2'
            if item['action'] == "form" or item['action'] == "plip":
                endpoint += f"/forms/{item['an_action_id']}"
            if item['action'] == "pressure":
                endpoint += f"/petitions/{item['an_action_id']}"
            if item['action'] == "donation":
                endpoint += f"/fundraising_pages/{item['an_action_id']}"
            
            endpoint += f"/{item['an_resource_name']}"

            headers = {
                'OSDI-API-Token': item['an_group_id'],
                'Content-Type': 'application/json'
            }
            
            print(f"{thread_name}: Connecting {item['an_group_id']} on Action Network API")
            # print(f"{thread_name}: {endpoint} ...")

            data = json.dumps(payload)
            # print(data)
            an_response = requests.request("POST", endpoint, data=data, headers=headers, timeout=(5, 20))
            
            print(f"{thread_name}: Response {an_response.status_code}")
            if an_response.status_code == 200:
                insert_streaming.append(dict(
                    an_response=an_response.json(),
                    action_id=item['action_id'],
                    action=item['action'],
                    created_at=datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                    community_id=item['community_id'],
                    widget_id=item['widget_id']
                ))
            else:
                insert_streaming.append(dict(
                    an_response=an_response.json(),
                    action_id=item['action_id'],
                    action=item['action'],
                    created_at=datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                    community_id=item['community_id'],
                    widget_id=item['widget_id']
                ))

            if len(insert_streaming) >= limit_size:
                print(f"{thread_name}: Connecting PostgreSQL...")
                engine.execute(log_activist_actions.insert(), insert_streaming)
                print(f"{thread_name}: Registered {len(insert_streaming)} logs")
                insert_streaming = []

        except Exception as error: # pylint: disable=broad-except
            if len(insert_streaming) > 0:
                engine.execute(log_activist_actions.insert(), insert_streaming)
                insert_streaming = []

            print(f"{thread_name}: {error}")
            # notify(f"Widget ID: {item['action_id']} // Kind: {item['action']} // {error}")
        finally:
            print(f"{thread_name}: POST ActivistAction {item['action_id']} is done.")
            # logging.info(f"POST ActivistAction {item['action_id']} is done.")

    if len(insert_streaming) > 0:
        engine.execute(log_activist_actions.insert(), insert_streaming)
        insert_streaming = []

if __name__ == '__main__':
    start_time = perf_counter()
    threads = []

    for x in range(4):
        offset = x * 5836
        t = Thread(target=submit, args=(sql + f" OFFSET {offset} LIMIT 5836", f"Thread {x}"))
        threads.append(t)
        t.start()
    
    for t in threads:
        t.join()
    
    end_time = perf_counter()

    print(f'Processo de inserção {end_time - start_time: 0.2f} segundo(s).')
