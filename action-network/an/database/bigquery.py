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
    UPDATE `analyze.activist_actions` aa
    SET aa.an_response={an_response}
    WHERE aa.action_id={action_id} AND aa.action={action}
    '''
    query_job = client.query(sql)
    query_job.result()


def select_groups(project_id="data-bonde"):
    """Fetch groups table"""
    # Run a Standard SQL query
    sql = "SELECT * FROM analyze.groups g"
    return pandas_gbq.read_gbq(sql, project_id=project_id, dialect='standard')


def select_activist_actions(community_id, start_date, end_date, project_id="data-bonde"):
    """Fetch activist actions table"""
    sql = f'''
    SELECT
        *
    FROM `analyze.activist_actions` aa
    INNER JOIN `analyze.actions` a ON a.widget_id = aa.widget_id
    INNER JOIN `analyze.groups` g ON g.community_id = a.community_id
    WHERE aa.action_date >= '{start_date}'
    AND aa.action_date <= '{end_date}'
    AND g.community_id = {community_id}
    '''

    return pandas_gbq.read_gbq(sql, project_id=project_id, dialect='standard')


def select_themes(project_id="data-bonde"):
    """Fetch themes table"""
    sql = 'SELECT * FROM `analyze.themes`'

    return pandas_gbq.read_gbq(sql, project_id=project_id)
