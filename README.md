# Google Data Workshop Resources

This repository contains resources and instructions for exercises using Terraform, DBT and Composer to build and operate a Google data environment.    

## Setup

Clone this repository to your Cloud Shell environment, you will then use the Cloud Shell Editor to make changes to files locally.  

## Environment Deployment and Configuration using Terraform

Each student will create two Big Query datasets (representing a `conformed` and `presentation` tier) encyrpted with a unique KMS key using CMEK.  This will be peformed in two *pseudo* environments (`prod` and `nonprod`).  

As all resources will be created in the same project, a prefix (as seen in `prod.tfvars` and `nonprod.tfvars`) will be appended to resource names along with the students surname.  For instance if the student's surname is `Smith` then the datasets would be named `prod-smith-conformed`, `nonprod-smith-presentation`, etc.  

Modify the files created in the `terraform` directory to perform the steps below.  

### Step 1 - Create a KMS Key Ring and Key for the `nonprod` environment

Use the information in [__kms_key_ring__](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring) and [__kms_crypto_key__](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/kms_crypto_key) to create a KMS Key Ring and Key for non prod environment.  

> Include your __surname__ and the __environment name__ in the key ring name and key name.

Generate a plan using `terraform plan` and execute it using `terraform apply`.  

### Step 2 - Create a KMS Key Ring and Key for the `prod` environment

Follow the pattern from step 1 to create a KMS Key Ring and Key for the `prod` environment.  

### Step 3 - Create datasets for the `conformed` and `presentation` tiers in the `prod` and `nonprod` environments

Use the information in [__bigquery_dataset__](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset) to create datasets for the `conformed` and `presentation` tiers in the `prod` and `nonprod` environments.  

The datasets should be located in `australia-southeast1` and encrypted with the KMS Keys created in step 1 and 2 respectively.  All other settings should be left at defaults.  

Generate a plan using `terraform plan` and execute it using `terraform apply`.  

### Step 4 - Create an IAM binding for the `presentation` tier in the `prod` environment

Use the information in [__google_bigquery_dataset_iam_binding__](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset_iam#google_bigquery_dataset_iam_binding) to create an IAM binding for the `presentation` tier in the `prod` environment allowing the user `javen@avensolutions` to access the dataset with the role of `roles/bigquery.dataViewer`.  

### Challenge

Perform any other actions required to allow the user in the role binding in Step 4 to access the dataset. 

## DBT Challenge

> An example `dbt` project is included in the [__dbt_example__](https://github.com/avensolutions/google-data-workshop/tree/main/dbt_example) directory for your reference.   

In your cloud shell, install `dbt` using the command below:  

```
sudo pip install \
  dbt-core \
  dbt-bigquery
```

use `dbt init` to create an empty `dbt` project.  

create a target table in the `conformed` tier dataset in the `nonprod` environment by joining the following datasets:  

`bigquery-public-data.san_francisco.bikeshare_stations`
`bigquery-public-data.san_francisco.bikeshare_status`

The target table (named `station_bikes_status`) schema required is:  

```	
station_id
station_name	
latitude
Latitude
dockcount
landmark
installation_date
bikes_available
docks_available
time
```

__Challenge__:

Create a target table in the `presentation` tier (called `station_bikes_status_by_month`) which shows averages for the `bikes_available` and `docks_available` fields for each month in every year avaiable in the source tables, return all other fields (except `bikes_available`, `docks_available` and `time`) as well.  

## Composer Challenge

Look at the example DAG in [composer_dag_example](https://github.com/avensolutions/google-data-workshop/tree/main/composer_dag_example).  Rename this dag using your surname, save the file and copy it to the DAGs directory in GCS, run the job using the Airflow UI.  

__Challenge__:

How would you restructure this DAG?  