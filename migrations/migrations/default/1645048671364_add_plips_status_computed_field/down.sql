-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- CREATE FUNCTION plips_status(p plips)
-- RETURNS TEXT AS $$
--     SELECT
--         CASE
--             WHEN (
--                 (SELECT sum(ps.confirmed_signatures) FROM plip_signatures ps WHERE ps.unique_identifier = p.unique_identifier) > 0
--             ) THEN 'CONCLUIDO'
--             WHEN (
--                 (SELECT sum(ps.confirmed_signatures) FROM plip_signatures ps WHERE ps.unique_identifier = p.unique_identifier) IS NULL AND
--                 (
--                     ((p.form_data->>'expected_signatures')::int = 10 AND p.created_at <= NOW() - INTERVAL '30' DAY) OR
--                     ((p.form_data->'expected_signatures')::int = 20 AND p.created_at <= NOW() - INTERVAL '60' DAY) OR
--                     ((p.form_data->'expected_signatures')::int = 30 AND p.created_at <= NOW() - INTERVAL '90' DAY) OR
--                     ((p.form_data->'expected_signatures')::int = 40 AND p.created_at <= NOW() - INTERVAL '120' DAY) OR
--                     ((p.form_data->'expected_signatures')::int = 50 AND p.created_at <= NOW() - INTERVAL '150' DAY) OR
--                     ((p.form_data->'expected_signatures')::int = 100 AND p.created_at <= NOW() - INTERVAL '180' DAY) OR
--                     ((p.form_data->'expected_signatures')::int = 500 AND p.created_at <= NOW() - INTERVAL '210' DAY) OR
--                     ((p.form_data->'expected_signatures')::int = 1000 AND p.created_at <= NOW() - INTERVAL '240' DAY)
--                 )
--             ) THEN 'PENDENTE'
--             ELSE 'INSCRITO'
--         END;
-- $$ LANGUAGE sql STABLE;
