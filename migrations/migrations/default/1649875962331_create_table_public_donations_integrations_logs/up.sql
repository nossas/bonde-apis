create table "public"."donations_integration_logs"(
	"id" serial4 NOT NULL,
	"created_at" timestamptz NOT NULL DEFAULT now(),
	"updated_at" timestamptz NOT NULL DEFAULT now(),
	"widget_id" int4 NOT NULL,
	"community_id" int4 NOT NULL,
	"integration_id" int4 NOT NULL,
	"message" text,
	"action_type" varchar(50) not null,
	"donation_id" int4 not null,
	
	CONSTRAINT "donations_integration_logs_pkey" PRIMARY KEY ("id"),
	CONSTRAINT "donations_integration_logs_widget_id_fkey" FOREIGN KEY ("widget_id") REFERENCES public.widgets("id") ON DELETE RESTRICT ON UPDATE restrict,
  CONSTRAINT "donations_integration_logs_community_id_fkey" FOREIGN KEY ("community_id") REFERENCES public.communities("id") ON DELETE RESTRICT ON UPDATE restrict,
  CONSTRAINT "donations_integration_logs_integrations_id_fkey" FOREIGN KEY ("integration_id") REFERENCES public.integrations("id") ON DELETE RESTRICT ON UPDATE restrict,
  CONSTRAINT "donations_integration_logs_donation_id_fkey" FOREIGN KEY ("donation_id") REFERENCES public.donations("id") ON DELETE RESTRICT ON UPDATE restrict

);COMMENT ON TABLE "public"."donations_integration_logs" IS E'Tabela responsável por armazenar logs das integrações realizadas a cada doação.';