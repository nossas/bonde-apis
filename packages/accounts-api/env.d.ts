declare namespace NodeJS {
  export interface ProcessEnv {
    PORT?: string
    HOST?: string
    LOG_LEVEL?: string
    GRAPHQL_HTTP_URL: string
    JWT_SECRET: string
    JWT_TOKEN?: string
    HASURA_SECRET?: string
    AWS_ACCESS_KEY?: string
    AWS_SECRET_KEY?: string
    AWS_ROUTE53_REGION?: string
    AWS_LOAD_BALANCER_DNS?: string
    AWS_LOAD_BALANCER_HOSTED_ZONE_ID?: string
  }
}