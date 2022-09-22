hasura_event_form_entries_json = {
    "event": {
        "session_variables": {
            "x-hasura-role": "admin"
        },
        "op": "INSERT",
        "data": {
            "old": None,
            "new": {
                "cached_community_id": 513,
                "synchronized": None,
                "mailchimp_syncronization_error_reason": None,
                "updated_at": "2022-09-19T20:04:47.569918",
                "rede_syncronized": False,
                "created_at": "2022-09-19T20:04:47.569918",
                "activist_id": 5731614,
                "mailchimp_status": None,
                "id": 3003555,
                "widget_id": 71408,
                "mailchimp_syncronization_at": None,
                "fields": "[{\"uid\":\"field-1499266904225-97\",\"kind\":\"text\",\"label\":\"Nome\",\"placeholder\":\"\",\"required\":true,\"value\":\"Nome\"},{\"uid\":\"field-1499266911225-52\",\"kind\":\"text\",\"label\":\"Sobrenome\",\"placeholder\":\"\",\"required\":true,\"value\":\"Sobrenome 827\"},{\"uid\":\"field-1499266918265-18\",\"kind\":\"email\",\"label\":\"Email\",\"placeholder\":\"\",\"required\":true,\"value\":\"email827@exemplo.com\"},{\"uid\":\"field-1499266928134-4\",\"kind\":\"dropdown\",\"label\":\"Cidade\",\"placeholder\":\"Rio de Janeiro,São Paulo,Recife\",\"required\":true,\"value\":\"Rio de Janeiro\"}]",
                "mobilization_id": 6981
            }
        },
        "trace_context": {
            "trace_id": "85fcfa2cff6a7e2f",
            "span_id": "9d616af98f909edf"
        }
    },
    "created_at": "2022-09-19T20:04:47.569918Z",
    "id": "3692b725-6337-4e35-8c9c-7ccac263f453",
    "delivery_info": {
        "max_retries": 3,
        "current_retry": 0
    },
    "trigger": {
        "name": "n8n-test"
    },
    "table": {
        "schema": "public",
        "name": "form_entries"
    }
}