## Como contribuir com o desenvolvimento

### Preparando o ambiente virtual

Em um dispositivo com Python 3, crie um ambiente virtual com o módulo `virtualenv`:

`python3 -m venv environment`

Ative seu ambiente virtual:

`source bin environment/bin/activate`

### Variáveis de ambiente

Configure um arquivo `.env` com as variáveis a seguir:

- `DATABASE_URL`: Base de dados PostgreSQL
- `GOOGLE_APPLICATION_CREDENTIALS`: Credencial de acesso ao BigQuery
- `ACTION_NETWORK_API_KEY`: Chave de API do grupo principal na ActionNetwork

## WEB
Projeto baseado em Python 3 e (https://fastapi.tiangolo.com)[fastapi]

Instale as dependências do projeto para usar a WEB:

`pip install -r requirements-web.txt`

Execute o servidor dentro da pasta `web`:

`uvicorn main:app --reload`

## CLI

Instale as dependências do projeto para usar a CLI:

`pip install -r requirements-cli.txt`

Prefixo utilizado no shell para qualquer comando:

`export $(cat .env | xargs) && python an/cli.py [COMMAND] [--ARGS]`

### Lista de comandos

Normalizar ações do Bonde para serem inseridas no conjunto de dados do BigQuery

`normalize --community [int] --action [donation | pressure | form]`

Sincronizar widgets e mobilizações do Bonde para ações da Action Network

`syncronize --community [int] --action [donation | pressure | form]`

Submiter ação do ativista normalizada no BigQuery para Action Network

`submit --community [int] --start [datetime string] --end [datetime string] --background [boolean]`

Sincronizar relação de temas e subtemas das mobilizações do Bonde para temas no BigQuery e tags na ActionNetwork

`tags --db [bq | an]`

## TODO
- [] Verificar funcionamento do atributo `region` com Datadat
- [] Documentar processo de despublicar grupos ActionNetwork