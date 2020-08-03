# Bonde GraphQL APIs

TODO:

- [ ] Definição resumida
- [ ] Definição tecnica de uma API GraphQL (bibliotecas)
- [ ] Definição de arquitetura e fluxo de acesso

- How to build? typescript
- How to lint? eslint
- How to tests? jest
- How to run dev? nodemon and ts-node

### Setup API

**package.json**

```json
{
  "name": "{{ service_name }}-api",
  "scripts": {
    "build": "tsc -p .",
    "build:dev": "nodemon 'src/server.ts' --exec 'ts-node' src/server.ts -e ts,graphql",
    "clean": "rm -rf node_modules dist",
    "dev": "LOG_LEVEL=debug NODE_ENV=development yarn run build:dev",
    "start": "node 'dist/server.js'",
    "lint": "eslint . --ext ts,tsx --fix"
  }
}
```

**tsconfig.json**

```json
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "rootDir": "src",
    "outDir": "dist"
  }
}
```