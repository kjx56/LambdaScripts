#!/bin/bash

# Generates YAML resources for all Lambda functions in the current directory.

OUTPUT_FILE="template.yaml"

# YAML Header
cat <<EOL > $OUTPUT_FILE
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31
Description: >
  SAM Template for deploying Lambda functions based on folder names.

Globals:
  Function:
    Timeout: 3
    MemorySize: 128
    Tracing: Active
    LoggingConfig:
      LogFormat: JSON

  Api:
    TracingEnabled: true

Resources:
EOL

# Declare an array to store the logical ids for output generation
declare -a FUNCTION_NAMES

# Iterate over all folders in the current directory to create Lambda functions
for dir in */; do
  FUNCTION_NAME=$(basename "$dir")
  LOGICAL_ID=$(echo "$FUNCTION_NAME" | sed 's/[_-]//g')  # Remove underscores and hyphens

  # Add the Lambda function resource
  cat <<EOL >> $OUTPUT_FILE
  ${LOGICAL_ID}Function:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: $dir
      Handler: index.handler
      Runtime: nodejs22.x
      Architectures:
        - x86_64
      Events:
        ${LOGICAL_ID}Event:
          Type: Api
          Properties:
            Path: /${FUNCTION_NAME}
            Method: POST

EOL

  # Store the logical id for later use in outputs
  FUNCTION_NAMES+=("$LOGICAL_ID")
done

# Now, add the Outputs section after all Lambda functions are defined
cat <<EOL >> $OUTPUT_FILE

Outputs:
EOL

# Loop through the stored logical ids and generate the output for each Lambda function
for LOGICAL_ID in "${FUNCTION_NAMES[@]}"; do
  FUNCTION_NAME=$(echo "$LOGICAL_ID" | sed 's/^[^a-zA-Z0-9]*//;s/[^a-zA-Z0-9]*$//')  # Recover the function name from the logical id

  cat <<EOL >> $OUTPUT_FILE
  ${LOGICAL_ID}ApiEndpoint:
    Description: API Gateway endpoint URL for Prod stage for ${FUNCTION_NAME} function.
    Value: !Sub "https://\${ServerlessRestApi}.execute-api.\${AWS::Region}.amazonaws.com/Prod/${FUNCTION_NAME}/"

  ${LOGICAL_ID}FunctionIamRole:
    Description: IAM Role ARN created for ${FUNCTION_NAME} Lambda Function.
    Value: !GetAtt ${LOGICAL_ID}FunctionRole.Arn

EOL
done

echo "Resources and outputs have been generated in $OUTPUT_FILE"
