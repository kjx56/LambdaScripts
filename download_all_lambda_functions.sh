#!/bin/bash

# Ensure AWS CLI and jq are installed
if ! command -v aws &> /dev/null; then
  echo "AWS CLI not installed. Please install it first."
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo "jq not installed. Please install it first."
  exit 1
fi

# Directory to store downloaded Lambda function packages
OUTPUT_DIR="lambda_functions"
mkdir -p "$OUTPUT_DIR"

# List all Lambda functions
echo "Fetching list of Lambda functions..."
LAMBDA_FUNCTIONS=$(aws lambda list-functions --output json | jq -r '.Functions[].FunctionName')

if [[ -z "$LAMBDA_FUNCTIONS" ]]; then
  echo "No Lambda functions found."
  exit 0
fi

# Loop through each function and download the code
for FUNCTION_NAME in $LAMBDA_FUNCTIONS; do
  echo "Processing Lambda function: $FUNCTION_NAME"

  # Get the function code URL
  CODE_URL=$(aws lambda get-function --function-name "$FUNCTION_NAME" --output json | jq -r '.Code.Location')
  
  if [[ -z "$CODE_URL" ]]; then
    echo "Failed to retrieve code for function: $FUNCTION_NAME"
    continue
  fi

  # Download the code package
  OUTPUT_FILE="$OUTPUT_DIR/${FUNCTION_NAME}.zip"
  echo "Downloading code package for $FUNCTION_NAME to $OUTPUT_FILE..."
  curl -s -o "$OUTPUT_FILE" "$CODE_URL"

  if [[ $? -eq 0 ]]; then
    echo "Downloaded successfully."
  else
    echo "Failed to download code for function: $FUNCTION_NAME"
  fi
done

echo "All Lambda functions processed. Check the $OUTPUT_DIR directory for downloaded packages."

