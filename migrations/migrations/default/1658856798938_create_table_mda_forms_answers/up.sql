CREATE TABLE public.mda_forms_answers (
	id int4 NOT NULL ,
	form varchar NOT NULL,
	form_id int4 NOT NULL ,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	organization_id int8 NULL,
	volunteer_email varchar NOT NULL,
	msr_name varchar NOT NULL,
	ticket_id int4 NULL,
	answers json NULL,
	CONSTRAINT mda_forms_answers_pk PRIMARY KEY (id)
);COMMENT ON TABLE "public"."mda_forms_answers" IS E'Tabela responsável por armazenar respostas das voluntarias referante aos formulários de atendimento.';
CREATE SEQUENCE mda_forms_answers_id;
ALTER TABLE mda_forms_answers ALTER COLUMN id SET DEFAULT nextval('mda_forms_answers_id');
create trigger set_public_mda_forms_answers_updated_at before
update
    on
    public.mda_forms_answers for each row execute function set_current_timestamp_updated_at();