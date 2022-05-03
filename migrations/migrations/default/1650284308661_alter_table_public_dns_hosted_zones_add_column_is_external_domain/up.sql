alter table "public"."dns_hosted_zones" add column "is_external_domain" boolean
 not null default 'false';
