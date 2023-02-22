#!/usr/bin/env python
import sys
import json
import requests
import pandas as pd
from sqlalchemy import create_engine
from database import engine, log_activist_actions

sql = '''
SELECT
	a.an_action_id,
	c.an_group_id,
	a.an_resource_name,
	aa.*
FROM "analyze".actions a
INNER JOIN "analyze".activist_actions aa ON aa.widget_id = a.widget_id
INNER JOIN "public".communities c ON c.id = a.community_id
WHERE a.an_resource_name <> 'donations'
AND c.id <> 517
AND aa.email = 
'''

themes = pd.read_sql_query(f"""SELECT * FROM "analyze".themes""", engine).to_dict(orient='records')

def main(filename):

	df = pd.read_csv(filename)

	array_logs = []
	array_logs.append(filename)

	for _a, row in df.iterrows():
		results = pd.read_sql_query(sql + f"'{row['email']}'", engine)

		msg = f"Read {row['email']} with {len(results)} total actions"
		array_logs.append(msg)
		print(msg)

		for _b, item in results.iterrows():
			payload = dict(
				person=dict(
					given_name=item['given_name'],
					family_name=item['family_name'],
					email_addresses=[dict(address=item['email'])],
					languages_spoken=['pt-BR']
				)
			)

			if item['phone']:
				payload['person']['phone_numbers'] = [dict(number=item['phone'])]

			address = dict()
			if item['locality']:
				address['locality'] = item['locality']

			if item.region:
				address['region'] = f"BR-${item['region']}"

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

			if len(custom_fields.keys()) > 0:
				payload['person']['custom_fields'] = custom_fields

			tags = [x['theme'] for x in filter(lambda y: y['mobilization_id'] == item['mobilization_id'], themes)]

			if len(tags) > 0:
				payload['add_tags'] = tags


			endpoint = 'https://actionnetwork.org/api/v2'
			if item['action'] == "form":
				endpoint += f"/forms/{item['an_action_id']}"
			if item['action'] == "pressure":
				endpoint += f"/petitions/{item['an_action_id']}"
			# if item['action'] == "donation":
			# 	endpoint += f"/fundraising_pages/{item['an_action_id']}"
			
			endpoint += f"/{item['an_resource_name']}"

			headers = {
				'OSDI-API-Token': item['an_group_id'],
				'Content-Type': 'application/json'
			}
			
			an_response = requests.request("POST", endpoint, data=json.dumps(payload), headers=headers)

			msg = f"{item['email']} >> {item['action']} >> {item['action_id']}: {an_response.status_code}"
			array_logs.append(msg)
			print(msg)

			try:
				log = dict(
					an_response=an_response.json(),
					action_id=item['action_id'],
					action=item['action'],
					community_id=item['community_id'],
					widget_id=item['widget_id']
				)
				engine.execute(log_activist_actions.insert(), log)
			except requests.exceptions.JSONDecodeError as e:
				print(e)
				import ipdb; ipdb.set_trace()

if __name__ == '__main__':
	main(sys.argv[1])
