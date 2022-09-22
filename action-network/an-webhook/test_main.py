"""
You can auto-discover and run all tests with this command:

    $ pytest

Documentation:

* https://docs.pytest.org/en/latest/
* https://docs.pytest.org/en/latest/fixture.html
* http://flask.pocoo.org/docs/latest/testing/
"""

import json
import pytest
# import sqlalchemy

# main.py
import main
from mock import hasura_event_form_entries_json


@pytest.fixture
def create_engine(monkeypatch):
    """mock_cnx"""
    def mock_create_engine():
        # import ipdb; ipdb.set_trace()
        return dict(execute=lambda x: x)

    monkeypatch.setattr("sqlalchemy.create_engine", mock_create_engine)


@pytest.fixture
def app():
    app = main.create_app()
    app.debug = True
    return app.test_client()


def test_webhook_post(app):
    """xxx"""
    mimetype = 'application/json'
    headers = {
        'Content-Type': mimetype,
        'Accept': mimetype
    }

    res = app.post("/webhook",
                   data=json.dumps({'body': hasura_event_form_entries_json}),
                   headers=headers)

    expected = dict(
        given_name='Nome',
        family_name='Sobrenome 827',
        email='email827@exemplo.com',
        locality='Rio de Janeiro'
    )

    assert res.status_code == 200
    assert res.json == expected


def test_webhook_get(app):
    """xxx"""
    res = app.get("/webhook")
    assert res.status_code == 405
