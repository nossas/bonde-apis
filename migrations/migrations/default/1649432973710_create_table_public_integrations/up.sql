create table "public"."integrations"  (
	"id" serial4 NOT NULL,
	"created_at" timestamptz NOT NULL DEFAULT now(),
	"updated_at" timestamptz NOT NULL DEFAULT now(),
	"community_id" int4 NOT NULL,
	"name" varchar(50) not null,
	"credentials" jsonb not null,
	CONSTRAINT "integrations_pkey" PRIMARY KEY ("id"),
	CONSTRAINT "integrations_community_id_fkey" FOREIGN KEY ("community_id") REFERENCES "public"."communities"("id") ON DELETE RESTRICT ON UPDATE RESTRICT
);COMMENT ON TABLE "public"."integrations" IS E'Tabela responsável por armazenar informações das configurações das integrações usadas numa comunidade.';
