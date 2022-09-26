"""
Server for webapi
"""
from fastapi import FastAPI

from typings import Payload
from database import cnx, activist_actions
from normalize import to_payload

app = FastAPI()

@app.post("/webhook/activist_action")
def webhook_activist_action(body: Payload):
    """Webhook for integration Bonde activist actions to Action Network"""
    # Normalize hasura event payload
    result = to_payload(body)
    # Insert normalized action in database
    cnx.execute(activist_actions.insert(), result)

    return result
