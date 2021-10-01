--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.22
-- Dumped by pg_dump version 13.4 (Ubuntu 13.4-0ubuntu0.21.04.1)

-- Started on 2021-10-01 16:58:30 -03

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 19 (class 2615 OID 1956492)
-- Name: anonymous; Type: SCHEMA; Schema: -; Owner: reboo
--
create role postgraphql login password '3x4mpl3';
create role reboo;
create role anonymous;
create role common_user;
create role admin;
create role postgres;

CREATE SCHEMA anonymous;


ALTER SCHEMA anonymous OWNER TO reboo;


--
-- TOC entry 17 (class 2615 OID 148850)
-- Name: pgjwt; Type: SCHEMA; Schema: -; Owner: reboo
--

CREATE SCHEMA pgjwt;


ALTER SCHEMA pgjwt OWNER TO reboo;

--
-- TOC entry 18 (class 2615 OID 174510)
-- Name: postgraphile_watch; Type: SCHEMA; Schema: -; Owner: reboo
--

CREATE SCHEMA postgraphile_watch;


ALTER SCHEMA postgraphile_watch OWNER TO reboo;

--
-- TOC entry 13 (class 2615 OID 16539)
-- Name: postgraphql; Type: SCHEMA; Schema: -; Owner: reboo
--

CREATE SCHEMA postgraphql;


ALTER SCHEMA postgraphql OWNER TO reboo;

--
-- TOC entry 15 (class 2615 OID 148798)
-- Name: postgraphql_watch; Type: SCHEMA; Schema: -; Owner: reboo
--

CREATE SCHEMA postgraphql_watch;


ALTER SCHEMA postgraphql_watch OWNER TO reboo;

--
-- TOC entry 1 (class 3079 OID 16541)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 4700 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 7 (class 3079 OID 16555)
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- TOC entry 4701 (class 0 OID 0)
-- Dependencies: 7
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- TOC entry 6 (class 3079 OID 16558)
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- TOC entry 4702 (class 0 OID 0)
-- Dependencies: 6
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- TOC entry 5 (class 3079 OID 16560)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- TOC entry 4703 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- TOC entry 4 (class 3079 OID 16561)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 4704 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 3 (class 3079 OID 16563)
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- TOC entry 4705 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- TOC entry 2 (class 3079 OID 16565)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 4706 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';

--
-- TOC entry 978 (class 1247 OID 56120)
-- Name: facebook_activist_search_result_type; Type: TYPE; Schema: postgraphql; Owner: reboo
--

CREATE TYPE postgraphql.facebook_activist_search_result_type AS (
	fb_context_recipient_id text,
	fb_context_sender_id text,
	data jsonb,
	messages tsvector,
	quick_replies text[],
	created_at timestamp without time zone,
	updated_at timestamp without time zone,
	id integer
);


ALTER TYPE postgraphql.facebook_activist_search_result_type OWNER TO reboo;

--
-- TOC entry 1036 (class 1247 OID 71293)
-- Name: facebook_bot_campaigns_type; Type: TYPE; Schema: postgraphql; Owner: reboo
--

CREATE TYPE postgraphql.facebook_bot_campaigns_type AS (
	facebook_bot_configuration_id integer,
	name text,
	segment_filters jsonb,
	total_impacted_activists integer
);


ALTER TYPE postgraphql.facebook_bot_campaigns_type OWNER TO reboo;

--
-- TOC entry 1039 (class 1247 OID 71302)
-- Name: get_facebook_bot_campaign_activists_by_campaign_type; Type: TYPE; Schema: postgraphql; Owner: reboo
--

CREATE TYPE postgraphql.get_facebook_bot_campaign_activists_by_campaign_type AS (
	id integer,
	facebook_bot_campaign_id integer,
	facebook_bot_activist_id integer,
	received boolean,
	log jsonb,
	created_at timestamp without time zone,
	updated_at timestamp without time zone,
	fb_context_recipient_id text,
	fb_context_sender_id text,
	data jsonb,
	messages tsvector,
	quick_replies text[],
	interaction_dates timestamp without time zone[]
);


ALTER TYPE postgraphql.get_facebook_bot_campaign_activists_by_campaign_type OWNER TO reboo;

--
-- TOC entry 1042 (class 1247 OID 46922)
-- Name: jwt_token; Type: TYPE; Schema: postgraphql; Owner: reboo
--

CREATE TYPE postgraphql.jwt_token AS (
	role text,
	user_id integer
);


ALTER TYPE postgraphql.jwt_token OWNER TO reboo;

--
-- TOC entry 1045 (class 1247 OID 51950)
-- Name: twilio_calls_arguments; Type: TYPE; Schema: postgraphql; Owner: reboo
--

CREATE TYPE postgraphql.twilio_calls_arguments AS (
	activist_id integer,
	widget_id integer,
	"from" text,
	"to" text,
	twilio_call_sid text
);


ALTER TYPE postgraphql.twilio_calls_arguments OWNER TO reboo;

--
-- TOC entry 1048 (class 1247 OID 51953)
-- Name: watch_twilio_call_transition_record_set; Type: TYPE; Schema: postgraphql; Owner: reboo
--

CREATE TYPE postgraphql.watch_twilio_call_transition_record_set AS (
	widget_id integer,
	activist_id integer,
	twilio_call_id integer,
	twilio_call_account_sid text,
	twilio_call_call_sid text,
	twilio_call_from text,
	twilio_call_to text,
	twilio_call_transition_id integer,
	twilio_call_transition_sequence_number integer,
	twilio_call_transition_status text,
	twilio_call_transition_call_duration text,
	twilio_call_transition_created_at timestamp without time zone,
	twilio_call_transition_updated_at timestamp without time zone
);


ALTER TYPE postgraphql.watch_twilio_call_transition_record_set OWNER TO reboo;

--
-- TOC entry 1399 (class 1247 OID 227109)
-- Name: change_password_fields; Type: TYPE; Schema: public; Owner: reboo
--

CREATE TYPE public.change_password_fields AS (
	user_first_name text,
	user_last_name text,
	token postgraphql.jwt_token
);


ALTER TYPE public.change_password_fields OWNER TO reboo;

--
-- TOC entry 1473 (class 1247 OID 18428719)
-- Name: dnshostedzonestatus; Type: TYPE; Schema: public; Owner: reboo
--

CREATE TYPE public.dnshostedzonestatus AS ENUM (
    'created',
    'propagating',
    'propagated',
    'certifying',
    'certified'
);


ALTER TYPE public.dnshostedzonestatus OWNER TO reboo;

--
-- TOC entry 1054 (class 1247 OID 71283)
-- Name: email; Type: DOMAIN; Schema: public; Owner: reboo
--

CREATE DOMAIN public.email AS public.citext
	CONSTRAINT email_check CHECK ((VALUE OPERATOR(public.~) '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'::public.citext));


ALTER DOMAIN public.email OWNER TO reboo;

--
-- TOC entry 1062 (class 1247 OID 86183)
-- Name: status_mobilization; Type: TYPE; Schema: public; Owner: reboo
--

CREATE TYPE public.status_mobilization AS ENUM (
    'active',
    'archived'
);


ALTER TYPE public.status_mobilization OWNER TO reboo;

