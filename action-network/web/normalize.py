"""normalize.py"""
import json
import re

from typings import Donation, Form, Payload, Pressure, Plip
from utils import only_digits, get_field, find_by_ddd

def form(payload: Form):
    """form"""
    fields = json.loads(payload.fields)

    item = dict()

    item['given_name'] = get_field(
        r'(nombre|first[\s\-\_]?name|seu nome|nome|name|primeiro[\s\-\_]?nome)', fields)
    item['family_name'] = get_field(
        r'(sobre[\s\-\_]?nome|seu sobre[\s\-\_]?nome|surname|last[\s\-\_]?name|apellido)', fields)
    item['email'] = get_field(
        r'(e-?mail|correo electr(o|ó)nico|email|seu.*email)', fields)
    item['locality'] = get_field(r'(cidade|city|ciudad)', fields)
    item['phone'] = get_field(r'(celular|mobile|portable|whatsapp)', fields)
    item['region'] = get_field(r'(estado|state)', fields)
    item['gender'] = get_field(
        r'(gen[e|ê]ro|orienta[ç|c][a|ã]o sexual|identifica)', fields)
    item['color'] = get_field(r'(cor|ra[ç|c]a|etnia)', fields)
    item['birthday'] = get_field(
        r'(data[de ]*nascimento|idade|[ano]*[de ]*nascimento)', fields)

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


    if item['phone']:
        item['phone'] = only_digits(item['phone'])
        item['phone'] = re.sub(
            r'^(\d{2})(\d{1})(\d{4})(\d{4})$', r'+55 (\1) \2 \3 \4', item['phone'])
        item['phone'] = re.sub(
            r'^(\d{1})(\d{4})(\d{4})$', r'+55 (xx) \1 \2 \3', item['phone'])
        item['phone'] = re.sub(
            r'^(\d{2})(\d{4})(\d{4})$', r'+55 (\1) 9 \2 \3', item['phone'])
        item['phone'] = re.sub(
            r'^(\d{4})(\d{4})$', r'+55 (xx) 9 \1 \2', item['phone'])

    # Clean response
    response = dict()
    for key, value in item.items():
        if value:
            response[key] = value
    return response


def donation(payload: Donation):
    """donation"""

    if not payload.transaction_status:
        raise Exception("not_transaction_status")

    if not payload.payment_method:
        raise Exception("not_payment_method")

    if payload.amount > 999999:
        raise Exception("amount_gte_999999")

    checkout_data = payload.checkout_data

    item = dict()

    # Create activist fields
    amount = str(payload.amount)
    item['name'] = checkout_data.name.title()
    item['email'] = checkout_data.email
    item['metadata'] = dict(
        amount=f"{amount[:len(amount)-2]}.00",
        transaction_status=payload.transaction_status,
        payment_method=payload.payment_method,
        recurring=payload.subscription
    )
    if payload.subscription:
        item['metadata']['recurring_period'] = "Monthly"

    address = checkout_data.address

    item['address_line'] = \
        f"{address.street_number} {address.street}, {address.complementary}" \
        if address.complementary \
        else f"{address.street_number} {address.street}"

    item['locality'] = address.city
    item['region'] = address.state
    item['postal_code'] = address.zipcode

    phone = checkout_data.phone
    item['phone'] = f"+55{phone.ddd}{phone.number}"

    item['given_name'] = item['name'].split(" ")[0]
    item['family_name'] = " ".join(item['name'].split(" ")[1:])

    # Clean response
    response = dict()
    for key, value in item.items():
        if value:
            response[key] = value

    return response


