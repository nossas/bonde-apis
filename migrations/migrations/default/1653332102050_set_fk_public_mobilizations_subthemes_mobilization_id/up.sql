alter table "public"."mobilizations_subthemes"
  add constraint "mobilizations_subthemes_mobilization_id_fkey"
  foreign key ("mobilization_id")
  references "public"."mobilizations"
  ("id") on update restrict on delete restrict;
