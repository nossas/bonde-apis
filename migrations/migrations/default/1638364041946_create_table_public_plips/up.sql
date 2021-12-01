CREATE TABLE "public"."plips" ("id" serial NOT NULL, "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "unique_identifier" uuid NOT NULL, "widget_id" Integer NOT NULL, "form_data" jsonb NOT NULL, "pdf_data" text, PRIMARY KEY ("id") , FOREIGN KEY ("widget_id") REFERENCES "public"."widgets"("id") ON UPDATE restrict ON DELETE restrict, UNIQUE ("id"));
CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_plips_updated_at"
BEFORE UPDATE ON "public"."plips"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_plips_updated_at" ON "public"."plips" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
