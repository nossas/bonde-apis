"""
Server for webapi
"""
from fastapi import FastAPI, status
from fastapi.responses import JSONResponse
from sqlalchemy.exc import IntegrityError
from sqlalchemy import insert, update

from typings import Payload
from database import cnx, activist_actions
from normalize import to_payload
import json

app = FastAPI()

@app.post("/webhook/activist_action")

async def webhook_activist_action(body: Payload):
    """Webhook for integration Bonde activist actions to Action Network"""
    # Normalize hasura event payload
    result = to_payload(body)

    try:
        if result['action'] == "donation" and result['metadata']['transaction_status'] not in ['pending','processing']:
            # Update transaction_status from donation
            stmt = (
                update(activist_actions).
                where(activist_actions.c.action_id == result['action_id']).
                values(metadata=result['metadata'])
            )

            with cnx.connect() as connection:
                connection.execute(stmt)
                connection.commit()

        else:
            # Insert normalized action in database
            with cnx.connect() as connection:
                connection.execute(activist_actions.insert(), result)
                connection.commit()

    except IntegrityError:
        # Continue process don't stop workflow
        # Database is responsible not duplicate
        pass

    return result
