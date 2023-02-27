**Normalização**

Padrão de entrada (INPUT):

TODO: Hasura Events Webhook

**Submissão**

Padrão de entrada (INPUT):

```json
{
    "action": string,
    "action_id": int,
    "action_date": string,
    "widget_id": int,
    "mobilization_id": int,
    "community_id": int,
    "email": string,
    "name": string,
    "given_name": string,
    "family_name": string,
    "address_line": string,
    "locality": string,
    "region": string,
    "postal_code": string,
    "phone": string,
    "gender": string,
    "color": string,
    "birthday": string,
    "metadata": JSON,
    "an_action_id": string,
    "mobilization_name": string,
    "an_resource_name": string,
    "an_group_id": string
}
```

first_action_date: data da primeira interação daquele e-mail com a widget


