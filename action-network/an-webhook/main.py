"""
Documentation

See also https://www.python-boilerplate.com/flask
"""
import os
import json
import re
from flask import Flask, jsonify, request
from flask_cors import CORS
from sqlalchemy import create_engine, Table, Column, Integer, String, MetaData, ForeignKey

DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://')

# print(DATABASE_URL)

cnx = create_engine(DATABASE_URL,
                    pool_size=10,
                    max_overflow=2,
                    pool_recycle=300,
                    pool_pre_ping=True,
                    pool_use_lifo=True)

analyze_metadata = MetaData(schema="analyze")

activist_actions = Table("activist_actions", analyze_metadata,
    Column("action", String),
    Column("action_id", Integer),
    Column("action_date", String),
    Column("widget_id", Integer),
    Column("mobilization_id", Integer),
    Column("community_id", Integer),
    Column("email", String),
    Column("name", String, nullable=False),
    Column("given_name", String, nullable=False),
    Column("family_name", String, nullable=False),
    Column("address_line", String, nullable=False),
    Column("locality", String, nullable=False),
    Column("region", String, nullable=False),
    Column("postal_code", String, nullable=False),
    Column("phone", String, nullable=False),
    Column("gender", String, nullable=False),
    Column("color", String, nullable=False),
    Column("birthday", String, nullable=False),
    Column("amount", String, nullable=False)
)

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

def get_field(regex_pattern, fields):
    """xxx"""
    pattern = re.compile(regex_pattern)

    results = list(filter(lambda x: pattern.match(x['label'].lower()), fields))

    if len(results) == 1:
        return results[0]['value']

    return None


def prepare(data: dict):
    """xxx"""
    payload = data['event']['data']['new']
    fields = json.loads(payload['fields'])

    item = dict()

    item['given_name'] = get_field(
        r'(nombre|first[-\s]?name|seu nome|nome|name|primeiro[-\s]?nome)', fields)
    item['family_name'] = get_field(
        r'(sobre[\s-]?nome|seu sobre[\s-]?nome|surname|last[\s-]?name|apellido)', fields)
    item['email'] = get_field(
        r'(e-?mail|correo electr(o|ó)nico|email)', fields)
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

    # Clean response
    response = dict()

    for key in item.keys():
        if item[key]:
            response[key] = item[key]

    # Fill response with default params
    response['widget_id'] = payload['widget_id']
    response['mobilization_id'] = payload['mobilization_id']
    response['community_id'] = payload['cached_community_id']
    response['action_id'] = payload['id']
    response['action_date'] = payload['created_at']

    if data['table']['name'] == 'form_entries':
        response['action'] = 'form'

    return response

def insert_pg(data):
    """xxx"""
    cnx.execute(activist_actions.insert(), data)

def create_app(config=None):
    """xxx"""
    app= Flask(__name__)

    # See http://flask.pocoo.org/docs/latest/config/
    app.config.update(dict(DEBUG=True))
    app.config.update(config or {})

    # Setup cors headers to allow all domains
    # https://flask-cors.readthedocs.io/en/latest/
    CORS(app)

    # Definition of the routes. Put them into their own file. See also
    # Flask Blueprints: http://flask.pocoo.org/docs/latest/blueprints
    @ app.route("/webhook", methods=["POST"])
    def webhook():
        data= request.get_json()['body']

        result= prepare(data)
        insert_pg(result)

        return jsonify(result)

    return app


if __name__ == "__main__":
    port= int(os.environ.get("PORT", 8000))
    app= create_app()
    app.run(host="0.0.0.0", port=port)
