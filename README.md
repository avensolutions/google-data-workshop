# Google Workshop Resources Terraform Repository

This repository contains the Terraform configuration for the Google Workshop Resources.  

## Overview

In this exercise you will clone this repository to your Cloud Shell environment, make the necessary changes, and deploy the resources using Terraform.  

## Requirements

Each student will create two Big Query datasets (representing a `conformed` and `presentation` tier) encyrpted with a unique KMS key using CMEK.  This will be peformed in two *pseudo* environments (`prod` and `nonprod`).  

As all resources will be created in the same project, a prefix (as seen in `prod.tfvars` and `nonprod.tfvars`) will be appended to resource names along with the students surname.  For instance if the student's surname is `Smith` then the datasets would be named `prod-smith-conformed`, `nonprod-smith-presentation`, etc.  


