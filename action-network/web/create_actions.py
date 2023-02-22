import json
import requests
import pandas as pd
from database import engine as cnx, actions

# community_id = 517

# widgets_id = [
#     "73513",
#     "73359",
#     "16825",
#     "9121",
#     "14545",
#     "23043",
#     "23775",
#     "23824",
#     "23842",
#     "23962",
#     "23354",
#     "25485",
#     "24031",
#     "23978",
#     "23636",
#     "67681",
#     "66978",
#     "71596"
# ]

sql = f"""
    SELECT
        m.id AS mobilization_id,
        m.name AS mobilization_name,
        m.goal AS mobilization_description,
        m.custom_domain AS domain,
        c.id AS community_id,
        c.an_group_id as an_group_id,
        w.id AS widget_id,
        w.kind as widget_kind
    FROM widgets w
    INNER JOIN blocks b ON b.id = w.block_id
    INNER JOIN mobilizations m ON m.id = b.mobilization_id
    INNER JOIN communities c ON c.id = m.community_id
    WHERE w.id = 70801
"""
# WHERE w.id IN ({','.join(widgets_id)})

df = pd.read_sql_query(sql, cnx)
actions_db = []

for index, item in df.iterrows():
    headers = {
        'OSDI-API-Token': item['an_group_id'],
        'Content-Type': 'application/json'
    }

    payload = dict(
        title=f"{item['mobilization_name']}#{item['widget_id']}",
        description=item['mobilization_description'],
        origin_system="BONDE"
    )

    endpoint = "https://actionnetwork.org/api/v2"
    an_resource_name = None

    if item['widget_kind'] == "pressure":
        endpoint += "/petitions"
        an_resource_name = "signatures"

    if item['widget_kind'] == "donation":
        endpoint += "/fundraising_pages"
        an_resource_name = "donations"

    if item['widget_kind'] == "form":
        endpoint += "/forms"
        an_resource_name = "submissions"
    
    if item['widget_kind'] == "plip":
        endpoint += "/forms"
        an_resource_name = "submissions"
    

    response = requests.post(endpoint, data=json.dumps(payload), headers=headers)

    if response.status_code == 200:
        # import ipdb; ipdb.set_trace()
        an_response = response.json()

        an_action_id = list(filter(lambda x: x.startswith('action_network:'), an_response['identifiers']))[0]
        an_action_id = an_action_id.split(':')[1]

        values = dict(
            community_id=item['community_id'],
            mobilization_id=item['mobilization_id'],
            mobilization_name=item['mobilization_name'],
            widget_id=item['widget_id'],
            an_action_id=an_action_id,
            an_resource_name=an_resource_name,
            an_response=an_response
        )

        cnx.execute(actions.insert(), values)
    else:
        an_response = response.json()

        values = dict(
            community_id=item['community_id'],
            mobilization_id=item['mobilization_id'],
            mobilization_name=item['mobilization_name'],
            widget_id=item['widget_id'],
            an_resource_name=an_resource_name,
            an_response=an_response
        )

        cnx.execute(actions.insert(), values)

# try:
#     cnx.execute(actions.insert(), actions)
# except Exception as e:
#     print(e)
#     pd.DataFrame(actions_db).to_csv("/home/iguin13/Repositorios/nossas/actions.csv")
