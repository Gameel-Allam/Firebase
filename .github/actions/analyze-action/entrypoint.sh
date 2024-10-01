#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

ZIP_FILE='repo.zip'
ANALYSIS_URL=$1

echo "Zipping repository..."
zip -r $ZIP_FILE .

echo "Uploading $ZIP_FILE to analysis app at $ANALYSIS_URL"
ANALYSIS_RESULT=$(curl -s -X POST "$ANALYSIS_URL" \
  -F "file=@$ZIP_FILE" \
  | jq -r '.status')

echo "Analysis result: $ANALYSIS_RESULT"

# Set the action output
echo "::set-output name=result::$ANALYSIS_RESULT"

# Exit with a failure if the analysis failed
if [ "$ANALYSIS_RESULT" == "fail" ]; then
  echo "Deployment blocked: Analysis failed."
  exit 1
fi

echo "Analysis passed, proceeding with deployment."
