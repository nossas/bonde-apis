"""Submit activist actions BigQuery to Action Network"""
import json
import requests
from database.bigquery import select_activist_actions, select_themes, update_activist_actions


def submit_actions(community_id: int, start_date: str, end_date: str):
    """Submit activist actions BigQuery to Action Network"""
    df = select_activist_actions(community_id, start_date, end_date)
    df = df[df['an_response'].isnull()]
    themes = select_themes()

    # import ipdb; ipdb.set_trace()
    # df = df[df['email'] == "xxxx"]

    for index, item in df.iterrows():
        payload = dict(
            person=dict(
                given_name=item['given_name'],
                family_name=item['given_name'],
                email_addresses=[dict(address=item['email'])],
                languages_spoken=['pt-BR']
            )
        )

        if item['phone']:
            payload['person']['phone_numbers'] = [dict(number=item['phone'])]

        # ADDRESS
        address = dict()
        if item['locality']:
            address['locality'] = item['locality']
        if item['region']:
            address['region'] = item['region']

        address['country'] = 'BR'
        payload['person']['postal_addresses'] = [address]

        # CUSTOM FIELDS
        payload['person']['custom_fields'] = dict(
            action_date=item['action_date'].to_pydatetime().strftime("%Y-%m-%d %H:%M:%S"))

        # TAGS
        tags = [a[1]['theme'] for a in filter(
            lambda x: x[1]['mobilization_id'] == item['mobilization_id'], themes.iterrows())]
        payload['add_tags'] = tags

        # import ipdb; ipdb.set_trace()
        endpoint = 'https://actionnetwork.org/api/v2'
        if item['an_resource_name'] == 'submissions':
            endpoint += f"/forms/{item['an_action_id']}/submissions/"
        elif item['an_resource_name'] == 'signatures':
            endpoint += f"/petitions/{item['an_action_id']}/signatures/"
        elif item['an_resource_name'] == 'donations':
            endpoint += f"/fundraising_pages/{item['an_action_id']}/donations"

        headers = {
            'OSDI-API-Token': item['an_group_id'],
            'Content-Type': 'application/json'
        }
        # print(headers)
        response = requests.request("POST", endpoint, data=json.dumps(payload), headers=headers)

        if response.status_code == 200:
            update_activist_actions(an_response=json.dumps(
                response.json()), action_id=item['action_id'], action=item['action'])
        else:
            update_activist_actions(an_response=json.dumps(
                response.json()), action_id=item['action_id'], action=item['action'])
