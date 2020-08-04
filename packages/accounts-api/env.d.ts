declare namespace NodeJS {
  export interface ProcessEnv {
    PORT?: number
    HOST?: string
    DEBUG: string
    GRAPHQL_HTTP_URL: string
    JWT_SECRET: string
    HASURA_SECRET?: string
  }
}
