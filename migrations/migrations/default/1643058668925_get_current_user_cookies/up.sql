CREATE OR REPLACE FUNCTION public.get_current_user(
	hasura_session json)
    RETURNS SETOF users 
    LANGUAGE 'sql'
    COST 100
    STABLE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
  select * from users where id = (hasura_session ->> 'x-hasura-user-id')::Int
$BODY$;
