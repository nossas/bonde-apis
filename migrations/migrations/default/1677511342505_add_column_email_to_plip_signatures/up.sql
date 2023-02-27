ALTER TABLE public.plip_signatures ADD column email text;
CREATE OR REPLACE FUNCTION public.plip_signatures_add_email()
                           RETURNS trigger AS
$BODY$
begin
  NEW.email = (SELECT distinct p.form_data->>'email'
                            FROM public.plips p
                            WHERE p.unique_identifier = NEW.unique_identifier);
  RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER plip_signatures_add_email
               BEFORE INSERT
               ON public.plip_signatures
               FOR EACH ROW
               EXECUTE PROCEDURE public.plip_signatures_add_email();