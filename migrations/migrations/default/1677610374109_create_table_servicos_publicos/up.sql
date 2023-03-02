CREATE SCHEMA IF NOT EXISTS "mapa_do_acolhimento"; 

CREATE TABLE "mapa_do_acolhimento".servicos_publicos (
	id int4 NOT NULL,
	area text null,
	servico text null,
	nome text null,
	estado text null,
	municipio text null,
	endereco text null,
	created_at timestamptz NOT NULL DEFAULT now(),
	updated_at timestamptz NOT NULL DEFAULT now(),
	CONSTRAINT servicos_publicos_pk PRIMARY KEY (id)
);COMMENT ON TABLE "mapa_do_acolhimento".servicos_publicos IS E'Mapeamento Serviço Público da Rede de Enfrentamento de Violência Contra Mulher .';
CREATE SEQUENCE servicos_publicos_id;
ALTER TABLE "mapa_do_acolhimento".servicos_publicos ALTER COLUMN id SET DEFAULT nextval('servicos_publicos_id');