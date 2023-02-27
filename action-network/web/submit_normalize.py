from sqlalchemy import create_engine
import pandas as pd
from sqlalchemy.exc import IntegrityError
from pydantic.error_wrappers import ValidationError
from normalize import to_payload
from database import engine as cnx, activist_actions
from typings import Payload, Event, Donation, CheckoutData, Table, Data, Form, Pressure, Plip, FormData
from time import gmtime, strftime

sql = '''
SELECT
    'plip'::text AS action,
    p.id AS action_id,
    w.id AS widget_id,
    m.id AS mobilization_id,
    m.community_id AS community_id,
    p.created_at AS action_date,
    p.unique_identifier AS unique_identifier,
    p.expected_signatures AS expected_signatures,
    p.state as state,
    p.form_data AS form_data
FROM "public".plips p
FULL OUTER JOIN "analyze".activist_actions aa ON aa.action_id = p.id AND aa.action = 'plip'
INNER JOIN "public".communities c ON c.id = p.cached_community_id
INNER JOIN "public".widgets w ON w.id = p.widget_id
INNER JOIN "public".blocks b ON b.id = w.block_id
INNER JOIN "public".mobilizations m ON m.id = b.mobilization_id
WHERE c.id = 518
AND aa.action_id IS NULL
ORDER BY p.created_at ASC
'''

# sql = '''
# SELECT
#     'donation'::text AS action,
#     d.id AS action_id,
#     w.id AS widget_id,
#     m.id AS mobilization_id,
#     m.community_id AS community_id,
#     d.created_at AS action_date,
# 	d.transaction_status AS transaction_status,
# 	d.payment_method AS payment_method,
# 	d.subscription AS subscription,
#     d.amount AS amount,
#     d.checkout_data,
#     d.gateway_data->'customer' AS customer
# FROM "public".donations d
# FULL OUTER JOIN "analyze".activist_actions aa ON aa.action_id = d.id AND aa.action = 'donation'
# INNER JOIN "public".communities c ON c.id = d.cached_community_id
# INNER JOIN "public".widgets w ON w.id = d.widget_id
# INNER JOIN "public".blocks b ON b.id = w.block_id
# INNER JOIN "public".mobilizations m ON m.id = b.mobilization_id
# WHERE c.an_group_id IS NOT NULL
# AND aa.action_id IS NULL
# AND d.created_at >= '2018-01-01 00:00:00'
# ORDER BY d.created_at ASC
# '''

# sql = '''
# SELECT
# 	'form'::text AS action,
# 	fe.id AS action_id,
# 	w.id AS widget_id,
# 	m.id AS mobilization_id,
# 	m.community_id AS community_id,
# 	fe.activist_id as activist_id,
# 	fe.created_at AS action_date,
# 	fe.fields AS fields
# FROM form_entries fe
# JOIN widgets w ON w.id = fe.widget_id
# JOIN blocks b ON b.id = w.block_id
# JOIN mobilizations m ON m.id = b.mobilization_id
# WHERE m.community_id = 10
# AND fe.created_at > '2022-08-14 23:59:59'
# ORDER BY fe.created_at ASC
# '''

# sql = '''
# SELECT
#     'pressure'::text AS action,
#     ap.id AS action_id,
#     w.id AS widget_id,
#     m.id AS mobilization_id,
#     m.community_id AS community_id,
#     ap.activist_id as activist_id,
#     ap.created_at AS action_date,
#     ap.form_data
# FROM activist_pressures ap
# JOIN widgets w ON w.id = ap.widget_id
# JOIN blocks b ON b.id = w.block_id
# JOIN mobilizations m ON m.id = b.mobilization_id
# WHERE w.id = 73359
# ORDER BY ap.created_at ASC
# OFFSET 70000
# LIMIT 10000
# '''

print(f'{strftime("%a, %d %b %Y %H:%M:%S +0000", gmtime())}: Inicia script')

