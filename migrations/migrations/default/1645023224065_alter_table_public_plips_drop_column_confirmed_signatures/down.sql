alter table "public"."plips" alter column "confirmed_signatures" drop not null;
alter table "public"."plips" add column "confirmed_signatures" int4;
