"""Criar Forms"""
import json
import requests
from database.bigquery import insert_actions, select_groups
from database.postgres import cnx
import pandas as pd


def form_sync_actions(community_id: int):
    """Insert form widgets Bonde on forms Action Network"""
    df = pd.read_sql_query(f'''
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
      WHERE c.id = {community_id} AND w.kind = 'form'
    ''', cnx)

    # Merge postgres pressure widgets with bigquery groups
    df = pd.merge(df, select_groups(), how='left', on='community_id')

    for index, item in df.iterrows():
        headers = {
            'OSDI-API-Token': item['an_group_id'],
            'Content-Type': 'application/json'
        }

        # https://actionnetwork.org/api/v2/forms
        payload = dict(
            id=item['mobilization_id'],
            title=f"{item['mobilization_name']}#{item['widgets_id']}",
            description=item['mobilization_description'],
            origin_system="Bonde.org (Integration)"
        )

        response = requests.post(
            "https://actionnetwork.org/api/v2/forms/", data=json.dumps(payload), headers=headers)

        # salva o id e a mobilization_id, widgets_id em um df
        if response.status_code == 200:
            an_action = response.json()
            an_action_id = list(filter(lambda x: x.startswith(
                'action_network:'), an_action['identifiers']))[0]
            an_resource_name = 'signatures'
            an_action_id = an_action_id.split(':')[1]
            mobilization_id = payload['id']

            df_an = pd.DataFrame()
            df_an['community_id'] = pd.Series([community_id], dtype="int")
            df_an['mobilization_id'] = pd.Series(
                [mobilization_id], dtype="int")
            df_an['widget_id'] = pd.Series(item['widgets_id'], dtype="int")
            df_an['an_action_id'] = pd.Series([an_action_id], dtype="string")
            df_an['an_resource_name'] = an_resource_name
            df_an['an_response'] = pd.Series([an_action], dtype="string")

            insert_actions(df_an)
        else:
            an_action = response.json()
            an_resource_name = 'submissions'
            mobilization_id = payload['id']

            df_an = pd.DataFrame()
            df_an['community_id'] = pd.Series([community_id], dtype="int")
            df_an['mobilization_id'] = pd.Series(
                [mobilization_id], dtype="int")
            df_an['widget_id'] = pd.Series(item['widgets_id'], dtype="int")
            df_an['an_resource_name'] = an_resource_name
            df_an['an_response'] = pd.Series([an_action], dtype="string")

            insert_actions(df_an)