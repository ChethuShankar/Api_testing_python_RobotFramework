*** Settings ***
Library    RequestsLibrary
Library    Collections
*** Variables ***
${base_url}    https://fakerestapi.azurewebsites.net

*** Test Cases ***
Get_request
    Create Session   session    ${base_url}
    ${response}=    Get Request    session    /api/v1/Activities
    Log To Console    ${response.status_code}
#    Log To Console    ${response.content}
    Log To Console    ${response.headers}
    
    
# Validations
    ${status_code}=    Convert To String    ${response.status_code}
    Should Be Equal    ${status_code}    200
    ${body}=    Convert To String    ${response.content}
    Should Contain    ${body}    Activity 1
    
    ${header_value}=    Get From Dictionary   ${response.headers}    Content-Type
    Should Contain    ${header_value}   application/json
    