"""Criar Petitions"""

from database.bigquery import insert
from database.bigquery import read
from database.postgres import cnx
import pandas as pd
import numpy as np
import requests
import json

df = pd.read_sql_query('''
SELECT
  m.id AS mobilization_id,
  m.name AS mobilization_name,
  m.goal AS mobilization_description,
  m.custom_domain AS domain,
  c.id AS community_id,
  w.id AS widgets_id,
  w.kind as type
FROM widgets w
INNER JOIN blocks b ON b.id = w.block_id
INNER JOIN mobilizations m ON m.id = b.mobilization_id
INNER JOIN communities c ON c.id = m.community_id
WHERE c.id = 263 AND w.kind = 'pressure' ''', cnx)

df = pd.merge(df, read.df_groups, how = 'left', on = 'community_id')

def InsertActions():
    for index, item in df.iterrows():
        headers = {
        'OSDI-API-Token': item['an_group_id'],
        'Content-Type': 'application/json'
        }
      #https://actionnetwork.org/api/v2/petitions
        payload = dict(
            id=item['mobilization_id'],
            title=(item['mobilization_name'], item['widgets_id']),
            description=item['mobilization_description'],
            origin_system=item['domain']
        )
        #print(payload)
        response = requests.post("https://actionnetwork.org/api/v2/petitions/", data=json.dumps(payload), headers=headers)


        #salva o id e a mobilization_id, widgets_id em um df
        if (response.status_code == 200):
            an_action = response.json()
            an_action_id = list(filter(lambda x: x.startswith('action_network:'), an_action['identifiers']))[0]
            an_resource_name = 'signatures'
            mobilization_id = payload['id']
            an_action_id = an_action_id.split(':')[1]
            df_an['mobilization_id'] = pd.Series([mobilization_id], dtype="int")
            df_an['an_action_id'] = pd.Series([an_action_id], dtype="string")
            df_an['widget_id'] = pd.Series(item['widgets_id'], dtype="int")
            df_an['an_resource_name'] = an_resource_name
            df_an['an_response'] = pd.Series([an_action], dtype="string")
            insert(df_an)