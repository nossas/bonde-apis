alter table "public"."certificates" alter column "updated_at" drop not null;
alter table "public"."certificates" add column "updated_at" timestamp;
