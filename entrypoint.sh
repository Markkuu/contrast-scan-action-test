#!/bin/sh -l
echo "API Key: $INPUT_APIKEY"
echo "Org ID: $INPUT_ORGID"
echo "Project Name: $INPUT_PROJECTNAME"
echo "Project ID: $INPUT_PROJECTID"
echo "API URL $INPUT_APIURL"
echo "Auth Header: $INPUT_AUTHHEADER"
echo "Artifact: $INPUT_ARTIFACT"
echo "SARIF Output: $INPUT_SARIF"
echo "Languages: $INPUT_LANGUAGE"
echo "Timeout: $INPUT_TIMEOUT"

contrast-cli --scan "$INPUT_ARTIFACT" --api_key "$INPUT_APIKEY"  --authorization "$INPUT_AUTHHEADER" --organization_id "$INPUT_INPUT_ORGID" --host "$INPUT_HOST" --project_name "$INPUT_PROJECTNAME" --language "$INPUT_LANGUAGE" --scan_timeout "${INPUT_TIMEOUT:-300}" --wait_for_scan --save_scan_results
