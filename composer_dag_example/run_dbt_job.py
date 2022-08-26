from __future__ import print_function

import datetime

from airflow import models
from airflow.operators import bash_operator
from airflow.operators import python_operator
from airflow.kubernetes.secret import Secret
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator

default_dag_args = {
    # The start_date describes when a DAG is valid / can be run. Set this to a
    # fixed point in time rather than dynamically, since it is evaluated every
    # time a DAG is parsed. See:
    # https://airflow.apache.org/faq.html#what-s-the-deal-with-start-date
    'start_date': datetime.datetime(2018, 1, 1),
}

# Define a DAG (directed acyclic graph) of tasks.
# Any task you create within the context manager is automatically added to the
# DAG object.
with models.DAG(
        'run_dbt_job',
        schedule_interval=None,
        default_args=default_dag_args) as dag:
    def log_message(message):
        import logging
        logging.info(message)

    # commands to be run in K8S operator task
    commands = [
    'git clone https://github.com/avensolutions/google-data-workshop.git',
    'cd google-data-workshop/dbt_example',
    'dbt parse --profiles-dir .',
    'dbt run --profiles-dir .',
    'dbt test --profiles-dir .'
    ]
    

    # example python operator usage
    python_task = python_operator.PythonOperator(
        task_id='python_task',
        python_callable=log_message('Running a task usign the python operator'))

    # example bash operator usage
    bash_task = bash_operator.BashOperator(
        task_id='bash_task',
        bash_command='Running a bash task')

    kubernetes_task = KubernetesPodOperator(
        # The ID specified for the task.
        task_id='kubernetes_task',
        # Name of task you want to run, used to generate Pod ID.
        name='pod-ex-minimum',
        # Entrypoint of the container, if not specified the Docker container's
        # entrypoint is used. The cmds parameter is templated.
        cmds=commands,
        # The namespace to run within Kubernetes, default namespace is
        # `default`. There is the potential for the resource starvation of
        # Airflow workers and scheduler within the Cloud Composer environment,
        # the recommended solution is to increase the amount of nodes in order
        # to satisfy the computing requirements. Alternatively, launching pods
        # into a custom namespace will stop fighting over resources.
        namespace='default',
        # Docker image specified. Defaults to hub.docker.com, but any fully
        # qualified URLs will point to a custom repository. Supports private
        # gcr.io images if the Composer Environment is under the same
        # project-id as the gcr.io images and the service account that Composer
        # uses has permission to access the Google Container Registry
        # (the default service account has permission)
        image='ghcr.io/dbt-labs/dbt-bigquery:1.2.latest')

    # Define the order in which the tasks complete by using the >> and <<
    # operators
    python_task >> bash_task >> kubernetes_task