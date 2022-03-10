# Hasura Migrations

## Requirements

* (Hasura CLI)[https://hasura.io/docs/latest/graphql/core/hasura-cli/install-hasura-cli.html] `curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash`
* Endpoint GraphQL
* Graphql Admin Secret

Migrations and metadata

All interactions with hasura migrations and metadata must be made in these path.

## How to open console

* `HASURA_GRAPHQL_ADMIN_SECRET=a1111 hasura console  --endpoint http://api-graphql.bonde.devel`

## How to export metadata

* `HASURA_GRAPHQL_ADMIN_SECRET=a1111 hasura metadata export  --endpoint http://api-graphql.bonde.devel`

## How to show applied migrations

* `HASURA_GRAPHQL_ADMIN_SECRET=a1111 hasura migrate diff  --endpoint http://api-graphql.bonde.devel`

## How to deploy rules / contributing

* `HASURA_GRAPHQL_ADMIN_SECRET=a1111 hasura migrate apply  --endpoint http://api-graphql.bonde.devel`
