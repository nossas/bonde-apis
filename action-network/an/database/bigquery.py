from google.cloud import bigquery
import pandas_gbq

client = bigquery.Client()


def insert_actions(df, project_id="data-bonde", table_id="analyze.actions"):
    """Insert actions table"""
    pandas_gbq.to_gbq(df, table_id, project_id=project_id, if_exists="append")


def insert_activist_actions(df, project_id="data-bonde", table_id="analyze.activist_actions"):
    """Insert activist_actions table"""
    pandas_gbq.to_gbq(df, table_id, project_id=project_id, if_exists="append")


def select_groups(project_id="data-bonde"):
    """Fetch groups table"""
    # Run a Standard SQL query
    sql = "SELECT * FROM analyze.groups g"
    return pandas_gbq.read_gbq(sql, project_id=project_id, dialect='standard')
