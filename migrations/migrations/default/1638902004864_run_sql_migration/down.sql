-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- CREATE OR REPLACE VIEW plips_by_state AS
-- SELECT
--     widget_id,
--     count(id) as subscribers,
--     state as state,
--     sum(confirmed_signatures) as confirmed_signatures,
--     sum(expected_signatures) as expected_signatures
--     FROM plips
--     GROUP BY widget_id, state
-- ;
