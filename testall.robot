*** Settings ***
Documentation       Example SeleniumLibrary
Library             SeleniumLibrary
Library             RequestsLibrary
Library             JSONLibrary

*** Variables ***
${LOGIN URL}    https://refurbed.at
${BROWSER}      Chrome

# *** Test Cases ***
# Test "Hello World"
#     Log     "Hello World"

*** Test Cases ***
Query Check
    Open Browser                https://refurbed.at/  Chrome
    Wait until page contains    Refurbished Elektronik mit mindestens 12 Monaten Garantie
    ${current_title}            Get Title
    Should contain              ${current_title}    refurbed
    Input text                  query   apple\n  True
    Wait until page contains    Suche nach “apple”
    Click link                  link:Handys
    ${link_count}               Get Element Count  link:Fashion
    IF                          ${link_count} > 0
        Click link              link:Fashion
    ELSE
        Click link              link:Bekleidung
    END

Do a GET Request and validate the response code and response body
    [documentation]  This test case verifies that the response code of the GET Request should be 200,
    ...  the response body contains the 'title' key with value as 'REFURBED',
    ...  and the response body contains the key 'location_type'.
    [tags]  REFURBED
    Create Session  mysession  https://api.refurbed.io/  verify=true
    ${response}=  GET On Session  mysession  /v1/categories/id/27/  
    Status Should Be  200  ${response}  #Check Status as 200

    #Check ID as id:27 from Response Body
    ${id}  Get Value From Json  ${response.json()}  id
    Should be Equal as Numbers  ${id}[0]  27

    [Teardown]                  Close Browser



