"""
Fetch Bonde donation actions in PostgreSQL and normalize to insert on BigQuery
"""
from logger import logging
from database.postgres import cnx
from database.bigquery import insert
from validate_docbr import CPF
import pandas as pd
import numpy as np

cpf = CPF()


def run(community_id):
    """
    Fetch Bonde donation actions in PostgreSQL and normalize to insert on BigQuery
    """
    df = pd.read_sql_query(f'''
        SELECT
        'donation'::text AS action,
        d.id AS action_id,
        w.id AS widget_id,
        m.id AS mobilization_id,
        m.community_id AS community_id,
        d.activist_id as activist_id,
        d.created_at AS action_date,
        a.email AS email,
        a.first_name AS first_name,
        a.last_name AS last_name,
        a.phone AS phone,
        a.document_type AS document_type,
        a.document_number AS document_number,
        d.checkout_data->'name' AS checkout_name,
        d.checkout_data->'address' AS checkout_address,
        d.checkout_data->'phone' AS checkout_phone,
        d.customer::hstore->'name' AS customer_name,
        d.customer::hstore->'phone' AS customer_phone,
        d.customer::hstore->'address' AS customer_address,
        d.customer::hstore->'document_number' AS customer_document_number
        FROM donations d
        JOIN activists a ON a.id = d.activist_id
        JOIN widgets w ON w.id = d.widget_id
        JOIN blocks b ON b.id = w.block_id
        JOIN mobilizations m ON m.id = b.mobilization_id
        WHERE m.community_id = {community_id}
    ''', cnx)

    # Normalizando estado
    logging.info("Normalizando informações de endereço...")
    df['state'] = df['customer_address'].str.replace(
        r'[\{\w+ "=>\},Á-ú\']+"state"=>"(\w{2})"\}*', r'\1', regex=True)
    df['state'] = np.where(df['state'].isnull(),
                           df['checkout_address'].str['state'], df['state'])
    df['state'] = np.where(df['state'].str.contains(
        '{'), df['checkout_address'].str['state'], df['state'])

    df['city'] = df['customer_address'].str.replace(
        r'[\{\w+ "=>\},Á-ú\']+"city"=>"([\w Á-ù]+)"[\{\w+ "=>\},Á-ú\']+', r'\1', regex=True)
    df['city'] = np.where(df['city'].isnull(),
                          df['checkout_address'].str['city'], df['city'])
    df['city'] = np.where(df['city'].str.contains(
        '{'), df['checkout_address'].str['city'], df['city'])

    df['zipcode'] = df['customer_address'].str.replace(
        r'[\{\w+ "=>\},Á-ú\']+"zipcode"=>"(\d{8})"[\{\w+ "=>\},Á-ú\']+', r'\1', regex=True)
    df['zipcode'] = np.where(df['zipcode'].str.contains(
        "\("), df['zipcode'].str.split(pat="\(").str[0], df['zipcode'])
    df['zipcode'] = np.where(len(df['zipcode']) > 8, df['zipcode'].str.replace(
        r'^(\d{8})[\w\.\d=>"\-\,} ]+$', r'\1', regex=True), df['zipcode'])

    # Normalizando nomes
    logging.info("Normalizando informações sobre o nome...")
    df['name'] = df['checkout_name'].str.title()
    df['name'] = np.where(df['name'].isnull(), df['customer_name'], df['name'])

    df['first_name'] = np.where(df['first_name'].isnull(
    ), df['name'].str.split(pat=" ").str[0], df['first_name'])
    df['last_name'] = np.where(df['last_name'].isnull(), df['name'].str.split(
        pat=" ").str[1:].str.join(" "), df['last_name'])

    df['first_name'] = np.where(len(df['first_name'].str.split(
        pat=" ")) > 1, df['first_name'].str.split(pat=" ").str[0], df['first_name'])

    df['name'] = df['name'].str.title()
    df['first_name'] = df['first_name'].str.title()
    df['last_name'] = df['last_name'].str.title()

    # Normalizando telefone
    logging.info("Normalizando informações de telefone...")
    df['phone'] = np.where(df['phone'].isnull(),
                           df['customer_phone'], df['phone'])

    df["phone"] = df["phone"].str.replace(r'[\(\) -]+', '', regex=True)
    df["phone"] = df["phone"].str.replace(
        '^(\d{2})(\d{1})(\d{4})(\d{4})$', r'+55 (\1) \2 \3 \4', regex=True)
    df["phone"] = df["phone"].str.replace(
        '^\+(\d{2})(\d{2})(\d{1})(\d{4})(\d{4})$', r'+\1 (\2) \3 \4 \5', regex=True)
    df["phone"] = df["phone"].str.replace(
        '^(\d{2})(\d{4})(\d{4})$', r'+55 (\1) 9 \2 \3', regex=True)
    df["phone"] = df["phone"].str.replace(
        '^\{"ddd"=>"(\d{2})","number"=>"(\d{1})(\d{8})"\}$', r'+55 (\1) \2 \3', regex=True)
    df["phone"] = df["phone"].str.replace(
        '^\{"ddd"=>"(\d{2})","number"=>"(\d{8})"\}$', r'+55 (\1) 9 \2', regex=True)

    # Normalizando documentos
    logging.info("Normalizando informações de documento...")
    df['document_number'] = np.where(df['document_number'].isnull(
    ), df['customer_document_number'], df['document_number'])

    df_is_empty = df[df["document_number"].isnull()]
    df_is_cpf = df[df["document_number"].notnull()]

    # Normalizando documentos
    df_is_cpf['document_type'] = np.where(cpf.validate(
        df_is_cpf['document_number'].values[0]), "cpf", None)

    df = pd.concat([df_is_empty, df_is_cpf])

    df = df[[
        "action",
        "widget_id",
        "mobilization_id",
        "community_id",
        "activist_id",
        "action_id",
        "action_date",
        "email",
        "name",
        "first_name",
        "last_name",
        "zipcode",
        "city",
        "state",
        "phone",
        "document_type",
        "document_number"
    ]]

    insert(df)
