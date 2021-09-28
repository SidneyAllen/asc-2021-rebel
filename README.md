# APISpec Confernce 2021: Rebel without a Spec
This project was built for a talk about OpenAPI Extensions (aka specification extensions or vendor extensions). It utilizes OpenAPI generator to create a Java SDK and documentation. The petstore API definition included in this project is used to demonstrate both custom properties and custom objects.

## Pre-requisites
* Docker

## Running OpenAPI Generator
To run the build script located in the generator folder, you'll need to first set the permissions.  In a terminal, navigate to the generator folder and run the command.

`chmod 777 build.sh`

Next, navigate to the script folder and run the command.

`chmod 777 *`

Return to the generator folder and run the build.sh file.

`./build.sh`

## Custom Property
A custom property has been added to the Pet schema.  The extension is a boolean and used to identify properties which are dates, but do not follow a standard date format.  In this example, the date format created by Microsoft called. MSJSON dateformat.

`dob:
description: Date of birth – YYYY-MM-DD
type: string
example: "/Date(1573755038314)/"
x-is-msdate: true`

The OpenAPI extension is defined as x-is-msdate and used in the mustache templates for the Java SDK to modify the code generated so a native Java date is both returned and accepted then converted to MSJSON date format.

## Custom Object
A custom object has been added to the Pet create operation.  