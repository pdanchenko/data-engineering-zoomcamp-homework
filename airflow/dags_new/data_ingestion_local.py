import os
from datetime import datetime

from airflow import DAG

from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator

url = "https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_{{ execution_date.strftime(\'%Y-%m\') }}.csv"
AIRFLOW_HOME = os.environ.get("AIRFLOW_HOME", "/opt/airflow/")
URL_PREFIX = 'https://s3.amazonaws.com/nyc-tlc/trip+data' 
URL_TEMPLATE = URL_PREFIX + '/yellow_tripdata_{{ execution_date.strftime(\'%Y-%m\') }}.csv'
OUTPUT_FILE_TEMPLATE = AIRFLOW_HOME + '/output_{{ execution_date.strftime(\'%Y-%m\') }}.csv'
TABLE_NAME_TEMPLATE = 'yellow_taxi_{{ execution_date.strftime(\'%Y_%m\') }}'


local_workflow = DAG(
    dag_id="local_ingestion_dag",
    start_date=datetime(2021, 1, 1),
    schedule_interval="0 6 2 * *"
)

with local_workflow:
    wget_task = BashOperator(
        task_id="get_yellow_taxi_file",
        bash_command=f"curl -sSL {url} > {OUTPUT_FILE_TEMPLATE}"
    )

    ingest_task = BashOperator(
        task_id="ingest",
        bash_command=f"ls {AIRFLOW_HOME}"
    )

    wget_task >> ingest_task