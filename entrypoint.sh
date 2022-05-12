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

contrast-cli --scan "$INPUT_ARTIFACT" --api_key "$INPUT_APIKEY"  --authorization "$INPUT_AUTHHEADER" --organization_id "$INPUT_ORGID" --host "$INPUT_APIURL" --project_name "$INPUT_PROJECTNAME" --language "$INPUT_LANGUAGE" --scan_timeout "${INPUT_TIMEOUT:-300}" --wait_for_scan --save_scan_results

./node_modules/node-jq/bin/jq '.runs[].results | length' results.json

file_size() {
	file=$1
	minimumsize=10485760
	actualsize=$(wc -c <"$file")
		if [ $actualsize -ge $minimumsize ]; then
	    echo size is over $minimumsize bytes
		else
	    echo size is under $minimumsize bytes
		fi
}

file_size results.json
