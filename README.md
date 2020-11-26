# Bonde GraphQL APIs

TODO:

- [ ] Definição resumida
- [X] Definição tecnica de uma API GraphQL (bibliotecas)
- [ ] Definição de arquitetura e fluxo de acesso

### Understand the SETUP

**Install**

```sh
# Install the package manager
yarn global add pnpm
# Install packages dependencies
pnpm i
```

**Libraries**

- Build (Node, Typescript)
- Server (Express, GraphQL)
- Log (Pino)
- Tests (Jest)

**Commands**

- Tests:

```sh
pnpm m run tests # pnpm m run coverage
```

- Development server:

```sh
pnpm m run dev
```

- Production build and start:

```sh
pnpm m run build
pnpm m run start
```

### How to create a new package?

Install [cookiecutter](https://cookiecutter.readthedocs.io/en/1.7.2/installation.html#install-cookiecutter), following setup on Debian/Ubuntu OS:

```
sudo apt-get install cookiecutter
```

PS: In Ubuntu version 20.04 there's no package available for `cookiecutter` (yet). You'll need to install it via Python packages.

Copy a base project to GraphQL API:

```
cookiecutter example-api/ -o packages/
```

Run tests on your new GraphQL API, change `example` by the `domain` configuration made in the previous step:
```
pnpm m run tests --filter example-api
```

### Requirements for adding permissions to resolver

- The permissions for the user that made the request are checked before our resolver is called
- `community_id` must be passed from the resolver args input
  - That's where the **permissions-util** get the `community_id`
- The session context is passed in every Graphql request (you can see it in the `server.js`), and it's data are contained inside the `Bearer ${token}`
  - More info about _context_ and authentication in this [Apollo docs article](https://www.apollographql.com/docs/apollo-server/security/authentication/) 
  - If you wish to import a resolver inside another, **you** must pass the context via parameters (see an example of this in the `create_match` resolver inside the _redes_ package)

### How to test if my API is working?

1. Initiate a localhost tunnel using `ngrok`
2. Declare the SCHEMA url in the `api-graphql` service via enviroment variables
3. Create a Remote Schema in Hasura using the SCHEMA variable you just declared in the service
4. Start your API and happy coding!