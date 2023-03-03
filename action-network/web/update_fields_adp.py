import pandas as pd
import json
import requests
from database import engine

sql = """
select
	agg.email,
	agg.action_date,
	agg.expected_signatures,
	agg.an_group_id,
	agg.form_uri
from (
	select
		aa.email,
		(
			SELECT
	            min(action_date)
	        FROM "analyze".activist_actions
	        WHERE widget_id = aa.widget_id AND email = aa.email
		) as action_date,
	    c.an_group_id,
	    (
	    	SELECT
	            metadata->>'expected_signatures'
	        FROM "analyze".activist_actions
	        WHERE widget_id = aa.widget_id AND email = aa.email
	        order by action_date asc limit 1
	    ) as expected_signatures,
	    laa.an_response->'_links'->'osdi:form'->>'href' as form_uri
	FROM "analyze".log_activist_actions laa
	INNER JOIN "public".communities c ON c.id = laa.community_id
	inner join "analyze".activist_actions aa on aa.action = laa.action and aa.action_id = laa.action_id
	WHERE c.id = 66
	AND laa.action = 'plip'
) as agg
group by agg.email, agg.an_group_id, agg.expected_signatures, agg.form_uri, agg.action_date
order by agg.action_date asc
offset 18504
"""

sql2 = """
select
	p.form_data->>'email' as email,
	laa.an_response->'_links'->'osdi:form'->>'href' as form_uri,
	p.pdf_data as link_da_ficha,
	(
		select count(1) from "public".plips
		where form_data->>'email' = p.form_data->>'email' and widget_id = p.widget_id
	) as total_fichas_geradas,
	(
		select count(1) from "public".plip_signatures
		where email = p.form_data->>'email' and widget_id = p.widget_id
	) as total_fichas_entregues,
	(
		select max(created_at) from "public".plip_signatures
		where email = p.form_data->>'email' and widget_id = p.widget_id
	) as data_ultima_entrega,
        c.an_group_id
from "public".plips p
inner join "analyze".log_activist_actions laa on laa.action_id = p.id and laa.action = 'plip'
inner join "public".communities c on c.id = p.cached_community_id
where p.cached_community_id = 66
order by p.created_at asc
"""

sql3 = """
select
	email,
	form_uri,
	link_da_ficha,
	total_fichas_geradas,
	data_ficha_gerada,
	an_group_id
from (
	select
		p.form_data->>'email' as email,
		laa.an_response->'_links'->'osdi:form'->>'href' as form_uri,
		(
			select p.created_at from "public".plips
			where form_data->>'email' = p.form_data->>'email' and widget_id = p.widget_id
			order by p.created_at asc
			limit 1
		) as data_ficha_gerada,
		(
			select p.pdf_data from "public".plips
			where form_data->>'email' = p.form_data->>'email' and widget_id = p.widget_id
			order by created_at asc
			limit 1
		) as link_da_ficha,
		(
			select count(1) from "public".plips
			where form_data->>'email' = p.form_data->>'email' and widget_id = p.widget_id
		) as total_fichas_geradas,
	    c.an_group_id
	from "public".plips p
	inner join "public".communities c on c.id = p.cached_community_id
	inner join "analyze".log_activist_actions laa on laa.action_id = p.id and laa.action = 'plip'
	where p.cached_community_id = 66
) as results
group by email, form_uri, link_da_ficha, total_fichas_geradas, data_ficha_gerada, an_group_id
"""


df = pd.read_sql_query(sql3, engine)

for i, item in enumerate(df.to_dict(orient='records')):
    payload = dict(
        person=dict(
            email_addresses=[dict(address=item['email'])],
            custom_fields=dict(
                link_da_ficha=item['link_da_ficha'],
                total_fichas_geradas=item['total_fichas_geradas'],
                # total_fichas_entregues=item['total_fichas_entregues'], 
                #assinaturas_esperadas=item['expected_signatures'],
                data_ficha_gerada=item['data_ficha_gerada'][:19]
            )
        )
    )

    if item['data_ultima_entrega']:
        data_ultima_entrega=item['data_ultima_entrega']

    # payload['add_tags'] = ['Ficha gerada']

    if item['form_uri']:

        endpoint = f"{item['form_uri']}/submissions"
        headers = {
            'OSDI-API-Token': item['an_group_id'],
            'Content-Type': 'application/json'
        }

        data = json.dumps(payload)
        an_response = requests.request(
                "POST", endpoint, data=data, headers=headers, timeout=(5, 20))

        if an_response.status_code == 200:
            print(f'Indice: {i}')
            print(payload)
        else:
            print(an_response.json())
    else:
        print(f'Indice: {i}')
        print(payload)
        print('Não enviado!')

