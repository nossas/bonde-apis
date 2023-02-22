import requests
import pandas as pd
from database import engine, log_activist_actions

sql = f"""
SELECT
    a.an_action_id,
    c.id as community_id,
    c.an_group_id,
    aa.email,
    log_aa.an_response->'_links'->'self'->>'href' as submission_uri,
    log_aa.an_response->'_links'->'osdi:form'->>'href' as form_uri,
    log_aa.an_response->'_links'->'osdi:person'->>'href' as person_uri,
    COALESCE((
	SELECT sum(ps.confirmed_signatures)
        FROM plip_signatures as ps
	WHERE ps.widget_id = aa.widget_id
	AND ps.unique_identifier = aa.metadata->>'unique_identifier'
    ), 0) as confirmed_signatures
FROM "analyze".activist_actions aa
INNER JOIN "analyze".actions a ON a.widget_id = aa.widget_id
INNER JOIN "public".communities c ON c.id = aa.community_id
INNER JOIN "analyze".log_activist_actions log_aa ON log_aa.widget_id = aa.widget_id AND log_aa.action_id = aa.action_id
WHERE aa.action = 'plip'
AND COALESCE((
    SELECT sum(ps.confirmed_signatures)
    FROM plip_signatures as ps
    WHERE ps.widget_id = aa.widget_id
    AND ps.unique_identifier = aa.metadata->>'unique_identifier'
), 0) > 0
;
"""

def submit(query_sql, thread_name):
    print(f"{thread_name}: Starting actions submit")
    df = pd.read_sql_query(query_sql, engine)

    print(f"Total: {len(df)}")

if __name__ == '__main__':
    submit(sql, "No thread")
