#!/bin/sh

SCRIPT="$0"
echo "# START SCRIPT: $SCRIPT"

# ---- Docker Run ---
ags1="generate
-t /local/modules/htmlDocs2
-g html
-i https://raw.githubusercontent.com/SidneyAllen/asc-2021-rebel/main/petstore.yaml
-c /local/scripts/java.json
-o /local/output/docs/"
#--global-property debugModels,debugOperations

echo "**************  Generate Pet docs ******************"
docker run --rm -v ${PWD}:/local -e JAVA_OPTS="-Dlog.level=error" openapitools/openapi-generator-cli:v4.3.1 $ags1
