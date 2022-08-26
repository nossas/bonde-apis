"""Submit activist actions BigQuery to Action Network"""
import json
import requests
from logger import logging
from database.bigquery import select_activist_actions, select_themes, update_activist_actions


def submit_actions(community_id: int, start_date: str, end_date: str, background: bool = False):
    """Submit activist actions BigQuery to Action Network"""
    dataframe = select_activist_actions(
        community_id=community_id, start_date=start_date, end_date=end_date)

    dataframe = dataframe[dataframe['an_response'].isnull()]

    themes = select_themes()

    for i, item in dataframe.iterrows():  # pylint: disable=unused-variable
        payload = dict(
            person=dict(
                given_name=item['given_name'],
                family_name=item['given_name'],
                email_addresses=[dict(address=item['email'])],
                languages_spoken=['pt-BR']
            )
        )

        if item['action'] == 'donation':
            payload['recipients'] = [
                dict(display_name=item['mobilization_name'],
                     amount=f"{item['amount'][:-2]}.{item['amount'][-2:]}")
            ]

            payload['created_date'] = str(item['action_date'])[:19]

        if item['phone']:
            payload['person']['phone_numbers'] = [dict(number=item['phone'])]

        # ADDRESS
        address = dict()
        if item['locality']:
            address['locality'] = item['locality']
        if item['region']:
            address['region'] = f"BR-{item['region']}"

        address['country'] = 'BR'
        payload['person']['postal_addresses'] = [address]

        # CUSTOM FIELDS
        custom_fields = dict()
        if item['gender']:
            custom_fields['gender'] = item['gender']
        if item['color']:
            custom_fields['color'] = item['color']
        if item['region']:
            custom_fields['state'] = item['region']

        payload['person']['custom_fields'] = custom_fields

        # TAGS
        tags = [a[1]['theme'] for a in filter(
            lambda x: x[1]['mobilization_id'] == item['mobilization_id'], themes.iterrows())]  # pylint: disable=cell-var-from-loop
        payload['add_tags'] = tags

        # Mount endpoint to request
        endpoint = 'https://actionnetwork.org/api/v2'
        if item['an_resource_name'] == 'submissions':
            endpoint += f"/forms/{item['an_action_id']}/submissions/"
        elif item['an_resource_name'] == 'signatures':
            endpoint += f"/petitions/{item['an_action_id']}/signatures/"
        elif item['an_resource_name'] == 'donations':
            endpoint += f"/fundraising_pages/{item['an_action_id']}/donations"

        # Define background proccess
        if background:
            endpoint += '?background_request=true'

        logging.info(
            f"POST ActivistAction {item['action_id']} to ActionNetwork {item['an_resource_name']}.")

        headers = {
            'OSDI-API-Token': item['an_group_id'],
            'Content-Type': 'application/json'
        }
        response = requests.request(
            "POST", endpoint, data=json.dumps(payload), headers=headers)

        if response.status_code == 200:
            update_activist_actions(an_response=json.dumps(
                response.json()), action_id=item['action_id'], action=item['action'])
        else:
            update_activist_actions(an_response=json.dumps(
                response.json()), action_id=item['action_id'], action=item['action'])

        logging.info(f"POST ActivistAction {item['action_id']} is done.")
