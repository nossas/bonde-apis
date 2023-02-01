"""
Server for webapi
"""
from fastapi import FastAPI, status
from fastapi.responses import JSONResponse
from sqlalchemy.exc import IntegrityError

from typings import Payload
from database import cnx, activist_actions
from normalize import to_payload
import json

app = FastAPI()

@app.post("/webhook/activist_action")
def webhook_activist_action(body: Payload):
    """Webhook for integration Bonde activist actions to Action Network"""
    # Normalize hasura event payload
    result = to_payload(body)

    try:
        if result['action'] == "donation" and result['metadata']['transaction_status'] not in ['pending','processing']:
            # Update transaction_status from donation
            cnx.execute('UPDATE "analyze".activist_actions SET metadata = \'' + json.dumps(result['metadata']) + '\' WHERE action_id = ' + str(result['action_id']))
        else:
            # Insert normalized action in database
            cnx.execute(activist_actions.insert(), result)
    except IntegrityError:
        # Continue process don't stop workflow
        # Database is responsible not duplicate
        pass

    return result
