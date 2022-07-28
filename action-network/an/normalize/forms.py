"""
Fetch Bonde form actions in PostgreSQL and normalize to insert on BigQuery
"""
import json
import warnings
import re
from io import StringIO
from logger import logging
from database.bigquery import insert
from database.postgres import cnx
from normalize.utils import find_by_ddd
from validate_docbr import CPF
import pandas as pd
# import time

warnings.filterwarnings("ignore", 'This pattern has match groups')

cpf = CPF()


def get_field_name(dataframe, regex_pattern):
    """
    get_field_name
    """
    field_group = dataframe.columns[dataframe.columns.str.lower(
    ).str.contains(regex_pattern, regex=True)]
    if len(field_group) > 0:
        field_name = field_group[0]
        return dataframe[field_name].str.strip().str.cat()


def parse_item(item):
    """
    Parse fields to column
    """
    d2 = json.loads(json.dumps(item['fields']))
    df2 = pd.read_json(StringIO(d2))  # lendo json no df coluna fields
    df2 = df2.append(df2)
    df2 = df2.set_index('label')
    df2 = df2.T
    df2 = df2.loc[['value']]
    df2 = df2.loc[:, ~df2.columns.duplicated()].copy()

    # Pegar nome ou primeiro nome
    item['form_first_name'] = get_field_name(
        df2, r'(nombre|first[-\s]?name|seu nome|nome|name|primeiro[-\s]?nome)')
    # Pegar sobrenome
    item['form_last_name'] = get_field_name(
        df2, r'(sobre[\s-]?nome|seu sobre[\s-]?nome|surname|last[\s-]?name|apellido)')
    # Pegar email
    item['form_email'] = get_field_name(
        df2, r'(e-?mail|correo electr(o|ó)nico|email)')
    # Pegar telefone
    item['form_phone'] = get_field_name(
        df2, r'(celular|mobile|portable|whatsapp)')
    # Pegar cidade
    item['form_city'] = get_field_name(
        df2, r'(cidade|city|ciudad)')
    # Pegar estado
    item['form_state'] = get_field_name(df2, r'(estado|state)')
    # Pegar genero
    item['gender'] = get_field_name(
        df2, r'(gen[e|ê]ro|orienta[ç|c][a|ã]o sexual)')
    # Pegar cor, raça ou etnia
    item['color'] = get_field_name(
        df2, r'(cor|ra[ç|c]a|etnia)')
    # Pegar estado
    item['birthday'] = get_field_name(
        df2, r'(data[de ]*nascimento|idade|[ano]*[de ]*nascimento)')

    # normalizando os state
    item['state'] = item['form_state'] if item['form_state'] else item['state']
    item['state'] = re.sub(r'[\w Á-ù]+\((\w{2})\)', r'\1', item['state']) if '(' in (item['state'] or '') else item['state']
    item['city'] = item['form_city'] if not item['city'] else item['city']

    # Normalizando nomes
    item['name'] = item['form_first_name'] + \
        (item['form_last_name'] or '') if '{' in item['name'] else item['name']

    item['first_name'] = item['form_first_name'] if not item['first_name'] else item['first_name']
    item['last_name'] = item['form_last_name'] if not item['last_name'] else item['last_name']

    item['first_name'] = item['name'].split(
        " ")[0] if not item['first_name'] else item['first_name']
    item['last_name'] = " ".join(item['name'].split(
        " ")[1:]) if not item['last_name'] else item['last_name']

    # Removendo espaco em branco no inicio da string
    item['first_name'] = item['first_name'].lstrip()

    item['first_name'] = item['first_name'].split(" ")[0] if len(
        item['first_name'].split(" ")) > 1 else item['first_name']

    item['name'] = item['name'].title()
    item['first_name'] = item['first_name'].title()
    item['last_name'] = item['last_name'].title()

    item['phone'] = item['form_phone'] if not item['phone'] else item['phone']

    item["phone"] = re.sub(r'[\(\) -]+', '', item['phone']
                           ) if item['phone'] else item['phone']
    item["phone"] = re.sub(r'^\d{1}(\d{2})(\d{1})(\d{4})(\d{4})$',
                           r'+55 (\1) \2 \3 \4', item["phone"]) if item['phone'] else item['phone']
    item["phone"] = re.sub(r'^\d{2}(\d{2})(\d{1})(\d{4})(\d{4})$',
                           r'+55 (\1) \2 \3 \4', item["phone"]) if item['phone'] else item['phone']
    item["phone"] = re.sub(r'^(\d{2})(\d{1})(\d{4})(\d{4})$', r'+55 (\1) \2 \3 \4',
                           item["phone"]) if item['phone'] else item['phone']
    item["phone"] = re.sub(r'^\+(\d{2})(\d{2})(\d{1})(\d{4})(\d{4})$',
                           r'+\1 (\2) \3 \4 \5', item["phone"]) if item['phone'] else item['phone']
    item["phone"] = re.sub(r'^(\d{2})(\d{4})(\d{4})$', r'+55 (\1) 9 \2 \3',
                           item["phone"]) if item['phone'] else item['phone']
    item["phone"] = re.sub(r'^\{"ddd"=>"(\d{2})","number"=>"(\d{1})(\d{8})"\}$',
                           r'+55 (\1) \2 \3', item["phone"]) if item['phone'] else item['phone']

    item['state'] = re.sub(r'^\+[\d ]+\((\d{2})\)[\d ]+$', r'\1', item["phone"]
                           ) if not item['state'] and item['phone'] else item['state']

    item['state'] = find_by_ddd(item['state'])

    return item


