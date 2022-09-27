"""
Server for webapi
"""
from fastapi import FastAPI, status
from fastapi.responses import JSONResponse
from sqlalchemy.exc import IntegrityError

from typings import Payload
from database import cnx, activist_actions
from normalize import to_payload

app = FastAPI()

@app.post("/webhook/activist_action")
def webhook_activist_action(body: Payload):
    """Webhook for integration Bonde activist actions to Action Network"""
    # Normalize hasura event payload
    result = to_payload(body)

    try:
        # Insert normalized action in database
        cnx.execute(activist_actions.insert(), result)
    except IntegrityError as err:
        print(err)
        return JSONResponse(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            content=dict(message="sqlalchemy.IntegrityError")
        )

    return result
