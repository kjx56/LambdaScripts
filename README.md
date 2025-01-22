# LambdaScripts
A repository of bash scripts to optimize working with AWS Lambdas efficiently 

Prerequisites

BASH -- THAT SHOULD GO WITHOUT SAYING
Install AWS CLI and configure to preferred account
Install SAM CLI

STEPS

CD to script location folder

Make the script executable:
chmod +x <scriptname.sh>  e.g  chmod +x download_lambda_functions.sh

Run the script:
./<scriptname.sh>   e.g   ./download_lambda_functions.sh

Scripts -

download_all_lambda_functions.sh - This allows users to automatically download all Lambda functions for an AWS account 

unzip_all.sh - Unzip all lambda functions that are Zipped 
Note: store all zipped files or lambdas in the same 
directory and run script in the same directory all zip files will be uncompressed into named folders,

generate_resources.sh - Automatically creates a SAM .yaml file from all the unzipped lambda function folders
Note: Run script in the same folder as all the unzipped lambda functions