def run(community_id, sbar, manager, default_limit=30000):
    """
    Fetch Bonde form actions in PostgreSQL and normalize to insert on BigQuery
    """
    limit = default_limit
    page = 0
    total = 0

    # sbar = kwargs.get('sbar')
    # manager = kwargs.get('manager')

    while True:
        sbar.update(stage=f'Initializing SLOT {page}', status='LOADING')
        df = pd.read_sql_query(f'''
        SELECT
            'form'::text AS action,
            fe.id AS action_id,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id AS community_id,
            fe.activist_id as activist_id,
            fe.created_at AS action_date,
            a.email AS email,
            a.name AS name,
            a.first_name AS first_name,
            a.last_name AS last_name,
            a.city AS city,
            a.state AS state,
            a.phone AS phone,
            a.document_type AS document_type,
            a.document_number AS document_number,
            fe.fields AS fields
        FROM form_entries fe
        JOIN activists a ON a.id = fe.activist_id
        JOIN widgets w ON w.id = fe.widget_id
        JOIN blocks b ON b.id = w.block_id
        JOIN mobilizations m ON m.id = b.mobilization_id
        WHERE m.community_id = {community_id}
        ORDER BY fe.created_at ASC
        OFFSET {page * limit}
        LIMIT {limit}
        ''', cnx)

        sbar.update(stage=f'Parsing SLOT {page}', status='PROCESSING')
        pbar = manager.counter(total=len(df), desc=f'Processing {page}', unit='ticks')

        items = []
        for i, item in df.iterrows():
            items.append(parse_item(item))
            pbar.update()

        pbar.close(clear=True)

        df = pd.DataFrame(items)
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
            "city",
            "state",
            "phone",
            "document_type",
            "document_number",
            "gender",
            "color",
            "birthday"
        ]]

        logging.info(f'SLOT {page} is processed')
        sbar.update(stage=f'Inserting SLOT {page}', status='PROCESSING')

        insert(df)
        logging.info(f'SLOT {page} is inserted')

        page += 1
        total += len(df)

        if len(df) < limit:
            break
    
    logging.info(f'Success to process and insert {total}')
    sbar.update(stage=f'Success to process and insert {total}', status='DONE')
