#!/bin/sh

SCRIPT="$0"
echo "# START SCRIPT: $SCRIPT"

# ---- Docker Run ---
args2="generate 
-t /local/modules/Java 
-g java 
-i https://raw.githubusercontent.com/SidneyAllen/asc-2021-rebel/main/petstore.yaml
--library google-api-client 
-c /local/scripts/java.json  
-o /local/output/java 
--model-package com.pet.models"
#--global-property debugModels
#debugOperations

echo "**************  Generate Pet Java SDK ******************"
docker run --rm -v ${PWD}:/local -e JAVA_OPTS="-Dlog.level=error" openapitools/openapi-generator-cli:v4.3.1 $args2
