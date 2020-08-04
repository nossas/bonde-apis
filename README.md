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

Copy a base project to GraphQL API:

```
cookiecutter example-api/ -o packages/
```

Run tests on your new GraphQL API, change `example` by the `domain` configuration made in the previous step:
```
pnpm m run tests --filter example-api
```