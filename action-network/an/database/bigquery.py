from google.cloud import bigquery
import pandas_gbq

client = bigquery.Client()

def insertactions(df_an, project_id="data-bonde", table_id="analyze.actions"):
    # Insert on table
    pandas_gbq.to_gbq(df, table_id, project_id=project_id, if_exists="append")

def insert(df, project_id="data-bonde", table_id="analyze.activist_actions"):
    # Insert on table
    pandas_gbq.to_gbq(df, table_id, project_id=project_id, if_exists="append")

def read(project_id="data-bonde"):
    # Read table
    sql = """
    SELECT
      * 
    FROM analyze.groups g """

    # Run a Standard SQL query
    df_groups = pandas_gbq.read_gbq(sql, project_id=project_id, dialect='standard')