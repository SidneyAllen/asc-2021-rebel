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

The results can be found in the **output** folder.

## Custom Property
A custom property has been added to the Pet schema.  The extension is a boolean and used to identify properties which are dates, but do not follow a standard date format.  In this example, Microsoft's MSJSON date format.

The OpenAPI extension is defined as x-is-msdate and used in the mustache templates for the Java SDK to modify the code generated so a native Java date is both returned and accepted then converted to MSJSON date format.

```
dob:
    description: Date of birth – YYYY-MM-DD
    type: string
    example: "/Date(1573755038314)/"
    x-is-msdate: true`
```

In the pojo.mustache template  an alternate method this is added only if x-is-msdate is true (or exists)

```
{{#vendorExtensions}}
{{#x-is-msdate}}
  /** 
  {{#description}}
   * {{description}}
  {{/description}}
  {{^description}}
   * {{name}}
  {{/description}}
   * @return LocalDate
  **/
  public LocalDate {{getter}}AsDate() {
    if (this.{{name}} != null) {
      try {
        return util.convertStringToDate(this.{{name}});
      } catch (IOException e) {
        e.printStackTrace();
      }  
    }
    return null;        
  }
{{/x-is-msdate}}
{{/vendorExtensions}}
```

The code that is generated includes a getter and setter (not shown below)

```
public LocalDate getDobAsDate() {
    if (this.dob != null) {
      try {
        return util.convertStringToDate(this.dob);
      } catch (IOException e) {
        e.printStackTrace();
      }  
    }
  return null;        
}
```

## Custom Object
A custom object has been added to the Pet create operation. Objects are for defining more complex object, arrays or a combination of both.  In this example, we are defining the struture of an example requestBody in a non-language specific way, so that runnable code examples can be generated for our SDK documentation.

```
x-example:
    - object:
        is_object: true
        key: pet
        keyPascal: Pet
    - name:
        key: name
        keyPascal: Name
        default: Fido
        object: pet
    - tag:
        key: tag
        keyPascal: Tag
        default: dog
        nonString: true
        php: PetAPI\PetPHP\Models\PetTag::DOG
        java: com.pet.models.Pet.TagEnum.DOG
        object: pet
    - dob:
        is_last: true
        key: dob
        keyPascal: Dob
        default: "7-1-2019"
        is_date: true
        object: pet
```

In our mustache template, we wrap our custom object in the <vendorExtension> tag

```
{{#vendorExtensions}}
    {{#x-example}}
        {{#is_object}}
            {{{keyPascal}}} {{{key}}} = new {{{keyPascal}}}();
        {{/is_object}}
        {{^is_object}}
            {{object}}.set{{{keyPascal}}}({{java}}{{^java}}{{#is_date}}new Date({{/is_date}}"{{{default}}}"{{#is_date}}){{/is_date}}{{/java}});
        {{/is_object}}{    
    {/x-example}}
{{/vendorExtensions}}
```

The custom object produces the following Java code snippet.

```
// Generated code
Pet pet = new Pet();
pet.setName("Fido");
pet.setTag(com.pet.models.Pet.TagEnum.DOG);
pet.setDob(new Date("7-1-2019"));

// Static code
try {
    apiInstance.createPets(pet);
} catch (ApiException e) {
    System.err.println("Exception when calling PetsApi#createPets");
    e.printStackTrace();
}
```