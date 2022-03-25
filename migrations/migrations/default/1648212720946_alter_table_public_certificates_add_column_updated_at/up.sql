alter table "public"."certificates" add column "updated_at" timestamptz
 null default now();
