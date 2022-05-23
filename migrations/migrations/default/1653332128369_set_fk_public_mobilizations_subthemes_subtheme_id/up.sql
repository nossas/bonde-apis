alter table "public"."mobilizations_subthemes"
  add constraint "mobilizations_subthemes_subtheme_id_fkey"
  foreign key ("subtheme_id")
  references "public"."subthemes"
  ("id") on update restrict on delete restrict;
