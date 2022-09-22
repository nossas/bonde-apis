"""
Documentation

See also https://www.python-boilerplate.com/flask
"""
import os
from flask import Flask, jsonify, request
from flask_cors import CORS
from database import cnx, activist_actions
from normalize import to_payload

def create_app(config=None):
    """create_app"""
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
        data = request.get_json()['body']

        # Normalize hasura event data
        result = to_payload(data)
        # Insert normalized action in database
        cnx.execute(activist_actions.insert(), result)

        return jsonify(result)

    return app


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    app = create_app()
    app.run(host="0.0.0.0", port=port)
