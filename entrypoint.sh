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
echo "SaveScanResults $INPUT_SAVESCANRESULTS"

set -x #echo on

file_size() {
	file=$1
	maximum_size=10485760
	actual_size=$(wc -c <"$file")
		if [ "$actual_size" -ge $maximum_size ]; then
	    echo Results file size is over $maximum_size bytes
		else
	    echo Results file size is under $maximum_size bytes
		fi
}

contrast-cli --scan "$INPUT_ARTIFACT" --api_key "$INPUT_APIKEY" \
 --authorization "$INPUT_AUTHHEADER" --organization_id "$INPUT_ORGID" --host "$INPUT_APIURL" \
 --project_name "$INPUT_PROJECTNAME" --language "$INPUT_LANGUAGE" --scan_timeout "${INPUT_TIMEOUT:-300}" \
 ${INPUT_WAITFORSCAN:+"--wait_for_scan"} ${INPUT_SAVESCANRESULTS:+"--save_scan_results"} ${INPUT_SARIF:+"$INPUT_SARIF"}

/usr/local/lib/node_modules/node-jq/bin/jq '.runs[].results | length' "$INPUT_SARIF"
file_size results.json


