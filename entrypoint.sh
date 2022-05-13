#!/bin/sh -l

echo "API Key: $INPUT_APIKEY"
echo "Org ID: $INPUT_ORGID"
echo "Project Name: $INPUT_PROJECTNAME"
echo "API URL $INPUT_APIURL"
echo "Auth Header: $INPUT_AUTHHEADER"
echo "Artifact: $INPUT_ARTIFACT"
echo "SARIF Output: $INPUT_SARIF"
echo "Languages: $INPUT_LANGUAGE"
echo "Timeout: $INPUT_TIMEOUT"
echo "WaitForScan: $INPUT_WAITFORSCAN"
echo "SaveScanResults: $INPUT_SAVESCANRESULTS"
echo "ValidateSarifForGithub: $INPUT_VALIDATESARIFFORGITHUB"

set -x #echo on

contrast-cli --scan "$INPUT_ARTIFACT" --api_key "$INPUT_APIKEY" \
 --authorization "$INPUT_AUTHHEADER" --organization_id "$INPUT_ORGID" --host "$INPUT_APIURL" \
 --project_name "$INPUT_PROJECTNAME" --language "$INPUT_LANGUAGE" --scan_timeout "${INPUT_TIMEOUT:-300}" \
 ${INPUT_WAITFORSCAN:+"--wait_for_scan"} ${INPUT_SAVESCANRESULTS:+"--save_scan_results"} ${INPUT_SAVESCANRESULTS:+"--results_file_name"} ${INPUT_SAVESCANRESULTS:+"$INPUT_SARIF"}

if [ "$INPUT_VALIDATESARIFFORGITHUB" = "true" ]
then
  #use jq to get the total number of result elements within the sarif
  RESULT_COUNT=$(/usr/local/lib/node_modules/node-jq/bin/jq '.runs[].results | length' "$INPUT_SARIF")
  #Githubs 25000 result rejection limit
  if [ "$RESULT_COUNT" -gt 25000 ]
  then
    echo "Sarif result limit hit. GitHub will reject this analysis"
    exit 1
  #Githubs 5000 result truncation limit
  elif [ "$RESULT_COUNT" -gt 5000 ]
  then
    echo "Sarif truncation limit. Some results will be truncated"
  fi
  maximum_size=$((10 * 1024 * 1024))
  actual_size=$(wc -c <"$INPUT_SARIF")
  if [ "$actual_size" -ge $maximum_size ]; then
  	echo "$INPUT_SARIF is over Githubs file size limit of 10MB. $maximum_size bytes"
  else
  	echo "$INPUT_SARIF size is within Githubs file size limit of 10MB. $maximum_size bytes"
  fi
fi




