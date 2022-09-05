from google.cloud import bigquery
import pandas_gbq

client = bigquery.Client()


def insert_actions(df, project_id="data-bonde", table_id="analyze.actions"):
    """Insert actions table"""
    pandas_gbq.to_gbq(df, table_id, project_id=project_id, if_exists="append")


def insert_activist_actions(df, project_id="data-bonde", table_id="analyze.activist_actions"):
    """Insert activist_actions table"""
    pandas_gbq.to_gbq(df, table_id, project_id=project_id, if_exists="append")


def insert_themes(df, project_id="data-bonde", table_id="analyze.themes"):
    """Insert themes table"""
    pandas_gbq.to_gbq(df, table_id, project_id=project_id, if_exists="append")


def update_activist_actions(an_response: str, action_id: int, action: str):
    """Update activist_actions table"""
    sql = f'''
    UPDATE `log.activist_actions` aa
    SET aa.an_response='{an_response}'
    WHERE aa.action_id={action_id} AND aa.action='{action}'
    '''
    query_job = client.query(sql)
    query_job.result()


def select_groups(project_id="data-bonde"):
    """Fetch groups table"""
    # Run a Standard SQL query
    sql = "SELECT * FROM analyze.groups g"
    return pandas_gbq.read_gbq(sql, project_id=project_id, dialect='standard')


# SELECT
#     aa.action,
#     aa.action_id,
#     aa.action_date,
#     aa.widget_id,
#     aa.mobilization_id,
#     aa.community_id,
#     aa.email,
#     aa.name,
#     aa.given_name,
#     aa.family_name,
#     aa.address_line,
#     aa.locality,
#     aa.region,
#     aa.postal_code,
#     aa.phone,
#     aa.gender,
#     aa.color,
#     aa.birthday,
#     aa.amount,
#     a.an_action_id,
#     a.an_resource_name,
#     g.an_group_id,
#     aa_log.an_response
# FROM `analyze.activist_actions` aa
# INNER JOIN `analyze.actions` a ON a.widget_id = aa.widget_id
# INNER JOIN `analyze.groups` g ON g.community_id = a.community_id
# FULL OUTER JOIN `log.activist_actions` aa_log ON aa_log.action_id = aa.action_id AND aa_log.action = aa.action
# WHERE g.community_id = 263 AND aa_log.an_response IS NULL;

def select_activist_actions(project_id="data-bonde", **kwargs):
    """Fetch activist actions table"""
    sql = '''
    SELECT
        aa.action,
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
        aa.amount,
        a.an_action_id,
        a.an_resource_name,
        a.mobilization_name,
        g.an_group_id,
        aa_log.an_response
    FROM `analyze.activist_actions` aa
    INNER JOIN `analyze.actions` a ON a.widget_id = aa.widget_id
    INNER JOIN `analyze.groups` g ON g.community_id = a.community_id
    FULL OUTER JOIN `log.activist_actions` aa_log ON aa_log.action_id = aa.action_id AND aa_log.action = aa.action
    '''

    filters = []

    if kwargs['community_id']:
        filters.append(f"g.community_id = {kwargs['community_id']}")

    if kwargs['start_date'] and kwargs['end_date']:
        filters.append(f"aa.action_date >= '{kwargs['start_date']}'")
        filters.append(f"aa.action_date <= '{kwargs['end_date']}'")

    for i, item in enumerate(filters):
        if i == 0:
            sql += f"WHERE {item} "
        else:
            sql += f"AND {item} "

    sql += f"order by aa.action_date desc"

    return pandas_gbq.read_gbq(sql, project_id=project_id, dialect='standard')

def select_activist_actions_update(project_id="data-bonde", **kwargs):
    """Fetch activist actions table"""
    sql = '''
    SELECT
        *
    FROM `analyze.update_an` aa
    INNER JOIN `analyze.actions` a ON a.widget_id = aa.widget_id
    INNER JOIN `analyze.groups` g ON g.community_id = a.community_id
    '''

    filters = []

    if kwargs['community_id']:
        filters.append(f"g.community_id = {kwargs['community_id']}")

    if kwargs['start_date'] and kwargs['end_date']:
        filters.append(f"aa.action_date >= '{kwargs['start_date']}'")
        filters.append(f"aa.action_date <= '{kwargs['end_date']}'")

    for i, item in enumerate(filters):
        if i == 0:
            sql += f"WHERE {item} "
        else:
            sql += f"AND {item} "

    return pandas_gbq.read_gbq(sql, project_id=project_id, dialect='standard')


def select_themes(project_id="data-bonde"):
    """Fetch themes table"""
    sql = 'SELECT * FROM `analyze.themes`'

    return pandas_gbq.read_gbq(sql, project_id=project_id)
