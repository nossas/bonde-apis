from google.cloud import bigquery
import pandas_gbq

client = bigquery.Client()

def insert(df, project_id="data-bonde", table_id="analyze.activist_actions"):
    # Insert on table
    pandas_gbq.to_gbq(df, table_id, project_id=project_id, if_exists="append")
