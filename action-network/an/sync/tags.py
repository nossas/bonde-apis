"""Criar Tags"""
import os
import json
import requests
from database.postgres import cnx
import pandas as pd

ACTION_NETWORK_API_KEY = os.getenv('ACTION_NETWORK_API_KEY', 'xxxxx')


def sync_tags():
    """Insert subthemes Bonde on tags Action Network"""
    df = pd.read_sql_query('SELECT label, value FROM subthemes s', cnx)

    # insert in Nossas Group

    for index, item in df.iterrows():
        headers = {
            'OSDI-API-Token': ACTION_NETWORK_API_KEY,
            'Content-Type': 'application/json'
        }

        # https://actionnetwork.org/api/v2/tags
        payload = dict(
            name=item['label'],
        )

        response = requests.post(
            "https://actionnetwork.org/api/v2/tags/", data=json.dumps(payload), headers=headers)

        if response.status_code == 200:
            print(response.json())
        else:
            print(response.json())
