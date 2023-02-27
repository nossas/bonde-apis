import requests
import json
import pandas as pd
from datetime import datetime
from database import engine, log_activist_actions

sql = f"""
SELECT
    aa.widget_id,
    a.an_action_id,
    c.id as community_id,
    c.an_group_id,
    aa.email,
    ps2.id as action_id,
    ps2.created_at as action_date,
    (
        SELECT min(ps.created_at)
	FROM plip_signatures as ps
	WHERE ps.widget_id = aa.widget_id
	AND ps.email = aa.email
    ) as first_action_date,
    log_aa.an_response->'_links'->'self'->>'href' as submission_uri,
    log_aa.an_response->'_links'->'osdi:form'->>'href' as form_uri,
    log_aa.an_response->'_links'->'osdi:person'->>'href' as person_uri,
    COALESCE((
	SELECT sum(ps.confirmed_signatures)
        FROM plip_signatures as ps
	WHERE ps.widget_id = aa.widget_id
	AND ps.email = aa.email
    ), 0) as confirmed_signatures
FROM "analyze".activist_actions aa
INNER JOIN "analyze".actions a ON a.widget_id = aa.widget_id
INNER JOIN "public".communities c ON c.id = aa.community_id
INNER JOIN "public".plip_signatures ps2 ON ps2.unique_identifier = aa.metadata->>'unique_identifier'
INNER JOIN "analyze".log_activist_actions log_aa ON log_aa.widget_id = aa.widget_id AND log_aa.action_id = aa.action_id
FULL OUTER JOIN "analyze".log_activist_actions log_aa2 ON log_aa2.action_id = ps2.id AND log_aa2.action = 'plip_signature'
WHERE aa.action = 'plip'
AND log_aa2.an_response IS NULL
AND COALESCE((
    SELECT sum(ps.confirmed_signatures)
    FROM plip_signatures as ps
    WHERE ps.widget_id = aa.widget_id
    AND ps.email = aa.email
), 0) > 0
and aa.community_id = 518
ORDER BY ps2.created_at
LIMIT 10
"""

def submit(query_sql, thread_name):
    print(f"{thread_name}: Starting actions submit")
    df = pd.read_sql_query(query_sql, engine)

    print(f"Total: {len(df)}")

    for item in df.to_dict(orient="records"):
        try:

            first_action_date = item['first_action_date'].strftime('%Y-%m-%d %H:%M:%S')
            custom_fields = dict(
                assinaturas_confirmadas=item['confirmed_signatures'],
                data_ficha_entregue=first_action_date
            )

            payload = dict(
                person=dict(
                    email_addresses=[dict(address=item['email'])],
                    custom_fields=custom_fields
                )
            )

            if item['first_action_date'] == item['action_date']:
                payload['add_tags'] = ["Ficha Entregue"]

            print("Submit this payload: ")
            print(payload)

            endpoint = f"{item['form_uri']}/submissions"
            headers = {
                'OSDI-API-Token': item['an_group_id'],
                'Content-Type': 'application/json'
            }

            data = json.dumps(payload)
            an_response = requests.request("POST", endpoint, data=data, headers=headers, timeout=(5, 20))

            import ipdb; ipdb.set_trace()
            values = dict(
                an_response=an_response.json(),
                action_id=item['action_id'],
                action="plip_signature",
                created_at=datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                community_id=item['community_id'],
                widget_id=item['widget_id']
            )
            engine.execute(log_activist_actions.insert(), values)
            print(f"{item['action_id']} {item['email']} is {an_response.status_code}!")

        except Exception as e:
            print(e)


if __name__ == '__main__':
    submit(sql, "No thread")