--
-- TOC entry 629 (class 1255 OID 122095)
-- Name: locale_names(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.locale_names() RETURNS text[]
    LANGUAGE sql IMMUTABLE
    AS $$
    select '{pt-BR, es, en}'::text[];
$$;


ALTER FUNCTION public.locale_names() OWNER TO reboo;

SET default_tablespace = '';

--
-- TOC entry 222 (class 1259 OID 16619)
-- Name: users; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.users (
    id integer NOT NULL,
    provider character varying NOT NULL,
    uid character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    first_name character varying,
    last_name character varying,
    email character varying,
    tokens text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    avatar character varying,
    admin boolean,
    locale text DEFAULT 'pt-BR'::text NOT NULL,
    is_admin boolean DEFAULT false,
    CONSTRAINT localechk CHECK ((locale = ANY (public.locale_names())))
);


ALTER TABLE public.users OWNER TO reboo;

--
-- TOC entry 642 (class 1255 OID 148853)
-- Name: algorithm_sign(text, text, text); Type: FUNCTION; Schema: pgjwt; Owner: reboo
--

CREATE FUNCTION pgjwt.algorithm_sign(signables text, secret text, algorithm text) RETURNS text
    LANGUAGE sql
    AS $$
      WITH
        alg AS (
          SELECT CASE
            WHEN algorithm = 'HS256' THEN 'sha256'
            WHEN algorithm = 'HS384' THEN 'sha384'
            WHEN algorithm = 'HS512' THEN 'sha512'
            ELSE '' END AS id)  -- hmac throws error
      SELECT pgjwt.url_encode(hmac(signables, secret, alg.id)) FROM alg;
      $$;


ALTER FUNCTION pgjwt.algorithm_sign(signables text, secret text, algorithm text) OWNER TO reboo;

--
-- TOC entry 643 (class 1255 OID 148854)
-- Name: sign(json, text, text); Type: FUNCTION; Schema: pgjwt; Owner: reboo
--

CREATE FUNCTION pgjwt.sign(payload json, secret text, algorithm text DEFAULT 'HS256'::text) RETURNS text
    LANGUAGE sql
    AS $$
      WITH
        header AS (
          SELECT pgjwt.url_encode(convert_to('{"alg":"' || algorithm || '","typ":"JWT"}', 'utf8')) AS data
          ),
        payload AS (
          SELECT pgjwt.url_encode(convert_to(payload::text, 'utf8')) AS data
          ),
        signables AS (
          SELECT header.data || '.' || payload.data AS data FROM header, payload
          )
      SELECT
          signables.data || '.' ||
          pgjwt.algorithm_sign(signables.data, secret, algorithm) FROM signables;
      $$;


ALTER FUNCTION pgjwt.sign(payload json, secret text, algorithm text) OWNER TO reboo;

--
-- TOC entry 641 (class 1255 OID 148852)
-- Name: url_decode(text); Type: FUNCTION; Schema: pgjwt; Owner: reboo
--

CREATE FUNCTION pgjwt.url_decode(data text) RETURNS bytea
    LANGUAGE sql
    AS $$
      WITH t AS (SELECT translate(data, '-_', '+/') AS trans),
           rem AS (SELECT length(t.trans) % 4 AS remainder FROM t) -- compute padding size
          SELECT decode(
              t.trans ||
              CASE WHEN rem.remainder > 0
                 THEN repeat('=', (4 - rem.remainder))
                 ELSE '' END,
          'base64') FROM t, rem;
      $$;


ALTER FUNCTION pgjwt.url_decode(data text) OWNER TO reboo;

--
-- TOC entry 640 (class 1255 OID 148851)
-- Name: url_encode(bytea); Type: FUNCTION; Schema: pgjwt; Owner: reboo
--

CREATE FUNCTION pgjwt.url_encode(data bytea) RETURNS text
    LANGUAGE sql
    AS $$
      SELECT translate(encode(data, 'base64'), E'+/=\n', '-_');
$$;


ALTER FUNCTION pgjwt.url_encode(data bytea) OWNER TO reboo;

--
-- TOC entry 631 (class 1255 OID 148855)
-- Name: verify(text, text, text); Type: FUNCTION; Schema: pgjwt; Owner: reboo
--

CREATE FUNCTION pgjwt.verify(token text, secret text, algorithm text DEFAULT 'HS256'::text) RETURNS TABLE(header json, payload json, valid boolean)
    LANGUAGE sql
    AS $$
        SELECT
          convert_from(pgjwt.url_decode(r[1]), 'utf8')::json AS header,
          convert_from(pgjwt.url_decode(r[2]), 'utf8')::json AS payload,
          r[3] = pgjwt.algorithm_sign(r[1] || '.' || r[2], secret, algorithm) AS valid
        FROM regexp_split_to_array(token, '\.') r;
      $$;


ALTER FUNCTION pgjwt.verify(token text, secret text, algorithm text) OWNER TO reboo;

--
-- TOC entry 654 (class 1255 OID 174511)
-- Name: notify_watchers_ddl(); Type: FUNCTION; Schema: postgraphile_watch; Owner: reboo
--

CREATE FUNCTION postgraphile_watch.notify_watchers_ddl() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
begin
  perform pg_notify(
    'postgraphile_watch',
    json_build_object(
      'type',
      'ddl',
      'payload',
      (select json_agg(json_build_object('schema', schema_name, 'command', command_tag)) from pg_event_trigger_ddl_commands() as x)
    )::text
  );
end;
$$;


ALTER FUNCTION postgraphile_watch.notify_watchers_ddl() OWNER TO reboo;

--
-- TOC entry 655 (class 1255 OID 174512)
-- Name: notify_watchers_drop(); Type: FUNCTION; Schema: postgraphile_watch; Owner: reboo
--

CREATE FUNCTION postgraphile_watch.notify_watchers_drop() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
begin
  perform pg_notify(
    'postgraphile_watch',
    json_build_object(
      'type',
      'drop',
      'payload',
      (select json_agg(distinct x.schema_name) from pg_event_trigger_dropped_objects() as x)
    )::text
  );
end;
$$;


ALTER FUNCTION postgraphile_watch.notify_watchers_drop() OWNER TO reboo;

--
-- TOC entry 292 (class 1259 OID 51916)
-- Name: twilio_calls; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.twilio_calls (
    id integer NOT NULL,
    activist_id integer,
    widget_id integer,
    twilio_account_sid text,
    twilio_call_sid text,
    "from" text NOT NULL,
    "to" text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    community_id integer
);


ALTER TABLE public.twilio_calls OWNER TO reboo;

--
-- TOC entry 295 (class 1259 OID 51943)
-- Name: twilio_calls; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.twilio_calls AS
 SELECT twilio_calls.id,
    twilio_calls.activist_id,
    twilio_calls.widget_id,
    twilio_calls.twilio_account_sid,
    twilio_calls.twilio_call_sid,
    twilio_calls."from",
    twilio_calls."to",
    twilio_calls.data,
    twilio_calls.created_at,
    twilio_calls.updated_at,
    twilio_calls.community_id
   FROM public.twilio_calls;


ALTER TABLE postgraphql.twilio_calls OWNER TO reboo;

--
-- TOC entry 637 (class 1255 OID 16597)
-- Name: add_twilio_call(postgraphql.twilio_calls); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.add_twilio_call(call postgraphql.twilio_calls) RETURNS postgraphql.twilio_calls
    LANGUAGE plpgsql
    AS $$
        DECLARE twilio_calls postgraphql.twilio_calls;
        BEGIN
          INSERT INTO postgraphql.twilio_calls (
            activist_id,
            community_id,
            widget_id,
            "from",
            "to",
            created_at,
            updated_at
          ) VALUES (
            coalesce(CALL.activist_id, NULL),
            CALL.community_id,
            CALL.widget_id,
            CALL.from,
            CALL.to,
            now(),
            now()
          ) returning * INTO twilio_calls;
          RETURN twilio_calls;
        END;
      $$;


ALTER FUNCTION postgraphql.add_twilio_call(call postgraphql.twilio_calls) OWNER TO reboo;

--
-- TOC entry 299 (class 1259 OID 51959)
-- Name: twilio_configurations; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.twilio_configurations (
    id integer NOT NULL,
    community_id integer NOT NULL,
    twilio_account_sid text NOT NULL,
    twilio_auth_token text NOT NULL,
    twilio_number text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.twilio_configurations OWNER TO reboo;

--
-- TOC entry 300 (class 1259 OID 51969)
-- Name: twilio_configurations; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.twilio_configurations AS
 SELECT twilio_configurations.id,
    twilio_configurations.community_id,
    twilio_configurations.twilio_account_sid,
    twilio_configurations.twilio_auth_token,
    twilio_configurations.twilio_number,
    twilio_configurations.created_at,
    twilio_configurations.updated_at
   FROM public.twilio_configurations;


ALTER TABLE postgraphql.twilio_configurations OWNER TO reboo;

--
-- TOC entry 414 (class 1255 OID 16599)
-- Name: add_twilio_configuration(postgraphql.twilio_configurations); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.add_twilio_configuration(config postgraphql.twilio_configurations) RETURNS postgraphql.twilio_configurations
    LANGUAGE plpgsql
    AS $$
  DECLARE twilio_configuration postgraphql.twilio_configurations;
  BEGIN
    INSERT INTO postgraphql.twilio_configurations (
      community_id,
      twilio_account_sid,
      twilio_auth_token,
      twilio_number,
      created_at,
      updated_at
    ) VALUES (
      CONFIG.community_id,
      CONFIG.twilio_account_sid,
      CONFIG.twilio_auth_token,
      CONFIG.twilio_number,
      now(),
      now()
    ) RETURNING * INTO twilio_configuration;
    RETURN twilio_configuration;
  END;
$$;


ALTER FUNCTION postgraphql.add_twilio_configuration(config postgraphql.twilio_configurations) OWNER TO reboo;

--
-- TOC entry 628 (class 1255 OID 122093)
-- Name: change_password(json); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.change_password(data json) RETURNS postgraphql.jwt_token
    LANGUAGE plpgsql
    AS $_$
    declare
        _user public.users;
    begin
        if nullif(($1->> 'password')::text, '') is null then
            raise 'missing_password';
        end if;

        if length(($1->>'password'::text)) < 6 then
            raise 'password_lt_six_chars';
        end if;

        if ($1->>'password'::text) <> ($1->>'password_confirmation'::text) then
            raise 'password_confirmation_not_match';
        end if;

        -- when user is anonymous should be have reset_password_token
        if current_role = 'anonymous' then
            if nullif(($1->>'reset_password_token')::text, '') is not null then
                select * from public.users
                    where reset_password_token is not null
                        and ($1->>'reset_password_token')::text = reset_password_token
                    into _user;

                if _user.id is null then
                    raise 'invalid_reset_password_token';
                end if;
            else
                raise 'missing_reset_password_token';
            end if;
        else
        -- when user already logged (jwt) should not require reset_password_token
            select * from users where id = postgraphql.current_user_id()
                into _user;
        end if;

        update users
            set encrypted_password = public.crypt(($1->>'password')::text, public.gen_salt('bf', 9))
        where id = _user.id;

        return (
            (case when _user.admin is true then 'admin' else 'common_user' end),
            _user.id
        )::postgraphql.jwt_token;
    end;
$_$;


ALTER FUNCTION postgraphql.change_password(data json) OWNER TO reboo;

--
-- TOC entry 272 (class 1259 OID 47803)
-- Name: invitations; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.invitations (
    id integer NOT NULL,
    community_id integer,
    user_id integer,
    email character varying,
    code character varying,
    expires timestamp without time zone,
    role integer,
    expired boolean,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.invitations OWNER TO reboo;

--
-- TOC entry 636 (class 1255 OID 137544)
-- Name: check_invitation(text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.check_invitation(invitation_code text) RETURNS SETOF public.invitations
    LANGUAGE sql IMMUTABLE
    AS $$
  select * from public.invitations where code=invitation_code
$$;


ALTER FUNCTION postgraphql.check_invitation(invitation_code text) OWNER TO reboo;

--
-- TOC entry 422 (class 1255 OID 16601)
-- Name: create_activist(json); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.create_activist(activist json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
        declare
            _activist public.activists;
            _community_id integer;
            _mobilization public.mobilizations;
            _community_activist public.community_activists;
        begin
            _community_id := ($1->>'community_id')::integer;

            if _community_id is null then
                raise 'missing community_id inside activist';
            end if;

            if not postgraphql.current_user_has_community_participation(_community_id) then
                raise 'operation not permitted';
            end if;

            select * from public.mobilizations
                where community_id = _community_id
                    and id = ($1->>'mobilization_id')::integer
                into _mobilization;

            select * from public.activists a
                where a.email = lower(($1->>'email')::email)
                limit 1 into _activist;

            if _activist.id is null then
                insert into public.activists (first_name, last_name, name, email, phone, document_number, document_type, city, created_at, updated_at)
                    values ($1->>'first_name'::text, $1->>'last_name'::text, $1->>'name'::text, lower($1->>'email'), $1->>'phone'::text, $1->>'document_number'::text,
                        $1->>'document_type'::text, $1->>'city'::text, now(), now())
                    returning * into _activist;
            end if;

            select *
                from public.community_activists
                where community_id = _community_id
                    and activist_id = _activist.id
                into _community_activist;

            if _community_activist.id is null then
                insert into public.community_activists (community_id, activist_id, created_at, updated_at, profile_data)
                    values (_community_id, _activist.id, now(), now(), ($1)::jsonb)
                    returning * into _community_activist;
            end if;

            if _mobilization.id is not null and not exists(select true
                from public.mobilization_activists
                where mobilization_id = _mobilization.id
                    and activist_id = _activist.id
            ) then
                insert into public.mobilization_activists (mobilization_id, activist_id, created_at, updated_at)
                    values (_mobilization.id, _activist.id, now(), now());
            end if;

            return row_to_json(_community_activist);
        end;
    $_$;


ALTER FUNCTION postgraphql.create_activist(activist json) OWNER TO reboo;

--
-- TOC entry 423 (class 1255 OID 16602)
-- Name: create_activist_tag(json); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.create_activist_tag(data json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
        declare
            _activist public.activists;
            _tagging public.taggings;
            _tag public.tags;
            _activist_tag public.activist_tags;
            _community_id integer;
            --_mobilization public.mobilizations;
        begin
            -- check for community_id
            _community_id := ($1->>'community_id')::integer;
            if _community_id is null then
                raise 'missing community_id inside activist';
            end if;

            -- check if current_user has participation on this community or he is admin
            if not postgraphql.current_user_has_community_participation(_community_id) and current_role <> 'admin' then
                raise 'operation not permitted';
            end if;

            -- get mobilization
            -- select * from public.mobilizations
            --     where community_id = _community_id
            --         and id = ($1->>'mobilization_id')::integer
            --     into _mobilization;

            -- get activist
            select * from public.activists a
                where a.id = ($1->>'activist_id')::integer
                limit 1 into _activist;

            -- check if activists in community
            if not exists(select true from community_activists
                where community_id = _community_id
                    and activist_id = _activist.id) then
                raise 'activist not found on community';
            end if;

            -- insert new activist_tag
            select * from public.activist_tags
                where activist_id = _activist.id
                    and community_id = _community_id
                into _activist_tag;

            if _activist_tag is null then
                insert into public.activist_tags (activist_id, community_id, created_at, updated_at)
                    values (_activist.id, _community_id, now(), now())
                    returning * into _activist_tag;
            end if;

            -- search for some tag that have the same name
            select * from public.tags
                where name = 'input_'||public.slugfy(($1->>'name')::text)
                limit 1
                into _tag;

            -- insert tag if not found
            if _tag is null then
                insert into public.tags (name, label)
                    values ('input_'||public.slugfy(($1->>'name')::text), ($1->>'name')::text)
                    returning * into _tag;
            end if;

            -- create taggings linking activist_tag to tag
            select * from public.taggings
                where tag_id = _tag.id
                    and taggable_id = _activist_tag.id
                    and taggable_type = 'ActivistTag'
                into _tagging;
            if _tagging is null then
                insert into public.taggings(tag_id, taggable_id, taggable_type)
                    values (_tag.id, _activist_tag.id, 'ActivistTag')
                    returning * into _tagging;
            end if;

            return json_build_object(
                'activist_tag_id', _activist_tag.id,
                'tag_id', _tag.id,
                'activist_id', _activist.id,
                'tag_name', _tag.name,
                'tag_label', _tag.label
            );
        end;
    $_$;


ALTER FUNCTION postgraphql.create_activist_tag(data json) OWNER TO reboo;

--
-- TOC entry 424 (class 1255 OID 16603)
-- Name: create_bot(json); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.create_bot(bot_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
        declare
            bot_json public.facebook_bot_configurations;
        begin
            insert into public.facebook_bot_configurations
                (community_id, messenger_app_secret, messenger_validation_token, messenger_page_access_token, data, created_at, updated_at)
                values (
                    (bot_data ->> 'community_id')::integer,
                    (bot_data ->> 'messenger_app_secret'),
                    (bot_data ->> 'messenger_validation_token'),
                    (bot_data ->> 'messenger_page_access_token'),
                    coalesce((bot_data ->> 'data')::jsonb, '{}'),
                    now(),
                    now())
                returning * into bot_json;

                return row_to_json(bot_json);
        end;
    $$;


ALTER FUNCTION postgraphql.create_bot(bot_data json) OWNER TO reboo;

--
-- TOC entry 425 (class 1255 OID 16604)
-- Name: create_bot_interaction(json); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.create_bot_interaction(bot_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
        declare
            bot_json public.activist_facebook_bot_interactions;
        begin
            insert into public.activist_facebook_bot_interactions
                (facebook_bot_configuration_id, fb_context_recipient_id, fb_context_sender_id, interaction, created_at, updated_at)
                values (
                    (bot_data ->> 'facebook_bot_configuration_id')::integer,
                    (bot_data ->> 'fb_context_recipient_id'),
                    (bot_data ->> 'fb_context_sender_id'),
                    coalesce((bot_data ->> 'interaction')::jsonb, '{}'),
                    now(),
                    now())
                returning * into bot_json;

                return row_to_json(bot_json);
        end;
    $$;


ALTER FUNCTION postgraphql.create_bot_interaction(bot_data json) OWNER TO reboo;

--
-- TOC entry 635 (class 1255 OID 137538)
-- Name: create_community(json); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.create_community(data json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
          declare
              _community public.communities;
          begin
              if current_role = 'anonymous' then
                  raise 'permission_denied';
              end if;

              if nullif(btrim($1->> 'name'::text), '') is null then
                  raise 'missing_community_name';
              end if;

              if nullif(btrim($1->> 'city'::text), '') is null then
                  raise 'missing_community_city';
              end if;

              insert into public.communities(name, city, created_at, updated_at)
                  values(
                      ($1->>'name')::text,
                      ($1->>'city')::text,
                      now(),
                      now()
                  ) returning * into _community;

              -- create user x community after create community
              insert into public.community_users(user_id, community_id, role, created_at, updated_at)
                  values(
                      postgraphql.current_user_id(),
                      _community.id,
                      1,
                      now(),
                      now()
                  );

              return row_to_json(_community);
          end;
      $_$;


ALTER FUNCTION postgraphql.create_community(data json) OWNER TO reboo;

--
-- TOC entry 630 (class 1255 OID 148858)
-- Name: create_dns_record(json); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.create_dns_record(data json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
        declare
          _dns_hosted_zone public.dns_hosted_zones;
          _dns_record public.dns_records;
        begin
          -- to execute function in api-v1
          -- if current_role <> 'microservices' then
          --     raise 'permission_denied';
          -- end if;

          select * from public.dns_hosted_zones d where d.id = ($1->>'dns_hosted_zone_id')::integer
          into _dns_hosted_zone;

          if _dns_hosted_zone is null then
              raise 'dns_hosted_zone_not_found';
          end if;

          select *
              from public.dns_records
          where name = $1->>'name' and record_type = $1->>'record_type'
          into _dns_record;

          if _dns_record is null then
              insert into public.dns_records(dns_hosted_zone_id, name, record_type, value, ttl, created_at, updated_at, comment)
              values (
                  _dns_hosted_zone.id, $1->>'name', $1->>'record_type', $1->>'value', $1->>'ttl', now(), now(),  $1->>'comment'
              )
              returning * into _dns_record;

              -- after create dns_record perform route53
              perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
                  'action', 'create_dns_record',
                  'id', _dns_record.id,
                  'created_at', _dns_record.created_at,
                  'sent_to_queuing', now(),
                  'jit', now()::timestamp
              ), public.configuration('jwt_secret'), 'HS512'));

              return json_build_object(
                  'id', _dns_record.id,
                  'dns_hosted_zone_id', _dns_record.dns_hosted_zone_id,
                  'name', _dns_record.name,
                  'comment', _dns_record.comment
              );
          else
              raise 'dns_record_already_registered';
          end if;
        end;
      $_$;


ALTER FUNCTION postgraphql.create_dns_record(data json) OWNER TO reboo;

--
-- TOC entry 312 (class 1259 OID 71159)
-- Name: facebook_bot_campaigns; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.facebook_bot_campaigns (
    id integer NOT NULL,
    facebook_bot_configuration_id integer NOT NULL,
    name text NOT NULL,
    segment_filters jsonb NOT NULL,
    total_impacted_activists integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.facebook_bot_campaigns OWNER TO reboo;

--
-- TOC entry 426 (class 1255 OID 16605)
-- Name: create_facebook_bot_campaign(postgraphql.facebook_bot_campaigns_type); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.create_facebook_bot_campaign(campaign postgraphql.facebook_bot_campaigns_type) RETURNS public.facebook_bot_campaigns
    LANGUAGE plpgsql
    AS $$
    DECLARE
        _facebook_bot_campaign public.facebook_bot_campaigns;
        _campaign_id integer;
    BEGIN
        INSERT INTO public.facebook_bot_campaigns (
            facebook_bot_configuration_id,
            name,
            segment_filters,
            total_impacted_activists,
            created_at,
            updated_at
        ) VALUES (
            campaign.facebook_bot_configuration_id,
            campaign.name,
            campaign.segment_filters,
            campaign.total_impacted_activists,
            now(),
            now()
        ) RETURNING * INTO _facebook_bot_campaign;

        INSERT INTO public.facebook_bot_campaign_activists (
            facebook_bot_campaign_id,
            facebook_bot_activist_id,
            received,
            created_at,
            updated_at
        )
            SELECT
                (to_json(_facebook_bot_campaign) ->> 'id')::integer as facebook_bot_activist_id,
                id as facebook_bot_activist_id,
                FALSE,
                NOW(),
                NOW()
            FROM postgraphql.get_facebook_bot_activists_strategy(campaign.segment_filters);
      RETURN _facebook_bot_campaign;
    END;
$$;


ALTER FUNCTION postgraphql.create_facebook_bot_campaign(campaign postgraphql.facebook_bot_campaigns_type) OWNER TO reboo;

--
-- TOC entry 647 (class 1255 OID 174276)
-- Name: create_tags(text, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.create_tags(name text, label text) RETURNS json
    LANGUAGE plpgsql
    AS $$
declare
    _tag public.tags;
    _user_tag public.user_tags;
begin
    if current_role = 'anonymous' then
        raise 'permission_denied';
    end if;

    if name is null then
        raise 'name_is_empty';
    end if;

    if label is null then
        raise 'label_is_empty';
    end if;

    insert into public.tags(name, label)
    values(concat('user_', name), label)
    returning * into _tag;

    -- insert a new tag in current_user
    insert into public.user_tags(user_id, tag_id, created_at, updated_at)
    values(postgraphql.current_user_id(), _tag.id, now(), now())
    returning * into _user_tag;

    return json_build_object(
        'msg', 'tag created successful',
        'tag_id', _tag.id,
        'user_tag', _user_tag.id
    );
end;
$$;


ALTER FUNCTION postgraphql.create_tags(name text, label text) OWNER TO reboo;

--
-- TOC entry 646 (class 1255 OID 174275)
-- Name: create_user_tags(json); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.create_user_tags(data json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
declare
    _tags json;
    _tag text;
begin
    if current_role = 'anonymous' then
        raise 'permission_denied';
    end if;

    for _tag in (select * from json_array_elements_text(($1->>'tags')::json))
    loop
        insert into public.user_tags(user_id, tag_id, created_at, updated_at)
        (
            select postgraphql.current_user_id(),
            (select id from public.tags where name = _tag),
            now(),
            now()
        ) returning * into _tags;
    end loop;

    return (select json_agg(t.name) from (
        select * from tags t
        left join user_tags ut on ut.tag_id = t.id
        where ut.user_id = (postgraphql.current_user_id())
    ) t);
end;
$_$;


ALTER FUNCTION postgraphql.create_user_tags(data json) OWNER TO reboo;

--
-- TOC entry 331 (class 1259 OID 174277)
-- Name: users; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.users AS
SELECT
    NULL::integer AS id,
    NULL::character varying AS provider,
    NULL::character varying AS uid,
    NULL::character varying AS encrypted_password,
    NULL::character varying AS reset_password_token,
    NULL::timestamp without time zone AS reset_password_sent_at,
    NULL::timestamp without time zone AS remember_created_at,
    NULL::integer AS sign_in_count,
    NULL::timestamp without time zone AS current_sign_in_at,
    NULL::timestamp without time zone AS last_sign_in_at,
    NULL::character varying AS current_sign_in_ip,
    NULL::character varying AS last_sign_in_ip,
    NULL::character varying AS confirmation_token,
    NULL::timestamp without time zone AS confirmed_at,
    NULL::timestamp without time zone AS confirmation_sent_at,
    NULL::character varying AS unconfirmed_email,
    NULL::character varying AS first_name,
    NULL::character varying AS last_name,
    NULL::character varying AS email,
    NULL::text AS tokens,
    NULL::timestamp without time zone AS created_at,
    NULL::timestamp without time zone AS updated_at,
    NULL::character varying AS avatar,
    NULL::boolean AS admin,
    NULL::text AS locale,
    NULL::json AS tags,
    NULL::boolean AS is_admin;


ALTER TABLE postgraphql.users OWNER TO reboo;

--
-- TOC entry 648 (class 1255 OID 174282)
-- Name: current_user(); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql."current_user"() RETURNS postgraphql.users
    LANGUAGE sql STABLE
    AS $$
  select *
  from postgraphql.users
  where id = current_setting('jwt.claims.user_id')::integer
$$;


ALTER FUNCTION postgraphql."current_user"() OWNER TO reboo;

--
-- TOC entry 427 (class 1255 OID 16607)
-- Name: current_user_has_community_participation(integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.current_user_has_community_participation(com_id integer) RETURNS boolean
    LANGUAGE sql
    AS $$
        select (exists(
            select true from public.community_users cu
                where cu.user_id = postgraphql.current_user_id()
                and cu.community_id = com_id
        ) or current_role = 'admin');
    $$;


ALTER FUNCTION postgraphql.current_user_has_community_participation(com_id integer) OWNER TO reboo;

--
-- TOC entry 428 (class 1255 OID 16608)
-- Name: current_user_has_community_participation(integer, integer[]); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.current_user_has_community_participation(com_id integer, role_ids integer[]) RETURNS boolean
    LANGUAGE sql
    AS $$
        select exists(
            select true from public.community_users cu
                where cu.user_id = postgraphql.current_user_id()
                and cu.community_id = com_id
                and cu.role = ANY(role_ids)
        );
    $$;


ALTER FUNCTION postgraphql.current_user_has_community_participation(com_id integer, role_ids integer[]) OWNER TO reboo;

--
-- TOC entry 429 (class 1255 OID 16609)
-- Name: current_user_id(); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.current_user_id() RETURNS integer
    LANGUAGE sql
    AS $$
        select id from postgraphql.current_user();
    $$;


ALTER FUNCTION postgraphql.current_user_id() OWNER TO reboo;

--
-- TOC entry 235 (class 1259 OID 19911)
-- Name: template_mobilizations; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.template_mobilizations (
    id integer NOT NULL,
    name character varying,
    user_id integer,
    color_scheme character varying,
    facebook_share_title character varying,
    facebook_share_description text,
    header_font character varying,
    body_font character varying,
    facebook_share_image character varying,
    slug character varying,
    custom_domain character varying,
    twitter_share_text character varying(140),
    community_id integer,
    uses_number integer,
    global boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    goal text,
    favicon character varying
);


ALTER TABLE public.template_mobilizations OWNER TO reboo;

--
-- TOC entry 430 (class 1255 OID 16610)
-- Name: custom_templates(integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.custom_templates(ctx_community_id integer) RETURNS SETOF public.template_mobilizations
    LANGUAGE sql STABLE
    AS $$
        select *
          from public.template_mobilizations
          where community_id = ctx_community_id
          and global = false
          and postgraphql.current_user_has_community_participation(ctx_community_id);
      $$;


ALTER FUNCTION postgraphql.custom_templates(ctx_community_id integer) OWNER TO reboo;

--
-- TOC entry 431 (class 1255 OID 16611)
-- Name: destroy_bot(integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.destroy_bot(bot_id integer) RETURNS void
    LANGUAGE sql
    AS $$
        update public.facebook_bot_configurations
            set data = jsonb_set(data, '{deleted}', 'true')
        where id = bot_id
    $$;


ALTER FUNCTION postgraphql.destroy_bot(bot_id integer) OWNER TO reboo;

--
-- TOC entry 252 (class 1259 OID 33276)
-- Name: activist_tags; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.activist_tags (
    id integer NOT NULL,
    activist_id integer,
    community_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    mobilization_id integer
);


ALTER TABLE public.activist_tags OWNER TO reboo;

--
-- TOC entry 250 (class 1259 OID 33244)
-- Name: taggings; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying,
    tagger_id integer,
    tagger_type character varying,
    context character varying(128),
    created_at timestamp without time zone
);


ALTER TABLE public.taggings OWNER TO reboo;

--
-- TOC entry 248 (class 1259 OID 33233)
-- Name: tags; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    name character varying,
    taggings_count integer DEFAULT 0,
    label text,
    kind text
);


ALTER TABLE public.tags OWNER TO reboo;

--
-- TOC entry 289 (class 1259 OID 50916)
-- Name: community_tags; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.community_tags AS
 SELECT at.community_id,
    tag.name AS tag_complete_name,
    (regexp_split_to_array((tag.name)::text, '_'::text))[1] AS tag_from,
    (regexp_split_to_array((tag.name)::text, '_'::text))[2] AS tag_name,
    count(DISTINCT at.activist_id) AS total_activists,
    tag.label AS tag_label
   FROM ((public.activist_tags at
     JOIN public.taggings tgs ON ((((tgs.taggable_type)::text = 'ActivistTag'::text) AND (tgs.taggable_id = at.id))))
     JOIN public.tags tag ON ((tag.id = tgs.tag_id)))
  GROUP BY at.community_id, tag.name, tag.label;


ALTER TABLE public.community_tags OWNER TO reboo;

--
-- TOC entry 290 (class 1259 OID 50921)
-- Name: community_tags; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.community_tags AS
 SELECT community_tags.community_id,
    community_tags.tag_complete_name,
    community_tags.tag_from,
    community_tags.tag_name,
    community_tags.total_activists,
    community_tags.tag_label
   FROM public.community_tags
  WHERE postgraphql.current_user_has_community_participation(community_tags.community_id);


ALTER TABLE postgraphql.community_tags OWNER TO reboo;

--
-- TOC entry 432 (class 1255 OID 16617)
-- Name: filter_community_tags(text, integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.filter_community_tags(search text, ctx_community_id integer) RETURNS SETOF postgraphql.community_tags
    LANGUAGE sql STABLE
    AS $$
  select * from postgraphql.community_tags
    where community_id = ctx_community_id
    and tag_complete_name ilike ('%' || search || '%')
$$;


ALTER FUNCTION postgraphql.filter_community_tags(search text, ctx_community_id integer) OWNER TO reboo;

--
-- TOC entry 4727 (class 0 OID 0)
-- Dependencies: 432
-- Name: FUNCTION filter_community_tags(search text, ctx_community_id integer); Type: COMMENT; Schema: postgraphql; Owner: reboo
--

COMMENT ON FUNCTION postgraphql.filter_community_tags(search text, ctx_community_id integer) IS 'filter community_tags view by tag_complete_name and communityd_id';


--
-- TOC entry 433 (class 1255 OID 16618)
-- Name: get_facebook_activists_by_campaign_ids(integer[]); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_campaign_ids(campaign_ids integer[]) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        DISTINCT _fba.fb_context_recipient_id,
        _fba.fb_context_sender_id,
        _fba.data,
        _fba.messages,
        _fba.quick_replies,
        _fba.created_at,
        _fba.updated_at,
        _fba.id
    FROM public.facebook_bot_campaign_activists as _fbca
    LEFT JOIN public.facebook_bot_activists as _fba
        ON _fba.id = _fbca.facebook_bot_activist_id
    WHERE _fbca.facebook_bot_campaign_id = ANY(campaign_ids)
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_campaign_ids(campaign_ids integer[]) OWNER TO reboo;

--
-- TOC entry 441 (class 1255 OID 16619)
-- Name: get_facebook_activists_by_campaigns_both_inclusion_exclusion(jsonb, integer[], integer[]); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_campaigns_both_inclusion_exclusion(segment_filters jsonb, campaign_exclusion_ids integer[], campaign_inclusion_ids integer[]) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT *
    FROM postgraphql.get_facebook_activists_by_campaigns_exclusion(
        segment_filters,
        campaign_exclusion_ids
    )
    UNION
    SELECT *
    FROM postgraphql.get_facebook_activists_by_campaign_ids(
        campaign_inclusion_ids
    );
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_campaigns_both_inclusion_exclusion(segment_filters jsonb, campaign_exclusion_ids integer[], campaign_inclusion_ids integer[]) OWNER TO reboo;

--
-- TOC entry 442 (class 1255 OID 16620)
-- Name: get_facebook_activists_by_campaigns_exclusion(jsonb, integer[]); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_campaigns_exclusion(segment_filters jsonb, campaign_ids integer[]) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        fas.fb_context_recipient_id,
        fas.fb_context_sender_id,
        fas.data,
        fas.messages,
        fas.quick_replies,
        fas.created_at,
        fas.updated_at,
        fas.id
    FROM postgraphql.get_facebook_bot_activists_strategy(segment_filters) as fas
    LEFT JOIN (
        SELECT fba.*
        FROM public.facebook_bot_campaign_activists as fbca
        LEFT JOIN public.facebook_bot_activists as fba
            ON fba.id = fbca.facebook_bot_activist_id
        WHERE fbca.facebook_bot_campaign_id = ANY(campaign_ids)
    ) as fbca
        ON fbca.fb_context_recipient_id = fas.fb_context_recipient_id
    WHERE fbca.id IS NULL
    ORDER BY fas.updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_campaigns_exclusion(segment_filters jsonb, campaign_ids integer[]) OWNER TO reboo;

--
-- TOC entry 443 (class 1255 OID 16621)
-- Name: get_facebook_activists_by_campaigns_inclusion(jsonb, integer[]); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_campaigns_inclusion(segment_filters jsonb, campaign_ids integer[]) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        fas.fb_context_recipient_id,
        fas.fb_context_sender_id,
        fas.data,
        fas.messages,
        fas.quick_replies,
        fas.created_at,
        fas.updated_at,
        fas.id
    FROM postgraphql.get_facebook_bot_activists_strategy(segment_filters) as fas
    UNION
    SELECT *
    FROM postgraphql.get_facebook_activists_by_campaign_ids(campaign_ids);
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_campaigns_inclusion(segment_filters jsonb, campaign_ids integer[]) OWNER TO reboo;

--
-- TOC entry 444 (class 1255 OID 16622)
-- Name: get_facebook_activists_by_date_interval(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_date_interval(date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT DISTINCT
        fb_context_recipient_id,
        fb_context_sender_id,
        data,
        messages,
        quick_replies,
        created_at,
        updated_at,
        id
    FROM (
        SELECT *, UNNEST(interaction_dates) as interaction_date
        FROM public.facebook_bot_activists
    ) as a
    WHERE interaction_date::date BETWEEN date_interval_start AND date_interval_end
    ORDER BY updated_at;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_date_interval(date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) OWNER TO reboo;

--
-- TOC entry 445 (class 1255 OID 16623)
-- Name: get_facebook_activists_by_message(text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_message(message text) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        fb_context_recipient_id,
        fb_context_sender_id,
        data,
        messages,
        quick_replies,
        created_at,
        updated_at,
        id
    FROM public.facebook_bot_activists
    WHERE messages @@ plainto_tsquery('portuguese', message)
    ORDER BY updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_message(message text) OWNER TO reboo;

--
-- TOC entry 446 (class 1255 OID 16624)
-- Name: get_facebook_activists_by_message_date_interval(text, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_message_date_interval(message text, date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT *
    FROM postgraphql.get_facebook_activists_by_date_interval(
        date_interval_start,
        date_interval_end
    )
    WHERE messages @@ plainto_tsquery('portuguese', message)
    ORDER BY updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_message_date_interval(message text, date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) OWNER TO reboo;

--
-- TOC entry 448 (class 1255 OID 16625)
-- Name: get_facebook_activists_by_message_quick_reply(text, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_message_quick_reply(message text, quick_reply text) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        fb_context_recipient_id,
        fb_context_sender_id,
        data,
        messages,
        quick_replies,
        created_at,
        updated_at,
        id
    FROM public.facebook_bot_activists
    WHERE
        messages @@ plainto_tsquery('portuguese', message) AND
        quick_reply = ANY(quick_replies)
    ORDER BY updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_message_quick_reply(message text, quick_reply text) OWNER TO reboo;

--
-- TOC entry 449 (class 1255 OID 16626)
-- Name: get_facebook_activists_by_message_quick_reply_date_interval(text, text, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_message_quick_reply_date_interval(message text, quick_reply text, date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT *
    FROM postgraphql.get_facebook_activists_by_date_interval(
        date_interval_start,
        date_interval_end
    )
    WHERE
        messages @@ plainto_tsquery('portuguese', message) AND
        quick_reply = ANY(quick_replies)
    ORDER BY updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_message_quick_reply_date_interval(message text, quick_reply text, date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) OWNER TO reboo;

--
-- TOC entry 450 (class 1255 OID 16627)
-- Name: get_facebook_activists_by_quick_reply(text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_quick_reply(quick_reply text) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        fb_context_recipient_id,
        fb_context_sender_id,
        data,
        messages,
        quick_replies,
        created_at,
        updated_at,
        id
    FROM public.facebook_bot_activists
    WHERE quick_reply = ANY(quick_replies)
    ORDER BY updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_quick_reply(quick_reply text) OWNER TO reboo;

--
-- TOC entry 451 (class 1255 OID 16628)
-- Name: get_facebook_activists_by_quick_reply_date_interval(text, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_activists_by_quick_reply_date_interval(quick_reply text, date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT *
    FROM postgraphql.get_facebook_activists_by_date_interval(
        date_interval_start,
        date_interval_end
    )
    WHERE quick_reply = ANY(quick_replies)
    ORDER BY updated_at DESC;
$$;


ALTER FUNCTION postgraphql.get_facebook_activists_by_quick_reply_date_interval(quick_reply text, date_interval_start timestamp without time zone, date_interval_end timestamp without time zone) OWNER TO reboo;

--
-- TOC entry 452 (class 1255 OID 16629)
-- Name: get_facebook_bot_activists_strategy(jsonb); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_bot_activists_strategy(search jsonb) RETURNS SETOF postgraphql.facebook_activist_search_result_type
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    DECLARE
        _message                text      := search ->> 'message';
        _quick_reply            text      := search ->> 'quickReply';
        _date_interval_start    timestamp := search ->> 'dateIntervalStart';
        _date_interval_end      timestamp := search ->> 'dateIntervalEnd';
        _campaign_exclusion_ids int[]     := search ->> 'campaignExclusionIds';
        _campaign_inclusion_ids int[]     := search ->> 'campaignInclusionIds';

        _m      boolean := _message                IS NOT NULL;
        _qr     boolean := _quick_reply            IS NOT NULL;
        _start  boolean := _date_interval_start    IS NOT NULL;
        _end    boolean := _date_interval_end      IS NOT NULL;
        _ce     boolean := _campaign_exclusion_ids IS NOT NULL;
        _ci     boolean := _campaign_inclusion_ids IS NOT NULL;

        _is_only_campaign_exclusion boolean :=      _ce  AND (NOT _ci);
        _is_only_campaign_inclusion boolean := (NOT _ce) AND      _ci;
        _is_both_campaign_strategy  boolean :=      _ce  AND      _ci;
        _is_only_message            boolean :=      _m  AND (NOT _qr) AND (NOT _start) AND (NOT _end);
        _is_only_q_reply            boolean := (NOT _m) AND      _qr  AND (NOT _start) AND (NOT _end);
        _is_only_date_interval      boolean := (NOT _m) AND (NOT _qr) AND      _start  AND      _end;
        _is_q_reply_date_interval   boolean := (NOT _m) AND      _qr  AND       _start AND      _end;
        _is_message_date_interval   boolean :=      _m  AND (NOT _qr) AND      _start  AND      _end;
        _is_message_q_reply         boolean :=      _m  AND      _qr  AND (NOT _start) AND (NOT _end);
        _is_all                     boolean :=      _m  AND      _qr  AND      _start  AND      _end;
    BEGIN
        IF _is_only_campaign_exclusion THEN RETURN QUERY (
            SELECT *
            FROM postgraphql.get_facebook_activists_by_campaigns_exclusion(
                search - 'campaignExclusionIds',
                _campaign_exclusion_ids
            )
        );
        ELSIF _is_only_campaign_inclusion THEN RETURN QUERY (
            SELECT *
            FROM postgraphql.get_facebook_activists_by_campaigns_inclusion(
                search - 'campaignInclusionIds',
                _campaign_inclusion_ids
            )
        );
        ELSIF _is_both_campaign_strategy THEN RETURN QUERY (
            SELECT *
            FROM postgraphql.get_facebook_activists_by_campaigns_both_inclusion_exclusion(
                search - 'campaignInclusionIds' - 'campaignExclusionIds',
                _campaign_exclusion_ids,
                _campaign_inclusion_ids
            )
        );
        ELSE
            IF _is_only_message THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_message(_message)
            );
            ELSIF _is_only_q_reply THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_quick_reply(_quick_reply)
            );
            ELSIF _is_only_date_interval THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_date_interval(
                    _date_interval_start,
                    _date_interval_end
                )
            );
            ELSIF _is_q_reply_date_interval THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_quick_reply_date_interval(
                    _quick_reply,
                    _date_interval_start,
                    _date_interval_end
                )
            );
            ELSIF _is_message_date_interval THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_message_date_interval(
                    _message,
                    _date_interval_start,
                    _date_interval_end
                )
            );
            ELSIF _is_message_q_reply THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_message_quick_reply(
                    _message,
                    _quick_reply
                )
            );
            ELSIF _is_all THEN RETURN QUERY (
                SELECT *
                FROM postgraphql.get_facebook_activists_by_message_quick_reply_date_interval(
                    _message,
                    _quick_reply,
                    _date_interval_start,
                    _date_interval_end
                )
            );
            END IF;
        END IF;
    END;
$$;


ALTER FUNCTION postgraphql.get_facebook_bot_activists_strategy(search jsonb) OWNER TO reboo;

--
-- TOC entry 453 (class 1255 OID 16630)
-- Name: get_facebook_bot_campaign_activists_by_campaign_id(integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_bot_campaign_activists_by_campaign_id(campaign_id integer) RETURNS SETOF postgraphql.get_facebook_bot_campaign_activists_by_campaign_type
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT
        fbca.*,
        fba.fb_context_recipient_id,
        fba.fb_context_sender_id,
        fba.data,
        fba.messages,
        fba.quick_replies,
        fba.interaction_dates
    FROM public.facebook_bot_campaign_activists as fbca
    LEFT JOIN public.facebook_bot_activists as fba
        ON fba.id = fbca.facebook_bot_activist_id
    WHERE fbca.facebook_bot_campaign_id = campaign_id;
$$;


ALTER FUNCTION postgraphql.get_facebook_bot_campaign_activists_by_campaign_id(campaign_id integer) OWNER TO reboo;

--
-- TOC entry 454 (class 1255 OID 16631)
-- Name: get_facebook_bot_campaigns_by_community_id(integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_facebook_bot_campaigns_by_community_id(ctx_community_id integer) RETURNS SETOF public.facebook_bot_campaigns
    LANGUAGE sql IMMUTABLE
    AS $$
    SELECT campaigns.*
    FROM public.facebook_bot_campaigns as campaigns
    LEFT JOIN public.facebook_bot_configurations as configs
        ON campaigns.facebook_bot_configuration_id = configs.id
    WHERE configs.community_id = ctx_community_id;
$$;


ALTER FUNCTION postgraphql.get_facebook_bot_campaigns_by_community_id(ctx_community_id integer) OWNER TO reboo;

--
-- TOC entry 660 (class 1255 OID 16632)
-- Name: get_widget_donation_stats(integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.get_widget_donation_stats(widget_id integer) RETURNS json
    LANGUAGE sql STABLE
    AS $_$
        select
            json_build_object(
            'pledged', sum(d.amount / 100) + coalesce(nullif(w.settings::json->>'external_resource', ''), '0')::bigint,
            'widget_id', w.id,
            'goal', w.goal,
            'progress', ((sum(d.amount / 100) + coalesce(nullif(w.settings::json->>'external_resource', ''), '0')::bigint) / w.goal) * 100,
            'total_donations', (count(distinct d.id)),
            'total_donators', (count(distinct d.activist_id))
            )
        from widgets w
            join donations d on d.widget_id = w.id
            where w.id = $1 and
                d.transaction_status = 'paid'
            group by w.id;
        $_$;


ALTER FUNCTION postgraphql.get_widget_donation_stats(widget_id integer) OWNER TO reboo;

--
-- TOC entry 4728 (class 0 OID 0)
-- Dependencies: 660
-- Name: FUNCTION get_widget_donation_stats(widget_id integer); Type: COMMENT; Schema: postgraphql; Owner: reboo
--

COMMENT ON FUNCTION postgraphql.get_widget_donation_stats(widget_id integer) IS 'Returns a json with pledged, progress and goal from widget';


--
-- TOC entry 455 (class 1255 OID 16633)
-- Name: global_templates(); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.global_templates() RETURNS SETOF public.template_mobilizations
    LANGUAGE sql STABLE
    AS $$
          select *
          from public.template_mobilizations
          where
            global = true
        $$;


ALTER FUNCTION postgraphql.global_templates() OWNER TO reboo;

--
-- TOC entry 201 (class 1259 OID 16531)
-- Name: activists; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.activists (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    phone character varying,
    document_number character varying,
    document_type character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    city character varying,
    first_name text,
    last_name text,
    state text
);


ALTER TABLE public.activists OWNER TO reboo;

--
-- TOC entry 302 (class 1259 OID 53293)
-- Name: community_activists; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.community_activists (
    id integer NOT NULL,
    community_id integer NOT NULL,
    activist_id integer NOT NULL,
    search_index tsvector,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    profile_data jsonb
);


ALTER TABLE public.community_activists OWNER TO reboo;

--
-- TOC entry 241 (class 1259 OID 28942)
-- Name: community_users; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.community_users (
    id integer NOT NULL,
    user_id integer,
    community_id integer,
    role integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.community_users OWNER TO reboo;

--
-- TOC entry 288 (class 1259 OID 50902)
-- Name: activists; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.activists AS
 WITH current_communities_access AS (
         SELECT DISTINCT cu.community_id
           FROM public.community_users cu
          WHERE ((cu.user_id = postgraphql.current_user_id()) OR ("current_user"() = 'admin'::name))
        )
 SELECT ca.community_id,
    ca.activist_id AS id,
    ((ca.profile_data ->> 'name'::text))::character varying AS name,
    a.email,
    ((ca.profile_data ->> 'phone'::text))::character varying AS phone,
    ((ca.profile_data ->> 'document_number'::text))::character varying AS document_number,
    ca.created_at,
    (ca.profile_data)::json AS data,
    '{}'::json AS mobilizations,
    '{}'::jsonb AS tags
   FROM (public.community_activists ca
     JOIN public.activists a ON ((a.id = ca.activist_id)))
  WHERE (ca.community_id IN ( SELECT current_communities_access.community_id
           FROM current_communities_access));


ALTER TABLE postgraphql.activists OWNER TO reboo;

--
-- TOC entry 456 (class 1255 OID 16644)
-- Name: search_activists_on_community(text, integer, integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.search_activists_on_community(query text, ctx_community_id integer, days_ago integer) RETURNS SETOF postgraphql.activists
    LANGUAGE sql STABLE
    AS $$
        with search_index as (
              select
                  atg.community_id,
                  atg.activist_id,
                  json_agg(json_build_object(
                    'tag_name', tag.name,
                    'activist_name', a.name,
                    'activist_email', a.email
                  )) package_search_vector
                  from public.activist_tags atg
                      join public.taggings tgs on tgs.taggable_type = 'ActivistTag'
                          and tgs.taggable_id = atg.id
                      join public.tags tag on tag.id = tgs.tag_id
                      join public.activists a on a.id = atg.activist_id
                      where atg.community_id = ctx_community_id
                        and (
                            case when days_ago is null or days_ago = 0 then true
                            else atg.created_at >= (current_timestamp - (days_ago||' days')::interval) end
                            )
                    group by atg.activist_id, atg.community_id, a.id
              ) select
                    act.*
                    from search_index si
                        join lateral (
                            select exists (
                                select
                                    true
                                from json_array_elements(si.package_search_vector)  as vec
                                    where (setweight(
                                              to_tsvector('portuguese', replace((regexp_split_to_array((vec->>'tag_name')::text, '_'::text))[2], '-', ' ')), 'A'
                                          )||setweight(
                                              to_tsvector('portuguese', (vec->>'tag_name')::text), 'B'
                                          )||setweight(
                                              to_tsvector('portuguese', vec->>'activist_name'), 'B'
                                          )||setweight(
                                              to_tsvector('portuguese', vec->>'activist_email'), 'C'
                                          ))::tsvector @@ plainto_tsquery('portuguese', query)
                            ) as found
                        ) as si_r on found
                        join lateral (
                             SELECT pa.*
                             FROM postgraphql.activists pa
                              WHERE pa.community_id = si.community_id
                                and pa.id = si.activist_id
                        ) as act on true
        $$;


ALTER FUNCTION postgraphql.search_activists_on_community(query text, ctx_community_id integer, days_ago integer) OWNER TO reboo;

--
-- TOC entry 434 (class 1255 OID 16645)
-- Name: total_avg_donations_by_community(integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_avg_donations_by_community(com_id integer) RETURNS double precision
    LANGUAGE sql
    AS $$
        select avg(d.payable_amount)
                from postgraphql.donations d where d.community_id = com_id
                and d.transaction_status = 'paid'
    $$;


ALTER FUNCTION postgraphql.total_avg_donations_by_community(com_id integer) OWNER TO reboo;

--
-- TOC entry 435 (class 1255 OID 16646)
-- Name: total_avg_donations_by_community_interval(integer, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_avg_donations_by_community_interval(com_id integer, timeinterval interval) RETURNS double precision
    LANGUAGE sql
    AS $$
        select avg(d.payable_amount)
                from postgraphql.donations d where d.community_id = com_id
                and d.transaction_status = 'paid'
                and d.payment_date > CURRENT_TIMESTAMP - timeinterval
    $$;


ALTER FUNCTION postgraphql.total_avg_donations_by_community_interval(com_id integer, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 447 (class 1255 OID 16647)
-- Name: total_avg_donations_by_mobilization(integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_avg_donations_by_mobilization(mob_id integer) RETURNS double precision
    LANGUAGE sql
    AS $$
        select avg(d.payable_amount)
                from postgraphql.donations d where d.mobilization_id = mob_id
                and d.transaction_status = 'paid'
    $$;


ALTER FUNCTION postgraphql.total_avg_donations_by_mobilization(mob_id integer) OWNER TO reboo;

--
-- TOC entry 460 (class 1255 OID 16648)
-- Name: total_avg_donations_by_mobilization_interval(integer, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_avg_donations_by_mobilization_interval(mob_id integer, timeinterval interval) RETURNS double precision
    LANGUAGE sql
    AS $$
        select avg(d.payable_amount)
                from postgraphql.donations d where d.mobilization_id = mob_id
                and d.transaction_status = 'paid'
                and d.payment_date > CURRENT_TIMESTAMP - timeinterval
    $$;


ALTER FUNCTION postgraphql.total_avg_donations_by_mobilization_interval(mob_id integer, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 461 (class 1255 OID 16649)
-- Name: total_count_donations_from_community(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_count_donations_from_community(com_id integer, status text) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1)
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_donations_from_community(com_id integer, status text) OWNER TO reboo;

--
-- TOC entry 462 (class 1255 OID 16651)
-- Name: total_count_donations_from_community_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_count_donations_from_community_interval(com_id integer, status text, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1)
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_donations_from_community_interval(com_id integer, status text, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 463 (class 1255 OID 16652)
-- Name: total_count_donations_from_mobilization(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_count_donations_from_mobilization(mob_id integer, status text) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1)
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_donations_from_mobilization(mob_id integer, status text) OWNER TO reboo;

--
-- TOC entry 464 (class 1255 OID 16653)
-- Name: total_count_donations_from_mobilization_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_count_donations_from_mobilization_interval(mod_id integer, status text, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1)
            from postgraphql.donations d
                where d.mobilization_id = mod_id
                    and d.transaction_status = status
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_donations_from_mobilization_interval(mod_id integer, status text, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 465 (class 1255 OID 16654)
-- Name: total_count_subscription_donations_from_community(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_count_subscription_donations_from_community(com_id integer, status text) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1)
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.subscription_id is not null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_subscription_donations_from_community(com_id integer, status text) OWNER TO reboo;

--
-- TOC entry 466 (class 1255 OID 16655)
-- Name: total_count_subscription_donations_from_community_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_count_subscription_donations_from_community_interval(com_id integer, status text, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1)
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status
                    and d.subscription_id is not null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_subscription_donations_from_community_interval(com_id integer, status text, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 467 (class 1255 OID 16656)
-- Name: total_count_subscription_donations_from_mobilization(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_count_subscription_donations_from_mobilization(mob_id integer, status text) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1)
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.subscription_id is not null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_subscription_donations_from_mobilization(mob_id integer, status text) OWNER TO reboo;

--
-- TOC entry 481 (class 1255 OID 16657)
-- Name: total_count_subscription_donations_from_mobilization_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_count_subscription_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1)
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status
                    and d.subscription_id is not null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_subscription_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 482 (class 1255 OID 16658)
-- Name: total_count_uniq_donations_from_community(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_count_uniq_donations_from_community(com_id integer, status text) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1)
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.subscription_id is null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_uniq_donations_from_community(com_id integer, status text) OWNER TO reboo;

--
-- TOC entry 483 (class 1255 OID 16659)
-- Name: total_count_uniq_donations_from_community_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_count_uniq_donations_from_community_interval(com_id integer, status text, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1)
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status
                    and d.subscription_id is null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_uniq_donations_from_community_interval(com_id integer, status text, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 484 (class 1255 OID 16660)
-- Name: total_count_uniq_donations_from_mobilization(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_count_uniq_donations_from_mobilization(mob_id integer, status text) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1)
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.subscription_id is null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_uniq_donations_from_mobilization(mob_id integer, status text) OWNER TO reboo;

--
-- TOC entry 485 (class 1255 OID 16661)
-- Name: total_count_uniq_donations_from_mobilization_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_count_uniq_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select count(1)
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status
                    and d.subscription_id is null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_count_uniq_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 486 (class 1255 OID 16662)
-- Name: total_sum_donations_from_community(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_sum_donations_from_community(com_id integer, status text) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount)
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_donations_from_community(com_id integer, status text) OWNER TO reboo;

--
-- TOC entry 487 (class 1255 OID 16663)
-- Name: total_sum_donations_from_community_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_sum_donations_from_community_interval(com_id integer, status text, timeinterval interval) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount)
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_donations_from_community_interval(com_id integer, status text, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 488 (class 1255 OID 16664)
-- Name: total_sum_donations_from_mobilization(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_sum_donations_from_mobilization(mob_id integer, status text) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount)
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_donations_from_mobilization(mob_id integer, status text) OWNER TO reboo;

--
-- TOC entry 489 (class 1255 OID 16665)
-- Name: total_sum_donations_from_mobilization_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_sum_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount)
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 490 (class 1255 OID 16666)
-- Name: total_sum_subscription_donations_from_community(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_sum_subscription_donations_from_community(com_id integer, status text) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount)
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.subscription_id is not null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_subscription_donations_from_community(com_id integer, status text) OWNER TO reboo;

--
-- TOC entry 491 (class 1255 OID 16667)
-- Name: total_sum_subscription_donations_from_community_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_sum_subscription_donations_from_community_interval(com_id integer, status text, timeinterval interval) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount)
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status
                    and d.subscription_id is not null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_subscription_donations_from_community_interval(com_id integer, status text, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 501 (class 1255 OID 16668)
-- Name: total_sum_subscription_donations_from_mobilization(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_sum_subscription_donations_from_mobilization(mob_id integer, status text) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount)
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.subscription_id is not null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_subscription_donations_from_mobilization(mob_id integer, status text) OWNER TO reboo;

--
-- TOC entry 502 (class 1255 OID 16669)
-- Name: total_sum_subscription_donations_from_mobilization_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_sum_subscription_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount)
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status
                    and d.subscription_id is not null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_subscription_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 626 (class 1255 OID 16670)
-- Name: total_sum_transfer_operations_from_community(integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_sum_transfer_operations_from_community(community_id integer) RETURNS numeric
    LANGUAGE sql
    AS $_$
         WITH current_communities_access AS (
             SELECT DISTINCT(cu.community_id)
               FROM community_users cu
              WHERE ((cu.user_id = postgraphql.current_user_id()) OR ("current_user"() = 'admin'::name))
            ) select sum(bos.operation_amount)
            from public.balance_operation_summaries bos
            where bos.operation_type = 'transfer'
            and bos.community_id = $1 and (bos.community_id IN (
            SELECT current_communities_access.community_id FROM current_communities_access));
    $_$;


ALTER FUNCTION postgraphql.total_sum_transfer_operations_from_community(community_id integer) OWNER TO reboo;

--
-- TOC entry 4734 (class 0 OID 0)
-- Dependencies: 626
-- Name: FUNCTION total_sum_transfer_operations_from_community(community_id integer); Type: COMMENT; Schema: postgraphql; Owner: reboo
--

COMMENT ON FUNCTION postgraphql.total_sum_transfer_operations_from_community(community_id integer) IS 'Get total sum of all transfers to community';


--
-- TOC entry 503 (class 1255 OID 16671)
-- Name: total_sum_uniq_donations_from_community(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_sum_uniq_donations_from_community(com_id integer, status text) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount)
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.subscription_id is null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_uniq_donations_from_community(com_id integer, status text) OWNER TO reboo;

--
-- TOC entry 504 (class 1255 OID 16672)
-- Name: total_sum_uniq_donations_from_community_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_sum_uniq_donations_from_community_interval(com_id integer, status text, timeinterval interval) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount)
            from postgraphql.donations d
                where d.community_id = com_id
                    and d.transaction_status = status
                    and d.subscription_id is null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_uniq_donations_from_community_interval(com_id integer, status text, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 505 (class 1255 OID 16673)
-- Name: total_sum_uniq_donations_from_mobilization(integer, text); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_sum_uniq_donations_from_mobilization(mob_id integer, status text) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount)
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.subscription_id is null
                    and d.transaction_status = status), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_uniq_donations_from_mobilization(mob_id integer, status text) OWNER TO reboo;

--
-- TOC entry 506 (class 1255 OID 16674)
-- Name: total_sum_uniq_donations_from_mobilization_interval(integer, text, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_sum_uniq_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $$
        select coalesce((select sum(d.payable_amount)
            from postgraphql.donations d
                where d.mobilization_id = mob_id
                    and d.transaction_status = status
                    and d.subscription_id is null
                    and d.payment_date > CURRENT_TIMESTAMP - timeinterval), 0);
    $$;


ALTER FUNCTION postgraphql.total_sum_uniq_donations_from_mobilization_interval(mob_id integer, status text, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 507 (class 1255 OID 16675)
-- Name: total_uniq_activists_by_kind_and_community(text, integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_uniq_activists_by_kind_and_community(kind_name text, com_id integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where community_id = com_id
                and participate_kind = kind_name
    $$;


ALTER FUNCTION postgraphql.total_uniq_activists_by_kind_and_community(kind_name text, com_id integer) OWNER TO reboo;

--
-- TOC entry 508 (class 1255 OID 16676)
-- Name: total_uniq_activists_by_kind_and_community_interval(text, integer, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_uniq_activists_by_kind_and_community_interval(kind_name text, com_id integer, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where community_id = com_id
                and participate_kind = kind_name
                and participate_at > CURRENT_TIMESTAMP - timeinterval;
    $$;


ALTER FUNCTION postgraphql.total_uniq_activists_by_kind_and_community_interval(kind_name text, com_id integer, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 509 (class 1255 OID 16677)
-- Name: total_uniq_activists_by_kind_and_mobilization(text, integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_uniq_activists_by_kind_and_mobilization(kind_name text, mob_id integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where mobilization_id = mob_id
                and participate_kind = kind_name
    $$;


ALTER FUNCTION postgraphql.total_uniq_activists_by_kind_and_mobilization(kind_name text, mob_id integer) OWNER TO reboo;

--
-- TOC entry 510 (class 1255 OID 16678)
-- Name: total_uniq_activists_by_kind_and_mobilization_interval(text, integer, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_uniq_activists_by_kind_and_mobilization_interval(kind_name text, mob_id integer, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where mobilization_id = mob_id
                and participate_kind = kind_name
                and participate_at > CURRENT_TIMESTAMP - timeinterval;
    $$;


ALTER FUNCTION postgraphql.total_uniq_activists_by_kind_and_mobilization_interval(kind_name text, mob_id integer, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 511 (class 1255 OID 16679)
-- Name: total_unique_activists_by_community(integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_unique_activists_by_community(com_id integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where community_id = com_id;
    $$;


ALTER FUNCTION postgraphql.total_unique_activists_by_community(com_id integer) OWNER TO reboo;

--
-- TOC entry 512 (class 1255 OID 16680)
-- Name: total_unique_activists_by_community_interval(integer, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_unique_activists_by_community_interval(com_id integer, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where community_id = com_id
                and participate_at > CURRENT_TIMESTAMP - timeinterval;
    $$;


ALTER FUNCTION postgraphql.total_unique_activists_by_community_interval(com_id integer, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 492 (class 1255 OID 16681)
-- Name: total_unique_activists_by_mobilization(integer); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_unique_activists_by_mobilization(mob_id integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where mobilization_id = mob_id;
    $$;


ALTER FUNCTION postgraphql.total_unique_activists_by_mobilization(mob_id integer) OWNER TO reboo;

--
-- TOC entry 493 (class 1255 OID 16682)
-- Name: total_unique_activists_by_mobilization_interval(integer, interval); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.total_unique_activists_by_mobilization_interval(mob_id integer, timeinterval interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $$
        select
            count(distinct activist_id) as total
        from postgraphql.participations
            where mobilization_id = mob_id
                and participate_at > CURRENT_TIMESTAMP - timeinterval;
    $$;


ALTER FUNCTION postgraphql.total_unique_activists_by_mobilization_interval(mob_id integer, timeinterval interval) OWNER TO reboo;

--
-- TOC entry 513 (class 1255 OID 16683)
-- Name: update_bot(json); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.update_bot(bot_data json) RETURNS json
    LANGUAGE plpgsql
    AS $$
        declare
            bot_json public.facebook_bot_configurations;
        begin
            update public.facebook_bot_configurations
                set community_id = coalesce((bot_data ->> 'community_id')::integer, community_id)::integer,
                    messenger_app_secret = coalesce((bot_data ->> 'messenger_app_secret'), messenger_app_secret),
                    messenger_validation_token = coalesce((bot_data ->> 'messenger_validation_token'), messenger_validation_token),
                    messenger_page_access_token = coalesce((bot_data ->> 'messenger_page_access_token'), messenger_validation_token),
                    data = coalesce((bot_data ->> 'data')::jsonb, data),
                    updated_at = now()
                where id = (bot_data ->> 'id')::integer
                returning * into bot_json;

                return row_to_json(bot_json);
        end;
    $$;


ALTER FUNCTION postgraphql.update_bot(bot_data json) OWNER TO reboo;

--
-- TOC entry 314 (class 1259 OID 71176)
-- Name: facebook_bot_campaign_activists; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.facebook_bot_campaign_activists (
    id integer NOT NULL,
    facebook_bot_campaign_id integer NOT NULL,
    facebook_bot_activist_id integer NOT NULL,
    received boolean DEFAULT false NOT NULL,
    log jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.facebook_bot_campaign_activists OWNER TO reboo;

--
-- TOC entry 514 (class 1255 OID 16686)
-- Name: update_facebook_bot_campaign_activists(integer, boolean, jsonb); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.update_facebook_bot_campaign_activists(facebook_bot_campaign_activist_id integer, ctx_received boolean, ctx_log jsonb) RETURNS public.facebook_bot_campaign_activists
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_facebook_bot_campaign_activist public.facebook_bot_campaign_activists;
    BEGIN
        UPDATE public.facebook_bot_campaign_activists SET
            received = ctx_received,
            "log" = ctx_log,
            updated_at = NOW()
        WHERE id = facebook_bot_campaign_activist_id
        RETURNING * INTO v_facebook_bot_campaign_activist;
        RETURN v_facebook_bot_campaign_activist;
    END;
$$;


ALTER FUNCTION postgraphql.update_facebook_bot_campaign_activists(facebook_bot_campaign_activist_id integer, ctx_received boolean, ctx_log jsonb) OWNER TO reboo;

--
-- TOC entry 515 (class 1255 OID 16687)
-- Name: update_twilio_configuration(postgraphql.twilio_configurations); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.update_twilio_configuration(config postgraphql.twilio_configurations) RETURNS postgraphql.twilio_configurations
    LANGUAGE plpgsql
    AS $$
  DECLARE twilio_configuration postgraphql.twilio_configurations;
  BEGIN
    UPDATE postgraphql.twilio_configurations
    SET
      twilio_account_sid = COALESCE(
        CONFIG.twilio_account_sid,
        twilio_configuration.twilio_account_sid
      ),
      twilio_auth_token = COALESCE(
        CONFIG.twilio_auth_token,
        twilio_configuration.twilio_auth_token
      ),
      twilio_number = COALESCE(
        CONFIG.twilio_number,
        twilio_configuration.twilio_number
      ),
      updated_at = now()
    WHERE community_id = CONFIG.community_id
    RETURNING * INTO twilio_configuration;
    RETURN twilio_configuration;
  END;
$$;


ALTER FUNCTION postgraphql.update_twilio_configuration(config postgraphql.twilio_configurations) OWNER TO reboo;

--
-- TOC entry 516 (class 1255 OID 16688)
-- Name: watch_twilio_call_transitions(postgraphql.twilio_calls_arguments); Type: FUNCTION; Schema: postgraphql; Owner: reboo
--

CREATE FUNCTION postgraphql.watch_twilio_call_transitions(call postgraphql.twilio_calls_arguments) RETURNS postgraphql.watch_twilio_call_transition_record_set
    LANGUAGE sql IMMUTABLE
    AS $$
  SELECT tc.widget_id AS widget_id,
         tc.activist_id AS activist_id,
         tc.id AS twilio_call_id,
         tc.twilio_account_sid AS twilio_call_account_sid,
         tc.twilio_call_sid AS twilio_call_call_sid,
         tc."from" AS twilio_call_from,
         tc."to" AS twilio_call_to,
         tct.id AS twilio_call_transition_id,
         tct.sequence_number AS twilio_call_transition_sequence_number,
         tct.status AS twilio_call_transition_status,
         tct.call_duration AS twilio_call_transition_call_duration,
         tct.created_at AS twilio_call_transition_created_at,
         tct.updated_at AS twilio_call_transition_updated_at
  FROM public.twilio_calls AS tc
  RIGHT JOIN public.twilio_call_transitions AS tct ON tc.twilio_call_sid = tct.twilio_call_sid
  WHERE tc.widget_id = CALL.widget_id
    AND tc."from" = CALL."from"
  ORDER BY tc.id DESC,
           tct.sequence_number DESC LIMIT 1;
$$;


ALTER FUNCTION postgraphql.watch_twilio_call_transitions(call postgraphql.twilio_calls_arguments) OWNER TO reboo;

--
-- TOC entry 639 (class 1255 OID 148799)
-- Name: notify_watchers(); Type: FUNCTION; Schema: postgraphql_watch; Owner: reboo
--

CREATE FUNCTION postgraphql_watch.notify_watchers() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$ begin perform pg_notify( 'postgraphql_watch', (select array_to_json(array_agg(x)) from (select schema_name as schema, command_tag as command from pg_event_trigger_ddl_commands()) as x)::text ); end; $$;


ALTER FUNCTION postgraphql_watch.notify_watchers() OWNER TO reboo;

--
-- TOC entry 652 (class 1255 OID 148857)
-- Name: configuration(text); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.configuration(name text) RETURNS text
    LANGUAGE sql
    AS $_$
            select value from public.configurations where name = $1;
        $_$;


ALTER FUNCTION public.configuration(name text) OWNER TO reboo;

--
-- TOC entry 664 (class 1255 OID 1955993)
-- Name: copy_activist_pressures(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.copy_activist_pressures() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO
        activist_actions(action, widget_id, mobilization_id, community_id, activist_id, action_created_at, activist_created_at)
    SELECT 'activist_pressures'::text AS action,
		w.id AS widget_id,
		m.id AS mobilization_id,
		m.community_id,
		fe.activist_id,
		fe.created_at AS action_created_date,
		a.created_at AS activist_created_at
	FROM activist_pressures fe
		 JOIN activists a ON a.id = fe.activist_id
		 JOIN widgets w ON w.id = fe.widget_id
		 JOIN blocks b ON b.id = w.block_id
		 JOIN mobilizations m ON m.id = b.mobilization_id
	WHERE fe.id = new.id;
   	RETURN new;
END;
$$;


ALTER FUNCTION public.copy_activist_pressures() OWNER TO reboo;

--
-- TOC entry 665 (class 1255 OID 1955995)
-- Name: copy_donations(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.copy_donations() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO
        activist_actions(action, widget_id, mobilization_id, community_id, activist_id, action_created_at, activist_created_at)
    SELECT 'donations'::text AS action,
		w.id AS widget_id,
		m.id AS mobilization_id,
		m.community_id,
		fe.activist_id,
		fe.created_at AS action_created_date,
		a.created_at AS activist_created_at
	FROM donations fe
		 JOIN activists a ON a.id = fe.activist_id
		 JOIN widgets w ON w.id = fe.widget_id
		 JOIN blocks b ON b.id = w.block_id
		 JOIN mobilizations m ON m.id = b.mobilization_id
	WHERE fe.id = new.id;
   	RETURN new;
END;
$$;


ALTER FUNCTION public.copy_donations() OWNER TO reboo;

--
-- TOC entry 666 (class 1255 OID 1955997)
-- Name: copy_form_entries(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.copy_form_entries() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO
        activist_actions(action, widget_id, mobilization_id, community_id, activist_id, action_created_at, activist_created_at)
    SELECT 'form_entries'::text AS action,
		w.id AS widget_id,
		m.id AS mobilization_id,
		m.community_id,
		fe.activist_id,
		fe.created_at AS action_created_date,
		a.created_at AS activist_created_at
	FROM form_entries fe
		 JOIN activists a ON a.id = fe.activist_id
		 JOIN widgets w ON w.id = fe.widget_id
		 JOIN blocks b ON b.id = w.block_id
		 JOIN mobilizations m ON m.id = b.mobilization_id
	WHERE fe.id = new.id;
   	RETURN new;
END;
$$;


ALTER FUNCTION public.copy_form_entries() OWNER TO reboo;

--
-- TOC entry 658 (class 1255 OID 396268)
-- Name: diesel_manage_updated_at(regclass); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.diesel_manage_updated_at(_tbl regclass) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    EXECUTE format('CREATE TRIGGER set_updated_at BEFORE UPDATE ON %s
                    FOR EACH ROW EXECUTE PROCEDURE diesel_set_updated_at()', _tbl);
END;
$$;


ALTER FUNCTION public.diesel_manage_updated_at(_tbl regclass) OWNER TO reboo;

--
-- TOC entry 659 (class 1255 OID 396269)
-- Name: diesel_set_updated_at(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.diesel_set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (
        NEW IS DISTINCT FROM OLD AND
        NEW.updated_at IS NOT DISTINCT FROM OLD.updated_at
    ) THEN
        NEW.updated_at := current_timestamp;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.diesel_set_updated_at() OWNER TO reboo;

--
-- TOC entry 440 (class 1255 OID 16722)
-- Name: facebook_activist_message_full_text_index(text); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.facebook_activist_message_full_text_index(v_message text) RETURNS tsvector
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN setweight(to_tsvector('portuguese', v_message), 'A');
    END;
$$;


ALTER FUNCTION public.facebook_activist_message_full_text_index(v_message text) OWNER TO reboo;

--
-- TOC entry 211 (class 1259 OID 16572)
-- Name: form_entries; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.form_entries (
    id integer NOT NULL,
    widget_id integer,
    fields text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    synchronized boolean,
    activist_id integer,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text,
    cached_community_id integer,
    rede_syncronized boolean DEFAULT false,
    mobilization_id integer
);


ALTER TABLE public.form_entries OWNER TO reboo;

--
-- TOC entry 458 (class 1255 OID 16724)
-- Name: first_time_in_entries(public.form_entries); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.first_time_in_entries(entry public.form_entries) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
        select (select
            count(1)
        from form_entries fe2
        where
            entry.activist_id = fe2.activist_id
            and fe2.created_at <= entry.created_at
            and entry.id <> fe2.id
            limit 2) > 1;
    $$;


ALTER FUNCTION public.first_time_in_entries(entry public.form_entries) OWNER TO reboo;

--
-- TOC entry 231 (class 1259 OID 17246)
-- Name: activist_pressures; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.activist_pressures (
    id integer NOT NULL,
    activist_id integer,
    widget_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    synchronized boolean,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text,
    cached_community_id integer,
    mobilization_id integer,
    targets jsonb,
    syncronized boolean,
    form_data jsonb,
    status text DEFAULT 'draft'::text
);


ALTER TABLE public.activist_pressures OWNER TO reboo;

--
-- TOC entry 459 (class 1255 OID 16725)
-- Name: first_time_in_pressures(public.activist_pressures); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.first_time_in_pressures(pressure public.activist_pressures) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
        select (select
            count(1)
        from activist_pressures ap2
        where
            pressure.activist_id = ap2.activist_id
            and ap2.created_at <= pressure.created_at
            and ap2.id <> pressure.id
            limit 2) > 1;
    $$;


ALTER FUNCTION public.first_time_in_pressures(pressure public.activist_pressures) OWNER TO reboo;

--
-- TOC entry 645 (class 1255 OID 16730)
-- Name: generate_activists_from_generic_resource_with_widget(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.generate_activists_from_generic_resource_with_widget() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        declare
            v_mobilization public.mobilizations;
            v_profile_data json;
        begin
            IF TG_TABLE_NAME in ('subscriptions', 'form_entries', 'donations', 'activist_pressures')
                AND NEW.activist_id is not null AND NEW.widget_id is not null THEN

                select distinct(m.*) from mobilizations m
                    join blocks b on b.mobilization_id = m.id
                    join widgets w on w.block_id = b.id
                    where w.id = NEW.widget_id
                    into v_mobilization;

                select row_to_json(activists.*) from activists where id = NEW.activist_id
                    into v_profile_data;

                IF v_mobilization.id IS NOT NULL THEN
                    if not exists(select true
                        from community_activists
                        where community_id = v_mobilization.community_id and activist_id = NEW.activist_id) then
                        insert into community_activists (community_id, activist_id, created_at, updated_at, profile_data)
                            values (v_mobilization.community_id, NEW.activist_id, now(), now(), v_profile_data::jsonb);
                    end if;

                    if not exists(select true
                        from mobilization_activists
                        where mobilization_id = v_mobilization.id and activist_id = NEW.activist_id) then
                        insert into mobilization_activists (mobilization_id, activist_id, created_at, updated_at)
                            values (v_mobilization.id, NEW.activist_id, now(), now());
                    end if;
                END IF;

            END IF;
            return NEW;
        end;
    $$;


ALTER FUNCTION public.generate_activists_from_generic_resource_with_widget() OWNER TO reboo;

--
-- TOC entry 4740 (class 0 OID 0)
-- Dependencies: 645
-- Name: FUNCTION generate_activists_from_generic_resource_with_widget(); Type: COMMENT; Schema: public; Owner: reboo
--

COMMENT ON FUNCTION public.generate_activists_from_generic_resource_with_widget() IS 'insert a row on mobilization_activists and community_activists linking from NEW.activist_id / widget_id';


--
-- TOC entry 649 (class 1255 OID 148836)
-- Name: generate_notification_tags(json); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.generate_notification_tags(relations json) RETURNS json
    LANGUAGE plpgsql
    AS $_$
        declare
            _subscription public.subscriptions;
            _donation public.donations;
            _last_subscription_payment public.donations;
            _activist public.activists;
            _community public.communities;
            _mobilization public.mobilizations;
            _user public.users;
            _result json;
        begin
            -- get subscription when json->>'subscription_id' is present
            select * from public.subscriptions where id = ($1->>'subscription_id')::integer
                into _subscription;

            -- get donation when json->>'donation_id' is present
            select * from public.donations where id = ($1->>'donation_id')::integer
                into _donation;

            -- get last subscription donation when json ->> 'subscription_id' is present
            select * from public.donations where local_subscription_id = _subscription.id
                order by created_at desc limit 1 into _last_subscription_payment;

            -- get activist when json ->> 'activist_id' is present or subscription/donation is found
            select * from public.activists where id = coalesce(coalesce(($1->>'activist_id')::integer, _subscription.activist_id), _donation.activist_id)
                into _activist;

            -- get community when json->>'community_id' is present or subscription/donation is found
            select * from public.communities where id = coalesce(coalesce(($1->>'community_id')::integer, _subscription.community_id), _donation.cached_community_id)
                into _community;

            -- get user when json->>'user_id' is present
            select * from public.users where id = ($1->>'user_id')::integer
                into _user;

            -- get mobilization from subscription/donation widget when block is defined
            select * from mobilizations m
                join blocks b on b.mobilization_id = m.id
                join widgets w on w.block_id = b.id
                where w.id = coalesce(_subscription.widget_id, _donation.widget_id)
                into _mobilization;


            -- build and return template tags json after collect all data
            _result := json_build_object(
                'subscription_id', _subscription.id,
                'payment_method', coalesce(_subscription.payment_method, _donation.payment_method),
                'donation_id', _donation.id,
                'widget_id', _donation.widget_id,
                'mobilization_id', _mobilization.id,
                'mobilization_name', _mobilization.name,
                'boleto_expiration_date', (_donation.gateway_data ->> 'boleto_expiration_date'),
                'boleto_barcode', (_donation.gateway_data ->> 'boleto_barcode'),
                'boleto_url', (_donation.gateway_data ->> 'boleto_url'),
                'manage_url', (
                    case when _subscription.id is not null then
                        'https://app.bonde.org/subscriptions/'||_subscription.id||'/edit?token='||_subscription.token
                    else null end
                ),
                'amount', (coalesce(_subscription.amount, _donation.amount) / 100),
                'user', json_build_object(
                    'first_name', _user.first_name,
                    'last_name', _user.last_name
                ),
                'customer', json_build_object(
                    'name', _activist.name,
                    'first_name', _activist.first_name,
                    'last_name', _activist.last_name
                ),
                'community', json_build_object(
                    'id', _community.id,
                    'name', _community.name,
                    'image', _community.image
                ),
                'last_donation', json_build_object(
                    'payment_method', _last_subscription_payment.payment_method,
                    'widget_id', _last_subscription_payment.widget_id,
                    'mobilization_id', _mobilization.id,
                    'mobilization_name', _mobilization.name,
                    'boleto_expiration_date', (_last_subscription_payment.gateway_data ->> 'boleto_expiration_date'),
                    'boleto_barcode', (_last_subscription_payment.gateway_data ->> 'boleto_barcode'),
                    'boleto_url', (_last_subscription_payment.gateway_data ->> 'boleto_url')
                )
            );

            return _result;
        end;
    $_$;


ALTER FUNCTION public.generate_notification_tags(relations json) OWNER TO reboo;

--
-- TOC entry 262 (class 1259 OID 34619)
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    widget_id integer,
    activist_id integer,
    community_id integer,
    card_data jsonb,
    status character varying,
    period integer DEFAULT 30,
    amount integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    payment_method text NOT NULL,
    token uuid DEFAULT public.uuid_generate_v4(),
    gateway_subscription_id integer,
    synchronized boolean,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text,
    gateway_customer_id integer,
    customer_data jsonb,
    schedule_next_charge_at timestamp without time zone
);


ALTER TABLE public.subscriptions OWNER TO reboo;

--
-- TOC entry 473 (class 1255 OID 16787)
-- Name: next_transaction_charge_date(public.subscriptions); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.next_transaction_charge_date(public.subscriptions) RETURNS timestamp without time zone
    LANGUAGE sql STABLE
    AS $_$
        select
            d.created_at + '1 month'::interval
        from public.donations d
            where d.transaction_status = 'paid'
                and d.local_subscription_id = $1.id
            order by d.created_at desc limit 1;
    $_$;


ALTER FUNCTION public.next_transaction_charge_date(public.subscriptions) OWNER TO reboo;

--
-- TOC entry 474 (class 1255 OID 16789)
-- Name: nossas_recipient_id(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.nossas_recipient_id() RETURNS text
    LANGUAGE sql
    AS $$
         select 're_cinemdtb204bk2l5x8zri0iv8'::text;
$$;


ALTER FUNCTION public.nossas_recipient_id() OWNER TO reboo;

--
-- TOC entry 633 (class 1255 OID 148838)
-- Name: notify(text, json); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.notify(template_name text, relations json) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
    declare
        _community public.communities;
        _user public.users;
        _activist public.activists;
        _notification public.notifications;
        _notification_template public.notification_templates;
        _template_vars json;
    begin
        -- get community from relations
        select * from public.communities where id = ($2->>'community_id')::integer
            into _community;

        -- get user from relations
        select * from public.users where id = ($2->>'user_id')::integer
            into _user;

        -- get activist when set on relations
        select * from public.activists where id = ($2->>'activist_id')::integer
            into _activist;

        -- try get notification template from community
        select * from public.notification_templates nt
            where nt.community_id = ($2->>'community_id')::integer
                and nt.label = $1
            into _notification_template;

        -- if not found on community try get without community
        if _notification_template is null then
            select * from public.notification_templates nt
                where nt.label = $1
                into _notification_template;

            if _notification_template is null then
                raise 'invalid_notification_template';
            end if;
        end if;

        _template_vars := public.generate_notification_tags(relations);

        -- insert notification to database
        insert into notifications(activist_id, notification_template_id, template_vars, created_at, updated_at, user_id, email)
            values (_activist.id, _notification_template.id, _template_vars::jsonb, now(), now(), _user.id, $2->>'email')
        returning * into _notification;

        -- notify to notification_channels
        perform pg_notify('notifications_channel',pgjwt.sign(json_build_object(
            'action', 'deliver_notification',
            'id', _notification.id,
            'created_at', now(),
            'sent_to_queuing', now(),
            'jit', now()::timestamp
        ), public.configuration('jwt_secret'), 'HS512'));

        return json_build_object('id', _notification.id);
    end;
$_$;


ALTER FUNCTION public.notify(template_name text, relations json) OWNER TO reboo;

--
-- TOC entry 638 (class 1255 OID 137546)
-- Name: notify_create_twilio_configuration_trigger(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.notify_create_twilio_configuration_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
          IF (TG_OP = 'INSERT') THEN
            perform pg_notify('twilio_configuration_created', row_to_json(NEW)::text);
          END IF;

          IF (TG_OP = 'UPDATE') THEN
            perform pg_notify('twilio_configuration_updated', row_to_json(NEW)::text);
          END IF;

          RETURN NEW;
        END;
      $$;


ALTER FUNCTION public.notify_create_twilio_configuration_trigger() OWNER TO reboo;

--
-- TOC entry 657 (class 1255 OID 283294)
-- Name: notify_form_entries_trigger(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.notify_form_entries_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN

          perform pg_notify('form_entries_channel',
            pgjwt.sign(
              row_to_json(NEW),
              public.configuration('jwt_secret'),
              'HS512'
            )
          );

          RETURN NEW;
        END;
      $$;


ALTER FUNCTION public.notify_form_entries_trigger() OWNER TO reboo;

--
-- TOC entry 475 (class 1255 OID 16790)
-- Name: notify_twilio_call_trigger(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.notify_twilio_call_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    BEGIN perform pg_notify('twilio_call_created', row_to_json(NEW)::text);
    RETURN NEW;
  END;
$$;


ALTER FUNCTION public.notify_twilio_call_trigger() OWNER TO reboo;

--
-- TOC entry 209 (class 1259 OID 16563)
-- Name: donations; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.donations (
    id integer NOT NULL,
    widget_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    token character varying,
    payment_method character varying,
    amount integer,
    email character varying,
    card_hash character varying,
    customer public.hstore,
    skip boolean DEFAULT false,
    transaction_id character varying,
    transaction_status character varying DEFAULT 'pending'::character varying,
    subscription boolean,
    credit_card character varying,
    activist_id integer,
    subscription_id character varying,
    period integer,
    plan_id integer,
    parent_id integer,
    payables jsonb,
    gateway_data jsonb,
    payable_transfer_id integer,
    old_synch boolean,
    converted_from integer,
    synchronized boolean,
    local_subscription_id integer,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text,
    checkout_data jsonb,
    cached_community_id integer,
    mobilization_id integer
);


ALTER TABLE public.donations OWNER TO reboo;

--
-- TOC entry 623 (class 1255 OID 16799)
-- Name: payable_fee(public.donations); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.payable_fee(d public.donations) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $$
    select (
    case
    when d.payables is not null and jsonb_array_length(d.payables) < 2 then
        (
            case
            when extract(year from d.created_at) <= 2016 then
                (((d.payables -> 0 ->> 'amount')::integer / 100.0) * 0.15)  - ((d.payables -> 0 ->> 'fee')::integer / 100.0)
            else
                (((d.payables -> 0 ->> 'amount')::integer / 100.0) * 0.13) - ((d.payables -> 0 ->> 'fee')::integer / 100.0)
            end
        )
    when d.payables is null then
        (
            case
            when extract(year from d.created_at) <= 2016 then
                (d.amount / 100.0) * 0.15
            else
                (d.amount / 100.0) * 0.13
            end
        )
    else
        (
            select
                ((p ->> 'amount')::integer / 100.0) - ((p ->> 'fee')::integer / 100.0)
            from jsonb_array_elements(d.payables) p
                where (p ->> 'fee')::integer <> 0
                    limit 1
        )
    end)::decimal - (case d.payment_method
                     when 'boleto' then 0
                     else coalesce(((d.gateway_data ->> 'cost')::integer / 100.0), 0) end)
$$;


ALTER FUNCTION public.payable_fee(d public.donations) OWNER TO reboo;

--
-- TOC entry 634 (class 1255 OID 133418)
-- Name: payable_fee_2(public.donations); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.payable_fee_2(d public.donations) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $$
    select (
    case
    when d.payables is not null and jsonb_array_length(d.payables) < 2 then
        (
            case
            when extract(year from d.created_at) <= 2016 then
                (((d.payables -> 0 ->> 'amount')::integer / 100.0) * 0.13)  - ((d.payables -> 0 ->> 'fee')::integer / 100.0)
            else
                (((d.payables -> 0 ->> 'amount')::integer / 100.0) * 0.13) - ((d.payables -> 0 ->> 'fee')::integer / 100.0)
            end
        )
    when d.payables is null then
        (
            case
            when extract(year from d.created_at) <= 2016 then
                (d.amount / 100.0) * 0.15
            else
                (d.amount / 100.0) * 0.13
            end
        )
    else
        (
            select
                ((p ->> 'amount')::integer / 100.0) - ((p ->> 'fee')::integer / 100.0)
            from jsonb_array_elements(d.payables) p
                where (p ->> 'fee')::integer <> 0
                    limit 1
        )
    end)::decimal - (case d.payment_method
                     when 'boleto' then 0
                     else coalesce(((d.gateway_data ->> 'cost')::integer / 100.0), 0) end)
$$;


ALTER FUNCTION public.payable_fee_2(d public.donations) OWNER TO reboo;

--
-- TOC entry 650 (class 1255 OID 174285)
-- Name: receiving_unpaid_notifications(public.subscriptions); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.receiving_unpaid_notifications(public.subscriptions) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $_$
    declare
        _last_paid_donation public.donations;
    begin
        select * from donations
            where local_subscription_id = $1.id
                and transaction_status = 'paid'
                order by created_at desc
                limit 1
        into _last_paid_donation;

        if _last_paid_donation.id is not null then
            return coalesce((
                select count(1) <= 2
                    from notifications n
                    join notification_templates nt on nt.id = n.notification_template_id
                    where nt.label = 'unpaid_subscription'
                        and (n.template_vars->>'subscription_id')::integer = $1.id
                        and n.created_at >= _last_paid_donation.created_at
            ), true);
        else
            return (
                select count(1) <= 2
                    from notifications n
                    join notification_templates nt on nt.id = n.notification_template_id
                    where nt.label = 'unpaid_subscription'
                        and (n.template_vars->>'subscription_id')::integer = $1.id
            );
        end if;
    end;
$_$;


ALTER FUNCTION public.receiving_unpaid_notifications(public.subscriptions) OWNER TO reboo;

--
-- TOC entry 651 (class 1255 OID 174315)
-- Name: refresh_custom_domain_frontend(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.refresh_custom_domain_frontend() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    begin
        if new.traefik_host_rule is not null then
            perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
                'action', 'refresh_frontend',
                'id', new.id,
                'created_at', now(),
                'sent_to_queuing', now(),
                'jit', now()::timestamp
            ), public.configuration('jwt_secret'), 'HS512'));
        end if;

        return new;
    end;
$$;


ALTER FUNCTION public.refresh_custom_domain_frontend() OWNER TO reboo;

--
-- TOC entry 596 (class 1255 OID 16851)
-- Name: slugfy(text); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.slugfy(text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$
        select regexp_replace(replace(unaccent(lower($1)), ' ', '-'), '[^a-z0-9-_]+', '', 'g');
    $_$;


ALTER FUNCTION public.slugfy(text) OWNER TO reboo;

--
-- TOC entry 653 (class 1255 OID 10684979)
-- Name: slugify(text); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.slugify(value text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  -- removes accents (diacritic signs) from a given string --
  WITH "unaccented" AS (
    SELECT unaccent("value") AS "value"
  ),
  -- lowercases the string
  "lowercase" AS (
    SELECT lower("value") AS "value"
    FROM "unaccented"
  ),
  -- remove single and double quotes
  "removed_quotes" AS (
    SELECT regexp_replace("value", '[''"]+', '', 'gi') AS "value"
    FROM "lowercase"
  ),
  -- replaces anything that's not a letter, number, hyphen('-'), or underscore('_') with a hyphen('-')
  "hyphenated" AS (
    SELECT regexp_replace("value", '[^a-z0-9\\-_]+', '-', 'gi') AS "value"
    FROM "removed_quotes"
  ),
  -- trims hyphens('-') if they exist on the head or tail of the string
  "trimmed" AS (
    SELECT regexp_replace(regexp_replace("value", '\-+$', ''), '^\-', '') AS "value"
    FROM "hyphenated"
  )
  SELECT "value" FROM "trimmed";
$_$;


ALTER FUNCTION public.slugify(value text) OWNER TO reboo;

--
-- TOC entry 656 (class 1255 OID 10684912)
-- Name: slugify(text, boolean); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.slugify(value text, allow_unicode boolean) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$

  WITH "normalized" AS (
    SELECT CASE
      WHEN "allow_unicode" THEN "value"
      ELSE unaccent("value")
    END AS "value"
  ),
  "remove_chars" AS (
    SELECT regexp_replace("value", E'[^\\w\\s-]', '', 'gi') AS "value"
    FROM "normalized"
  ),
  "lowercase" AS (
    SELECT lower("value") AS "value"
    FROM "remove_chars"
  ),
  "trimmed" AS (
    SELECT trim("value") AS "value"
    FROM "lowercase"
  ),
  "hyphenated" AS (
    SELECT regexp_replace("value", E'[-\\s]+', '-', 'gi') AS "value"
    FROM "trimmed"
  )
  SELECT "value" FROM "hyphenated";

$$;


ALTER FUNCTION public.slugify(value text, allow_unicode boolean) OWNER TO reboo;

--
-- TOC entry 667 (class 1255 OID 1956514)
-- Name: update_expires(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.update_expires() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.expires = now()::date + (3 || ' days')::interval;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_expires() OWNER TO reboo;

--
-- TOC entry 613 (class 1255 OID 16868)
-- Name: update_facebook_bot_activists_full_text_index(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.update_facebook_bot_activists_full_text_index() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
        v_facebook_bot_activists public.facebook_bot_activists;
        v_payload jsonb;
        v_quick_reply text;
        v_messages tsvector;
        v_quick_replies text[];
    BEGIN
        SELECT *
        FROM public.facebook_bot_activists
        WHERE fb_context_recipient_id = NEW.fb_context_recipient_id
        INTO v_facebook_bot_activists;

        IF NEW.interaction ->> 'is_bot' IS NULL THEN
            v_payload := NEW.interaction -> 'payload';
            v_quick_reply := v_payload -> 'message' -> 'quick_reply' ->> 'payload';
            v_messages := CASE WHEN v_quick_reply IS NULL THEN
                public.facebook_activist_message_full_text_index(
                    v_payload -> 'message' ->> 'text'
                )
            END;

            IF v_quick_reply IS NOT NULL THEN
                v_quick_replies := ARRAY[v_quick_reply]::text[];
            END IF;

            IF v_facebook_bot_activists IS NULL THEN
                INSERT INTO public.facebook_bot_activists (
                    fb_context_recipient_id,
                    fb_context_sender_id,
                    data,
                    messages,
                    quick_replies,
                    interaction_dates,
                    created_at,
                    updated_at
                ) VALUES (
                    NEW.fb_context_recipient_id,
                    NEW.fb_context_sender_id,
                    NEW.interaction -> 'profile',
                    v_messages,
                    COALESCE(v_quick_replies, ARRAY[]::text[]),
                    ARRAY[NEW.created_at]::timestamp without time zone[],
                    NEW.created_at,
                    NEW.updated_at
                );
            ELSE
                UPDATE public.facebook_bot_activists
                SET
                    interaction_dates = ARRAY_APPEND(interaction_dates, NEW.created_at),
                    messages = CASE WHEN v_quick_reply IS NULL THEN
                        COALESCE(messages, '') || COALESCE(v_messages, '')
                    ELSE COALESCE(messages, '')
                    END,
                    quick_replies = CASE WHEN v_quick_replies IS NOT NULL THEN
                        (SELECT ARRAY_AGG(DISTINCT qr)
                        FROM UNNEST(ARRAY_CAT(quick_replies, v_quick_replies)) as qr)
                    ELSE
                        quick_replies
                    END
                WHERE fb_context_recipient_id = NEW.fb_context_recipient_id;
            END IF;
        END IF;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.update_facebook_bot_activists_full_text_index() OWNER TO reboo;

--
-- TOC entry 627 (class 1255 OID 396290)
-- Name: updated_at_column(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.updated_at_column() OWNER TO reboo;

--
-- TOC entry 632 (class 1255 OID 148859)
-- Name: verify_custom_domain(); Type: FUNCTION; Schema: public; Owner: reboo
--

CREATE FUNCTION public.verify_custom_domain() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      CASE TG_OP
      WHEN 'INSERT' THEN
        IF NEW.custom_domain is not null then
          perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
              'action', 'verify_custom_domain',
              'id', NEW.id,
              'custom_domain', NEW.custom_domain,
              'pg_action', 'insert_custom_domain',
              'sent_to_queuing', now(),
              'jit', now()::timestamp
          ), public.configuration('jwt_secret'), 'HS512'));
        END IF;
        RETURN NEW;

      WHEN 'UPDATE' THEN
        IF NEW.custom_domain is not null then
          perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
              'action', 'verify_custom_domain',
              'id', NEW.id,
              'custom_domain', NEW.custom_domain,
              'pg_action', 'update_custom_domain',
              'sent_to_queuing', now(),
              'jit', now()::timestamp
          ), public.configuration('jwt_secret'), 'HS512'));
        END IF;
        RETURN NEW;

     WHEN 'DELETE' THEN
      perform pg_notify('dns_channel', pgjwt.sign(json_build_object(
          'action', 'verify_custom_domain',
          'id', OLD.id,
          'custom_domain', OLD.custom_domain,
          'pg_action', 'delete_custom_domain',
          'sent_to_queuing', now(),
          'jit', now()::timestamp
      ), public.configuration('jwt_secret'), 'HS512'));
      RETURN OLD;

     ELSE
        raise  'custom_domain_not_processed';
      END CASE;
        END;
      $$;


ALTER FUNCTION public.verify_custom_domain() OWNER TO reboo;

--
-- TOC entry 357 (class 1259 OID 1955967)
-- Name: activist_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.activist_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activist_actions_id_seq OWNER TO reboo;

--
-- TOC entry 358 (class 1259 OID 1955969)
-- Name: activist_actions; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.activist_actions (
    action_created_at timestamp without time zone NOT NULL,
    activist_created_at timestamp without time zone NOT NULL,
    id integer DEFAULT nextval('public.activist_actions_id_seq'::regclass) NOT NULL,
    action text NOT NULL,
    widget_id integer NOT NULL,
    mobilization_id integer NOT NULL,
    community_id integer NOT NULL,
    activist_id integer NOT NULL
);


ALTER TABLE public.activist_actions OWNER TO reboo;

--
-- TOC entry 4745 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE activist_actions; Type: COMMENT; Schema: public; Owner: reboo
--

COMMENT ON TABLE public.activist_actions IS 'Tabela responsável por agregar informações sobre as ações do ativista';


--
-- TOC entry 360 (class 1259 OID 1956502)
-- Name: activist_actions; Type: VIEW; Schema: anonymous; Owner: reboo
--

CREATE VIEW anonymous.activist_actions AS
 SELECT activist_actions.action_created_at,
    activist_actions.id,
    activist_actions.action,
    activist_actions.mobilization_id
   FROM public.activist_actions;


ALTER TABLE anonymous.activist_actions OWNER TO reboo;

--
-- TOC entry 4746 (class 0 OID 0)
-- Dependencies: 360
-- Name: VIEW activist_actions; Type: COMMENT; Schema: anonymous; Owner: reboo
--

COMMENT ON VIEW anonymous.activist_actions IS 'Public view to access data of activist actions.';


--
-- TOC entry 215 (class 1259 OID 16588)
-- Name: communities; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.communities (
    id integer NOT NULL,
    name character varying,
    city character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    mailchimp_api_key text,
    mailchimp_list_id text,
    mailchimp_group_id text,
    image character varying,
    description text,
    recipient_id integer,
    facebook_app_id character varying,
    fb_link character varying,
    twitter_link character varying,
    subscription_retry_interval integer DEFAULT 7,
    subscription_dead_days_interval integer DEFAULT 90,
    email_template_from character varying,
    mailchimp_sync_request_at timestamp without time zone,
    modules jsonb DEFAULT '{"settings": true, "mobilization": true}'::jsonb,
    signature jsonb
);


ALTER TABLE public.communities OWNER TO reboo;

--
-- TOC entry 359 (class 1259 OID 1956498)
-- Name: communities; Type: VIEW; Schema: anonymous; Owner: reboo
--

CREATE VIEW anonymous.communities AS
 SELECT communities.id,
    communities.name,
    communities.city,
    communities.created_at,
    communities.image,
    communities.description,
    communities.fb_link,
    communities.twitter_link,
    communities.email_template_from
   FROM public.communities;


ALTER TABLE anonymous.communities OWNER TO reboo;

--
-- TOC entry 4748 (class 0 OID 0)
-- Dependencies: 359
-- Name: VIEW communities; Type: COMMENT; Schema: anonymous; Owner: reboo
--

COMMENT ON VIEW anonymous.communities IS 'Public view to access data of communities.';

--
-- TOC entry 318 (class 1259 OID 103370)
-- Name: certificates; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.certificates (
    id integer NOT NULL,
    community_id integer,
    mobilization_id integer,
    dns_hosted_zone_id integer,
    domain character varying,
    file_content text,
    expire_on timestamp without time zone,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.certificates OWNER TO reboo;

--
-- TOC entry 213 (class 1259 OID 16580)
-- Name: mobilizations; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.mobilizations (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    color_scheme character varying,
    google_analytics_code character varying,
    goal text,
    header_font character varying,
    body_font character varying,
    facebook_share_title character varying,
    facebook_share_description text,
    facebook_share_image character varying,
    slug character varying,
    custom_domain character varying,
    twitter_share_text character varying(300),
    community_id integer,
    favicon character varying,
    deleted_at timestamp without time zone,
    status public.status_mobilization DEFAULT 'active'::public.status_mobilization,
    traefik_host_rule character varying,
    traefik_backend_address character varying,
    language character varying(5) DEFAULT 'pt-BR'::character varying
);


ALTER TABLE public.mobilizations OWNER TO reboo;

--
-- TOC entry 254 (class 1259 OID 33295)
-- Name: dns_hosted_zones; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.dns_hosted_zones (
    id integer NOT NULL,
    community_id integer,
    domain_name character varying,
    comment text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    response jsonb,
    ns_ok boolean,
    status public.dnshostedzonestatus DEFAULT 'created'::public.dnshostedzonestatus
);


ALTER TABLE public.dns_hosted_zones OWNER TO reboo;

--
-- TOC entry 258 (class 1259 OID 33329)
-- Name: notification_templates; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.notification_templates (
    id integer NOT NULL,
    label text NOT NULL,
    community_id integer,
    subject_template text NOT NULL,
    body_template text NOT NULL,
    template_vars jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    locale text DEFAULT 'pt-BR'::text NOT NULL,
    CONSTRAINT localechk CHECK ((locale = ANY (public.locale_names())))
);


ALTER TABLE public.notification_templates OWNER TO reboo;

--
-- TOC entry 260 (class 1259 OID 33345)
-- Name: notifications; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    activist_id integer,
    notification_template_id integer NOT NULL,
    template_vars jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    community_id integer,
    user_id integer,
    email character varying,
    deliver_at timestamp without time zone,
    delivered_at timestamp without time zone
);


ALTER TABLE public.notifications OWNER TO reboo;

--
-- TOC entry 282 (class 1259 OID 49368)
-- Name: activist_facebook_bot_interactions; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.activist_facebook_bot_interactions (
    id integer NOT NULL,
    activist_id integer,
    facebook_bot_configuration_id integer NOT NULL,
    fb_context_recipient_id text NOT NULL,
    fb_context_sender_id text NOT NULL,
    interaction jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.activist_facebook_bot_interactions OWNER TO reboo;

--
-- TOC entry 280 (class 1259 OID 49356)
-- Name: facebook_bot_configurations; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.facebook_bot_configurations (
    id integer NOT NULL,
    community_id integer,
    messenger_app_secret text NOT NULL,
    messenger_validation_token text NOT NULL,
    messenger_page_access_token text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.facebook_bot_configurations OWNER TO reboo;

--
-- TOC entry 284 (class 1259 OID 49398)
-- Name: activist_facebook_bot_interactions; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.activist_facebook_bot_interactions AS
 SELECT i.id,
    i.activist_id,
    i.facebook_bot_configuration_id,
    i.fb_context_recipient_id,
    i.fb_context_sender_id,
    i.interaction,
    i.created_at,
    i.updated_at,
    c.community_id,
    c.data AS facebook_bot_configuration
   FROM (public.activist_facebook_bot_interactions i
     JOIN public.facebook_bot_configurations c ON ((i.facebook_bot_configuration_id = c.id)))
  WHERE postgraphql.current_user_has_community_participation(c.community_id);


ALTER TABLE postgraphql.activist_facebook_bot_interactions OWNER TO reboo;

--
-- TOC entry 304 (class 1259 OID 53317)
-- Name: mobilization_activists; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.mobilization_activists (
    id integer NOT NULL,
    mobilization_id integer NOT NULL,
    activist_id integer NOT NULL,
    search_index tsvector,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.mobilization_activists OWNER TO reboo;

--
-- TOC entry 361 (class 1259 OID 2195083)
-- Name: activist_mobilizations; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.activist_mobilizations AS
 SELECT ma.activist_id,
    m.id,
    m.name,
    m.created_at,
    m.updated_at,
    m.user_id,
    m.color_scheme,
    m.google_analytics_code,
    m.goal,
    m.header_font,
    m.body_font,
    m.facebook_share_title,
    m.facebook_share_description,
    m.facebook_share_image,
    m.slug,
    m.custom_domain,
    m.twitter_share_text,
    m.community_id,
    m.favicon,
    m.deleted_at,
    m.status,
    m.traefik_host_rule,
    m.traefik_backend_address
   FROM (public.mobilization_activists ma
     JOIN public.mobilizations m ON ((m.id = ma.mobilization_id)))
  WHERE postgraphql.current_user_has_community_participation(m.community_id);


ALTER TABLE postgraphql.activist_mobilizations OWNER TO reboo;

--
-- TOC entry 307 (class 1259 OID 56090)
-- Name: activist_tags; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.activist_tags AS
 SELECT at.community_id,
    at.activist_id,
    tag.name AS tag_complete_name,
    (regexp_split_to_array((tag.name)::text, '_'::text))[1] AS tag_from,
    replace((regexp_split_to_array((tag.name)::text, '_'::text))[2], '-'::text, ' '::text) AS tag_name,
    tag.label AS tag_label
   FROM ((public.activist_tags at
     JOIN public.taggings tgs ON ((((tgs.taggable_type)::text = 'ActivistTag'::text) AND (tgs.taggable_id = at.id))))
     JOIN public.tags tag ON ((tag.id = tgs.tag_id)))
  WHERE postgraphql.current_user_has_community_participation(at.community_id);


ALTER TABLE postgraphql.activist_tags OWNER TO reboo;

--
-- TOC entry 278 (class 1259 OID 49337)
-- Name: balance_operations; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.balance_operations (
    id integer NOT NULL,
    recipient_id integer NOT NULL,
    gateway_data jsonb NOT NULL,
    gateway_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.balance_operations OWNER TO reboo;

--
-- TOC entry 244 (class 1259 OID 30708)
-- Name: recipients; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.recipients (
    id integer NOT NULL,
    pagarme_recipient_id character varying NOT NULL,
    recipient jsonb NOT NULL,
    community_id integer NOT NULL,
    transfer_day integer,
    transfer_enabled boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.recipients OWNER TO reboo;

--
-- TOC entry 286 (class 1259 OID 50893)
-- Name: balance_operation_summaries; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.balance_operation_summaries AS
 SELECT bo.id,
    bo.recipient_id,
    r.community_id,
    (bo.gateway_data ->> 'type'::text) AS operation_type,
    (bo.gateway_data ->> 'object'::text) AS operation_object,
    (bo.gateway_data ->> 'status'::text) AS operation_status,
    (((bo.gateway_data ->> 'amount'::text))::numeric / 100.0) AS operation_amount,
    (((bo.gateway_data ->> 'balance_amount'::text))::numeric / 100.0) AS balance_amount_at_moment,
    (((bo.gateway_data ->> 'fee'::text))::numeric / 100.0) AS operation_fee,
    ((bo.gateway_data ->> 'date_created'::text))::timestamp without time zone AS operation_created_at,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'id'::text) AS movement_object_id,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'type'::text) AS movement_object_type,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'status'::text) AS movement_object_status,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'object'::text) AS movement_object_object,
    ((((bo.gateway_data -> 'movement_object'::text) ->> 'amount'::text))::numeric / 100.0) AS movement_object_amount,
    ((((bo.gateway_data -> 'movement_object'::text) ->> 'fee'::text))::numeric / 100.0) AS movement_object_fee,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'transaction_id'::text) AS movement_object_transaction_id,
    ((bo.gateway_data -> 'movement_object'::text) ->> 'payment_method'::text) AS movement_object_payment_method,
    (bo.gateway_data -> 'movement_object'::text) AS movement_object
   FROM (public.balance_operations bo
     JOIN public.recipients r ON ((r.id = bo.recipient_id)))
  ORDER BY ((bo.gateway_data ->> 'date_created'::text))::timestamp without time zone DESC;


ALTER TABLE public.balance_operation_summaries OWNER TO reboo;

--
-- TOC entry 287 (class 1259 OID 50898)
-- Name: balance_operations; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.balance_operations AS
 SELECT bos.id,
    bos.recipient_id,
    bos.community_id,
    bos.operation_type,
    bos.operation_object,
    bos.operation_status,
    bos.operation_amount,
    bos.balance_amount_at_moment,
    bos.operation_fee,
    bos.operation_created_at,
    bos.movement_object_id,
    bos.movement_object_type,
    bos.movement_object_status,
    bos.movement_object_object,
    bos.movement_object_amount,
    bos.movement_object_fee,
    bos.movement_object_transaction_id,
    bos.movement_object_payment_method,
    bos.movement_object
   FROM public.balance_operation_summaries bos
  WHERE postgraphql.current_user_has_community_participation(bos.community_id);


ALTER TABLE postgraphql.balance_operations OWNER TO reboo;

--
-- TOC entry 306 (class 1259 OID 53503)
-- Name: facebook_activist_interactions; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.facebook_activist_interactions AS
 SELECT activist_facebook_bot_interactions.id,
    activist_facebook_bot_interactions.activist_id,
    activist_facebook_bot_interactions.facebook_bot_configuration_id,
    activist_facebook_bot_interactions.fb_context_recipient_id,
    activist_facebook_bot_interactions.fb_context_sender_id,
    activist_facebook_bot_interactions.interaction,
    activist_facebook_bot_interactions.created_at,
    activist_facebook_bot_interactions.updated_at
   FROM public.activist_facebook_bot_interactions
  WHERE ((activist_facebook_bot_interactions.interaction -> 'is_bot'::text) IS NULL);


ALTER TABLE postgraphql.facebook_activist_interactions OWNER TO reboo;

--
-- TOC entry 285 (class 1259 OID 49402)
-- Name: bot_recipients; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.bot_recipients AS
 SELECT i.facebook_bot_configuration_id,
    i.fb_context_recipient_id,
    i.fb_context_sender_id,
    i.interaction,
    c.community_id,
    c.data AS facebook_bot_configuration,
    i.created_at
   FROM ((postgraphql.facebook_activist_interactions i
     LEFT JOIN postgraphql.facebook_activist_interactions aux ON (((i.facebook_bot_configuration_id = aux.facebook_bot_configuration_id) AND (i.fb_context_recipient_id = aux.fb_context_recipient_id) AND (i.fb_context_sender_id = aux.fb_context_sender_id) AND (i.id < aux.id))))
     LEFT JOIN public.facebook_bot_configurations c ON ((i.facebook_bot_configuration_id = c.id)))
  WHERE ((aux.id IS NULL) AND postgraphql.current_user_has_community_participation(c.community_id));


ALTER TABLE postgraphql.bot_recipients OWNER TO reboo;

--
-- TOC entry 333 (class 1259 OID 174300)
-- Name: communities; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.communities AS
 SELECT com.id,
    com.name,
    com.city,
    com.description,
    com.created_at,
    com.updated_at,
    com.image,
    com.fb_link,
    com.twitter_link
   FROM public.communities com;


ALTER TABLE postgraphql.communities OWNER TO reboo;

--
-- TOC entry 274 (class 1259 OID 48379)
-- Name: community_user_roles; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.community_user_roles AS
 SELECT cu.id,
    cu.user_id,
    cu.community_id,
    cu.role,
    cu.created_at,
    cu.updated_at
   FROM public.community_users cu
  WHERE (cu.user_id = postgraphql.current_user_id());


ALTER TABLE postgraphql.community_user_roles OWNER TO reboo;

--
-- TOC entry 205 (class 1259 OID 16547)
-- Name: blocks; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.blocks (
    id integer NOT NULL,
    mobilization_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    bg_class character varying,
    "position" integer,
    hidden boolean,
    bg_image text,
    name character varying,
    menu_hidden boolean,
    deleted_at timestamp without time zone
);


ALTER TABLE public.blocks OWNER TO reboo;

--
-- TOC entry 233 (class 1259 OID 17731)
-- Name: payable_transfers; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.payable_transfers (
    id integer NOT NULL,
    transfer_id integer,
    transfer_data jsonb,
    transfer_status text,
    community_id integer NOT NULL,
    amount numeric NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.payable_transfers OWNER TO reboo;

--
-- TOC entry 224 (class 1259 OID 16630)
-- Name: widgets; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.widgets (
    id integer NOT NULL,
    block_id integer,
    settings jsonb,
    kind character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sm_size integer,
    md_size integer,
    lg_size integer,
    mailchimp_segment_id character varying,
    action_community boolean DEFAULT false,
    exported_at timestamp without time zone,
    mailchimp_unique_segment_id character varying,
    mailchimp_recurring_active_segment_id character varying,
    mailchimp_recurring_inactive_segment_id character varying,
    goal numeric(12,2),
    deleted_at timestamp without time zone
);


ALTER TABLE public.widgets OWNER TO reboo;

--
-- TOC entry 267 (class 1259 OID 46555)
-- Name: payable_details; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.payable_details AS
 SELECT o.id AS community_id,
    d.widget_id,
    m.id AS mobilization_id,
    b.id AS block_id,
    d.id AS donation_id,
    d.subscription_id,
    d.transaction_id,
    (dd.value ->> 'id'::text) AS payable_id,
    (((d.amount)::numeric / 100.0))::double precision AS donation_value,
    (((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision) AS payable_value,
    (payable_summary.payable_fee)::double precision AS payable_pagarme_fee,
        CASE
            WHEN (jsonb_array_length(d.payables) > 1) THEN nossas_tx.amount
            ELSE ((((d.amount)::numeric / 100.0) * 0.13))::double precision
        END AS nossas_fee,
    nossas_tx.percent AS percent_tx,
        CASE
            WHEN (jsonb_array_length(d.payables) > 1) THEN ((((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision) - (payable_summary.payable_fee)::double precision)
            ELSE ((((d.amount)::numeric / 100.0))::double precision - ((((d.amount)::numeric / 100.0) * 0.13))::double precision)
        END AS value_without_fee,
    ((dd.value ->> 'date_created'::text))::timestamp without time zone AS payment_date,
    ((dd.value ->> 'payment_date'::text))::timestamp without time zone AS payable_date,
    d.transaction_status AS pagarme_status,
    (dd.value ->> 'status'::text) AS payable_status,
    d.payment_method,
    customer.name,
    customer.email,
    pt.id AS payable_transfer_id,
    pt.transfer_data,
    d.gateway_data,
    d.subscription AS is_subscription,
    (dd.value ->> 'recipient_id'::text) AS recipient_id,
    d.local_subscription_id
   FROM (((((((((public.communities o
     JOIN public.donations d ON (((d.cached_community_id = o.id) AND ((d.transaction_status)::text = 'paid'::text))))
     LEFT JOIN public.widgets w ON ((w.id = d.widget_id)))
     LEFT JOIN public.blocks b ON ((b.id = w.block_id)))
     LEFT JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
     LEFT JOIN public.payable_transfers pt ON ((pt.id = d.payable_transfer_id)))
     LEFT JOIN LATERAL ( SELECT COALESCE((d2.customer OPERATOR(public.->) 'name'::text), (d.customer OPERATOR(public.->) 'name'::text)) AS name,
            COALESCE((d2.customer OPERATOR(public.->) 'email'::text), (d.customer OPERATOR(public.->) 'email'::text)) AS email
           FROM public.donations d2
          WHERE
                CASE
                    WHEN (d.parent_id IS NULL) THEN (d2.id = d.id)
                    ELSE (d2.id = d.parent_id)
                END) customer ON (true))
     LEFT JOIN LATERAL ( SELECT data.value
           FROM jsonb_array_elements(d.payables) data(value)) dd ON (true))
     LEFT JOIN LATERAL ( SELECT (((jsonb_array_elements.value ->> 'amount'::text))::double precision / (100.0)::double precision) AS amount,
            ((((jsonb_array_elements.value ->> 'amount'::text))::double precision / (d.amount)::double precision) * (100.0)::double precision) AS percent
           FROM jsonb_array_elements(d.payables) jsonb_array_elements(value)
          WHERE ((jsonb_array_elements.value ->> 'recipient_id'::text) = public.nossas_recipient_id())) nossas_tx ON (true))
     LEFT JOIN LATERAL ( SELECT td.amount,
            td.payable_fee,
            td.transaction_cost,
            (td.amount - td.payable_fee) AS value_without_fee
           FROM ( SELECT ((((dd.value ->> 'amount'::text))::integer)::numeric / 100.0) AS amount,
                    ((((dd.value ->> 'fee'::text))::integer)::numeric / 100.0) AS payable_fee,
                    ((((d.gateway_data ->> 'cost'::text))::integer)::numeric / 100.0) AS transaction_cost) td) payable_summary ON (true))
  WHERE ((((dd.value ->> 'type'::text) = 'credit'::text) AND ((dd.value ->> 'object'::text) = 'payable'::text) AND ((dd.value ->> 'recipient_id'::text) IN ( SELECT (r.pagarme_recipient_id)::text AS pagarme_recipient_id
           FROM public.recipients r
          WHERE (r.community_id = o.id)))) OR (jsonb_array_length(d.payables) = 1));


ALTER TABLE public.payable_details OWNER TO reboo;

--
-- TOC entry 276 (class 1259 OID 48387)
-- Name: donations; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.donations AS
 SELECT d.id AS donation_id,
    COALESCE(c.id, d.cached_community_id) AS community_id,
    w.id AS widget_id,
    m.id AS mobilization_id,
    b.id AS block_id,
    d.activist_id,
    d.email AS donation_email,
    (d.amount / 100) AS donation_amount,
    d.local_subscription_id AS subscription_id,
    d.transaction_status,
    COALESCE(((d.gateway_data ->> 'date_created'::text))::timestamp without time zone, d.created_at) AS payment_date,
    pd.payable_date,
    pd.payable_value AS payable_amount,
    pd.payable_status,
    s.status AS subscription_status
   FROM ((((((public.donations d
     JOIN public.widgets w ON ((w.id = d.widget_id)))
     LEFT JOIN public.blocks b ON ((b.id = w.block_id)))
     LEFT JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
     LEFT JOIN public.communities c ON (((c.id = m.community_id) OR (c.id = d.cached_community_id))))
     LEFT JOIN public.subscriptions s ON ((s.id = d.local_subscription_id)))
     LEFT JOIN public.payable_details pd ON ((pd.donation_id = d.id)))
  WHERE ((d.transaction_id IS NOT NULL) AND (c.id IN ( SELECT community_user_roles.community_id
           FROM postgraphql.community_user_roles)));


ALTER TABLE postgraphql.donations OWNER TO reboo;

--
-- TOC entry 283 (class 1259 OID 49391)
-- Name: facebook_bot_configurations; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.facebook_bot_configurations AS
 SELECT facebook_bot_configurations.id,
    facebook_bot_configurations.community_id,
    facebook_bot_configurations.messenger_app_secret,
    facebook_bot_configurations.messenger_validation_token,
    facebook_bot_configurations.messenger_page_access_token,
    facebook_bot_configurations.data,
    facebook_bot_configurations.created_at,
    facebook_bot_configurations.updated_at
   FROM public.facebook_bot_configurations
  WHERE ((facebook_bot_configurations.data ->> 'deleted'::text) IS NULL);


ALTER TABLE postgraphql.facebook_bot_configurations OWNER TO reboo;

--
-- TOC entry 305 (class 1259 OID 53498)
-- Name: facebook_bot_interactions; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.facebook_bot_interactions AS
 SELECT activist_facebook_bot_interactions.id,
    activist_facebook_bot_interactions.activist_id,
    activist_facebook_bot_interactions.facebook_bot_configuration_id,
    activist_facebook_bot_interactions.fb_context_recipient_id,
    activist_facebook_bot_interactions.fb_context_sender_id,
    activist_facebook_bot_interactions.interaction,
    activist_facebook_bot_interactions.created_at,
    activist_facebook_bot_interactions.updated_at
   FROM public.activist_facebook_bot_interactions
  WHERE ((activist_facebook_bot_interactions.interaction -> 'is_bot'::text) = 'true'::jsonb);


ALTER TABLE postgraphql.facebook_bot_interactions OWNER TO reboo;

--
-- TOC entry 273 (class 1259 OID 48323)
-- Name: activist_participations; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.activist_participations AS
SELECT
    NULL::integer AS community_id,
    NULL::integer AS mobilization_id,
    NULL::integer AS widget_id,
    NULL::integer AS activist_id,
    NULL::character varying AS email,
    NULL::timestamp without time zone AS participate_at,
    NULL::text AS participate_kind,
    NULL::integer AS participate_id;


ALTER TABLE public.activist_participations OWNER TO reboo;

--
-- TOC entry 275 (class 1259 OID 48383)
-- Name: participations; Type: VIEW; Schema: postgraphql; Owner: reboo
--

CREATE VIEW postgraphql.participations AS
 SELECT ap.community_id,
    ap.mobilization_id,
    ap.widget_id,
    ap.activist_id,
    ap.email,
    ap.participate_at,
    ap.participate_kind,
    ap.participate_id
   FROM public.activist_participations ap
  WHERE (ap.community_id IN ( SELECT community_user_roles.community_id
           FROM postgraphql.community_user_roles));


ALTER TABLE postgraphql.participations OWNER TO reboo;

--
-- TOC entry 335 (class 1259 OID 396262)
-- Name: __diesel_schema_migrations; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.__diesel_schema_migrations (
    version character varying(50) NOT NULL,
    run_on timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.__diesel_schema_migrations OWNER TO reboo;

--
-- TOC entry 378 (class 1259 OID 18590330)
-- Name: activist_actions_lgpd; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.activist_actions_lgpd AS
 SELECT t.action,
    t.widget_id,
    t.mobilization_id,
    t.community_id,
    t.activist_id,
    t.action_created_date,
    t.activist_created_at
   FROM ( SELECT 'form_entries'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            fe.activist_id,
            fe.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.form_entries fe
             JOIN public.activists a ON ((a.id = fe.activist_id)))
             JOIN public.widgets w ON ((w.id = fe.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
        UNION ALL
         SELECT 'activist_pressures'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            ap.activist_id,
            ap.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.activist_pressures ap
             JOIN public.activists a ON ((a.id = ap.activist_id)))
             JOIN public.widgets w ON ((w.id = ap.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
        UNION ALL
         SELECT 'donations'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            d.activist_id,
            d.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.donations d
             JOIN public.activists a ON ((a.id = d.activist_id)))
             JOIN public.widgets w ON ((w.id = d.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))) t;


ALTER TABLE public.activist_actions_lgpd OWNER TO reboo;

--
-- TOC entry 374 (class 1259 OID 12444871)
-- Name: activist_actions_virtual; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.activist_actions_virtual AS
 SELECT t.action,
    t.widget_id,
    t.mobilization_id,
    t.community_id,
    t.activist_id,
    t.action_created_date,
    t.activist_created_at,
    t.activist_email
   FROM ( SELECT 'form_entries'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            fe.activist_id,
            fe.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.form_entries fe
             JOIN public.activists a ON ((a.id = fe.activist_id)))
             JOIN public.widgets w ON ((w.id = fe.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
        UNION ALL
         SELECT 'activist_pressures'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            ap.activist_id,
            ap.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.activist_pressures ap
             JOIN public.activists a ON ((a.id = ap.activist_id)))
             JOIN public.widgets w ON ((w.id = ap.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
        UNION ALL
         SELECT 'donations'::text AS action,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id,
            d.activist_id,
            d.created_at AS action_created_date,
            a.created_at AS activist_created_at,
            a.email AS activist_email
           FROM ((((public.donations d
             JOIN public.activists a ON ((a.id = d.activist_id)))
             JOIN public.widgets w ON ((w.id = d.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))) t;


ALTER TABLE public.activist_actions_virtual OWNER TO reboo;

--
-- TOC entry 281 (class 1259 OID 49366)
-- Name: activist_facebook_bot_interactions_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.activist_facebook_bot_interactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activist_facebook_bot_interactions_id_seq OWNER TO reboo;

--
-- TOC entry 4777 (class 0 OID 0)
-- Dependencies: 281
-- Name: activist_facebook_bot_interactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.activist_facebook_bot_interactions_id_seq OWNED BY public.activist_facebook_bot_interactions.id;


--
-- TOC entry 229 (class 1259 OID 17178)
-- Name: activist_matches; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.activist_matches (
    id integer NOT NULL,
    activist_id integer,
    match_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    synchronized boolean,
    mailchimp_syncronization_at timestamp without time zone,
    mailchimp_syncronization_error_reason text
);


ALTER TABLE public.activist_matches OWNER TO reboo;

--
-- TOC entry 228 (class 1259 OID 17176)
-- Name: activist_matches_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.activist_matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activist_matches_id_seq OWNER TO reboo;

--
-- TOC entry 4779 (class 0 OID 0)
-- Dependencies: 228
-- Name: activist_matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.activist_matches_id_seq OWNED BY public.activist_matches.id;


--
-- TOC entry 230 (class 1259 OID 17244)
-- Name: activist_pressures_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.activist_pressures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activist_pressures_id_seq OWNER TO reboo;

--
-- TOC entry 4780 (class 0 OID 0)
-- Dependencies: 230
-- Name: activist_pressures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.activist_pressures_id_seq OWNED BY public.activist_pressures.id;


--
-- TOC entry 251 (class 1259 OID 33274)
-- Name: activist_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.activist_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activist_tags_id_seq OWNER TO reboo;

--
-- TOC entry 4781 (class 0 OID 0)
-- Dependencies: 251
-- Name: activist_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.activist_tags_id_seq OWNED BY public.activist_tags.id;


--
-- TOC entry 202 (class 1259 OID 16537)
-- Name: activists_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activists_id_seq OWNER TO reboo;

--
-- TOC entry 4783 (class 0 OID 0)
-- Dependencies: 202
-- Name: activists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.activists_id_seq OWNED BY public.activists.id;


--
-- TOC entry 203 (class 1259 OID 16539)
-- Name: addresses; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.addresses (
    id integer NOT NULL,
    zipcode character varying,
    street character varying,
    street_number character varying,
    complementary character varying,
    neighborhood character varying,
    city character varying,
    state character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    activist_id integer
);


ALTER TABLE public.addresses OWNER TO reboo;

--
-- TOC entry 204 (class 1259 OID 16545)
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.addresses_id_seq OWNER TO reboo;

--
-- TOC entry 4785 (class 0 OID 0)
-- Dependencies: 204
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- TOC entry 380 (class 1259 OID 18594888)
-- Name: agg_activists; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.agg_activists AS
SELECT
    NULL::integer AS community_id,
    NULL::integer AS activist_id,
    NULL::character varying AS email,
    NULL::character varying AS name,
    NULL::bigint AS total_form_entries;


ALTER TABLE public.agg_activists OWNER TO reboo;

--
-- TOC entry 277 (class 1259 OID 49335)
-- Name: balance_operations_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.balance_operations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.balance_operations_id_seq OWNER TO reboo;

--
-- TOC entry 4786 (class 0 OID 0)
-- Dependencies: 277
-- Name: balance_operations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.balance_operations_id_seq OWNED BY public.balance_operations.id;


--
-- TOC entry 206 (class 1259 OID 16553)
-- Name: blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.blocks_id_seq OWNER TO reboo;

--
-- TOC entry 4787 (class 0 OID 0)
-- Dependencies: 206
-- Name: blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.blocks_id_seq OWNED BY public.blocks.id;


--
-- TOC entry 317 (class 1259 OID 103368)
-- Name: certificates_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.certificates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.certificates_id_seq OWNER TO reboo;

--
-- TOC entry 4788 (class 0 OID 0)
-- Dependencies: 317
-- Name: certificates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.certificates_id_seq OWNED BY public.certificates.id;


--
-- TOC entry 338 (class 1259 OID 396310)
-- Name: chatbot_campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.chatbot_campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chatbot_campaigns_id_seq OWNER TO reboo;

--
-- TOC entry 339 (class 1259 OID 396312)
-- Name: chatbot_campaigns; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.chatbot_campaigns (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.chatbot_campaigns_id_seq'::regclass) NOT NULL,
    name character varying NOT NULL,
    diagram jsonb,
    chatbot_id integer NOT NULL,
    status text,
    get_started boolean DEFAULT false
);


ALTER TABLE public.chatbot_campaigns OWNER TO reboo;

--
-- TOC entry 4789 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE chatbot_campaigns; Type: COMMENT; Schema: public; Owner: reboo
--

COMMENT ON TABLE public.chatbot_campaigns IS 'Tabela responsável por armazenar fluxos de conversa de um Chatbot';


--
-- TOC entry 348 (class 1259 OID 419216)
-- Name: chatbot_interactions_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.chatbot_interactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chatbot_interactions_id_seq OWNER TO reboo;

--
-- TOC entry 349 (class 1259 OID 419218)
-- Name: chatbot_interactions; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.chatbot_interactions (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.chatbot_interactions_id_seq'::regclass) NOT NULL,
    interaction jsonb NOT NULL,
    chatbot_id integer NOT NULL,
    context_recipient_id text NOT NULL,
    context_sender_id text NOT NULL
);


ALTER TABLE public.chatbot_interactions OWNER TO reboo;

--
-- TOC entry 4790 (class 0 OID 0)
-- Dependencies: 349
-- Name: TABLE chatbot_interactions; Type: COMMENT; Schema: public; Owner: reboo
--

COMMENT ON TABLE public.chatbot_interactions IS 'Tabela responsável por contextualizar interações entre o bot e o usuário';


--
-- TOC entry 340 (class 1259 OID 396332)
-- Name: chatbot_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.chatbot_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chatbot_settings_id_seq OWNER TO reboo;

--
-- TOC entry 341 (class 1259 OID 396334)
-- Name: chatbot_settings; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.chatbot_settings (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.chatbot_settings_id_seq'::regclass) NOT NULL,
    channel text NOT NULL,
    settings jsonb NOT NULL,
    chatbot_id integer NOT NULL
);


ALTER TABLE public.chatbot_settings OWNER TO reboo;

--
-- TOC entry 4791 (class 0 OID 0)
-- Dependencies: 341
-- Name: TABLE chatbot_settings; Type: COMMENT; Schema: public; Owner: reboo
--

COMMENT ON TABLE public.chatbot_settings IS 'Tabela responsável por armazenar as configurações dos canais usados para comunicação de um Chatbot';


--
-- TOC entry 336 (class 1259 OID 396291)
-- Name: chatbots_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.chatbots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chatbots_id_seq OWNER TO reboo;

--
-- TOC entry 337 (class 1259 OID 396293)
-- Name: chatbots; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.chatbots (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.chatbots_id_seq'::regclass) NOT NULL,
    name text NOT NULL,
    community_id integer NOT NULL,
    persistent_menu jsonb
);


ALTER TABLE public.chatbots OWNER TO reboo;

--
-- TOC entry 4792 (class 0 OID 0)
-- Dependencies: 337
-- Name: TABLE chatbots; Type: COMMENT; Schema: public; Owner: reboo
--

COMMENT ON TABLE public.chatbots IS 'Tabela responsável por relacionar módulo Chatbot com módulo Comunidade';


--
-- TOC entry 216 (class 1259 OID 16594)
-- Name: communities_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.communities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.communities_id_seq OWNER TO reboo;

--
-- TOC entry 4793 (class 0 OID 0)
-- Dependencies: 216
-- Name: communities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.communities_id_seq OWNED BY public.communities.id;


--
-- TOC entry 301 (class 1259 OID 53291)
-- Name: community_activists_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.community_activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.community_activists_id_seq OWNER TO reboo;

--
-- TOC entry 4795 (class 0 OID 0)
-- Dependencies: 301
-- Name: community_activists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.community_activists_id_seq OWNED BY public.community_activists.id;


--
-- TOC entry 369 (class 1259 OID 7809896)
-- Name: community_settings; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.community_settings (
    id bigint NOT NULL,
    name character varying NOT NULL,
    settings json,
    version integer DEFAULT 1 NOT NULL,
    community_id bigint NOT NULL
);


ALTER TABLE public.community_settings OWNER TO reboo;

--
-- TOC entry 240 (class 1259 OID 28940)
-- Name: community_users_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.community_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.community_users_id_seq OWNER TO reboo;

--
-- TOC entry 4797 (class 0 OID 0)
-- Dependencies: 240
-- Name: community_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.community_users_id_seq OWNED BY public.community_users.id;


--
-- TOC entry 328 (class 1259 OID 148841)
-- Name: configurations; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.configurations (
    id integer NOT NULL,
    name character varying NOT NULL,
    value text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.configurations OWNER TO reboo;

--
-- TOC entry 327 (class 1259 OID 148839)
-- Name: configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.configurations_id_seq OWNER TO reboo;

--
-- TOC entry 4800 (class 0 OID 0)
-- Dependencies: 327
-- Name: configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.configurations_id_seq OWNED BY public.configurations.id;


--
-- TOC entry 207 (class 1259 OID 16555)
-- Name: credit_cards; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.credit_cards (
    id integer NOT NULL,
    activist_id integer,
    last_digits character varying,
    card_brand character varying,
    card_id character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    expiration_date character varying
);


ALTER TABLE public.credit_cards OWNER TO reboo;

--
-- TOC entry 208 (class 1259 OID 16561)
-- Name: credit_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.credit_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.credit_cards_id_seq OWNER TO reboo;

--
-- TOC entry 4801 (class 0 OID 0)
-- Dependencies: 208
-- Name: credit_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.credit_cards_id_seq OWNED BY public.credit_cards.id;


--
-- TOC entry 253 (class 1259 OID 33293)
-- Name: dns_hosted_zones_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.dns_hosted_zones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dns_hosted_zones_id_seq OWNER TO reboo;

--
-- TOC entry 4802 (class 0 OID 0)
-- Dependencies: 253
-- Name: dns_hosted_zones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.dns_hosted_zones_id_seq OWNED BY public.dns_hosted_zones.id;


--
-- TOC entry 256 (class 1259 OID 33312)
-- Name: dns_records; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.dns_records (
    id integer NOT NULL,
    dns_hosted_zone_id integer,
    name character varying,
    record_type character varying,
    value text,
    ttl integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    comment character varying
);


ALTER TABLE public.dns_records OWNER TO reboo;

--
-- TOC entry 255 (class 1259 OID 33310)
-- Name: dns_records_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.dns_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dns_records_id_seq OWNER TO reboo;

--
-- TOC entry 4805 (class 0 OID 0)
-- Dependencies: 255
-- Name: dns_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.dns_records_id_seq OWNED BY public.dns_records.id;


--
-- TOC entry 377 (class 1259 OID 18555337)
-- Name: donation_reports; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.donation_reports AS
 SELECT m.id AS mobilization_id,
    w.id AS widget_id,
    c.id AS community_id,
    d.id,
    d.transaction_id,
    d.transaction_status AS status,
    to_char(d.created_at, 'dd/mm/YYYY'::text) AS data,
    COALESCE((d.customer OPERATOR(public.->) 'name'::text), (a.name)::text) AS nome,
    d.email,
    d.payment_method AS "cartao/boleto",
        CASE
            WHEN (d.subscription OR (d.local_subscription_id IS NOT NULL)) THEN 'Sim'::text
            ELSE 'Não'::text
        END AS recorrente,
    (((d.amount)::numeric / 100.0))::double precision AS valor,
    pd.value_without_fee AS "valor garantido",
    to_char(((d.gateway_data ->> 'boleto_expiration_date'::text))::timestamp without time zone, 'dd/mm/YYYY'::text) AS "data vencimento boleto",
    recurrency_donation.count AS "recorrencia da doacao",
    recurrency_activist.count AS "recorrencia do ativista",
    (gs.status)::text AS subscription_status,
    pd.payable_date AS "data de recebimento"
   FROM (((((((((((public.donations d
     JOIN public.widgets w ON ((w.id = d.widget_id)))
     JOIN public.blocks b ON ((b.id = w.block_id)))
     JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
     JOIN public.communities c ON ((c.id = m.community_id)))
     LEFT JOIN public.subscriptions gs ON ((gs.id = d.local_subscription_id)))
     LEFT JOIN public.payable_details pd ON ((pd.donation_id = d.id)))
     LEFT JOIN public.activists a ON ((a.id = d.activist_id)))
     LEFT JOIN LATERAL ( SELECT (((btrim(btrim((d.customer OPERATOR(public.->) 'phone'::text)), '{}'::text))::public.hstore OPERATOR(public.->) 'ddd'::text) || ((btrim(btrim((d.customer OPERATOR(public.->) 'phone'::text)), '{}'::text))::public.hstore OPERATOR(public.->) 'number'::text)) AS number) customer_phone ON (true))
     LEFT JOIN LATERAL ( SELECT (((btrim((a.phone)::text, '{}'::text))::public.hstore OPERATOR(public.->) 'ddd'::text) || ((btrim((a.phone)::text, '{}'::text))::public.hstore OPERATOR(public.->) 'number'::text)) AS number) activist_phone ON (true))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM public.donations d2
          WHERE ((d2.local_subscription_id IS NOT NULL) AND (d2.local_subscription_id = d.local_subscription_id))) recurrency_donation ON (true))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM public.donations d2
          WHERE ((d2.activist_id = d.activist_id) AND (d2.cached_community_id = d.cached_community_id) AND (d.activist_id IS NOT NULL))) recurrency_activist ON (true))
  WHERE (d.transaction_id IS NOT NULL);


ALTER TABLE public.donation_reports OWNER TO reboo;

--
-- TOC entry 324 (class 1259 OID 144839)
-- Name: donation_reports_2; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.donation_reports_2 AS
 SELECT m.id AS mobilization_id,
    w.id AS widget_id,
    c.id AS community_id,
    d.id,
    d.transaction_id,
    d.transaction_status AS status,
    to_char(d.created_at, 'dd/mm/YYYY'::text) AS data,
    COALESCE((d.customer OPERATOR(public.->) 'name'::text), (a.name)::text) AS nome,
    d.email,
    COALESCE(customer_phone.number, activist_phone.number) AS telefone,
    d.payment_method AS "cartao/boleto",
        CASE
            WHEN (d.subscription OR (d.local_subscription_id IS NOT NULL)) THEN 'Sim'::text
            ELSE 'Não'::text
        END AS recorrente,
    (((d.amount)::numeric / 100.0))::double precision AS valor,
    pd.value_without_fee AS "valor garantido",
    to_char(((d.gateway_data ->> 'boleto_expiration_date'::text))::timestamp without time zone, 'dd/mm/YYYY'::text) AS "data vencimento boleto",
    recurrency_donation.count AS "recorrencia da doacao",
    recurrency_activist.count AS "recorrencia do ativista",
    (gs.status)::text AS subscription_status,
    pd.payable_date AS "data de recebimento"
   FROM (((((((((((public.donations d
     JOIN public.widgets w ON ((w.id = d.widget_id)))
     JOIN public.blocks b ON ((b.id = w.block_id)))
     JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
     JOIN public.communities c ON ((c.id = m.community_id)))
     LEFT JOIN public.subscriptions gs ON ((gs.id = d.local_subscription_id)))
     LEFT JOIN public.payable_details pd ON ((pd.donation_id = d.id)))
     LEFT JOIN public.activists a ON ((a.id = d.activist_id)))
     LEFT JOIN LATERAL ( SELECT (((btrim(btrim((d.customer OPERATOR(public.->) 'phone'::text)), '{}'::text))::public.hstore OPERATOR(public.->) 'ddd'::text) || ((btrim(btrim((d.customer OPERATOR(public.->) 'phone'::text)), '{}'::text))::public.hstore OPERATOR(public.->) 'number'::text)) AS number) customer_phone ON (true))
     LEFT JOIN LATERAL ( SELECT (((btrim((a.phone)::text, '{}'::text))::public.hstore OPERATOR(public.->) 'ddd'::text) || ((btrim((a.phone)::text, '{}'::text))::public.hstore OPERATOR(public.->) 'number'::text)) AS number) activist_phone ON (true))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM public.donations d2
          WHERE ((d2.local_subscription_id IS NOT NULL) AND (d2.local_subscription_id = d.local_subscription_id))) recurrency_donation ON (true))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM public.donations d2
          WHERE ((d2.activist_id = d.activist_id) AND (d.activist_id IS NOT NULL))) recurrency_activist ON (true))
  WHERE (d.transaction_id IS NOT NULL);


ALTER TABLE public.donation_reports_2 OWNER TO reboo;

--
-- TOC entry 269 (class 1259 OID 46570)
-- Name: donation_transitions; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.donation_transitions (
    id integer NOT NULL,
    to_state character varying NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb,
    sort_key integer NOT NULL,
    donation_id integer NOT NULL,
    most_recent boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.donation_transitions OWNER TO reboo;

--
-- TOC entry 268 (class 1259 OID 46568)
-- Name: donation_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.donation_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.donation_transitions_id_seq OWNER TO reboo;

--
-- TOC entry 4807 (class 0 OID 0)
-- Dependencies: 268
-- Name: donation_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.donation_transitions_id_seq OWNED BY public.donation_transitions.id;


--
-- TOC entry 210 (class 1259 OID 16570)
-- Name: donations_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.donations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.donations_id_seq OWNER TO reboo;

--
-- TOC entry 4808 (class 0 OID 0)
-- Dependencies: 210
-- Name: donations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.donations_id_seq OWNED BY public.donations.id;


--
-- TOC entry 379 (class 1259 OID 18590335)
-- Name: donations_lgpd; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.donations_lgpd AS
 SELECT donations.id,
    donations.widget_id,
    donations.created_at,
    donations.updated_at,
    donations.payment_method,
    donations.amount,
    donations.skip,
    donations.transaction_id,
    donations.transaction_status,
    donations.subscription,
    donations.activist_id,
    donations.subscription_id,
    donations.period,
    donations.plan_id,
    donations.parent_id,
    donations.payable_transfer_id,
    donations.synchronized,
    donations.local_subscription_id,
    donations.mailchimp_syncronization_at,
    donations.mailchimp_syncronization_error_reason,
    donations.cached_community_id,
    donations.mobilization_id
   FROM public.donations;


ALTER TABLE public.donations_lgpd OWNER TO reboo;

--
-- TOC entry 309 (class 1259 OID 56098)
-- Name: facebook_bot_activists; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.facebook_bot_activists (
    id integer NOT NULL,
    fb_context_recipient_id text NOT NULL,
    fb_context_sender_id text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    messages tsvector,
    quick_replies text[] DEFAULT '{}'::text[],
    interaction_dates timestamp without time zone[] DEFAULT '{}'::timestamp without time zone[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.facebook_bot_activists OWNER TO reboo;

--
-- TOC entry 308 (class 1259 OID 56096)
-- Name: facebook_bot_activists_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.facebook_bot_activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.facebook_bot_activists_id_seq OWNER TO reboo;

--
-- TOC entry 4810 (class 0 OID 0)
-- Dependencies: 308
-- Name: facebook_bot_activists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.facebook_bot_activists_id_seq OWNED BY public.facebook_bot_activists.id;


--
-- TOC entry 313 (class 1259 OID 71174)
-- Name: facebook_bot_campaign_activists_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.facebook_bot_campaign_activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.facebook_bot_campaign_activists_id_seq OWNER TO reboo;

--
-- TOC entry 4812 (class 0 OID 0)
-- Dependencies: 313
-- Name: facebook_bot_campaign_activists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.facebook_bot_campaign_activists_id_seq OWNED BY public.facebook_bot_campaign_activists.id;


--
-- TOC entry 311 (class 1259 OID 71157)
-- Name: facebook_bot_campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.facebook_bot_campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.facebook_bot_campaigns_id_seq OWNER TO reboo;

--
-- TOC entry 4814 (class 0 OID 0)
-- Dependencies: 311
-- Name: facebook_bot_campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.facebook_bot_campaigns_id_seq OWNED BY public.facebook_bot_campaigns.id;


--
-- TOC entry 279 (class 1259 OID 49354)
-- Name: facebook_bot_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.facebook_bot_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.facebook_bot_configurations_id_seq OWNER TO reboo;

--
-- TOC entry 4816 (class 0 OID 0)
-- Dependencies: 279
-- Name: facebook_bot_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.facebook_bot_configurations_id_seq OWNED BY public.facebook_bot_configurations.id;


--
-- TOC entry 242 (class 1259 OID 30466)
-- Name: first_email_ids_activists; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.first_email_ids_activists AS
 SELECT min(activists.id) AS min_id,
    lower((activists.email)::text) AS email,
    array_agg(activists.id) AS ids
   FROM public.activists
  GROUP BY activists.email;


ALTER TABLE public.first_email_ids_activists OWNER TO reboo;

--
-- TOC entry 212 (class 1259 OID 16578)
-- Name: form_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.form_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.form_entries_id_seq OWNER TO reboo;

--
-- TOC entry 4818 (class 0 OID 0)
-- Dependencies: 212
-- Name: form_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.form_entries_id_seq OWNED BY public.form_entries.id;


--
-- TOC entry 246 (class 1259 OID 32694)
-- Name: gateway_subscriptions; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.gateway_subscriptions (
    id integer NOT NULL,
    subscription_id integer,
    gateway_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.gateway_subscriptions OWNER TO reboo;

--
-- TOC entry 245 (class 1259 OID 32692)
-- Name: gateway_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.gateway_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gateway_subscriptions_id_seq OWNER TO reboo;

--
-- TOC entry 4819 (class 0 OID 0)
-- Dependencies: 245
-- Name: gateway_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.gateway_subscriptions_id_seq OWNED BY public.gateway_subscriptions.id;


--
-- TOC entry 266 (class 1259 OID 38649)
-- Name: gateway_transactions; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.gateway_transactions (
    id integer NOT NULL,
    transaction_id text,
    gateway_data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.gateway_transactions OWNER TO reboo;

--
-- TOC entry 265 (class 1259 OID 38647)
-- Name: gateway_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.gateway_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gateway_transactions_id_seq OWNER TO reboo;

--
-- TOC entry 4820 (class 0 OID 0)
-- Dependencies: 265
-- Name: gateway_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.gateway_transactions_id_seq OWNED BY public.gateway_transactions.id;


--
-- TOC entry 271 (class 1259 OID 47801)
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invitations_id_seq OWNER TO reboo;

--
-- TOC entry 4821 (class 0 OID 0)
-- Dependencies: 271
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.invitations_id_seq OWNED BY public.invitations.id;


--
-- TOC entry 227 (class 1259 OID 16866)
-- Name: matches; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.matches (
    id integer NOT NULL,
    widget_id integer,
    first_choice character varying,
    second_choice character varying,
    goal_image character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.matches OWNER TO reboo;

--
-- TOC entry 226 (class 1259 OID 16864)
-- Name: matches_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.matches_id_seq OWNER TO reboo;

--
-- TOC entry 4822 (class 0 OID 0)
-- Dependencies: 226
-- Name: matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.matches_id_seq OWNED BY public.matches.id;


--
-- TOC entry 303 (class 1259 OID 53315)
-- Name: mobilization_activists_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.mobilization_activists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mobilization_activists_id_seq OWNER TO reboo;

--
-- TOC entry 4823 (class 0 OID 0)
-- Dependencies: 303
-- Name: mobilization_activists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.mobilization_activists_id_seq OWNED BY public.mobilization_activists.id;


--
-- TOC entry 214 (class 1259 OID 16586)
-- Name: mobilizations_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.mobilizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mobilizations_id_seq OWNER TO reboo;

--
-- TOC entry 4824 (class 0 OID 0)
-- Dependencies: 214
-- Name: mobilizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.mobilizations_id_seq OWNED BY public.mobilizations.id;


--
-- TOC entry 257 (class 1259 OID 33327)
-- Name: notification_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.notification_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_templates_id_seq OWNER TO reboo;

--
-- TOC entry 4825 (class 0 OID 0)
-- Dependencies: 257
-- Name: notification_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.notification_templates_id_seq OWNED BY public.notification_templates.id;


--
-- TOC entry 259 (class 1259 OID 33343)
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO reboo;

--
-- TOC entry 4826 (class 0 OID 0)
-- Dependencies: 259
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- TOC entry 350 (class 1259 OID 419244)
-- Name: notify_mail_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.notify_mail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notify_mail_id_seq OWNER TO reboo;

--
-- TOC entry 323 (class 1259 OID 113861)
-- Name: payable_details_2; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.payable_details_2 AS
 SELECT o.id AS community_id,
    d.widget_id,
    m.id AS mobilization_id,
    b.id AS block_id,
    d.id AS donation_id,
    d.subscription_id,
    d.transaction_id,
    (dd.value ->> 'id'::text) AS payable_id,
    (((d.amount)::numeric / 100.0))::double precision AS donation_value,
        CASE
            WHEN (jsonb_array_length(d.payables) = 1) THEN ((((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision) - ((((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision) * (0.13)::double precision))
            ELSE (((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision)
        END AS payable_value,
    (payable_summary.payable_fee)::double precision AS payable_pagarme_fee,
        CASE
            WHEN (jsonb_array_length(d.payables) > 1) THEN nossas_tx.amount
            ELSE ((((d.amount)::numeric / 100.0) * 0.13))::double precision
        END AS nossas_fee,
    nossas_tx.percent AS percent_tx,
        CASE
            WHEN (jsonb_array_length(d.payables) > 1) THEN ((((dd.value ->> 'amount'::text))::double precision / (100.0)::double precision) - (payable_summary.payable_fee)::double precision)
            ELSE ((((d.amount)::numeric / 100.0))::double precision - ((((d.amount)::numeric / 100.0) * 0.13))::double precision)
        END AS value_without_fee,
    ((dd.value ->> 'date_created'::text))::timestamp without time zone AS payment_date,
    ((dd.value ->> 'payment_date'::text))::timestamp without time zone AS payable_date,
    d.transaction_status AS pagarme_status,
    (dd.value ->> 'status'::text) AS payable_status,
    d.payment_method,
    customer.name,
    customer.email,
    pt.id AS payable_transfer_id,
    pt.transfer_data,
    d.gateway_data,
    d.subscription AS is_subscription,
    (dd.value ->> 'recipient_id'::text) AS recipient_id,
    d.local_subscription_id
   FROM (((((((((public.communities o
     JOIN public.donations d ON (((d.cached_community_id = o.id) AND ((d.transaction_status)::text = 'paid'::text))))
     LEFT JOIN public.widgets w ON ((w.id = d.widget_id)))
     LEFT JOIN public.blocks b ON ((b.id = w.block_id)))
     LEFT JOIN public.mobilizations m ON ((m.id = b.mobilization_id)))
     LEFT JOIN public.payable_transfers pt ON ((pt.id = d.payable_transfer_id)))
     LEFT JOIN LATERAL ( SELECT COALESCE((d2.customer OPERATOR(public.->) 'name'::text), (d.customer OPERATOR(public.->) 'name'::text)) AS name,
            COALESCE((d2.customer OPERATOR(public.->) 'email'::text), (d.customer OPERATOR(public.->) 'email'::text)) AS email
           FROM public.donations d2
          WHERE
                CASE
                    WHEN (d.parent_id IS NULL) THEN (d2.id = d.id)
                    ELSE (d2.id = d.parent_id)
                END) customer ON (true))
     LEFT JOIN LATERAL ( SELECT data.value
           FROM jsonb_array_elements(d.payables) data(value)) dd ON (true))
     LEFT JOIN LATERAL ( SELECT (((jsonb_array_elements.value ->> 'amount'::text))::double precision / (100.0)::double precision) AS amount,
            ((((jsonb_array_elements.value ->> 'amount'::text))::double precision / (d.amount)::double precision) * (100.0)::double precision) AS percent
           FROM jsonb_array_elements(d.payables) jsonb_array_elements(value)
          WHERE ((jsonb_array_elements.value ->> 'recipient_id'::text) = public.nossas_recipient_id())) nossas_tx ON (true))
     LEFT JOIN LATERAL ( SELECT td.amount,
            td.payable_fee,
            td.transaction_cost,
            (td.amount - td.payable_fee) AS value_without_fee
           FROM ( SELECT ((((dd.value ->> 'amount'::text))::integer)::numeric / 100.0) AS amount,
                    ((((dd.value ->> 'fee'::text))::integer)::numeric / 100.0) AS payable_fee,
                    ((((d.gateway_data ->> 'cost'::text))::integer)::numeric / 100.0) AS transaction_cost) td) payable_summary ON (true))
  WHERE ((((dd.value ->> 'type'::text) = 'credit'::text) AND ((dd.value ->> 'object'::text) = 'payable'::text) AND ((dd.value ->> 'recipient_id'::text) IN ( SELECT (r.pagarme_recipient_id)::text AS pagarme_recipient_id
           FROM public.recipients r
          WHERE (r.community_id = o.id)))) OR (jsonb_array_length(d.payables) = 1));


ALTER TABLE public.payable_details_2 OWNER TO reboo;

--
-- TOC entry 232 (class 1259 OID 17729)
-- Name: payable_transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.payable_transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payable_transfers_id_seq OWNER TO reboo;

--
-- TOC entry 4828 (class 0 OID 0)
-- Dependencies: 232
-- Name: payable_transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.payable_transfers_id_seq OWNED BY public.payable_transfers.id;


--
-- TOC entry 217 (class 1259 OID 16596)
-- Name: payments; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    transaction_status character varying,
    transaction_id character varying,
    plan_id integer,
    donation_id integer,
    subscription_id character varying,
    activist_id integer,
    address_id integer,
    credit_card_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.payments OWNER TO reboo;

--
-- TOC entry 218 (class 1259 OID 16602)
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO reboo;

--
-- TOC entry 4829 (class 0 OID 0)
-- Dependencies: 218
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- TOC entry 219 (class 1259 OID 16604)
-- Name: plans; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.plans (
    id integer NOT NULL,
    plan_id character varying,
    name character varying,
    amount integer,
    days integer,
    payment_methods text[] DEFAULT '{credit_card,boleto}'::text[],
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.plans OWNER TO reboo;

--
-- TOC entry 220 (class 1259 OID 16611)
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plans_id_seq OWNER TO reboo;

--
-- TOC entry 4831 (class 0 OID 0)
-- Dependencies: 220
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.plans_id_seq OWNED BY public.plans.id;


--
-- TOC entry 376 (class 1259 OID 18282045)
-- Name: pressure_targets_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.pressure_targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pressure_targets_id_seq OWNER TO reboo;

--
-- TOC entry 375 (class 1259 OID 18282030)
-- Name: pressure_targets; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.pressure_targets (
    id integer DEFAULT nextval('public.pressure_targets_id_seq'::regclass) NOT NULL,
    widget_id integer NOT NULL,
    targets jsonb,
    identify character varying NOT NULL,
    label character varying NOT NULL,
    email_subject character varying,
    email_body character varying,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.pressure_targets OWNER TO reboo;

--
-- TOC entry 243 (class 1259 OID 30706)
-- Name: recipients_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.recipients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recipients_id_seq OWNER TO reboo;

--
-- TOC entry 4832 (class 0 OID 0)
-- Dependencies: 243
-- Name: recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.recipients_id_seq OWNED BY public.recipients.id;


--
-- TOC entry 362 (class 1259 OID 2904856)
-- Name: rede_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.rede_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rede_groups_id_seq OWNER TO reboo;

--
-- TOC entry 363 (class 1259 OID 2904858)
-- Name: rede_groups; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.rede_groups (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.rede_groups_id_seq'::regclass) NOT NULL,
    name text NOT NULL,
    is_volunteer boolean DEFAULT false NOT NULL,
    community_id integer NOT NULL,
    widget_id integer NOT NULL,
    metadata jsonb NOT NULL,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.rede_groups OWNER TO reboo;

--
-- TOC entry 4833 (class 0 OID 0)
-- Dependencies: 363
-- Name: TABLE rede_groups; Type: COMMENT; Schema: public; Owner: reboo
--

COMMENT ON TABLE public.rede_groups IS 'Tabela responsável por relacionar módulo Rede com Comunidade e Widget';


--
-- TOC entry 364 (class 1259 OID 2904881)
-- Name: rede_individuals_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.rede_individuals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rede_individuals_id_seq OWNER TO reboo;

--
-- TOC entry 365 (class 1259 OID 2904883)
-- Name: rede_individuals; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.rede_individuals (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.rede_individuals_id_seq'::regclass) NOT NULL,
    email text NOT NULL,
    phone text NOT NULL,
    address text,
    city text,
    state text,
    whatsapp text NOT NULL,
    rede_group_id integer NOT NULL,
    form_entry_id integer NOT NULL,
    first_name character varying NOT NULL,
    coordinates jsonb,
    zipcode character varying(100) NOT NULL,
    status character varying DEFAULT 'inscrita'::character varying,
    availability character varying DEFAULT 'indisponível'::character varying,
    extras jsonb,
    last_name character varying
);


ALTER TABLE public.rede_individuals OWNER TO reboo;

--
-- TOC entry 4834 (class 0 OID 0)
-- Dependencies: 365
-- Name: TABLE rede_individuals; Type: COMMENT; Schema: public; Owner: reboo
--

COMMENT ON TABLE public.rede_individuals IS 'Tabela responsável por armazenar os indivíduos da rede separados por grupo';


--
-- TOC entry 366 (class 1259 OID 2904905)
-- Name: rede_relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.rede_relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rede_relationships_id_seq OWNER TO reboo;

--
-- TOC entry 367 (class 1259 OID 2904907)
-- Name: rede_relationships; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.rede_relationships (
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now(),
    id integer DEFAULT nextval('public.rede_relationships_id_seq'::regclass) NOT NULL,
    is_archived boolean DEFAULT false,
    comments text,
    status text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    metadata jsonb,
    volunteer_id integer NOT NULL,
    recipient_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.rede_relationships OWNER TO reboo;

--
-- TOC entry 4835 (class 0 OID 0)
-- Dependencies: 367
-- Name: TABLE rede_relationships; Type: COMMENT; Schema: public; Owner: reboo
--

COMMENT ON TABLE public.rede_relationships IS 'Tabela responsável por armazenar acompanhamento de um relacionamento seja com a inscrição na rede, seja entre voluntário e beneficiário.';


--
-- TOC entry 368 (class 1259 OID 2904936)
-- Name: rede_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.rede_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rede_settings_id_seq OWNER TO reboo;

--
-- TOC entry 221 (class 1259 OID 16613)
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO reboo;

--
-- TOC entry 347 (class 1259 OID 399450)
-- Name: schema_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.schema_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.schema_migrations_id_seq OWNER TO reboo;

--
-- TOC entry 4836 (class 0 OID 0)
-- Dependencies: 347
-- Name: schema_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.schema_migrations_id_seq OWNED BY public.schema_migrations.id;


--
-- TOC entry 356 (class 1259 OID 744595)
-- Name: solidarity_matches; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.solidarity_matches (
    id integer NOT NULL,
    individuals_ticket_id bigint,
    volunteers_ticket_id bigint,
    individuals_user_id bigint,
    volunteers_user_id bigint,
    community_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    status text
);


ALTER TABLE public.solidarity_matches OWNER TO reboo;

--
-- TOC entry 355 (class 1259 OID 744593)
-- Name: solidarity_matches_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.solidarity_matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.solidarity_matches_id_seq OWNER TO reboo;

--
-- TOC entry 4837 (class 0 OID 0)
-- Dependencies: 355
-- Name: solidarity_matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.solidarity_matches_id_seq OWNED BY public.solidarity_matches.id;


--
-- TOC entry 342 (class 1259 OID 396351)
-- Name: webhooks_registry_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.webhooks_registry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.webhooks_registry_id_seq OWNER TO reboo;

--
-- TOC entry 343 (class 1259 OID 396353)
-- Name: webhooks_registry; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.webhooks_registry (
    id integer DEFAULT nextval('public.webhooks_registry_id_seq'::regclass) NOT NULL,
    data jsonb NOT NULL,
    service_name character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.webhooks_registry OWNER TO reboo;

--
-- TOC entry 346 (class 1259 OID 399303)
-- Name: solidarity_mautic_form; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.solidarity_mautic_form AS
 SELECT (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'form'::text) -> 'name'::text) AS form_name,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'primeiro_nome'::text) AS name,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'sobrenome_completo'::text) AS firstname,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'email'::text) AS email,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'whatsapp_com_ddd'::text) AS whatsapp,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'telefone_de_atendimento_c'::text) AS phone,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'cep'::text) AS zip,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'cor'::text) AS color,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'qual_sua_area_de_atuacao'::text) AS occupation_area,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'insira_seu_numero_de_regi'::text) AS register_number,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'sendo_voluntaria_do_mapa'::text) AS attendance_availability,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'quantas_vezes_voce_ja_rec'::text) AS attendance_referrals,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'atualmente_quantas_mulher'::text) AS attendance_number,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'quanto_atendimentos_pelo'::text) AS attendance_completed,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'todos_os_atendimentos_rea'::text) AS guideline_expenses,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'as_voluntarias_do_mapa_do'::text) AS guideline_secrecy,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'o_comprometimento_a_dedic'::text) AS guideline_time_availability,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'o_mapa_do_acolhimento_ent'::text) AS guideline_support_help,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'para_que_as_mulheres_que'::text) AS guideline_termination_protocol,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'no_seu_primeiro_atendimen'::text) AS study_case_1,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'para_voce_o_que_e_mais_im'::text) AS study_case_2,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'durante_os_encontros_ana'::text) AS study_case_3,
    (((((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'submission'::text) -> 'results'::text) -> 'durante_os_atendimentos_a'::text) AS study_case_4,
    (((webhooks_registry.data -> 'mautic.form_on_submit'::text) -> 0) -> 'timestamp'::text) AS "timestamp"
   FROM public.webhooks_registry
  WHERE ((webhooks_registry.service_name)::text = 'mautic_form'::text);


ALTER TABLE public.solidarity_mautic_form OWNER TO reboo;

--
-- TOC entry 354 (class 1259 OID 744576)
-- Name: solidarity_tickets; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.solidarity_tickets (
    id integer NOT NULL,
    assignee_id bigint,
    created_at timestamp without time zone,
    custom_fields jsonb,
    description text,
    group_id bigint,
    ticket_id bigint NOT NULL,
    organization_id bigint,
    raw_subject text,
    requester_id bigint,
    status text,
    subject text,
    submitter_id bigint,
    tags jsonb,
    updated_at timestamp without time zone,
    status_acolhimento text,
    nome_voluntaria text,
    link_match text,
    nome_msr text,
    data_inscricao_bonde text,
    data_encaminhamento text,
    status_inscricao text,
    telefone text,
    estado text,
    cidade text,
    community_id integer,
    external_id bigint,
    atrelado_ao_ticket bigint,
    match_syncronized boolean DEFAULT true NOT NULL
);


ALTER TABLE public.solidarity_tickets OWNER TO reboo;

--
-- TOC entry 353 (class 1259 OID 744574)
-- Name: solidarity_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.solidarity_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.solidarity_tickets_id_seq OWNER TO reboo;

--
-- TOC entry 4838 (class 0 OID 0)
-- Dependencies: 353
-- Name: solidarity_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.solidarity_tickets_id_seq OWNED BY public.solidarity_tickets.id;


--
-- TOC entry 352 (class 1259 OID 744547)
-- Name: solidarity_users; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.solidarity_users (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    url text,
    name text,
    email text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    time_zone text,
    iana_time_zone text,
    phone text,
    shared_phone_number boolean,
    photo jsonb,
    locale_id bigint,
    locale text,
    organization_id bigint,
    role text,
    verified boolean,
    external_id bigint,
    tags jsonb,
    alias text,
    active boolean,
    shared boolean,
    shared_agent boolean,
    last_login_at timestamp without time zone,
    two_factor_auth_enabled boolean,
    signature text,
    details text,
    notes text,
    role_type bigint,
    custom_role_id bigint,
    moderator boolean,
    ticket_restriction text,
    only_private_comments boolean,
    restricted_agent boolean,
    suspended boolean,
    chat_only boolean,
    default_group_id bigint,
    report_csv boolean,
    user_fields jsonb,
    address text,
    atendimentos_concludos_calculado_ bigint,
    atendimentos_concluidos bigint,
    atendimentos_em_andamento bigint,
    atendimentos_em_andamento_calculado_ bigint,
    cep text,
    city text,
    condition text,
    cor text,
    data_de_inscricao_no_bonde timestamp without time zone,
    disponibilidade_de_atendimentos text,
    encaminhamentos bigint,
    encaminhamentos_realizados_calculado_ bigint,
    latitude text,
    longitude text,
    occupation_area text,
    registration_number text,
    state text,
    tipo_de_acolhimento text,
    ultima_atualizacao_de_dados timestamp without time zone,
    whatsapp text,
    permanently_deleted boolean,
    community_id integer
);


ALTER TABLE public.solidarity_users OWNER TO reboo;

--
-- TOC entry 351 (class 1259 OID 744545)
-- Name: solidarity_users_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.solidarity_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.solidarity_users_id_seq OWNER TO reboo;

--
-- TOC entry 4839 (class 0 OID 0)
-- Dependencies: 351
-- Name: solidarity_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.solidarity_users_id_seq OWNED BY public.solidarity_users.id;


--
-- TOC entry 345 (class 1259 OID 396375)
-- Name: solidarity_zd_tickets; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.solidarity_zd_tickets (
    id integer NOT NULL,
    assignee_id bigint,
    created_at timestamp without time zone,
    custom_fields jsonb,
    description text,
    group_id bigint,
    ticket_id bigint NOT NULL,
    organization_id bigint,
    raw_subject text,
    requester_id bigint,
    status text,
    subject text,
    submitter_id bigint,
    tags jsonb,
    updated_at timestamp without time zone,
    status_acolhimento text,
    nome_voluntaria text,
    link_match text,
    nome_msr text,
    data_inscricao_bonde timestamp without time zone,
    data_encaminhamento timestamp without time zone,
    status_inscricao text,
    telefone text,
    estado text,
    cidade text,
    community_id bigint
);


ALTER TABLE public.solidarity_zd_tickets OWNER TO reboo;

--
-- TOC entry 344 (class 1259 OID 396373)
-- Name: solidarity_zd_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.solidarity_zd_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.solidarity_zd_tickets_id_seq OWNER TO reboo;

--
-- TOC entry 4840 (class 0 OID 0)
-- Dependencies: 344
-- Name: solidarity_zd_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.solidarity_zd_tickets_id_seq OWNED BY public.solidarity_zd_tickets.id;


--
-- TOC entry 264 (class 1259 OID 34654)
-- Name: subscription_transitions; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.subscription_transitions (
    id integer NOT NULL,
    to_state character varying NOT NULL,
    metadata json DEFAULT '{}'::json,
    sort_key integer NOT NULL,
    subscription_id integer NOT NULL,
    most_recent boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.subscription_transitions OWNER TO reboo;

--
-- TOC entry 332 (class 1259 OID 174286)
-- Name: subscription_reports; Type: VIEW; Schema: public; Owner: reboo
--

CREATE VIEW public.subscription_reports AS
 SELECT s.community_id,
    a.name AS "Nome do doador",
    a.email AS "Email do doador",
    (((s.amount)::numeric / 100.0))::numeric(13,2) AS "Valor de doação",
    s.status AS "Status de assinatura",
    s.payment_method AS "Forma de doação (boleto/cartão)",
    s.id AS "ID da assinatura",
    s.created_at AS "Data de início da assinatura",
        CASE
            WHEN ((s.status)::text = 'canceled'::text) THEN ct.created_at
            ELSE NULL::timestamp without time zone
        END AS "Data do cancelamento da assinatura",
        CASE
            WHEN ((s.status)::text = 'unpaid'::text) THEN
            CASE
                WHEN public.receiving_unpaid_notifications(s.*) THEN 'Sim'::text
                ELSE 'Não'::text
            END
            ELSE NULL::text
        END AS "recebendo notificações?",
    ((('https://app.bonde.org/subscriptions/'::text || s.id) || '/edit?token='::text) || s.token) AS "Link de alteração da assinatura"
   FROM (((public.subscriptions s
     JOIN public.activists a ON ((a.id = s.activist_id)))
     LEFT JOIN LATERAL ( SELECT st.id,
            st.to_state,
            st.metadata,
            st.sort_key,
            st.subscription_id,
            st.most_recent,
            st.created_at,
            st.updated_at
           FROM public.subscription_transitions st
          WHERE ((st.subscription_id = s.id) AND ((st.to_state)::text = 'canceled'::text))
          ORDER BY st.created_at DESC
         LIMIT 1) ct ON (true))
     LEFT JOIN LATERAL ( SELECT n.id,
            n.activist_id,
            n.notification_template_id,
            n.template_vars,
            n.created_at,
            n.updated_at,
            n.community_id,
            n.user_id,
            n.email,
            n.deliver_at,
            n.delivered_at
           FROM (public.notifications n
             JOIN public.notification_templates nt ON ((nt.id = n.notification_template_id)))
          WHERE ((nt.label = 'unpaid_subscription'::text) AND (((n.template_vars ->> 'subscription_id'::text))::integer = s.id))
          ORDER BY n.created_at DESC
         LIMIT 1) last_unpaid_notification ON (true));


ALTER TABLE public.subscription_reports OWNER TO reboo;

--
-- TOC entry 263 (class 1259 OID 34652)
-- Name: subscription_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.subscription_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscription_transitions_id_seq OWNER TO reboo;

--
-- TOC entry 4841 (class 0 OID 0)
-- Dependencies: 263
-- Name: subscription_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.subscription_transitions_id_seq OWNED BY public.subscription_transitions.id;


--
-- TOC entry 261 (class 1259 OID 34617)
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscriptions_id_seq OWNER TO reboo;

--
-- TOC entry 4842 (class 0 OID 0)
-- Dependencies: 261
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- TOC entry 249 (class 1259 OID 33242)
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taggings_id_seq OWNER TO reboo;

--
-- TOC entry 4843 (class 0 OID 0)
-- Dependencies: 249
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.taggings_id_seq OWNED BY public.taggings.id;


--
-- TOC entry 247 (class 1259 OID 33231)
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO reboo;

--
-- TOC entry 4845 (class 0 OID 0)
-- Dependencies: 247
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- TOC entry 237 (class 1259 OID 19922)
-- Name: template_blocks; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.template_blocks (
    id integer NOT NULL,
    template_mobilization_id integer,
    bg_class character varying,
    "position" integer,
    hidden boolean,
    bg_image text,
    name character varying,
    menu_hidden boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.template_blocks OWNER TO reboo;

--
-- TOC entry 236 (class 1259 OID 19920)
-- Name: template_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.template_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.template_blocks_id_seq OWNER TO reboo;

--
-- TOC entry 4847 (class 0 OID 0)
-- Dependencies: 236
-- Name: template_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.template_blocks_id_seq OWNED BY public.template_blocks.id;


--
-- TOC entry 234 (class 1259 OID 19909)
-- Name: template_mobilizations_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.template_mobilizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.template_mobilizations_id_seq OWNER TO reboo;

--
-- TOC entry 4848 (class 0 OID 0)
-- Dependencies: 234
-- Name: template_mobilizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.template_mobilizations_id_seq OWNED BY public.template_mobilizations.id;


--
-- TOC entry 239 (class 1259 OID 19933)
-- Name: template_widgets; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.template_widgets (
    id integer NOT NULL,
    template_block_id integer,
    settings public.hstore,
    kind character varying,
    sm_size integer,
    md_size integer,
    lg_size integer,
    mailchimp_segment_id character varying,
    action_community boolean,
    exported_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.template_widgets OWNER TO reboo;

--
-- TOC entry 238 (class 1259 OID 19931)
-- Name: template_widgets_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.template_widgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.template_widgets_id_seq OWNER TO reboo;

--
-- TOC entry 4849 (class 0 OID 0)
-- Dependencies: 238
-- Name: template_widgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.template_widgets_id_seq OWNED BY public.template_widgets.id;


--
-- TOC entry 294 (class 1259 OID 51934)
-- Name: twilio_call_transitions; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.twilio_call_transitions (
    id integer NOT NULL,
    twilio_account_sid text NOT NULL,
    twilio_call_sid text NOT NULL,
    twilio_parent_call_sid text,
    sequence_number integer NOT NULL,
    status text NOT NULL,
    called text NOT NULL,
    caller text NOT NULL,
    call_duration text,
    data text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.twilio_call_transitions OWNER TO reboo;

--
-- TOC entry 293 (class 1259 OID 51932)
-- Name: twilio_call_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.twilio_call_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.twilio_call_transitions_id_seq OWNER TO reboo;

--
-- TOC entry 4851 (class 0 OID 0)
-- Dependencies: 293
-- Name: twilio_call_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.twilio_call_transitions_id_seq OWNED BY public.twilio_call_transitions.id;


--
-- TOC entry 291 (class 1259 OID 51914)
-- Name: twilio_calls_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.twilio_calls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.twilio_calls_id_seq OWNER TO reboo;

--
-- TOC entry 4852 (class 0 OID 0)
-- Dependencies: 291
-- Name: twilio_calls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.twilio_calls_id_seq OWNED BY public.twilio_calls.id;


--
-- TOC entry 298 (class 1259 OID 51957)
-- Name: twilio_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.twilio_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.twilio_configurations_id_seq OWNER TO reboo;

--
-- TOC entry 4854 (class 0 OID 0)
-- Dependencies: 298
-- Name: twilio_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.twilio_configurations_id_seq OWNED BY public.twilio_configurations.id;


--
-- TOC entry 330 (class 1259 OID 174263)
-- Name: user_tags; Type: TABLE; Schema: public; Owner: reboo
--

CREATE TABLE public.user_tags (
    id integer NOT NULL,
    user_id integer,
    tag_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_tags OWNER TO reboo;

--
-- TOC entry 329 (class 1259 OID 174261)
-- Name: user_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.user_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_tags_id_seq OWNER TO reboo;

--
-- TOC entry 4857 (class 0 OID 0)
-- Dependencies: 329
-- Name: user_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.user_tags_id_seq OWNED BY public.user_tags.id;


--
-- TOC entry 223 (class 1259 OID 16628)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO reboo;

--
-- TOC entry 4859 (class 0 OID 0)
-- Dependencies: 223
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 225 (class 1259 OID 16637)
-- Name: widgets_id_seq; Type: SEQUENCE; Schema: public; Owner: reboo
--

CREATE SEQUENCE public.widgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.widgets_id_seq OWNER TO reboo;

--
-- TOC entry 4861 (class 0 OID 0)
-- Dependencies: 225
-- Name: widgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reboo
--

ALTER SEQUENCE public.widgets_id_seq OWNED BY public.widgets.id;


--
-- TOC entry 4068 (class 2604 OID 17025)
-- Name: activist_facebook_bot_interactions id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_facebook_bot_interactions ALTER COLUMN id SET DEFAULT nextval('public.activist_facebook_bot_interactions_id_seq'::regclass);


--
-- TOC entry 4022 (class 2604 OID 17026)
-- Name: activist_matches id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_matches ALTER COLUMN id SET DEFAULT nextval('public.activist_matches_id_seq'::regclass);


--
-- TOC entry 4023 (class 2604 OID 17027)
-- Name: activist_pressures id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_pressures ALTER COLUMN id SET DEFAULT nextval('public.activist_pressures_id_seq'::regclass);


--
-- TOC entry 4042 (class 2604 OID 17028)
-- Name: activist_tags id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_tags ALTER COLUMN id SET DEFAULT nextval('public.activist_tags_id_seq'::regclass);


--
-- TOC entry 3982 (class 2604 OID 17029)
-- Name: activists id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activists ALTER COLUMN id SET DEFAULT nextval('public.activists_id_seq'::regclass);


--
-- TOC entry 3985 (class 2604 OID 17030)
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- TOC entry 4065 (class 2604 OID 17031)
-- Name: balance_operations id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.balance_operations ALTER COLUMN id SET DEFAULT nextval('public.balance_operations_id_seq'::regclass);


--
-- TOC entry 3986 (class 2604 OID 17032)
-- Name: blocks id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.blocks ALTER COLUMN id SET DEFAULT nextval('public.blocks_id_seq'::regclass);


--
-- TOC entry 4083 (class 2604 OID 17033)
-- Name: certificates id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.certificates ALTER COLUMN id SET DEFAULT nextval('public.certificates_id_seq'::regclass);


--
-- TOC entry 4001 (class 2604 OID 17034)
-- Name: communities id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.communities ALTER COLUMN id SET DEFAULT nextval('public.communities_id_seq'::regclass);


--
-- TOC entry 4073 (class 2604 OID 17035)
-- Name: community_activists id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.community_activists ALTER COLUMN id SET DEFAULT nextval('public.community_activists_id_seq'::regclass);


--
-- TOC entry 4031 (class 2604 OID 17036)
-- Name: community_users id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.community_users ALTER COLUMN id SET DEFAULT nextval('public.community_users_id_seq'::regclass);


--
-- TOC entry 4084 (class 2604 OID 148844)
-- Name: configurations id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.configurations ALTER COLUMN id SET DEFAULT nextval('public.configurations_id_seq'::regclass);


--
-- TOC entry 3987 (class 2604 OID 17037)
-- Name: credit_cards id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.credit_cards ALTER COLUMN id SET DEFAULT nextval('public.credit_cards_id_seq'::regclass);


--
-- TOC entry 4043 (class 2604 OID 17038)
-- Name: dns_hosted_zones id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.dns_hosted_zones ALTER COLUMN id SET DEFAULT nextval('public.dns_hosted_zones_id_seq'::regclass);


--
-- TOC entry 4047 (class 2604 OID 17039)
-- Name: dns_records id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.dns_records ALTER COLUMN id SET DEFAULT nextval('public.dns_records_id_seq'::regclass);


--
-- TOC entry 4061 (class 2604 OID 17040)
-- Name: donation_transitions id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.donation_transitions ALTER COLUMN id SET DEFAULT nextval('public.donation_transitions_id_seq'::regclass);


--
-- TOC entry 3990 (class 2604 OID 17041)
-- Name: donations id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.donations ALTER COLUMN id SET DEFAULT nextval('public.donations_id_seq'::regclass);


--
-- TOC entry 4078 (class 2604 OID 17042)
-- Name: facebook_bot_activists id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.facebook_bot_activists ALTER COLUMN id SET DEFAULT nextval('public.facebook_bot_activists_id_seq'::regclass);


--
-- TOC entry 4082 (class 2604 OID 17043)
-- Name: facebook_bot_campaign_activists id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.facebook_bot_campaign_activists ALTER COLUMN id SET DEFAULT nextval('public.facebook_bot_campaign_activists_id_seq'::regclass);


--
-- TOC entry 4079 (class 2604 OID 17044)
-- Name: facebook_bot_campaigns id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.facebook_bot_campaigns ALTER COLUMN id SET DEFAULT nextval('public.facebook_bot_campaigns_id_seq'::regclass);


--
-- TOC entry 4067 (class 2604 OID 17045)
-- Name: facebook_bot_configurations id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.facebook_bot_configurations ALTER COLUMN id SET DEFAULT nextval('public.facebook_bot_configurations_id_seq'::regclass);


--
-- TOC entry 3993 (class 2604 OID 17046)
-- Name: form_entries id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.form_entries ALTER COLUMN id SET DEFAULT nextval('public.form_entries_id_seq'::regclass);


--
-- TOC entry 4038 (class 2604 OID 17047)
-- Name: gateway_subscriptions id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.gateway_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.gateway_subscriptions_id_seq'::regclass);


--
-- TOC entry 4059 (class 2604 OID 17048)
-- Name: gateway_transactions id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.gateway_transactions ALTER COLUMN id SET DEFAULT nextval('public.gateway_transactions_id_seq'::regclass);


--
-- TOC entry 4062 (class 2604 OID 17049)
-- Name: invitations id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.invitations ALTER COLUMN id SET DEFAULT nextval('public.invitations_id_seq'::regclass);


--
-- TOC entry 4021 (class 2604 OID 17050)
-- Name: matches id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.matches ALTER COLUMN id SET DEFAULT nextval('public.matches_id_seq'::regclass);


--
-- TOC entry 4074 (class 2604 OID 17051)
-- Name: mobilization_activists id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.mobilization_activists ALTER COLUMN id SET DEFAULT nextval('public.mobilization_activists_id_seq'::regclass);


--
-- TOC entry 3998 (class 2604 OID 17052)
-- Name: mobilizations id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.mobilizations ALTER COLUMN id SET DEFAULT nextval('public.mobilizations_id_seq'::regclass);


--
-- TOC entry 4050 (class 2604 OID 17053)
-- Name: notification_templates id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.notification_templates ALTER COLUMN id SET DEFAULT nextval('public.notification_templates_id_seq'::regclass);


--
-- TOC entry 4053 (class 2604 OID 17054)
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- TOC entry 4027 (class 2604 OID 17055)
-- Name: payable_transfers id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.payable_transfers ALTER COLUMN id SET DEFAULT nextval('public.payable_transfers_id_seq'::regclass);


--
-- TOC entry 4006 (class 2604 OID 17056)
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- TOC entry 4008 (class 2604 OID 17057)
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.plans ALTER COLUMN id SET DEFAULT nextval('public.plans_id_seq'::regclass);


--
-- TOC entry 4035 (class 2604 OID 17058)
-- Name: recipients id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.recipients ALTER COLUMN id SET DEFAULT nextval('public.recipients_id_seq'::regclass);


--
-- TOC entry 4009 (class 2604 OID 399452)
-- Name: schema_migrations id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.schema_migrations ALTER COLUMN id SET DEFAULT nextval('public.schema_migrations_id_seq'::regclass);


--
-- TOC entry 4110 (class 2604 OID 744598)
-- Name: solidarity_matches id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_matches ALTER COLUMN id SET DEFAULT nextval('public.solidarity_matches_id_seq'::regclass);


--
-- TOC entry 4108 (class 2604 OID 744579)
-- Name: solidarity_tickets id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_tickets ALTER COLUMN id SET DEFAULT nextval('public.solidarity_tickets_id_seq'::regclass);


--
-- TOC entry 4106 (class 2604 OID 744550)
-- Name: solidarity_users id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_users ALTER COLUMN id SET DEFAULT nextval('public.solidarity_users_id_seq'::regclass);


--
-- TOC entry 4102 (class 2604 OID 396378)
-- Name: solidarity_zd_tickets id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_zd_tickets ALTER COLUMN id SET DEFAULT nextval('public.solidarity_zd_tickets_id_seq'::regclass);


--
-- TOC entry 4058 (class 2604 OID 17059)
-- Name: subscription_transitions id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.subscription_transitions ALTER COLUMN id SET DEFAULT nextval('public.subscription_transitions_id_seq'::regclass);


--
-- TOC entry 4056 (class 2604 OID 17060)
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- TOC entry 4041 (class 2604 OID 17061)
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.taggings ALTER COLUMN id SET DEFAULT nextval('public.taggings_id_seq'::regclass);


--
-- TOC entry 4040 (class 2604 OID 17062)
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- TOC entry 4029 (class 2604 OID 17063)
-- Name: template_blocks id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.template_blocks ALTER COLUMN id SET DEFAULT nextval('public.template_blocks_id_seq'::regclass);


--
-- TOC entry 4028 (class 2604 OID 17064)
-- Name: template_mobilizations id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.template_mobilizations ALTER COLUMN id SET DEFAULT nextval('public.template_mobilizations_id_seq'::regclass);


--
-- TOC entry 4030 (class 2604 OID 17065)
-- Name: template_widgets id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.template_widgets ALTER COLUMN id SET DEFAULT nextval('public.template_widgets_id_seq'::regclass);


--
-- TOC entry 4071 (class 2604 OID 17066)
-- Name: twilio_call_transitions id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.twilio_call_transitions ALTER COLUMN id SET DEFAULT nextval('public.twilio_call_transitions_id_seq'::regclass);


--
-- TOC entry 4070 (class 2604 OID 17067)
-- Name: twilio_calls id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.twilio_calls ALTER COLUMN id SET DEFAULT nextval('public.twilio_calls_id_seq'::regclass);


--
-- TOC entry 4072 (class 2604 OID 17068)
-- Name: twilio_configurations id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.twilio_configurations ALTER COLUMN id SET DEFAULT nextval('public.twilio_configurations_id_seq'::regclass);


--
-- TOC entry 4085 (class 2604 OID 174266)
-- Name: user_tags id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.user_tags ALTER COLUMN id SET DEFAULT nextval('public.user_tags_id_seq'::regclass);


--
-- TOC entry 4013 (class 2604 OID 17069)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4020 (class 2604 OID 17070)
-- Name: widgets id; Type: DEFAULT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.widgets ALTER COLUMN id SET DEFAULT nextval('public.widgets_id_seq'::regclass);


--
-- TOC entry 4353 (class 2606 OID 396267)
-- Name: __diesel_schema_migrations __diesel_schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.__diesel_schema_migrations
    ADD CONSTRAINT __diesel_schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4381 (class 2606 OID 1955977)
-- Name: activist_actions activist_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_actions
    ADD CONSTRAINT activist_actions_pkey PRIMARY KEY (id);


--
-- TOC entry 4310 (class 2606 OID 17071)
-- Name: activist_facebook_bot_interactions activist_facebook_bot_interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_facebook_bot_interactions
    ADD CONSTRAINT activist_facebook_bot_interactions_pkey PRIMARY KEY (id);


--
-- TOC entry 4225 (class 2606 OID 17072)
-- Name: activist_matches activist_matches_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_matches
    ADD CONSTRAINT activist_matches_pkey PRIMARY KEY (id);


--
-- TOC entry 4229 (class 2606 OID 17073)
-- Name: activist_pressures activist_pressures_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_pressures
    ADD CONSTRAINT activist_pressures_pkey PRIMARY KEY (id);


--
-- TOC entry 4265 (class 2606 OID 17074)
-- Name: activist_tags activist_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_tags
    ADD CONSTRAINT activist_tags_pkey PRIMARY KEY (id);


--
-- TOC entry 4164 (class 2606 OID 451806)
-- Name: activists activists_email_key; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activists
    ADD CONSTRAINT activists_email_key UNIQUE (email);


--
-- TOC entry 4166 (class 2606 OID 17075)
-- Name: activists activists_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activists
    ADD CONSTRAINT activists_pkey PRIMARY KEY (id);


--
-- TOC entry 4171 (class 2606 OID 17076)
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- TOC entry 4395 (class 2606 OID 7809904)
-- Name: community_settings app_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.community_settings
    ADD CONSTRAINT app_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 4304 (class 2606 OID 17077)
-- Name: balance_operations balance_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.balance_operations
    ADD CONSTRAINT balance_operations_pkey PRIMARY KEY (id);


--
-- TOC entry 4174 (class 2606 OID 17078)
-- Name: blocks blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);


--
-- TOC entry 4345 (class 2606 OID 17079)
-- Name: certificates certificates_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.certificates
    ADD CONSTRAINT certificates_pkey PRIMARY KEY (id);


--
-- TOC entry 4357 (class 2606 OID 396323)
-- Name: chatbot_campaigns chatbot_campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.chatbot_campaigns
    ADD CONSTRAINT chatbot_campaigns_pkey PRIMARY KEY (id);


--
-- TOC entry 4367 (class 2606 OID 419228)
-- Name: chatbot_interactions chatbot_interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.chatbot_interactions
    ADD CONSTRAINT chatbot_interactions_pkey PRIMARY KEY (id);


--
-- TOC entry 4359 (class 2606 OID 396344)
-- Name: chatbot_settings chatbot_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.chatbot_settings
    ADD CONSTRAINT chatbot_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 4355 (class 2606 OID 396303)
-- Name: chatbots chatbots_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.chatbots
    ADD CONSTRAINT chatbots_pkey PRIMARY KEY (id);


--
-- TOC entry 4201 (class 2606 OID 17080)
-- Name: communities communities_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT communities_pkey PRIMARY KEY (id);


--
-- TOC entry 4322 (class 2606 OID 17081)
-- Name: community_activists community_activists_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.community_activists
    ADD CONSTRAINT community_activists_pkey PRIMARY KEY (id);


--
-- TOC entry 4397 (class 2606 OID 7809906)
-- Name: community_settings community_module_version_unique; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.community_settings
    ADD CONSTRAINT community_module_version_unique UNIQUE (name, version, community_id);


--
-- TOC entry 4241 (class 2606 OID 17082)
-- Name: community_users community_users_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.community_users
    ADD CONSTRAINT community_users_pkey PRIMARY KEY (id);


--
-- TOC entry 4243 (class 2606 OID 1956510)
-- Name: community_users community_users_unique; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.community_users
    ADD CONSTRAINT community_users_unique UNIQUE (community_id, user_id, role);


--
-- TOC entry 4347 (class 2606 OID 148849)
-- Name: configurations configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT configurations_pkey PRIMARY KEY (id);


--
-- TOC entry 4177 (class 2606 OID 17083)
-- Name: credit_cards credit_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.credit_cards
    ADD CONSTRAINT credit_cards_pkey PRIMARY KEY (id);


--
-- TOC entry 4268 (class 2606 OID 18428743)
-- Name: dns_hosted_zones dns_hosted_zones_domain_name_key; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.dns_hosted_zones
    ADD CONSTRAINT dns_hosted_zones_domain_name_key UNIQUE (domain_name);


--
-- TOC entry 4270 (class 2606 OID 17084)
-- Name: dns_hosted_zones dns_hosted_zones_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.dns_hosted_zones
    ADD CONSTRAINT dns_hosted_zones_pkey PRIMARY KEY (id);


--
-- TOC entry 4273 (class 2606 OID 18436836)
-- Name: dns_records dns_records_name_record_type_key; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.dns_records
    ADD CONSTRAINT dns_records_name_record_type_key UNIQUE (name, record_type);


--
-- TOC entry 4275 (class 2606 OID 17085)
-- Name: dns_records dns_records_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.dns_records
    ADD CONSTRAINT dns_records_pkey PRIMARY KEY (id);


--
-- TOC entry 4297 (class 2606 OID 17086)
-- Name: donation_transitions donation_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.donation_transitions
    ADD CONSTRAINT donation_transitions_pkey PRIMARY KEY (id);


--
-- TOC entry 4182 (class 2606 OID 17087)
-- Name: donations donations_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_pkey PRIMARY KEY (id);


--
-- TOC entry 4332 (class 2606 OID 17088)
-- Name: facebook_bot_activists facebook_bot_activists_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.facebook_bot_activists
    ADD CONSTRAINT facebook_bot_activists_pkey PRIMARY KEY (id);


--
-- TOC entry 4341 (class 2606 OID 17089)
-- Name: facebook_bot_campaign_activists facebook_bot_campaign_activists_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.facebook_bot_campaign_activists
    ADD CONSTRAINT facebook_bot_campaign_activists_pkey PRIMARY KEY (id);


--
-- TOC entry 4338 (class 2606 OID 17090)
-- Name: facebook_bot_campaigns facebook_bot_campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.facebook_bot_campaigns
    ADD CONSTRAINT facebook_bot_campaigns_pkey PRIMARY KEY (id);


--
-- TOC entry 4307 (class 2606 OID 17091)
-- Name: facebook_bot_configurations facebook_bot_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.facebook_bot_configurations
    ADD CONSTRAINT facebook_bot_configurations_pkey PRIMARY KEY (id);


--
-- TOC entry 4190 (class 2606 OID 17092)
-- Name: form_entries form_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.form_entries
    ADD CONSTRAINT form_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4247 (class 2606 OID 17093)
-- Name: gateway_subscriptions gateway_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.gateway_subscriptions
    ADD CONSTRAINT gateway_subscriptions_pkey PRIMARY KEY (id);


--
-- TOC entry 4295 (class 2606 OID 17094)
-- Name: gateway_transactions gateway_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.gateway_transactions
    ADD CONSTRAINT gateway_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 4302 (class 2606 OID 17095)
-- Name: invitations invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- TOC entry 4223 (class 2606 OID 17096)
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);


--
-- TOC entry 4330 (class 2606 OID 17097)
-- Name: mobilization_activists mobilization_activists_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.mobilization_activists
    ADD CONSTRAINT mobilization_activists_pkey PRIMARY KEY (id);


--
-- TOC entry 4199 (class 2606 OID 17098)
-- Name: mobilizations mobilizations_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT mobilizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4279 (class 2606 OID 17099)
-- Name: notification_templates notification_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.notification_templates
    ADD CONSTRAINT notification_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 4284 (class 2606 OID 17100)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4233 (class 2606 OID 17101)
-- Name: payable_transfers payable_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.payable_transfers
    ADD CONSTRAINT payable_transfers_pkey PRIMARY KEY (id);


--
-- TOC entry 4204 (class 2606 OID 17102)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- TOC entry 4206 (class 2606 OID 17103)
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- TOC entry 4411 (class 2606 OID 18282037)
-- Name: pressure_targets pressure_targets_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.pressure_targets
    ADD CONSTRAINT pressure_targets_pkey PRIMARY KEY (id);


--
-- TOC entry 4245 (class 2606 OID 17104)
-- Name: recipients recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.recipients
    ADD CONSTRAINT recipients_pkey PRIMARY KEY (id);


--
-- TOC entry 4387 (class 2606 OID 2904869)
-- Name: rede_groups rede_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.rede_groups
    ADD CONSTRAINT rede_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 4389 (class 2606 OID 2917811)
-- Name: rede_individuals rede_individuals_form_entry_id; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.rede_individuals
    ADD CONSTRAINT rede_individuals_form_entry_id UNIQUE (form_entry_id);


--
-- TOC entry 4391 (class 2606 OID 2904893)
-- Name: rede_individuals rede_individuals_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.rede_individuals
    ADD CONSTRAINT rede_individuals_pkey PRIMARY KEY (id);


--
-- TOC entry 4393 (class 2606 OID 2904919)
-- Name: rede_relationships rede_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.rede_relationships
    ADD CONSTRAINT rede_relationships_pkey PRIMARY KEY (id);


--
-- TOC entry 4208 (class 2606 OID 399454)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4377 (class 2606 OID 837830)
-- Name: solidarity_matches solidarity_matches_individuals_ticket_id_volunteers_ticket__key; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_individuals_ticket_id_volunteers_ticket__key UNIQUE (individuals_ticket_id, volunteers_ticket_id);


--
-- TOC entry 4379 (class 2606 OID 744603)
-- Name: solidarity_matches solidarity_matches_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_pkey PRIMARY KEY (id);


--
-- TOC entry 4373 (class 2606 OID 744584)
-- Name: solidarity_tickets solidarity_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_tickets
    ADD CONSTRAINT solidarity_tickets_pkey PRIMARY KEY (id);


--
-- TOC entry 4375 (class 2606 OID 744586)
-- Name: solidarity_tickets solidarity_tickets_ticket_id_key; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_tickets
    ADD CONSTRAINT solidarity_tickets_ticket_id_key UNIQUE (ticket_id);


--
-- TOC entry 4369 (class 2606 OID 744555)
-- Name: solidarity_users solidarity_users_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_users
    ADD CONSTRAINT solidarity_users_pkey PRIMARY KEY (id);


--
-- TOC entry 4371 (class 2606 OID 744557)
-- Name: solidarity_users solidarity_users_user_id_key; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_users
    ADD CONSTRAINT solidarity_users_user_id_key UNIQUE (user_id);


--
-- TOC entry 4363 (class 2606 OID 396383)
-- Name: solidarity_zd_tickets solidarity_zd_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_zd_tickets
    ADD CONSTRAINT solidarity_zd_tickets_pkey PRIMARY KEY (id);


--
-- TOC entry 4365 (class 2606 OID 396385)
-- Name: solidarity_zd_tickets solidarity_zd_tickets_ticket_id_key; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_zd_tickets
    ADD CONSTRAINT solidarity_zd_tickets_ticket_id_key UNIQUE (ticket_id);


--
-- TOC entry 4293 (class 2606 OID 17105)
-- Name: subscription_transitions subscription_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.subscription_transitions
    ADD CONSTRAINT subscription_transitions_pkey PRIMARY KEY (id);


--
-- TOC entry 4289 (class 2606 OID 17106)
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- TOC entry 4263 (class 2606 OID 17107)
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- TOC entry 4251 (class 2606 OID 17108)
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- TOC entry 4237 (class 2606 OID 17109)
-- Name: template_blocks template_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.template_blocks
    ADD CONSTRAINT template_blocks_pkey PRIMARY KEY (id);


--
-- TOC entry 4235 (class 2606 OID 17110)
-- Name: template_mobilizations template_mobilizations_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.template_mobilizations
    ADD CONSTRAINT template_mobilizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4239 (class 2606 OID 17111)
-- Name: template_widgets template_widgets_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.template_widgets
    ADD CONSTRAINT template_widgets_pkey PRIMARY KEY (id);


--
-- TOC entry 4317 (class 2606 OID 17112)
-- Name: twilio_call_transitions twilio_call_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.twilio_call_transitions
    ADD CONSTRAINT twilio_call_transitions_pkey PRIMARY KEY (id);


--
-- TOC entry 4315 (class 2606 OID 17113)
-- Name: twilio_calls twilio_calls_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.twilio_calls
    ADD CONSTRAINT twilio_calls_pkey PRIMARY KEY (id);


--
-- TOC entry 4320 (class 2606 OID 17114)
-- Name: twilio_configurations twilio_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.twilio_configurations
    ADD CONSTRAINT twilio_configurations_pkey PRIMARY KEY (id);


--
-- TOC entry 4413 (class 2606 OID 18282039)
-- Name: pressure_targets unique_identify_widget_id; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.pressure_targets
    ADD CONSTRAINT unique_identify_widget_id UNIQUE (widget_id, identify);


--
-- TOC entry 4351 (class 2606 OID 174268)
-- Name: user_tags user_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.user_tags
    ADD CONSTRAINT user_tags_pkey PRIMARY KEY (id);


--
-- TOC entry 4213 (class 2606 OID 10681235)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4215 (class 2606 OID 17115)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4361 (class 2606 OID 396363)
-- Name: webhooks_registry webhooks_registry_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.webhooks_registry
    ADD CONSTRAINT webhooks_registry_pkey PRIMARY KEY (id);


--
-- TOC entry 4220 (class 2606 OID 17116)
-- Name: widgets widgets_pkey; Type: CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT widgets_pkey PRIMARY KEY (id);

--
-- TOC entry 4179 (class 1259 OID 113842)
-- Name: cached_community_id_idx; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX cached_community_id_idx ON public.donations USING btree (cached_community_id);


--
-- TOC entry 4180 (class 1259 OID 113849)
-- Name: donation_community_transaction_status_ids; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX donation_community_transaction_status_ids ON public.donations USING btree (cached_community_id, transaction_status);


--
-- TOC entry 4175 (class 1259 OID 30452)
-- Name: ids_blocks_mob_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX ids_blocks_mob_id ON public.blocks USING btree (mobilization_id);


--
-- TOC entry 4216 (class 1259 OID 30453)
-- Name: ids_widgets_block_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX ids_widgets_block_id ON public.widgets USING btree (block_id);


--
-- TOC entry 4217 (class 1259 OID 30454)
-- Name: ids_widgets_kind; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX ids_widgets_kind ON public.widgets USING btree (kind);


--
-- TOC entry 4382 (class 1259 OID 12197040)
-- Name: idx_activist_actions_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX idx_activist_actions_activist_id ON public.activist_actions USING btree (activist_id);


--
-- TOC entry 4383 (class 1259 OID 12197001)
-- Name: idx_activist_actions_community_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX idx_activist_actions_community_id ON public.activist_actions USING btree (community_id);


--
-- TOC entry 4384 (class 1259 OID 12196965)
-- Name: idx_activist_actions_mobilization_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX idx_activist_actions_mobilization_id ON public.activist_actions USING btree (mobilization_id);


--
-- TOC entry 4385 (class 1259 OID 12196925)
-- Name: idx_activist_actions_widget_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX idx_activist_actions_widget_id ON public.activist_actions USING btree (widget_id);


--
-- TOC entry 4311 (class 1259 OID 49377)
-- Name: idx_activists_on_bot_interations; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX idx_activists_on_bot_interations ON public.activist_facebook_bot_interactions USING btree (activist_id);


--
-- TOC entry 4312 (class 1259 OID 49378)
-- Name: idx_bot_config_on_bot_interactions; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX idx_bot_config_on_bot_interactions ON public.activist_facebook_bot_interactions USING btree (facebook_bot_configuration_id);


--
-- TOC entry 4342 (class 1259 OID 71188)
-- Name: idx_facebook_bot_campaign_activists_on_facebook_bot_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX idx_facebook_bot_campaign_activists_on_facebook_bot_activist_id ON public.facebook_bot_campaign_activists USING btree (facebook_bot_activist_id);


--
-- TOC entry 4343 (class 1259 OID 71187)
-- Name: idx_facebook_bot_campaign_activists_on_facebook_bot_campaign_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX idx_facebook_bot_campaign_activists_on_facebook_bot_campaign_id ON public.facebook_bot_campaign_activists USING btree (facebook_bot_campaign_id);


--
-- TOC entry 4191 (class 1259 OID 22382)
-- Name: idx_form_entries_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX idx_form_entries_activist_id ON public.form_entries USING btree (activist_id);


--
-- TOC entry 4193 (class 1259 OID 30450)
-- Name: idx_mobilizations_custom_domain; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX idx_mobilizations_custom_domain ON public.mobilizations USING btree (custom_domain);


--
-- TOC entry 4194 (class 1259 OID 30451)
-- Name: idx_mobilizations_slug; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX idx_mobilizations_slug ON public.mobilizations USING btree (slug);


--
-- TOC entry 4226 (class 1259 OID 17184)
-- Name: index_activist_matches_on_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_activist_matches_on_activist_id ON public.activist_matches USING btree (activist_id);


--
-- TOC entry 4227 (class 1259 OID 17185)
-- Name: index_activist_matches_on_match_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_activist_matches_on_match_id ON public.activist_matches USING btree (match_id);


--
-- TOC entry 4230 (class 1259 OID 17252)
-- Name: index_activist_pressures_on_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_activist_pressures_on_activist_id ON public.activist_pressures USING btree (activist_id);


--
-- TOC entry 4231 (class 1259 OID 17253)
-- Name: index_activist_pressures_on_widget_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_activist_pressures_on_widget_id ON public.activist_pressures USING btree (widget_id);


--
-- TOC entry 4266 (class 1259 OID 65228)
-- Name: index_activist_tags_on_activist_id_and_community_id_and_mob_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_activist_tags_on_activist_id_and_community_id_and_mob_id ON public.activist_tags USING btree (activist_id, community_id, mobilization_id);


--
-- TOC entry 4167 (class 1259 OID 50908)
-- Name: index_activists_on_created_at; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_activists_on_created_at ON public.activists USING btree (created_at DESC);


--
-- TOC entry 4168 (class 1259 OID 50907)
-- Name: index_activists_on_email; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_activists_on_email ON public.activists USING btree (email);


--
-- TOC entry 4172 (class 1259 OID 16729)
-- Name: index_addresses_on_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_addresses_on_activist_id ON public.addresses USING btree (activist_id);


--
-- TOC entry 4305 (class 1259 OID 49346)
-- Name: index_balance_operations_on_recipient_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_balance_operations_on_recipient_id ON public.balance_operations USING btree (recipient_id);


--
-- TOC entry 4323 (class 1259 OID 53303)
-- Name: index_community_activists_on_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_community_activists_on_activist_id ON public.community_activists USING btree (activist_id);


--
-- TOC entry 4324 (class 1259 OID 53302)
-- Name: index_community_activists_on_community_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_community_activists_on_community_id ON public.community_activists USING btree (community_id);


--
-- TOC entry 4325 (class 1259 OID 53314)
-- Name: index_community_activists_on_community_id_and_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_community_activists_on_community_id_and_activist_id ON public.community_activists USING btree (community_id, activist_id);


--
-- TOC entry 4348 (class 1259 OID 148856)
-- Name: index_configurations_on_name; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_configurations_on_name ON public.configurations USING btree (name);


--
-- TOC entry 4178 (class 1259 OID 16730)
-- Name: index_credit_cards_on_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_credit_cards_on_activist_id ON public.credit_cards USING btree (activist_id);


--
-- TOC entry 4271 (class 1259 OID 33309)
-- Name: index_dns_hosted_zones_on_domain_name; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_dns_hosted_zones_on_domain_name ON public.dns_hosted_zones USING btree (domain_name);


--
-- TOC entry 4276 (class 1259 OID 33326)
-- Name: index_dns_records_on_name_and_record_type; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_dns_records_on_name_and_record_type ON public.dns_records USING btree (name, record_type);


--
-- TOC entry 4298 (class 1259 OID 46581)
-- Name: index_donation_transitions_parent_most_recent; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_donation_transitions_parent_most_recent ON public.donation_transitions USING btree (donation_id, most_recent) WHERE most_recent;


--
-- TOC entry 4299 (class 1259 OID 46580)
-- Name: index_donation_transitions_parent_sort; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_donation_transitions_parent_sort ON public.donation_transitions USING btree (donation_id, sort_key);


--
-- TOC entry 4183 (class 1259 OID 16731)
-- Name: index_donations_on_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_donations_on_activist_id ON public.donations USING btree (activist_id);


--
-- TOC entry 4184 (class 1259 OID 16732)
-- Name: index_donations_on_customer; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_donations_on_customer ON public.donations USING gin (customer);


--
-- TOC entry 4185 (class 1259 OID 17740)
-- Name: index_donations_on_payable_transfer_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_donations_on_payable_transfer_id ON public.donations USING btree (payable_transfer_id);


--
-- TOC entry 4186 (class 1259 OID 46567)
-- Name: index_donations_on_transaction_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_donations_on_transaction_id ON public.donations USING btree (transaction_id);


--
-- TOC entry 4187 (class 1259 OID 16733)
-- Name: index_donations_on_widget_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_donations_on_widget_id ON public.donations USING btree (widget_id);


--
-- TOC entry 4333 (class 1259 OID 56113)
-- Name: index_facebook_bot_activists_on_interaction_dates; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_facebook_bot_activists_on_interaction_dates ON public.facebook_bot_activists USING btree (interaction_dates);


--
-- TOC entry 4334 (class 1259 OID 56111)
-- Name: index_facebook_bot_activists_on_messages; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_facebook_bot_activists_on_messages ON public.facebook_bot_activists USING gin (messages);


--
-- TOC entry 4335 (class 1259 OID 56112)
-- Name: index_facebook_bot_activists_on_quick_replies; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_facebook_bot_activists_on_quick_replies ON public.facebook_bot_activists USING btree (quick_replies);


--
-- TOC entry 4336 (class 1259 OID 56110)
-- Name: index_facebook_bot_activists_on_recipient_id_and_sender_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_facebook_bot_activists_on_recipient_id_and_sender_id ON public.facebook_bot_activists USING btree (fb_context_recipient_id, fb_context_sender_id);


--
-- TOC entry 4339 (class 1259 OID 71168)
-- Name: index_facebook_bot_campaigns_on_facebook_bot_configuration_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_facebook_bot_campaigns_on_facebook_bot_configuration_id ON public.facebook_bot_campaigns USING btree (facebook_bot_configuration_id);


--
-- TOC entry 4192 (class 1259 OID 16734)
-- Name: index_form_entries_on_widget_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_form_entries_on_widget_id ON public.form_entries USING btree (widget_id);


--
-- TOC entry 4248 (class 1259 OID 32703)
-- Name: index_gateway_subscriptions_on_subscription_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_gateway_subscriptions_on_subscription_id ON public.gateway_subscriptions USING btree (subscription_id);


--
-- TOC entry 4300 (class 1259 OID 47817)
-- Name: index_invitations_on_community_id_and_code; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_invitations_on_community_id_and_code ON public.invitations USING btree (community_id, code);


--
-- TOC entry 4221 (class 1259 OID 16875)
-- Name: index_matches_on_widget_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_matches_on_widget_id ON public.matches USING btree (widget_id);


--
-- TOC entry 4326 (class 1259 OID 53327)
-- Name: index_mobilization_activists_on_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_mobilization_activists_on_activist_id ON public.mobilization_activists USING btree (activist_id);


--
-- TOC entry 4327 (class 1259 OID 53326)
-- Name: index_mobilization_activists_on_mobilization_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_mobilization_activists_on_mobilization_id ON public.mobilization_activists USING btree (mobilization_id);


--
-- TOC entry 4328 (class 1259 OID 53338)
-- Name: index_mobilization_activists_on_mobilization_id_and_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_mobilization_activists_on_mobilization_id_and_activist_id ON public.mobilization_activists USING btree (mobilization_id, activist_id);


--
-- TOC entry 4195 (class 1259 OID 50909)
-- Name: index_mobilizations_on_community_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_mobilizations_on_community_id ON public.mobilizations USING btree (community_id);


--
-- TOC entry 4196 (class 1259 OID 46928)
-- Name: index_mobilizations_on_custom_domain; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_mobilizations_on_custom_domain ON public.mobilizations USING btree (custom_domain);


--
-- TOC entry 4197 (class 1259 OID 122119)
-- Name: index_mobilizations_on_slug; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_mobilizations_on_slug ON public.mobilizations USING btree (slug);


--
-- TOC entry 4280 (class 1259 OID 46543)
-- Name: index_notifications_on_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_notifications_on_activist_id ON public.notifications USING btree (activist_id);


--
-- TOC entry 4281 (class 1259 OID 38457)
-- Name: index_notifications_on_community_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_notifications_on_community_id ON public.notifications USING btree (community_id);


--
-- TOC entry 4282 (class 1259 OID 33355)
-- Name: index_notifications_on_notification_template_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_notifications_on_notification_template_id ON public.notifications USING btree (notification_template_id);


--
-- TOC entry 4202 (class 1259 OID 16735)
-- Name: index_payments_on_donation_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_payments_on_donation_id ON public.payments USING btree (donation_id);


--
-- TOC entry 4290 (class 1259 OID 34665)
-- Name: index_subscription_transitions_parent_most_recent; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_subscription_transitions_parent_most_recent ON public.subscription_transitions USING btree (subscription_id, most_recent) WHERE most_recent;


--
-- TOC entry 4291 (class 1259 OID 34664)
-- Name: index_subscription_transitions_parent_sort; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_subscription_transitions_parent_sort ON public.subscription_transitions USING btree (subscription_id, sort_key);


--
-- TOC entry 4285 (class 1259 OID 34630)
-- Name: index_subscriptions_on_activist_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_subscriptions_on_activist_id ON public.subscriptions USING btree (activist_id);


--
-- TOC entry 4286 (class 1259 OID 34631)
-- Name: index_subscriptions_on_community_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_subscriptions_on_community_id ON public.subscriptions USING btree (community_id);


--
-- TOC entry 4287 (class 1259 OID 34629)
-- Name: index_subscriptions_on_widget_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_subscriptions_on_widget_id ON public.subscriptions USING btree (widget_id);


--
-- TOC entry 4252 (class 1259 OID 33271)
-- Name: index_taggings_on_context; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_taggings_on_context ON public.taggings USING btree (context);


--
-- TOC entry 4253 (class 1259 OID 33267)
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_taggings_on_tag_id ON public.taggings USING btree (tag_id);


--
-- TOC entry 4254 (class 1259 OID 33268)
-- Name: index_taggings_on_taggable_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_taggings_on_taggable_id ON public.taggings USING btree (taggable_id);


--
-- TOC entry 4255 (class 1259 OID 50915)
-- Name: index_taggings_on_taggable_id_and_taggable_type; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type ON public.taggings USING btree (taggable_id, taggable_type);


--
-- TOC entry 4256 (class 1259 OID 33266)
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON public.taggings USING btree (taggable_id, taggable_type, context);


--
-- TOC entry 4257 (class 1259 OID 33269)
-- Name: index_taggings_on_taggable_type; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_taggings_on_taggable_type ON public.taggings USING btree (taggable_type);


--
-- TOC entry 4258 (class 1259 OID 33270)
-- Name: index_taggings_on_tagger_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_taggings_on_tagger_id ON public.taggings USING btree (tagger_id);


--
-- TOC entry 4259 (class 1259 OID 33272)
-- Name: index_taggings_on_tagger_id_and_tagger_type; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_taggings_on_tagger_id_and_tagger_type ON public.taggings USING btree (tagger_id, tagger_type);


--
-- TOC entry 4249 (class 1259 OID 33255)
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- TOC entry 4313 (class 1259 OID 51926)
-- Name: index_twilio_calls_on_widget_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_twilio_calls_on_widget_id ON public.twilio_calls USING btree (widget_id);


--
-- TOC entry 4318 (class 1259 OID 51968)
-- Name: index_twilio_configurations_on_community_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_twilio_configurations_on_community_id ON public.twilio_configurations USING btree (community_id);


--
-- TOC entry 4349 (class 1259 OID 174269)
-- Name: index_user_tags_on_user_id; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_user_tags_on_user_id ON public.user_tags USING btree (user_id);


--
-- TOC entry 4210 (class 1259 OID 16736)
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX index_users_on_email ON public.users USING btree (email);


--
-- TOC entry 4211 (class 1259 OID 16738)
-- Name: index_users_on_uid_and_provider; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX index_users_on_uid_and_provider ON public.users USING btree (uid, provider);


--
-- TOC entry 4188 (class 1259 OID 113843)
-- Name: local_subs_id_idx; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX local_subs_id_idx ON public.donations USING btree (local_subscription_id);


--
-- TOC entry 4277 (class 1259 OID 122117)
-- Name: notification_templates_label_uniq_idx; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX notification_templates_label_uniq_idx ON public.notification_templates USING btree (community_id, label, locale);


--
-- TOC entry 4218 (class 1259 OID 30455)
-- Name: ordasc_widgets; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX ordasc_widgets ON public.widgets USING btree (id);


--
-- TOC entry 4260 (class 1259 OID 33256)
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX taggings_idx ON public.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- TOC entry 4261 (class 1259 OID 33273)
-- Name: taggings_idy; Type: INDEX; Schema: public; Owner: reboo
--

CREATE INDEX taggings_idy ON public.taggings USING btree (taggable_id, taggable_type, tagger_id, context);


--
-- TOC entry 4169 (class 1259 OID 71285)
-- Name: uniq_email_acts; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX uniq_email_acts ON public.activists USING btree (lower(((email)::public.email)::text));


--
-- TOC entry 4308 (class 1259 OID 49389)
-- Name: uniq_m_page_access_token_idx; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX uniq_m_page_access_token_idx ON public.facebook_bot_configurations USING btree (messenger_page_access_token);


--
-- TOC entry 4209 (class 1259 OID 16739)
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: reboo
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- TOC entry 4679 (class 2618 OID 174280)
-- Name: users _RETURN; Type: RULE; Schema: postgraphql; Owner: reboo
--

CREATE OR REPLACE VIEW postgraphql.users AS
 SELECT u.id,
    u.provider,
    u.uid,
    u.encrypted_password,
    u.reset_password_token,
    u.reset_password_sent_at,
    u.remember_created_at,
    u.sign_in_count,
    u.current_sign_in_at,
    u.last_sign_in_at,
    u.current_sign_in_ip,
    u.last_sign_in_ip,
    u.confirmation_token,
    u.confirmed_at,
    u.confirmation_sent_at,
    u.unconfirmed_email,
    u.first_name,
    u.last_name,
    u.email,
    u.tokens,
    u.created_at,
    u.updated_at,
    u.avatar,
    u.admin,
    u.locale,
    COALESCE(json_agg(t.name), '[]'::json) AS tags,
    u.is_admin
   FROM ((public.users u
     LEFT JOIN public.user_tags ut ON ((ut.user_id = u.id)))
     LEFT JOIN public.tags t ON ((t.id = ut.tag_id)))
  WHERE (u.id = (current_setting('jwt.claims.user_id'::text))::integer)
  GROUP BY u.id;


--
-- TOC entry 4674 (class 2618 OID 17121)
-- Name: activist_participations _RETURN; Type: RULE; Schema: public; Owner: reboo
--

CREATE OR REPLACE VIEW public.activist_participations AS
 SELECT c.id AS community_id,
    m.id AS mobilization_id,
    w.id AS widget_id,
    a.id AS activist_id,
    a.email,
    COALESCE(fe.created_at, d.created_at, ap.created_at, s.created_at) AS participate_at,
        CASE
            WHEN (fe.id IS NOT NULL) THEN 'form_entry'::text
            WHEN ((d.id IS NOT NULL) AND (d.local_subscription_id IS NOT NULL)) THEN 'subscription'::text
            WHEN ((d.id IS NOT NULL) AND (d.local_subscription_id IS NULL)) THEN 'donation'::text
            WHEN (ap.id IS NOT NULL) THEN 'activist_pressure'::text
            WHEN (s.id IS NOT NULL) THEN 'subscription'::text
            ELSE NULL::text
        END AS participate_kind,
    COALESCE(fe.id, d.id, ap.id, s.id) AS participate_id
   FROM ((((((((public.communities c
     JOIN public.mobilizations m ON ((m.community_id = c.id)))
     LEFT JOIN public.blocks b ON ((b.mobilization_id = m.id)))
     LEFT JOIN public.widgets w ON ((w.block_id = b.id)))
     LEFT JOIN public.form_entries fe ON ((fe.widget_id = w.id)))
     LEFT JOIN public.donations d ON (((d.widget_id = w.id) AND (NOT d.subscription))))
     LEFT JOIN public.subscriptions s ON ((s.widget_id = w.id)))
     LEFT JOIN public.activist_pressures ap ON ((ap.widget_id = w.id)))
     JOIN public.activists a ON ((a.id = COALESCE(fe.activist_id, d.activist_id, s.activist_id, ap.activist_id))))
  GROUP BY c.id, m.id, w.id, a.id, fe.id, s.id, ap.id, d.id, fe.created_at, s.created_at, ap.created_at, d.created_at;


--
-- TOC entry 4690 (class 2618 OID 18594891)
-- Name: agg_activists _RETURN; Type: RULE; Schema: public; Owner: reboo
--

CREATE OR REPLACE VIEW public.agg_activists AS
 SELECT com.id AS community_id,
    a.id AS activist_id,
    a.email,
    a.name,
    agg_fe.count AS total_form_entries
   FROM ((((public.communities com
     JOIN public.community_activists cac ON ((cac.community_id = com.id)))
     JOIN public.activists a ON ((a.id = cac.activist_id)))
     LEFT JOIN LATERAL ( SELECT count(1) AS count
           FROM (((public.form_entries fe
             JOIN public.widgets w ON ((w.id = fe.widget_id)))
             JOIN public.blocks b ON ((b.id = w.block_id)))
             JOIN public.mobilizations m ON ((b.mobilization_id = m.id)))
          WHERE ((fe.activist_id = a.id) AND (m.community_id = com.id))) agg_fe ON (true))
     LEFT JOIN LATERAL ( SELECT (btrim((d2.customer OPERATOR(public.->) 'address'::text), '{}'::text))::public.hstore AS address
           FROM public.donations d2
          WHERE ((d2.activist_id = a.id) AND (d2.transaction_id IS NOT NULL) AND (d2.transaction_status IS NOT NULL) AND (d2.customer IS NOT NULL))
          ORDER BY d2.id DESC
         LIMIT 1) last_customer ON (true))
  WHERE (a.id IS NOT NULL)
  GROUP BY com.id, a.email, a.id, last_customer.address, agg_fe.count;


--
-- TOC entry 4512 (class 2620 OID 2904852)
-- Name: activist_pressures activist_pressures_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER activist_pressures_update_at BEFORE UPDATE ON public.activist_pressures FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4502 (class 2620 OID 2904855)
-- Name: activists activists_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER activists_update_at BEFORE UPDATE ON public.activists FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4526 (class 2620 OID 396331)
-- Name: chatbot_campaigns chatbots_campaigns_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER chatbots_campaigns_update_at BEFORE UPDATE ON public.chatbot_campaigns FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4530 (class 2620 OID 419234)
-- Name: chatbot_interactions chatbots_interactions_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER chatbots_interactions_update_at BEFORE UPDATE ON public.chatbot_interactions FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4527 (class 2620 OID 396350)
-- Name: chatbot_settings chatbots_settings_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER chatbots_settings_update_at BEFORE UPDATE ON public.chatbot_settings FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4525 (class 2620 OID 396309)
-- Name: chatbots chatbots_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER chatbots_update_at BEFORE UPDATE ON public.chatbots FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4514 (class 2620 OID 1956508)
-- Name: community_users community_users_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER community_users_update_at BEFORE UPDATE ON public.community_users FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4516 (class 2620 OID 18358435)
-- Name: dns_hosted_zones dns_hosted_zones_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER dns_hosted_zones_update_at BEFORE UPDATE ON public.dns_hosted_zones FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4517 (class 2620 OID 18358434)
-- Name: dns_records dns_records_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER dns_records_update_at BEFORE UPDATE ON public.dns_records FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4504 (class 2620 OID 19204256)
-- Name: donations donations_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER donations_update_at BEFORE UPDATE ON public.donations FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4511 (class 2620 OID 17124)
-- Name: activist_pressures generate_activists_from_generic_resource_with_widget; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER generate_activists_from_generic_resource_with_widget AFTER INSERT OR UPDATE ON public.activist_pressures FOR EACH ROW EXECUTE PROCEDURE public.generate_activists_from_generic_resource_with_widget();


--
-- TOC entry 4503 (class 2620 OID 17125)
-- Name: donations generate_activists_from_generic_resource_with_widget; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER generate_activists_from_generic_resource_with_widget AFTER INSERT OR UPDATE ON public.donations FOR EACH ROW EXECUTE PROCEDURE public.generate_activists_from_generic_resource_with_widget();


--
-- TOC entry 4506 (class 2620 OID 17123)
-- Name: form_entries generate_activists_from_generic_resource_with_widget; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER generate_activists_from_generic_resource_with_widget AFTER INSERT OR UPDATE ON public.form_entries FOR EACH ROW EXECUTE PROCEDURE public.generate_activists_from_generic_resource_with_widget();


--
-- TOC entry 4518 (class 2620 OID 17126)
-- Name: subscriptions generate_activists_from_generic_resource_with_widget; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER generate_activists_from_generic_resource_with_widget AFTER INSERT OR UPDATE ON public.subscriptions FOR EACH ROW EXECUTE PROCEDURE public.generate_activists_from_generic_resource_with_widget();


--
-- TOC entry 4519 (class 2620 OID 1956513)
-- Name: invitations invitations_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER invitations_update_at BEFORE UPDATE ON public.invitations FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4520 (class 2620 OID 1956515)
-- Name: invitations invitations_update_expires; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER invitations_update_expires BEFORE INSERT ON public.invitations FOR EACH ROW EXECUTE PROCEDURE public.update_expires();


--
-- TOC entry 4534 (class 2620 OID 18483425)
-- Name: pressure_targets pressure_targets_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER pressure_targets_update_at BEFORE UPDATE ON public.pressure_targets FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4515 (class 2620 OID 18623383)
-- Name: recipients recipients_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER recipients_update_at BEFORE UPDATE ON public.recipients FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4531 (class 2620 OID 2904880)
-- Name: rede_groups rede_groups_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER rede_groups_update_at BEFORE UPDATE ON public.rede_groups FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4532 (class 2620 OID 2904904)
-- Name: rede_individuals rede_individuals_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER rede_individuals_update_at BEFORE UPDATE ON public.rede_individuals FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4533 (class 2620 OID 2904935)
-- Name: rede_relationships rede_relationships_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER rede_relationships_update_at BEFORE UPDATE ON public.rede_relationships FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4509 (class 2620 OID 174316)
-- Name: mobilizations refresh_custom_domain_frontend; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER refresh_custom_domain_frontend AFTER INSERT OR UPDATE OF traefik_host_rule ON public.mobilizations FOR EACH ROW WHEN ((new.traefik_host_rule IS NOT NULL)) EXECUTE PROCEDURE public.refresh_custom_domain_frontend();


--
-- TOC entry 4513 (class 2620 OID 1955994)
-- Name: activist_pressures trig_copy_activist_pressures; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER trig_copy_activist_pressures AFTER INSERT ON public.activist_pressures FOR EACH ROW EXECUTE PROCEDURE public.copy_activist_pressures();


--
-- TOC entry 4505 (class 2620 OID 1955996)
-- Name: donations trig_copy_donations; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER trig_copy_donations AFTER INSERT ON public.donations FOR EACH ROW EXECUTE PROCEDURE public.copy_donations();


--
-- TOC entry 4521 (class 2620 OID 17127)
-- Name: activist_facebook_bot_interactions update_facebook_bot_activist_data; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER update_facebook_bot_activist_data AFTER INSERT OR UPDATE ON public.activist_facebook_bot_interactions FOR EACH ROW EXECUTE PROCEDURE public.update_facebook_bot_activists_full_text_index();


--
-- TOC entry 4524 (class 2620 OID 1955398)
-- Name: user_tags user_tags_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER user_tags_update_at BEFORE UPDATE ON public.user_tags FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4510 (class 2620 OID 1955401)
-- Name: users users_update_at; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER users_update_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE PROCEDURE public.updated_at_column();


--
-- TOC entry 4507 (class 2620 OID 283295)
-- Name: form_entries watched_create_form_entries_trigger; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER watched_create_form_entries_trigger AFTER INSERT OR UPDATE ON public.form_entries FOR EACH ROW WHEN ((new.widget_id = ANY (ARRAY[16850, 17628, 17633]))) EXECUTE PROCEDURE public.notify_form_entries_trigger();


--
-- TOC entry 4523 (class 2620 OID 137547)
-- Name: twilio_configurations watched_create_twilio_configuration_trigger; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER watched_create_twilio_configuration_trigger AFTER INSERT OR UPDATE ON public.twilio_configurations FOR EACH ROW EXECUTE PROCEDURE public.notify_create_twilio_configuration_trigger();


--
-- TOC entry 4508 (class 2620 OID 148860)
-- Name: mobilizations watched_custom_domain; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER watched_custom_domain AFTER INSERT OR DELETE OR UPDATE ON public.mobilizations FOR EACH ROW EXECUTE PROCEDURE public.verify_custom_domain();


--
-- TOC entry 4522 (class 2620 OID 17128)
-- Name: twilio_calls watched_twilio_call_trigger; Type: TRIGGER; Schema: public; Owner: reboo
--

CREATE TRIGGER watched_twilio_call_trigger AFTER INSERT ON public.twilio_calls FOR EACH ROW EXECUTE PROCEDURE public.notify_twilio_call_trigger();


--
-- TOC entry 4487 (class 2606 OID 1955978)
-- Name: activist_actions activist_actions_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_actions
    ADD CONSTRAINT activist_actions_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4488 (class 2606 OID 1955983)
-- Name: activist_actions activist_actions_mobilization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_actions
    ADD CONSTRAINT activist_actions_mobilization_id_fkey FOREIGN KEY (mobilization_id) REFERENCES public.mobilizations(id);


--
-- TOC entry 4489 (class 2606 OID 1955988)
-- Name: activist_actions activist_actions_widget_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_actions
    ADD CONSTRAINT activist_actions_widget_id_fkey FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- TOC entry 4477 (class 2606 OID 396326)
-- Name: chatbot_campaigns chatbot_campaigns_chatbot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.chatbot_campaigns
    ADD CONSTRAINT chatbot_campaigns_chatbot_id_fkey FOREIGN KEY (chatbot_id) REFERENCES public.chatbots(id);


--
-- TOC entry 4479 (class 2606 OID 419229)
-- Name: chatbot_interactions chatbot_interactions_chatbot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.chatbot_interactions
    ADD CONSTRAINT chatbot_interactions_chatbot_id_fkey FOREIGN KEY (chatbot_id) REFERENCES public.chatbots(id);


--
-- TOC entry 4478 (class 2606 OID 396345)
-- Name: chatbot_settings chatbot_settings_chatbot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.chatbot_settings
    ADD CONSTRAINT chatbot_settings_chatbot_id_fkey FOREIGN KEY (chatbot_id) REFERENCES public.chatbots(id);


--
-- TOC entry 4476 (class 2606 OID 396304)
-- Name: chatbots chatbots_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.chatbots
    ADD CONSTRAINT chatbots_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4497 (class 2606 OID 7809907)
-- Name: community_settings community_id_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.community_settings
    ADD CONSTRAINT community_id_foreign_key FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4499 (class 2606 OID 18282040)
-- Name: pressure_targets fk_pressure_targets_widget; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.pressure_targets
    ADD CONSTRAINT fk_pressure_targets_widget FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- TOC entry 4454 (class 2606 OID 17129)
-- Name: notification_templates fk_rails_015164fe8d; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.notification_templates
    ADD CONSTRAINT fk_rails_015164fe8d FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4441 (class 2606 OID 17134)
-- Name: mobilizations fk_rails_0786dde5c3; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT fk_rails_0786dde5c3 FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4459 (class 2606 OID 17139)
-- Name: subscriptions fk_rails_0ded3585f1; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_0ded3585f1 FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4473 (class 2606 OID 17144)
-- Name: facebook_bot_campaign_activists fk_rails_0ff272a657; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.facebook_bot_campaign_activists
    ADD CONSTRAINT fk_rails_0ff272a657 FOREIGN KEY (facebook_bot_activist_id) REFERENCES public.facebook_bot_activists(id);


--
-- TOC entry 4444 (class 2606 OID 17149)
-- Name: activist_matches fk_rails_26ca62b2d0; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_matches
    ADD CONSTRAINT fk_rails_26ca62b2d0 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- TOC entry 4455 (class 2606 OID 17154)
-- Name: notifications fk_rails_2fb35253bd; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_2fb35253bd FOREIGN KEY (notification_template_id) REFERENCES public.notification_templates(id);


--
-- TOC entry 4449 (class 2606 OID 17159)
-- Name: recipients fk_rails_35bdfe7f89; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.recipients
    ADD CONSTRAINT fk_rails_35bdfe7f89 FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4460 (class 2606 OID 17164)
-- Name: subscriptions fk_rails_3bd353c401; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_3bd353c401 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- TOC entry 4446 (class 2606 OID 17169)
-- Name: activist_pressures fk_rails_3ff765ac30; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_pressures
    ADD CONSTRAINT fk_rails_3ff765ac30 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- TOC entry 4450 (class 2606 OID 17174)
-- Name: activist_tags fk_rails_4d2ba73b48; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_tags
    ADD CONSTRAINT fk_rails_4d2ba73b48 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- TOC entry 4456 (class 2606 OID 17179)
-- Name: notifications fk_rails_4ea5195391; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_4ea5195391 FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4443 (class 2606 OID 17184)
-- Name: matches fk_rails_5238d1bbc9; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT fk_rails_5238d1bbc9 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- TOC entry 4461 (class 2606 OID 17189)
-- Name: subscriptions fk_rails_61f00b3de3; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_61f00b3de3 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- TOC entry 4432 (class 2606 OID 17194)
-- Name: addresses fk_rails_64d1e99667; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT fk_rails_64d1e99667 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- TOC entry 4447 (class 2606 OID 17199)
-- Name: activist_pressures fk_rails_67eb37c69b; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_pressures
    ADD CONSTRAINT fk_rails_67eb37c69b FOREIGN KEY (cached_community_id) REFERENCES public.communities(id);


--
-- TOC entry 4474 (class 2606 OID 17204)
-- Name: facebook_bot_campaign_activists fk_rails_6ed0c7457d; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.facebook_bot_campaign_activists
    ADD CONSTRAINT fk_rails_6ed0c7457d FOREIGN KEY (facebook_bot_campaign_id) REFERENCES public.facebook_bot_campaigns(id);


--
-- TOC entry 4433 (class 2606 OID 17209)
-- Name: donations fk_rails_7217bc1bdf; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_7217bc1bdf FOREIGN KEY (cached_community_id) REFERENCES public.communities(id);


--
-- TOC entry 4445 (class 2606 OID 17214)
-- Name: activist_matches fk_rails_7701a28e7f; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_matches
    ADD CONSTRAINT fk_rails_7701a28e7f FOREIGN KEY (match_id) REFERENCES public.matches(id);


--
-- TOC entry 4448 (class 2606 OID 17219)
-- Name: activist_pressures fk_rails_7e28014775; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_pressures
    ADD CONSTRAINT fk_rails_7e28014775 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- TOC entry 4470 (class 2606 OID 17224)
-- Name: mobilization_activists fk_rails_821106ac31; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.mobilization_activists
    ADD CONSTRAINT fk_rails_821106ac31 FOREIGN KEY (mobilization_id) REFERENCES public.mobilizations(id);


--
-- TOC entry 4465 (class 2606 OID 17229)
-- Name: activist_facebook_bot_interactions fk_rails_8229429c26; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_facebook_bot_interactions
    ADD CONSTRAINT fk_rails_8229429c26 FOREIGN KEY (facebook_bot_configuration_id) REFERENCES public.facebook_bot_configurations(id);


--
-- TOC entry 4467 (class 2606 OID 17234)
-- Name: twilio_calls fk_rails_8329ec7002; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.twilio_calls
    ADD CONSTRAINT fk_rails_8329ec7002 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- TOC entry 4457 (class 2606 OID 17239)
-- Name: notifications fk_rails_893eb4f32e; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_893eb4f32e FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- TOC entry 4438 (class 2606 OID 17244)
-- Name: form_entries fk_rails_920c5d67ae; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.form_entries
    ADD CONSTRAINT fk_rails_920c5d67ae FOREIGN KEY (cached_community_id) REFERENCES public.communities(id);


--
-- TOC entry 4434 (class 2606 OID 17249)
-- Name: donations fk_rails_9279978f7a; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_9279978f7a FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- TOC entry 4435 (class 2606 OID 17254)
-- Name: donations fk_rails_98e396f4c1; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_98e396f4c1 FOREIGN KEY (local_subscription_id) REFERENCES public.subscriptions(id);


--
-- TOC entry 4471 (class 2606 OID 17259)
-- Name: mobilization_activists fk_rails_9c54902f75; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.mobilization_activists
    ADD CONSTRAINT fk_rails_9c54902f75 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- TOC entry 4468 (class 2606 OID 17264)
-- Name: community_activists fk_rails_a007365593; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.community_activists
    ADD CONSTRAINT fk_rails_a007365593 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- TOC entry 4442 (class 2606 OID 17269)
-- Name: communities fk_rails_a268b06370; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT fk_rails_a268b06370 FOREIGN KEY (recipient_id) REFERENCES public.recipients(id);


--
-- TOC entry 4436 (class 2606 OID 17274)
-- Name: donations fk_rails_aaa30ab12e; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_aaa30ab12e FOREIGN KEY (payable_transfer_id) REFERENCES public.payable_transfers(id);


--
-- TOC entry 4458 (class 2606 OID 17279)
-- Name: notifications fk_rails_b080fb4855; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_b080fb4855 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4466 (class 2606 OID 17284)
-- Name: activist_facebook_bot_interactions fk_rails_b2d73f1a99; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_facebook_bot_interactions
    ADD CONSTRAINT fk_rails_b2d73f1a99 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- TOC entry 4472 (class 2606 OID 17289)
-- Name: facebook_bot_campaigns fk_rails_b518e26154; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.facebook_bot_campaigns
    ADD CONSTRAINT fk_rails_b518e26154 FOREIGN KEY (facebook_bot_configuration_id) REFERENCES public.facebook_bot_configurations(id);


--
-- TOC entry 4437 (class 2606 OID 17294)
-- Name: donations fk_rails_c1941efec9; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT fk_rails_c1941efec9 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- TOC entry 4452 (class 2606 OID 17299)
-- Name: dns_hosted_zones fk_rails_c6b1f8b17a; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.dns_hosted_zones
    ADD CONSTRAINT fk_rails_c6b1f8b17a FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4463 (class 2606 OID 17304)
-- Name: invitations fk_rails_c70c9be1c0; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT fk_rails_c70c9be1c0 FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4439 (class 2606 OID 17309)
-- Name: form_entries fk_rails_cbe3790222; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.form_entries
    ADD CONSTRAINT fk_rails_cbe3790222 FOREIGN KEY (activist_id) REFERENCES public.activists(id);


--
-- TOC entry 4453 (class 2606 OID 17314)
-- Name: dns_records fk_rails_ce2c3e0b71; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.dns_records
    ADD CONSTRAINT fk_rails_ce2c3e0b71 FOREIGN KEY (dns_hosted_zone_id) REFERENCES public.dns_hosted_zones(id);


--
-- TOC entry 4464 (class 2606 OID 17319)
-- Name: balance_operations fk_rails_cee230e2a2; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.balance_operations
    ADD CONSTRAINT fk_rails_cee230e2a2 FOREIGN KEY (recipient_id) REFERENCES public.recipients(id);


--
-- TOC entry 4440 (class 2606 OID 17324)
-- Name: form_entries fk_rails_db28a0ad48; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.form_entries
    ADD CONSTRAINT fk_rails_db28a0ad48 FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- TOC entry 4451 (class 2606 OID 17329)
-- Name: activist_tags fk_rails_e8fa6ecb6c; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.activist_tags
    ADD CONSTRAINT fk_rails_e8fa6ecb6c FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4475 (class 2606 OID 174270)
-- Name: user_tags fk_rails_ea0382482a; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.user_tags
    ADD CONSTRAINT fk_rails_ea0382482a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4469 (class 2606 OID 17334)
-- Name: community_activists fk_rails_fa4f63f07b; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.community_activists
    ADD CONSTRAINT fk_rails_fa4f63f07b FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4462 (class 2606 OID 17339)
-- Name: subscriptions gateway_subscription_fk; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT gateway_subscription_fk FOREIGN KEY (gateway_subscription_id) REFERENCES public.gateway_subscriptions(id);


--
-- TOC entry 4490 (class 2606 OID 2904870)
-- Name: rede_groups rede_groups_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.rede_groups
    ADD CONSTRAINT rede_groups_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4491 (class 2606 OID 2904875)
-- Name: rede_groups rede_groups_widget_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.rede_groups
    ADD CONSTRAINT rede_groups_widget_id_fkey FOREIGN KEY (widget_id) REFERENCES public.widgets(id);


--
-- TOC entry 4493 (class 2606 OID 2904899)
-- Name: rede_individuals rede_individuals_form_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.rede_individuals
    ADD CONSTRAINT rede_individuals_form_entry_id_fkey FOREIGN KEY (form_entry_id) REFERENCES public.form_entries(id);


--
-- TOC entry 4492 (class 2606 OID 2904894)
-- Name: rede_individuals rede_individuals_rede_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.rede_individuals
    ADD CONSTRAINT rede_individuals_rede_group_id_fkey FOREIGN KEY (rede_group_id) REFERENCES public.rede_groups(id);


--
-- TOC entry 4495 (class 2606 OID 2904925)
-- Name: rede_relationships rede_relationships_recipient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.rede_relationships
    ADD CONSTRAINT rede_relationships_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public.rede_individuals(id);


--
-- TOC entry 4496 (class 2606 OID 2904930)
-- Name: rede_relationships rede_relationships_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.rede_relationships
    ADD CONSTRAINT rede_relationships_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4494 (class 2606 OID 2904920)
-- Name: rede_relationships rede_relationships_volunteer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.rede_relationships
    ADD CONSTRAINT rede_relationships_volunteer_id_fkey FOREIGN KEY (volunteer_id) REFERENCES public.rede_individuals(id);


--
-- TOC entry 4486 (class 2606 OID 744630)
-- Name: solidarity_matches solidarity_matches_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4482 (class 2606 OID 744610)
-- Name: solidarity_matches solidarity_matches_individuals_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_individuals_ticket_id_fkey FOREIGN KEY (individuals_ticket_id) REFERENCES public.solidarity_tickets(ticket_id);


--
-- TOC entry 4484 (class 2606 OID 744620)
-- Name: solidarity_matches solidarity_matches_individuals_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_individuals_user_id_fkey FOREIGN KEY (individuals_user_id) REFERENCES public.solidarity_users(user_id);


--
-- TOC entry 4483 (class 2606 OID 744615)
-- Name: solidarity_matches solidarity_matches_volunteers_ticket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_volunteers_ticket_id_fkey FOREIGN KEY (volunteers_ticket_id) REFERENCES public.solidarity_tickets(ticket_id);


--
-- TOC entry 4485 (class 2606 OID 744625)
-- Name: solidarity_matches solidarity_matches_volunteers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_matches
    ADD CONSTRAINT solidarity_matches_volunteers_user_id_fkey FOREIGN KEY (volunteers_user_id) REFERENCES public.solidarity_users(user_id);


--
-- TOC entry 4481 (class 2606 OID 744587)
-- Name: solidarity_tickets solidarity_tickets_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_tickets
    ADD CONSTRAINT solidarity_tickets_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id);


--
-- TOC entry 4480 (class 2606 OID 744558)
-- Name: solidarity_users solidarity_users_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reboo
--

ALTER TABLE ONLY public.solidarity_users
    ADD CONSTRAINT solidarity_users_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.communities(id);



--
-- TOC entry 4697 (class 0 OID 0)
-- Dependencies: 17
-- Name: SCHEMA pgjwt; Type: ACL; Schema: -; Owner: reboo
--

GRANT USAGE ON SCHEMA pgjwt TO postgraphql;
GRANT USAGE ON SCHEMA pgjwt TO anonymous;


--
-- TOC entry 4698 (class 0 OID 0)
-- Dependencies: 13
-- Name: SCHEMA postgraphql; Type: ACL; Schema: -; Owner: reboo
--

GRANT USAGE ON SCHEMA postgraphql TO anonymous;
GRANT USAGE ON SCHEMA postgraphql TO common_user;
GRANT USAGE ON SCHEMA postgraphql TO admin;


--
-- TOC entry 4699 (class 0 OID 0)
-- Dependencies: 14
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: reboo
--

GRANT USAGE ON SCHEMA public TO admin;
GRANT USAGE ON SCHEMA public TO postgraphql;
GRANT USAGE ON SCHEMA public TO common_user;
GRANT USAGE ON SCHEMA public TO anonymous;


--
-- TOC entry 4708 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE users; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.users TO common_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.users TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.users TO anonymous;


--
-- TOC entry 4710 (class 0 OID 0)
-- Dependencies: 292
-- Name: TABLE twilio_calls; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.twilio_calls TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.twilio_calls TO common_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.twilio_calls TO anonymous;


--
-- TOC entry 4711 (class 0 OID 0)
-- Dependencies: 295
-- Name: TABLE twilio_calls; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE postgraphql.twilio_calls TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE postgraphql.twilio_calls TO common_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE postgraphql.twilio_calls TO anonymous;


--
-- TOC entry 4712 (class 0 OID 0)
-- Dependencies: 300
-- Name: TABLE twilio_configurations; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE postgraphql.twilio_configurations TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE postgraphql.twilio_configurations TO common_user;


--
-- TOC entry 4713 (class 0 OID 0)
-- Dependencies: 628
-- Name: FUNCTION change_password(data json); Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT ALL ON FUNCTION postgraphql.change_password(data json) TO common_user;
GRANT ALL ON FUNCTION postgraphql.change_password(data json) TO admin;
GRANT ALL ON FUNCTION postgraphql.change_password(data json) TO anonymous;


--
-- TOC entry 4714 (class 0 OID 0)
-- Dependencies: 272
-- Name: TABLE invitations; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.invitations TO anonymous;
GRANT SELECT ON TABLE public.invitations TO common_user;
GRANT SELECT ON TABLE public.invitations TO admin;
GRANT SELECT ON TABLE public.invitations TO postgraphql;


--
-- TOC entry 4715 (class 0 OID 0)
-- Dependencies: 635
-- Name: FUNCTION create_community(data json); Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT ALL ON FUNCTION postgraphql.create_community(data json) TO common_user;
GRANT ALL ON FUNCTION postgraphql.create_community(data json) TO admin;
GRANT ALL ON FUNCTION postgraphql.create_community(data json) TO anonymous;


--
-- TOC entry 4716 (class 0 OID 0)
-- Dependencies: 630
-- Name: FUNCTION create_dns_record(data json); Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT ALL ON FUNCTION postgraphql.create_dns_record(data json) TO postgraphql;


--
-- TOC entry 4717 (class 0 OID 0)
-- Dependencies: 312
-- Name: TABLE facebook_bot_campaigns; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_campaigns TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_campaigns TO common_user;


--
-- TOC entry 4718 (class 0 OID 0)
-- Dependencies: 647
-- Name: FUNCTION create_tags(name text, label text); Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT ALL ON FUNCTION postgraphql.create_tags(name text, label text) TO common_user;
GRANT ALL ON FUNCTION postgraphql.create_tags(name text, label text) TO admin;
GRANT ALL ON FUNCTION postgraphql.create_tags(name text, label text) TO postgraphql;


--
-- TOC entry 4719 (class 0 OID 0)
-- Dependencies: 646
-- Name: FUNCTION create_user_tags(data json); Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT ALL ON FUNCTION postgraphql.create_user_tags(data json) TO common_user;
GRANT ALL ON FUNCTION postgraphql.create_user_tags(data json) TO admin;
GRANT ALL ON FUNCTION postgraphql.create_user_tags(data json) TO postgraphql;


--
-- TOC entry 4720 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE users; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.users TO common_user;
GRANT SELECT ON TABLE postgraphql.users TO admin;


--
-- TOC entry 4721 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE template_mobilizations; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.template_mobilizations TO common_user;


--
-- TOC entry 4722 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE activist_tags; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT ON TABLE public.activist_tags TO common_user;
GRANT SELECT,INSERT ON TABLE public.activist_tags TO admin;


--
-- TOC entry 4723 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE taggings; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT ON TABLE public.taggings TO common_user;
GRANT SELECT,INSERT ON TABLE public.taggings TO admin;


--
-- TOC entry 4724 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE tags; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.tags TO common_user;
GRANT SELECT,INSERT,UPDATE ON TABLE public.tags TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.tags TO postgraphql;


--
-- TOC entry 4725 (class 0 OID 0)
-- Dependencies: 289
-- Name: TABLE community_tags; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.community_tags TO common_user;
GRANT SELECT ON TABLE public.community_tags TO admin;


--
-- TOC entry 4726 (class 0 OID 0)
-- Dependencies: 290
-- Name: TABLE community_tags; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.community_tags TO common_user;
GRANT SELECT ON TABLE postgraphql.community_tags TO admin;


--
-- TOC entry 4729 (class 0 OID 0)
-- Dependencies: 660
-- Name: FUNCTION get_widget_donation_stats(widget_id integer); Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT ALL ON FUNCTION postgraphql.get_widget_donation_stats(widget_id integer) TO anonymous;


--
-- TOC entry 4730 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE activists; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT ON TABLE public.activists TO admin;
GRANT SELECT,INSERT ON TABLE public.activists TO common_user;


--
-- TOC entry 4731 (class 0 OID 0)
-- Dependencies: 302
-- Name: TABLE community_activists; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT ON TABLE public.community_activists TO common_user;
GRANT SELECT,INSERT ON TABLE public.community_activists TO admin;


--
-- TOC entry 4732 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE community_users; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT ON TABLE public.community_users TO common_user;
GRANT SELECT,INSERT ON TABLE public.community_users TO admin;
GRANT SELECT,INSERT ON TABLE public.community_users TO anonymous;
GRANT SELECT,INSERT ON TABLE public.community_users TO postgraphql;


--
-- TOC entry 4733 (class 0 OID 0)
-- Dependencies: 288
-- Name: TABLE activists; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.activists TO common_user;
GRANT SELECT ON TABLE postgraphql.activists TO admin;


--
-- TOC entry 4735 (class 0 OID 0)
-- Dependencies: 626
-- Name: FUNCTION total_sum_transfer_operations_from_community(community_id integer); Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT ALL ON FUNCTION postgraphql.total_sum_transfer_operations_from_community(community_id integer) TO common_user;
GRANT ALL ON FUNCTION postgraphql.total_sum_transfer_operations_from_community(community_id integer) TO admin;


--
-- TOC entry 4736 (class 0 OID 0)
-- Dependencies: 314
-- Name: TABLE facebook_bot_campaign_activists; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_campaign_activists TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_campaign_activists TO common_user;


--
-- TOC entry 4737 (class 0 OID 0)
-- Dependencies: 652
-- Name: FUNCTION configuration(name text); Type: ACL; Schema: public; Owner: reboo
--

GRANT ALL ON FUNCTION public.configuration(name text) TO postgraphql;
GRANT ALL ON FUNCTION public.configuration(name text) TO anonymous;


--
-- TOC entry 4738 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE form_entries; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.form_entries TO common_user;
GRANT SELECT ON TABLE public.form_entries TO admin;


--
-- TOC entry 4739 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE activist_pressures; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.activist_pressures TO common_user;
GRANT SELECT ON TABLE public.activist_pressures TO admin;


--
-- TOC entry 4741 (class 0 OID 0)
-- Dependencies: 262
-- Name: TABLE subscriptions; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.subscriptions TO common_user;
GRANT SELECT ON TABLE public.subscriptions TO admin;


--
-- TOC entry 4742 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE donations; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.donations TO common_user;
GRANT SELECT ON TABLE public.donations TO admin;
GRANT SELECT ON TABLE public.donations TO anonymous;



--
-- TOC entry 4744 (class 0 OID 0)
-- Dependencies: 632
-- Name: FUNCTION verify_custom_domain(); Type: ACL; Schema: public; Owner: reboo
--

GRANT ALL ON FUNCTION public.verify_custom_domain() TO postgraphql;
GRANT ALL ON FUNCTION public.verify_custom_domain() TO admin;


--
-- TOC entry 4747 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE communities; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT ON TABLE public.communities TO common_user;
GRANT SELECT,INSERT ON TABLE public.communities TO admin;


--
-- TOC entry 4750 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE mobilizations; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.mobilizations TO common_user;
GRANT SELECT ON TABLE public.mobilizations TO admin;
GRANT SELECT ON TABLE public.mobilizations TO postgraphql;

--
-- TOC entry 4754 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE notification_templates; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.notification_templates TO anonymous;
GRANT SELECT ON TABLE public.notification_templates TO common_user;
GRANT SELECT ON TABLE public.notification_templates TO admin;


--
-- TOC entry 4756 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE notifications; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT ON TABLE public.notifications TO anonymous;
GRANT SELECT,INSERT ON TABLE public.notifications TO common_user;
GRANT SELECT,INSERT ON TABLE public.notifications TO admin;

--
-- TOC entry 4758 (class 0 OID 0)
-- Dependencies: 282
-- Name: TABLE activist_facebook_bot_interactions; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.activist_facebook_bot_interactions TO admin;


--
-- TOC entry 4759 (class 0 OID 0)
-- Dependencies: 280
-- Name: TABLE facebook_bot_configurations; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_configurations TO admin;


--
-- TOC entry 4760 (class 0 OID 0)
-- Dependencies: 304
-- Name: TABLE mobilization_activists; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.mobilization_activists TO common_user;
GRANT SELECT ON TABLE public.mobilization_activists TO admin;


--
-- TOC entry 4761 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE activist_mobilizations; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.activist_mobilizations TO common_user;
GRANT SELECT ON TABLE postgraphql.activist_mobilizations TO admin;


--
-- TOC entry 4762 (class 0 OID 0)
-- Dependencies: 307
-- Name: TABLE activist_tags; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.activist_tags TO admin;
GRANT SELECT ON TABLE postgraphql.activist_tags TO common_user;


--
-- TOC entry 4763 (class 0 OID 0)
-- Dependencies: 278
-- Name: TABLE balance_operations; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.balance_operations TO common_user;
GRANT SELECT ON TABLE public.balance_operations TO admin;


--
-- TOC entry 4764 (class 0 OID 0)
-- Dependencies: 286
-- Name: TABLE balance_operation_summaries; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.balance_operation_summaries TO common_user;
GRANT SELECT ON TABLE public.balance_operation_summaries TO admin;


--
-- TOC entry 4765 (class 0 OID 0)
-- Dependencies: 287
-- Name: TABLE balance_operations; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.balance_operations TO common_user;
GRANT SELECT ON TABLE postgraphql.balance_operations TO admin;


--
-- TOC entry 4766 (class 0 OID 0)
-- Dependencies: 306
-- Name: TABLE facebook_activist_interactions; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.facebook_activist_interactions TO admin;
GRANT SELECT ON TABLE postgraphql.facebook_activist_interactions TO common_user;
GRANT SELECT ON TABLE postgraphql.facebook_activist_interactions TO anonymous;


--
-- TOC entry 4767 (class 0 OID 0)
-- Dependencies: 285
-- Name: TABLE bot_recipients; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.bot_recipients TO admin;


--
-- TOC entry 4768 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE communities; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.communities TO common_user;
GRANT SELECT ON TABLE postgraphql.communities TO admin;
GRANT SELECT ON TABLE postgraphql.communities TO postgraphql;


--
-- TOC entry 4769 (class 0 OID 0)
-- Dependencies: 274
-- Name: TABLE community_user_roles; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.community_user_roles TO common_user;
GRANT SELECT ON TABLE postgraphql.community_user_roles TO admin;


--
-- TOC entry 4770 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE blocks; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.blocks TO common_user;
GRANT SELECT ON TABLE public.blocks TO admin;


--
-- TOC entry 4771 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE widgets; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.widgets TO common_user;
GRANT SELECT ON TABLE public.widgets TO admin;
GRANT SELECT ON TABLE public.widgets TO anonymous;


--
-- TOC entry 4772 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE donations; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.donations TO common_user;
GRANT SELECT ON TABLE postgraphql.donations TO admin;


--
-- TOC entry 4773 (class 0 OID 0)
-- Dependencies: 283
-- Name: TABLE facebook_bot_configurations; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.facebook_bot_configurations TO admin;


--
-- TOC entry 4774 (class 0 OID 0)
-- Dependencies: 305
-- Name: TABLE facebook_bot_interactions; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.facebook_bot_interactions TO admin;
GRANT SELECT ON TABLE postgraphql.facebook_bot_interactions TO common_user;
GRANT SELECT ON TABLE postgraphql.facebook_bot_interactions TO anonymous;


--
-- TOC entry 4775 (class 0 OID 0)
-- Dependencies: 273
-- Name: TABLE activist_participations; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.activist_participations TO common_user;
GRANT SELECT ON TABLE public.activist_participations TO admin;


--
-- TOC entry 4776 (class 0 OID 0)
-- Dependencies: 275
-- Name: TABLE participations; Type: ACL; Schema: postgraphql; Owner: reboo
--

GRANT SELECT ON TABLE postgraphql.participations TO common_user;
GRANT SELECT ON TABLE postgraphql.participations TO admin;


--
-- TOC entry 4778 (class 0 OID 0)
-- Dependencies: 281
-- Name: SEQUENCE activist_facebook_bot_interactions_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.activist_facebook_bot_interactions_id_seq TO admin;


--
-- TOC entry 4782 (class 0 OID 0)
-- Dependencies: 251
-- Name: SEQUENCE activist_tags_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.activist_tags_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.activist_tags_id_seq TO admin;


--
-- TOC entry 4784 (class 0 OID 0)
-- Dependencies: 202
-- Name: SEQUENCE activists_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.activists_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.activists_id_seq TO postgraphql;
GRANT USAGE ON SEQUENCE public.activists_id_seq TO admin;


--
-- TOC entry 4794 (class 0 OID 0)
-- Dependencies: 216
-- Name: SEQUENCE communities_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.communities_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.communities_id_seq TO admin;


--
-- TOC entry 4796 (class 0 OID 0)
-- Dependencies: 301
-- Name: SEQUENCE community_activists_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.community_activists_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.community_activists_id_seq TO admin;


--
-- TOC entry 4798 (class 0 OID 0)
-- Dependencies: 240
-- Name: SEQUENCE community_users_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.community_users_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.community_users_id_seq TO admin;
GRANT USAGE ON SEQUENCE public.community_users_id_seq TO anonymous;
GRANT USAGE ON SEQUENCE public.community_users_id_seq TO postgraphql;


--
-- TOC entry 4799 (class 0 OID 0)
-- Dependencies: 328
-- Name: TABLE configurations; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT ON TABLE public.configurations TO postgraphql;
GRANT SELECT ON TABLE public.configurations TO anonymous;


--
-- TOC entry 4804 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE dns_records; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT ON TABLE public.dns_records TO admin;
GRANT SELECT,INSERT ON TABLE public.dns_records TO postgraphql;


--
-- TOC entry 4806 (class 0 OID 0)
-- Dependencies: 255
-- Name: SEQUENCE dns_records_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.dns_records_id_seq TO postgraphql;
GRANT USAGE ON SEQUENCE public.dns_records_id_seq TO admin;


--
-- TOC entry 4809 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE facebook_bot_activists; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_activists TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_activists TO common_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.facebook_bot_activists TO anonymous;


--
-- TOC entry 4811 (class 0 OID 0)
-- Dependencies: 308
-- Name: SEQUENCE facebook_bot_activists_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.facebook_bot_activists_id_seq TO admin;
GRANT USAGE ON SEQUENCE public.facebook_bot_activists_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.facebook_bot_activists_id_seq TO anonymous;


--
-- TOC entry 4813 (class 0 OID 0)
-- Dependencies: 313
-- Name: SEQUENCE facebook_bot_campaign_activists_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.facebook_bot_campaign_activists_id_seq TO admin;
GRANT USAGE ON SEQUENCE public.facebook_bot_campaign_activists_id_seq TO common_user;


--
-- TOC entry 4815 (class 0 OID 0)
-- Dependencies: 311
-- Name: SEQUENCE facebook_bot_campaigns_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.facebook_bot_campaigns_id_seq TO admin;
GRANT USAGE ON SEQUENCE public.facebook_bot_campaigns_id_seq TO common_user;


--
-- TOC entry 4817 (class 0 OID 0)
-- Dependencies: 279
-- Name: SEQUENCE facebook_bot_configurations_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.facebook_bot_configurations_id_seq TO admin;


--
-- TOC entry 4827 (class 0 OID 0)
-- Dependencies: 259
-- Name: SEQUENCE notifications_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.notifications_id_seq TO anonymous;
GRANT USAGE ON SEQUENCE public.notifications_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.notifications_id_seq TO admin;


--
-- TOC entry 4844 (class 0 OID 0)
-- Dependencies: 249
-- Name: SEQUENCE taggings_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.taggings_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.taggings_id_seq TO admin;


--
-- TOC entry 4846 (class 0 OID 0)
-- Dependencies: 247
-- Name: SEQUENCE tags_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.tags_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.tags_id_seq TO admin;


--
-- TOC entry 4850 (class 0 OID 0)
-- Dependencies: 294
-- Name: TABLE twilio_call_transitions; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.twilio_call_transitions TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.twilio_call_transitions TO common_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.twilio_call_transitions TO anonymous;


--
-- TOC entry 4853 (class 0 OID 0)
-- Dependencies: 291
-- Name: SEQUENCE twilio_calls_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.twilio_calls_id_seq TO admin;
GRANT USAGE ON SEQUENCE public.twilio_calls_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.twilio_calls_id_seq TO anonymous;


--
-- TOC entry 4855 (class 0 OID 0)
-- Dependencies: 298
-- Name: SEQUENCE twilio_configurations_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.twilio_configurations_id_seq TO admin;
GRANT USAGE ON SEQUENCE public.twilio_configurations_id_seq TO common_user;


--
-- TOC entry 4856 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE user_tags; Type: ACL; Schema: public; Owner: reboo
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.user_tags TO common_user;
GRANT SELECT,INSERT,UPDATE ON TABLE public.user_tags TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.user_tags TO postgraphql;


--
-- TOC entry 4858 (class 0 OID 0)
-- Dependencies: 329
-- Name: SEQUENCE user_tags_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.user_tags_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.user_tags_id_seq TO admin;


--
-- TOC entry 4860 (class 0 OID 0)
-- Dependencies: 223
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: reboo
--

GRANT USAGE ON SEQUENCE public.users_id_seq TO anonymous;
GRANT USAGE ON SEQUENCE public.users_id_seq TO common_user;
GRANT USAGE ON SEQUENCE public.users_id_seq TO admin;


--
-- TOC entry 3980 (class 3466 OID 174513)
-- Name: postgraphile_watch_ddl; Type: EVENT TRIGGER; Schema: -; Owner: rdsadmin
--

CREATE EVENT TRIGGER postgraphile_watch_ddl ON ddl_command_end
         WHEN TAG IN ('ALTER DOMAIN', 'ALTER FOREIGN TABLE', 'ALTER FUNCTION', 'ALTER SCHEMA', 'ALTER TABLE', 'ALTER TYPE', 'ALTER VIEW', 'COMMENT', 'CREATE DOMAIN', 'CREATE FOREIGN TABLE', 'CREATE FUNCTION', 'CREATE SCHEMA', 'CREATE TABLE', 'CREATE TABLE AS', 'CREATE VIEW', 'DROP DOMAIN', 'DROP FOREIGN TABLE', 'DROP FUNCTION', 'DROP SCHEMA', 'DROP TABLE', 'DROP VIEW', 'GRANT', 'REVOKE', 'SELECT INTO')
   EXECUTE FUNCTION postgraphile_watch.notify_watchers_ddl();

--
-- TOC entry 3981 (class 3466 OID 174514)
-- Name: postgraphile_watch_drop; Type: EVENT TRIGGER; Schema: -; Owner: rdsadmin
--

CREATE EVENT TRIGGER postgraphile_watch_drop ON sql_drop
   EXECUTE FUNCTION postgraphile_watch.notify_watchers_drop();


--
-- TOC entry 3979 (class 3466 OID 148800)
-- Name: postgraphql_watch; Type: EVENT TRIGGER; Schema: -; Owner: rdsadmin
--

CREATE EVENT TRIGGER postgraphql_watch ON ddl_command_end
         WHEN TAG IN ('ALTER DOMAIN', 'ALTER FOREIGN TABLE', 'ALTER FUNCTION', 'ALTER SCHEMA', 'ALTER TABLE', 'ALTER TYPE', 'ALTER VIEW', 'COMMENT', 'CREATE DOMAIN', 'CREATE FOREIGN TABLE', 'CREATE FUNCTION', 'CREATE SCHEMA', 'CREATE TABLE', 'CREATE TABLE AS', 'CREATE VIEW', 'DROP DOMAIN', 'DROP FOREIGN TABLE', 'DROP FUNCTION', 'DROP SCHEMA', 'DROP TABLE', 'DROP VIEW', 'GRANT', 'REVOKE', 'SELECT INTO')
   EXECUTE FUNCTION postgraphql_watch.notify_watchers();


-- Completed on 2021-10-01 17:02:48 -03

--
-- PostgreSQL database dump complete
--

