create table "public"."integrations_logs"(
	"id" serial4 NOT NULL,
	"created_at" timestamptz NOT NULL DEFAULT now(),
	"updated_at" timestamptz NOT NULL DEFAULT now(),
	"widget_id" int4 NOT NULL,
	"community_id" int4 NOT NULL,
	"integration_id" int4 NOT NULL,
	"message" text,
	"action_type" varchar(50) not null,
	"action_id" int4 not null,
	
	CONSTRAINT "integrations_logs_pkey" PRIMARY KEY ("id"),
	CONSTRAINT "integrations_logs_widget_id_fkey" FOREIGN KEY ("widget_id") REFERENCES public.widgets("id") ON DELETE RESTRICT ON UPDATE restrict,
  CONSTRAINT "integrations_logs_community_id_fkey" FOREIGN KEY ("community_id") REFERENCES public.communities("id") ON DELETE RESTRICT ON UPDATE restrict,
  CONSTRAINT "integrations_logs_integrations_id_fkey" FOREIGN KEY ("integration_id") REFERENCES public.integrations("id") ON DELETE RESTRICT ON UPDATE restrict

);COMMENT ON TABLE "public"."integrations_logs" IS E'Tabela responsável por armazenar logs das integrações realizadas a cada ação.';
