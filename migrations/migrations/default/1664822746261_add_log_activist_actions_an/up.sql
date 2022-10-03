CREATE SCHEMA IF NOT EXISTS log;

CREATE TABLE IF NOT EXISTS log.activist_actions
(
    action_id integer,
    action text COLLATE pg_catalog."default",
    an_response jsonb
);