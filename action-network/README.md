## How to development

Create virtualenv:

`python3 -m venv environment`

Activate virtualenv:

`source bin environment/bin/activate`

Install dependencies:

`pip install -r requirements-cli.txt`

## Environments

- `DATABASE_URL`
- `GOOGLE_APPLICATION_CREDENTIALS`

## Commands

`export $(cat .env | xargs) && python an/cli.py normalize --community 263 --action donation`

## TODO
- [] Setup Pandas
- [] Setup BigQuery
- [] Setup SQLAlchemy
- [] Setup envs
- [] Setup logging
- [] Setup tests
- [] Setup CLI