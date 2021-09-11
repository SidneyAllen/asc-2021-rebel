#!/bin/sh

SCRIPT="$0"
echo "# START SCRIPT: $SCRIPT"

# ---- Docker Run ---
ags1='generate 
-t /local/modules/php 
-i https://raw.githubusercontent.com/SidneyAllen/asc-2021-rebel/main/petstore.yaml
-g php 
-c /local/scripts/php.json 
-o /local/output/php 
--invoker-package PetAPI\PetPHP 
--model-package Models\Pet 
--group-id Pet'

echo "**************  Generate Pet PHP SDK ******************"
docker run --rm -v ${PWD}:/local -e JAVA_OPTS="-Dlog.level=error" openapitools/openapi-generator-cli:v4.3.1 $ags1

