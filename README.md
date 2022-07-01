# A simple diagram about the solution:

![diagram](diagram/project01.png)

# Prerequisites to run example Infrastructure 
* Create a S3 Bucket, for the Terraform state files *(example name: example-app-tfstate)*
* Install terraform in the machines that will execute. *(Ref: https://learn.hashicorp.com/tutorials/terraform/install-cli)*
* Install terragrunt in the machines that will execute. *(Ref: https://terragrunt.gruntwork.io/docs/getting-started/install/)*
* Install AWS CLI. *(Ref:https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)* in the machines that will execute.
* To have or create a IAM user with admin permissions to create and manage the AWS resources.
* Use a key encrypt software, like GPG keychain. *(Ref:https://gpgtools.org/)*

# How to create example Infrastructure
## AWS example variables and parameters
Since the development of the TF templates and all of the infrastructure was done on a example AWS account, information like vpc id, subnets, ip’s... is specific for our
environment.

1. With your IAM programmatically credentials, login to  AWS CLI running:
```shell
aws configure
 ```
2. Go to the directory:
```shell
 cd /infra-organization/master
 ```
3. Run the init.sh script:
```shell
 ./init.sh
 ```