def pressure(payload: Pressure):
    """pressure"""
    form_data = payload.form_data
    item = dict()

    item['name'] = form_data.name.title()
    item['email'] = form_data.email
    item['given_name'] = form_data.name.title()
    item['family_name'] = form_data.lastname.title()
    if form_data.state:
        item['region'] = form_data.state

    if form_data.phone:
        item['phone'] = form_data.phone

        item["phone"] = item["phone"].replace(r'[\(\) -]+', '', regex=True)
        item["phone"] = item["phone"].replace(
            r'^\d{1}(\d{2})(\d{1})(\d{4})(\d{4})$', r'+55 (\1) \2 \3 \4', regex=True)
        item["phone"] = item["phone"].replace(
            r'^\d{2}(\d{2})(\d{1})(\d{4})(\d{4})$', r'+55 (\1) \2 \3 \4', regex=True)
        item["phone"] = item["phone"].replace(
            r'^(\d{2})(\d{1})(\d{4})(\d{4})$', r'+55 (\1) \2 \3 \4', regex=True)
        item["phone"] = item["phone"].replace(
            r'^\+(\d{2})(\d{2})(\d{1})(\d{4})(\d{4})$', r'+\1 (\2) \3 \4 \5', regex=True)
        item["phone"] = item["phone"].replace(
            r'^(\d{2})(\d{4})(\d{4})$', r'+55 (\1) 9 \2 \3', regex=True)
        item["phone"] = item["phone"].replace(
            r'^\{"ddd"=>"(\d{2})","number"=>"(\d{1})(\d{8})"\}$', r'+55 (\1) \2 \3', regex=True)

        item['region'] = item['phone'].replace(r'^\+[\d ]+\((\d{2})\)[\d ]+$', r'\1', regex=True) \
            if not item['region'] & item['phone'] \
            else item['region']

        item['region'] = find_by_ddd(item['region'])

    # Clean response
    response = dict()
    for key, value in item.items():
        if value:
            response[key] = value

    return response


def plip(payload: Plip):
    """plip"""
    form_data = payload.form_data
    item = dict()

    item['name'] = form_data.name.title()
    item['email'] = form_data.email
    item['region'] = form_data.state
    item['given_name'] = item['name'].split(" ")[0]
    item['family_name'] = " ".join(item['name'].split(" ")[1:])
    if form_data.color:
        item['color'] = form_data.color

    if form_data.whatsapp:
        item["phone"] = form_data.whatsapp

        item['phone'] = only_digits(item['phone'])
        item['phone'] = re.sub(
            r'^(\d{2})(\d{1})(\d{4})(\d{4})$', r'+55 (\1) \2 \3 \4', item['phone'])
        item['phone'] = re.sub(
            r'^(\d{1})(\d{4})(\d{4})$', r'+55 (xx) \1 \2 \3', item['phone'])
        item['phone'] = re.sub(
            r'^(\d{2})(\d{4})(\d{4})$', r'+55 (\1) 9 \2 \3', item['phone'])
        item['phone'] = re.sub(
            r'^(\d{4})(\d{4})$', r'+55 (xx) 9 \1 \2', item['phone'])

    if form_data.gender:
        item['gender'] = form_data.gender

    item['metadata'] = dict(
        expected_signatures=form_data.expected_signatures,
        status_form="INSCRITO",
        unique_identifier=payload.unique_identifier,
        type_form="ATIVISTA"
    )

    # Clean response
    response = dict()
    for key, value in item.items():
        if value:
            response[key] = value

    return response


def to_payload(data: Payload):
    """to_payload"""
    payload = data.event.data.new
    table = data.table.name
    response = dict()

    if table == 'form_entries':
        response = form(payload=payload)
        response['action'] = 'form'

    elif table == 'donations':
        response = donation(payload=payload)
        response['action'] = 'donation'

    elif table == 'activist_pressures':
        response = pressure(payload=payload)
        response['action'] = 'pressure'

    elif table == 'plips':
        response = plip(payload=payload)
        response['action'] = 'plip'

    response['widget_id'] = payload.widget_id
    response['mobilization_id'] = payload.mobilization_id
    response['community_id'] = payload.cached_community_id
    response['action_id'] = payload.id
    response['action_date'] = payload.created_at

    return response
