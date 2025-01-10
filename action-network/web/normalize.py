"""normalize.py"""
import json
import re

from typings import Donation, Form, Payload, Pressure, Plip
from utils import only_digits, get_field, find_by_ddd

def normalize_phone(phone):
    phone = only_digits(phone)
    patterns = [
        (r'^(\d{2})(\d{1})(\d{4})(\d{4})$', r'+55 (\1) \2 \3 \4'),
        (r'^(\d{1})(\d{4})(\d{4})$', r'+55 (xx) \1 \2 \3'),
        (r'^(\d{2})(\d{4})(\d{4})$', r'+55 (\1) 9 \2 \3'),
        (r'^(\d{4})(\d{4})$', r'+55 (xx) 9 \1 \2')
    ]
    for pattern, replacement in patterns:
        phone = re.sub(pattern, replacement, phone)
    return phone

def clean_response(item):
    return {key: value for key, value in item.items() if value}

def normalize_name(name, given_name, family_name):
    name = name.title() if name else ""
    given_name = given_name or name.split(" ")[0]
    family_name = family_name or " ".join(name.split(" ")[1:])
    return name, given_name.title(), family_name.title()

def normalize_region(region):
    if region and '(' in region:
        region = re.sub(r'[\w Á-ù]+\((\w{2})\)', r'\1', region)
    return region

def form(payload: Form):
    fields = json.loads(payload.fields)
    item = {
        'given_name': get_field(r'(nombre|first[\s\-\_]?name|seu nome|nome|name|primeiro[\s\-\_]?nome)', fields),
        'family_name': get_field(r'(sobre[\s\-\_]?nome|seu sobre[\s\-\_]?nome|surname|last[\s\-\_]?name|apellido)', fields),
        'email': get_field(r'(e-?mail|correo electr(o|ó)nico|email|seu.*email)', fields),
        'locality': get_field(r'(cidade|city|ciudad)', fields),
        'phone': get_field(r'(celular|mobile|portable|whatsapp)', fields),
        'region': get_field(r'(estado|state)', fields),
        'gender': get_field(r'(gen[e|ê]ro|orienta[ç|c][a|ã]o sexual|identifica)', fields),
        'color': get_field(r'(cor|ra[ç|c]a|etnia)', fields),
        'birthday': get_field(r'(data[de ]*nascimento|idade|[ano]*[de ]*nascimento)', fields)
    }

    item['region'] = normalize_region(item['region'])
    item['name'], item['given_name'], item['family_name'] = normalize_name(
        f"{item['given_name']} {item['family_name']}".strip(), item['given_name'], item['family_name']
    )
    if item['phone']:
        item['phone'] = normalize_phone(item['phone'])

    if not item['name'] or not item['email']:
        return None

    return clean_response(item)

def donation(payload: Donation):
    if not payload.transaction_status or not payload.payment_method:
        raise ValueError("Missing required fields in donation payload.")

    if payload.amount > 999999:
        raise ValueError("Amount exceeds allowed limit.")

    checkout_data = payload.checkout_data
    address = checkout_data.address
    phone = checkout_data.phone

    item = {
        'name': checkout_data.name.title(),
        'email': checkout_data.email,
        'metadata': {
            'amount': f"{str(payload.amount)[:-2]}.00",
            'transaction_status': payload.transaction_status,
            'payment_method': payload.payment_method,
            'recurring': payload.subscription,
            'recurring_period': "Monthly" if payload.subscription else None
        },
        'address_line': f"{address.street_number} {address.street}, {address.complementary}".strip(', '),
        'locality': address.city,
        'region': address.state,
        'postal_code': address.zipcode,
        'phone': f"+55{phone.ddd}{phone.number}" if phone else None
    }

    item['name'], item['given_name'], item['family_name'] = normalize_name(item['name'], None, None)
    return clean_response(item)

def pressure(payload: Pressure):
    form_data = payload.form_data
    item = {
        'name': form_data.name.title(),
        'email': form_data.email,
        'given_name': form_data.name.split(" ")[0].title(),
        'family_name': " ".join(form_data.name.split(" ")[1:]).title(),
        'region': form_data.state,
        'phone': normalize_phone(form_data.phone) if form_data.phone else None
    }
    if item['phone']:
        item['region'] = find_by_ddd(item['phone'])
    return clean_response(item)

def plip(payload: Plip):
    form_data = payload.form_data
    item = {
        'name': form_data.name.title(),
        'email': form_data.email,
        'region': form_data.state,
        'color': form_data.color,
        'phone': normalize_phone(form_data.whatsapp) if form_data.whatsapp else None,
        'metadata': {
            'expected_signatures': form_data.expected_signatures,
            'unique_identifier': payload.unique_identifier,
            'type_form': "Ativista"
        }
    }
    item['name'], item['given_name'], item['family_name'] = normalize_name(item['name'], None, None)
    return clean_response(item)

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
