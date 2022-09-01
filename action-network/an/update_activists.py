"""Update activist actions BigQuery to Action Network"""
import json
import requests
from logger import logging
from database.bigquery import update_activist_actions, select_activist_actions_update


def update_activists(community_id: int, start_date: str, end_date: str, background: bool = False):
    """Submit activist actions BigQuery to Action Network"""
    dataframe = select_activist_actions_update(
        community_id=community_id, start_date=start_date, end_date=end_date)

    dataframe = dataframe[dataframe['person_id'].notnull()]

    for i, item in dataframe.iterrows():  # pylint: disable=unused-variable
        payload = dict(
            person=dict(
                family_name=item['family_name'],
            )
        )
        
        # CUSTOM FIELDS
        custom_fields = dict()
        if item['region']:
            custom_fields['estado'] = item['region']
        if item['locality']:
            custom_fields['cidade'] = item['locality']

        payload['person']['custom_fields'] = custom_fields


        # Mount endpoint to request
        endpoint = f"https://actionnetwork.org/api/v2/people/{item['person_id']}/"
 
        logging.info(
            f"PUT ActivistAction {item['action_id']} to ActionNetwork {item['an_resource_name']}.")

        headers = {
            'OSDI-API-Token': item['an_group_id'],
            'Content-Type': 'application/json'
        }
        response = requests.request(
            "PUT", endpoint, data=json.dumps(payload), headers=headers)

        if response.status_code == 200:
            update_activist_actions(an_response=json.dumps(
                response.json()), action_id=item['action_id'], action=item['action'])
        else:
            update_activist_actions(an_response=json.dumps(
                response.json()), action_id=item['action_id'], action=item['action'])

        logging.info(f"PUT ActivistAction {item['action_id']} is done.")
