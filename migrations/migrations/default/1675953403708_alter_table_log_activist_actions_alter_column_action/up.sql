-- View: analyze.donations_not_sync
DROP MATERIALIZED VIEW IF EXISTS "analyze".donations_not_sync;

ALTER TABLE "analyze".log_activist_actions ALTER COLUMN action TYPE VARCHAR(15);

CREATE MATERIALIZED VIEW IF NOT EXISTS "analyze".donations_not_sync
TABLESPACE pg_default
AS
 SELECT aa.action,
    aa.action_id,
    aa.action_date,
    aa.widget_id,
    aa.mobilization_id,
    aa.community_id,
    aa.email,
    aa.name,
    aa.given_name,
    aa.family_name,
    aa.address_line,
    aa.locality,
    aa.region,
    aa.postal_code,
    aa.phone,
    aa.gender,
    aa.color,
    aa.birthday,
    aa.metadata
   FROM "analyze".activist_actions aa
     FULL JOIN "analyze".log_activist_actions log_aa ON log_aa.action_id = aa.action_id AND log_aa.action::text = aa.action
  WHERE aa.action = 'donation'::text AND (aa.metadata ->> 'transaction_status'::text) = 'paid'::text AND log_aa.an_response IS NULL
WITH DATA;

ALTER TABLE IF EXISTS "analyze".donations_not_sync
    OWNER TO cobrador;