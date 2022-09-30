-- SCHEMA: analyze

-- DROP SCHEMA IF EXISTS "analyze" ;

CREATE SCHEMA IF NOT EXISTS "analyze";


-- Table: analyze.actions

-- DROP TABLE IF EXISTS "analyze".actions;

CREATE TABLE IF NOT EXISTS "analyze".actions
(
    community_id integer NOT NULL,
    mobilization_id integer NOT NULL,
    widget_id integer NOT NULL,
    an_action_id text COLLATE pg_catalog."default",
    an_resource_name text COLLATE pg_catalog."default" NOT NULL,
    an_response jsonb,
    mobilization_name text COLLATE pg_catalog."default"
);


-- Table: analyze.activist_actions

-- DROP TABLE IF EXISTS "analyze".activist_actions;

CREATE TABLE IF NOT EXISTS "analyze".activist_actions
(
    action text COLLATE pg_catalog."default" NOT NULL,
    action_id bigint NOT NULL,
    action_date text COLLATE pg_catalog."default",
    widget_id bigint,
    mobilization_id bigint,
    community_id bigint,
    email text COLLATE pg_catalog."default",
    name text COLLATE pg_catalog."default",
    given_name text COLLATE pg_catalog."default",
    family_name text COLLATE pg_catalog."default",
    address_line text COLLATE pg_catalog."default",
    locality text COLLATE pg_catalog."default",
    region text COLLATE pg_catalog."default",
    postal_code double precision,
    phone text COLLATE pg_catalog."default",
    gender double precision,
    color double precision,
    birthday text COLLATE pg_catalog."default",
    an_response jsonb,
    amount double precision,
    CONSTRAINT activist_actions_pkey PRIMARY KEY (action, action_id)
);


-- View: analyze.themes

-- DROP VIEW "analyze".themes;

CREATE OR REPLACE VIEW "analyze".themes
 AS
 SELECT s.label AS theme,
    m.id AS mobilization_id
   FROM mobilizations_subthemes ms
     JOIN mobilizations m ON m.id = ms.mobilization_id
     JOIN subthemes s ON s.id = ms.subtheme_id
     JOIN themes t ON t.id = m.theme_id;