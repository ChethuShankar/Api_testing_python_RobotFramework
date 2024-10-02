*** Settings ***
Library           RequestsLibrary
Library    Collections
Library           JSONLibrary
Library           CSVLibrary  # Add this library for CSV support

*** Variables ***
${BASE_URL}       https://reqres.in/api
${ENDPOINT}       /users
${HEADERS}        {"Content-Type": "application/json"}

*** Keywords ***

Validate User Login and Extract User ID
    [Arguments]    ${username}    ${job}
    [Documentation]    Validates user login and extracts user_id from response.

    # Step 1: Create the payload using parameterized arguments
    ${PAYLOAD}=    Create Dictionary    name=${username}    job=${job}

    # Step 2: Create a session for the API
    Create Session    my_session    ${BASE_URL}

    # Step 3: Send a POST request with headers and capture the response object
    ${response}=    POST On Session    my_session    ${ENDPOINT}    headers=${HEADERS}    json=${PAYLOAD}

    # Step 4: Check if the response is successful (Status code 201)
    Should Be Equal As Numbers    ${response.status_code}    201

    # Step 5: Get the response body as JSON
    ${response_str}=    Convert To String    ${response.content}
    ${response_json}=      To Json      ${response_str}

    # Step 6: Validate the dynamic 'id' field
    ${user_id}=    Get From Dictionary    ${response_json}    id
    Should Not Be Empty    ${user_id}
    Should Be True         ${user_id} > 0

    # Step 7: Print a user-defined message to the console
    Log To Console    User ID: ${user_id} for username: ${username} was successfully validated.

*** Test Cases ***

Validate Multiple User Logins From CSV
    [Documentation]    Validates multiple user logins and extracts user_id from the response.

    # Step 1: Read data from CSV file
    @{user_data}=     Read Csv File To List        input1.csv    delimiter=,

    Log     userdata:${user_data}
    Log To Console    userdata:${user_data}


    # Step 2: Iterate through each row
    FOR    ${row}    IN RANGE    1    ${len(user_data)}
        Log To Console    ${row}
        ${username}=    Set Variable    ${row}[name]  # Fetching by column name
        ${job}=         Set Variable    ${row}[job]   # Fetching by column name

        # Call the keyword to validate the user login and print the message
        Validate User Login and Extract User ID    ${username}    ${job}
    END