df = pd.read_sql_query(sql, cnx)

print(f'{strftime("%a, %d %b %Y %H:%M:%S +0000", gmtime())}: Carrega dados')
# df = df[df['checkout_data'].notnull()]

print(f"Total de ações {len(df)}")

# def get_infos(item):
#     if item.checkout_data:
#         return item.checkout_data
    
#     return dict(
#         name=item.customer_name,
#         email=item.customer_email,
#         phone=item.customer_phone,
#         address=item.customer_address
#     )

validation_errors = []

for row in df.iterrows():
    # Insert normalized action in database
    item = row[1]

    try:
        values = to_payload(Payload(
            event=Event(
                data=Data(
                    new=Plip(
                        id=item.action_id,
                        created_at=str(item.action_date),
                        cached_community_id=item.community_id,
                        widget_id=item.widget_id,
                        mobilization_id=item.mobilization_id,
                        state=item.state,
                        unique_identifier=item.unique_identifier,
                        expected_signatures=item.expected_signatures,
                        form_data=item.form_data
                        # form_data=FormData(
                        #     email=item.form_data['email'],
                        #     state=item.form_data['state'],
                        #     color=item.form_data['color'],
                        #     whatsapp=item.form_data['whatsapp'],
                        #     gender=item.form_data['gender'],
                        #     name=item.form_data['name'],
                        #     expected_signatures=item.form_data['expected_signatures']
                        # )
                    )
                )
            ),
            table=Table(name='plips', schema='public')
        ))

        # values = to_payload(Payload(
        #     event=Event(
        #         data=Data(
        #             new=Donation(
        #                 id=item.action_id,
        #                 checkout_data=item.checkout_data or item.customer,
        #                 amount=str(item.amount),
        #                 transaction_status=item.transaction_status,
        #                 subscription=item.subscription,
        #                 payment_method=item.payment_method,
        #                 created_at=str(item.action_date),
        #                 cached_community_id=item.community_id,
        #                 widget_id=item.widget_id,
        #                 mobilization_id=item.mobilization_id
        #             )
        #         )
        #     ),
        #     table=Table(name='donations', schema='public')
        # ))

        # values = to_payload(Payload(
        #     event=Event(
        #         data=Data(
        #             new=Form(
        #                 id=item.action_id,
        #                 fields=item.fields,
        #                 created_at=str(item.action_date),
        #                 cached_community_id=item.community_id,
        #                 widget_id=item.widget_id,
        #                 mobilization_id=item.mobilization_id
        #             )
        #         )
        #     ),
        #     table=Table(name='form_entries', schema='public')
        # ))

        # values = to_payload(Payload(
        #     event=Event(
        #         data=Data(
        #             new=Pressure(
        #                 id=item.action_id,
        #                 form_data=item.form_data,
        #                 created_at=str(item.action_date),
        #                 cached_community_id=item.community_id,
        #                 widget_id=item.widget_id,
        #                 mobilization_id=item.mobilization_id
        #             )
        #         )
        #     ),
        #     table=Table(name='activist_pressures', schema='public')
        # ))

        # print(values)
        cnx.execute(activist_actions.insert(), values)
        print(f'{strftime("%a, %d %b %Y %H:%M:%S +0000", gmtime())}: Ação {values["email"]} normalizada.')
    except ValidationError as e:
        print(e)
        validation_errors.append(dict(
            error=e,
            widget_id=item.widget_id,
            action_id=item.action_id
        ))
        # import ipdb; ipdb.set_trace()
        pass
    except IntegrityError as e:
        # Continue process don't stop workflow
        # Database is responsible not duplicate
        # print(e)
        print(f"Integrity Error: {item.action_id}")
        pass
    except Exception as e:
        print(e)
        validation_errors.append(dict(
            error=e,
            widget_id=item.widget_id,
            action_id=item.action_id
        ))
        # import ipdb; ipdb.set_trace()
        pass
    
import ipdb; ipdb.set_trace()
