CREATE TABLE "mapa_do_acolhimento"."iana_feedback" (
  "id" SERIAL NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  "user_id" BIGINT NOT NULL,
  "question" TEXT NOT NULL,
  "answer" TEXT,
	
  CONSTRAINT "iana_feedback_pkey" PRIMARY KEY ("id")
);