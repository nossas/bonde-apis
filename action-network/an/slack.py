import os
# from slack_sdk import WebClient
# from slack_sdk.errors import SlackApiError
import json
import requests
from logger import logging


def notify(msg: str):
    """Send message to slack channel"""
    # ID of channel you want to post message to
    payload = {
        "text": f"<!subteam^SM0DGGHCG> {msg}"
    }

    headers = {
        'Content-Type': 'application/json'
    }
    response = requests.request(
        "POST", os.environ['SLACK_BOT_WEBHOOK_URL'], data=json.dumps(payload), headers=headers)

    if response.status_code == 200:
        logging.info(f"Notify slack {msg}")
    else:
        logging.error(f"Notify slack {response.text}")
