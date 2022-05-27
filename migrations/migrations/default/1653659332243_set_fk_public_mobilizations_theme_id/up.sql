alter table "public"."mobilizations"
  add constraint "mobilizations_theme_id_fkey"
  foreign key ("theme_id")
  references "public"."themes"
  ("id") on update restrict on delete restrict;
