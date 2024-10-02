*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${base_url}    https://reqres.in/api
#${payload}    {"name":"Chethan","job":"Engineer"}
#${headers}    {"Content-Type":"application/json"}


*** Test Cases ***
Post_call
    Create Session    mysession    ${base_url}

    ${body}=    Create Dictionary    name=Chethan    job=leader
    ${headers}=     Create Dictionary    Content-Type=application/json
   
    ${response}=    Post Request    mysession    /users    data=${body}    headers=${headers}
#    ${response}=    POST On Session    mysession    /users    json=${payload}    headers=${headers}
    Log To Console    ${response.status_code}
    Log To Console    ${response.content}
    
   
    #Validations
    ${status_code}=    Convert To String    ${response.status_code}
    Should Be Equal   ${status_code}    201

    ${res_body}=    Convert To String    ${response.content}
    Should Contain    ${res_body}    id
    Should Contain    ${res_body}    createdAt
    Log To Console    response contains id and createdAt
    
    ${resp_json}=    To Json    ${res_body}
    ${get_id}=    Get From Dictionary    ${resp_json}    id
    Should Be True    ${get_id}>0
    Log To Console    id is verified successfully and value is: ${get_id}