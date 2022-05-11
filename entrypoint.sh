#!/bin/sh -l
echo "$@"

echo "API Key: $INPUT_APIKEY"
echo "Org ID: $INPUT_ORGID"
echo "Project Name: $INPUT_PROJECTNAME"
echo "API URL $INPUT_APIURL"
echo "Auth Header: $INPUT_AUTHHEADER"
echo "Artifact: $INPUT_ARTIFACT"
echo "SARIF Output: $INPUT_SARIF"
echo "Languages: $INPUT_LANGUAGE"
echo "Timeout: $INPUT_TIMEOUT"

contrast-cli --api_key "$INPUT_APIKEY" --authorization "$INPUT_AUTHHEADER" --host "$INPUT_APIURL" --application_id "none" --organization_id "$INPUT_ORGID" --project_name "$INPUT_PROJECTNAME" --scan "$INPUT_ARTIFACT" --scan_timeout "$INPUT_TIMEOUT:=300" --language "$INPUT_LANGUAGE" --wait_for_scan --save_scan_results
