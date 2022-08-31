"""
Fetch Bonde donation actions in PostgreSQL and normalize to insert on BigQuery
"""
import json
import pandas as pd
import numpy as np
# from logger import logging
# from validate_docbr import CPF
from normalize.base import NormalizeWorkflowInterface

# cpf = CPF()


def map_postal_address(address_json: str) -> dict:
    """map field to postal address"""
    address = json.loads(address_json)

    return dict(
        postal_code=address['zipcode'],
        locality=address['city'],
        region=address['state'],
        address_line=f"{address['street_number']} {address['street']} Apt {address['complementary']}" if address[
            'complementary'] else f"{address['street_number']} {address['street']}"
    )


def map_locality(address_json: str) -> str:
    """map field to locality"""
    try:
        address = json.loads(address_json)
        return address['city']
    except TypeError:
        return None


def map_postal_code(address_json: str) -> str:
    """map field to locality"""
    try:
        address = json.loads(address_json)
        return address['zipcode']
    except TypeError:
        return None


def map_region(address_json: str) -> str:
    """map field to locality"""
    try:
        address = json.loads(address_json)
        return address['state']
    except TypeError:
        return None


def map_address_line(address_json: str) -> str:
    """map field to address line"""
    try:
        address = json.loads(address_json)

        return f"{address['street_number']} {address['street']} Apt {address['complementary']}" if address[
            'complementary'] else f"{address['street_number']} {address['street']}"
    except TypeError:
        return None


def map_phone(phone_json: str) -> str:
    """map field to phone"""
    try:
        phone = json.loads(phone_json)

        return f"+55{phone['ddd']}{phone['number']}"
    except TypeError:
        return None


class DonationNormalizeWorkflowInterface(NormalizeWorkflowInterface):

    def query(self, offset: int) -> str:
        """Query activist actions donation"""
        return f'''
        SELECT
            'donation'::text AS action,
            d.id AS action_id,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id AS community_id,
            d.created_at AS action_date,
            d.amount AS amount,
            d.checkout_data,
            d.checkout_data->'name' AS checkout_name,
            d.checkout_data->'email' AS checkout_email,
            d.checkout_data->'address' AS checkout_address,
            d.checkout_data->'phone' AS checkout_phone,
            d.customer,
            d.customer::hstore->'name' AS customer_name,
            d.customer::hstore->'email' AS customer_email,
            d.customer::hstore->'phone' AS customer_phone,
            d.customer::hstore->'address' AS customer_address
        FROM donations d
        JOIN widgets w ON w.id = d.widget_id
        JOIN blocks b ON b.id = w.block_id
        JOIN mobilizations m ON m.id = b.mobilization_id
        WHERE m.community_id = {self.params.get("community_id")}
        ORDER BY d.created_at ASC
        OFFSET {offset}
        LIMIT {self.limit}
        '''

    def normalize(self, df):
        """Normalize activist actions donation"""
        pd.set_option('mode.chained_assignment', None)

        df = df[df['customer'].notnull() | df['checkout_data'].notnull()]

        df['amount'] = df['amount'].astype(str)

        # Create activist fields
        df['name'] = np.where(df['customer_name'].isnull(),
                              df['checkout_name'], df['customer_name'])
        df['phone'] = np.where(df['customer_phone'].isnull(
        ), df['checkout_phone'], df['customer_phone'])
        df['postal_address'] = np.where(df['customer_address'].isnull(
        ), df['checkout_address'], df['customer_address'])
        df['email'] = np.where(df['customer_email'].isnull(
        ), df['checkout_email'], df['customer_email'])

        df['postal_address'] = df['postal_address'].str.replace('=>', ':')

        # df['postal_address'] = np.where(df['postal_address'].str.contains(
        #     '{'), df['postal_address'], "{" + df['postal_address'] + "}")
        df['phone'] = df['phone'].str.replace('=>', ':')

        df['address_line'] = df['postal_address'].map(map_address_line)
        df['locality'] = df['postal_address'].map(map_locality)
        df['region'] = df['postal_address'].map(map_region)
        df['postal_code'] = df['postal_address'].map(map_postal_code)

        df['phone'] = df['phone'].map(map_phone)

        df['name'] = df['name'].str.title()
        df['given_name'] = df['name'].str.split(pat=" ").str[0]
        df['family_name'] = df['name'].str.split(pat=" ").str[1:].str.join(" ")

        # df['phone'] = np.where(df['phone'].isnull(),
        #                        df['customer_phone'], df['phone'])

        # df["phone"] = df["phone"].str.replace(r'[\(\) -]+', '', regex=True)
        # df["phone"] = df["phone"].str.replace(
        #     r'^(\d{2})(\d{1})(\d{4})(\d{4})$', r'+55 (\1) \2 \3 \4', regex=True)
        # df["phone"] = df["phone"].str.replace(
        #     r'^\+(\d{2})(\d{2})(\d{1})(\d{4})(\d{4})$', r'+\1 (\2) \3 \4 \5', regex=True)
        # df["phone"] = df["phone"].str.replace(
        #     r'^(\d{2})(\d{4})(\d{4})$', r'+55 (\1) 9 \2 \3', regex=True)
        # df["phone"] = df["phone"].str.replace(
        #     r'^\{"ddd"=>"(\d{2})","number"=>"(\d{1})(\d{8})"\}$', r'+55 (\1) \2 \3', regex=True)
        # df["phone"] = df["phone"].str.replace(
        #     r'^\{"ddd"=>"(\d{2})","number"=>"(\d{8})"\}$', r'+55 (\1) 9 \2', regex=True)

        df = df[[
            "action",
            "action_id",
            "action_date",
            "widget_id",
            "mobilization_id",
            "community_id",
            "email",
            "name",
            "given_name",
            "family_name",
            "address_line",
            "locality",
            "region",
            "postal_code",
            "phone",
            "amount"
        ]]

        return df
