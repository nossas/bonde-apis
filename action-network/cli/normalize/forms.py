"""
Fetch Bonde form actions in PostgreSQL and normalize to insert on BigQuery
"""
import json
import warnings
import re
from io import StringIO
from normalize.base import NormalizeWorkflowInterface
# from normalize.utils import find_by_ddd
from validate_docbr import CPF
import pandas as pd

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


def only_digits(field):
    """function to extract only digits of phone number"""
    phone = ""
    if field:
        for char in field:
            if char.isdigit():
                phone += char

        if phone.startswith('55'):
            phone = phone[2:]
        if phone.startswith('0'):
            phone = phone[1:]

        if len(phone) >= 8 and len(phone) <= 11:
            return phone
        else:
            return field


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
    item['given_name'] = get_field_name(
        df2, r'(nombre|first[-\s]?name|seu nome|nome|name|primeiro[-\s]?nome)')
    # Pegar sobrenome
    item['family_name'] = get_field_name(
        df2, r'(sobre[\s-]?nome|seu sobre[\s-]?nome|surname|last[\s-]?name|apellido)')
    # Pegar email
    item['email'] = get_field_name(
        df2, r'(e-?mail|correo electr(o|ó)nico|email)')
    # Pegar telefone
    item['phone'] = get_field_name(
        df2, r'(celular|mobile|portable|whatsapp)')
    # Pegar cidade
    item['locality'] = get_field_name(
        df2, r'(cidade|city|ciudad)')
    # Pegar estado
    item['region'] = get_field_name(df2, r'(estado|state)')
    # Pegar genero
    item['gender'] = get_field_name(
        df2, r'(gen[e|ê]ro|orienta[ç|c][a|ã]o sexual)')
    # Pegar cor, raça ou etnia
    item['color'] = get_field_name(
        df2, r'(cor|ra[ç|c]a|etnia)')
    # Pegar estado
    item['birthday'] = get_field_name(
        df2, r'(data[de ]*nascimento|idade|[ano]*[de ]*nascimento)')

    item['name'] = item['given_name'] + \
        f" {item['family_name']}" if item['family_name'] else item['given_name']

    # normalizando os state
    item['locality'] = item['locality'].lstrip(
    ) if item['locality'] else item['locality']

    item['region'] = re.sub(
        r'[\w Á-ù]+\((\w{2})\)', r'\1', item['region']) if '(' in (item['region'] or '') \
        else item['region']

    # Normalizando nomes
    item['name'] = item['given_name'] + \
        (f" {item['family_name']}" or '') if '{' in (
            item['name'] or '') else item['name']

    # Remove item wihtout name ou email
    if not item['name'] or not item['email']:
        return None

    item['given_name'] = item['name'].split(
        " ")[0] if not item['given_name'] else item['given_name']
    item['family_name'] = " ".join(item['name'].split(
        " ")[1:]) if not item['family_name'] else item['family_name']

    # Removendo espaco em branco no inicio da string
    item['given_name'] = item['given_name'].lstrip()

    item['given_name'] = item['given_name'].split(" ")[0] if len(
        item['given_name'].split(" ")) > 1 else item['given_name']

    item['name'] = item['name'].title()
    item['given_name'] = item['given_name'].title()
    item['family_name'] = item['family_name'].title()

    item['phone'] = only_digits(item['phone'])

    if item['phone']:
        item['phone'] = re.sub(
            r'^(\d{2})(\d{1})(\d{4})(\d{4})$', r'+55 (\1) \2 \3 \4', item['phone'])
        item['phone'] = re.sub(
            r'^(\d{1})(\d{4})(\d{4})$', r'+55 (xx) \1 \2 \3', item['phone'])
        item['phone'] = re.sub(
            r'^(\d{2})(\d{4})(\d{4})$', r'+55 (\1) 9 \2 \3', item['phone'])
        item['phone'] = re.sub(
            r'^(\d{4})(\d{4})$', r'+55 (xx) 9 \1 \2', item['phone'])

    # item['region'] = re.sub(r'^\+[\d ]+\((\d{2})\)[\d ]+$', r'\1', item["phone"]
    #                         ) if not item['region'] and item['phone'] else item['region']

    # item['region'] = find_by_ddd(item['region'])

    return item


class FormNormalizeWorkflowInterface(NormalizeWorkflowInterface):

    def query(self, offset: int) -> str:
        """Query activist actions form"""
        return f'''
        SELECT
            'form'::text AS action,
            fe.id AS action_id,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id AS community_id,
            fe.activist_id as activist_id,
            fe.created_at AS action_date,
            fe.fields AS fields
        FROM form_entries fe
        JOIN widgets w ON w.id = fe.widget_id
        JOIN blocks b ON b.id = w.block_id
        JOIN mobilizations m ON m.id = b.mobilization_id
        WHERE m.community_id = {self.params.get("community_id")}
        ORDER BY fe.created_at ASC
        OFFSET {offset}
        LIMIT {self.limit}
        '''

    def normalize(self, df):
        """Normalize activist actions form"""
        self.sbar.update(stage=f'Parsing {self.page}', status='PROCESSING')
        pbar = self.manager.counter(
            total=len(df), desc=f'Processing {self.page}', unit='ticks')

        items = []
        for i, item in df.iterrows():
            result = parse_item(item)
            if result is None: print('No name item')
            else: items.append(result)
            pbar.update()

        pbar.close(clear=True)

        df = pd.DataFrame(items)
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
            # "address_lines",
            "locality",
            "region",
            "phone",
            "gender",
            "color",
            "birthday"
        ]]

        return df
