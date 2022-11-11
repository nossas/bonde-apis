--change postal_code to text
ALTER TABLE "analyze".activist_actions ALTER COLUMN postal_code TYPE text;
ALTER TABLE "analyze".activist_actions DROP COLUMN amount;
ALTER TABLE "analyze".activist_actions DROP COLUMN an_response;
