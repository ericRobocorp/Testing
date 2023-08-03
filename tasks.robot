*** Settings ***
Documentation       Template robot main suite.

Library             RPA.Browser.Selenium    auto_close=${False}


*** Variables ***
${URL}              https://ifstest.oriflame.com/main/ifsapplications/web/start
${User}             robor2r@oriflame.com
${Password}         Samarth@rekha16
${ReportName}       Order Report


*** Tasks ***
Minimal task
    Login to if
    Log    Done.


*** Keywords ***
Login to if
    # set the download directory before opening the browser so it download to the artifacts that are uploaded to control room
    Set Download Directory    ${OUTPUT_DIR}
    Open Available Browser    ${URL}

    # using sleep is a bad practice as it introduces slow downs that may not be needed
    # additionally depending on network traffic a web page can open slower or faster so the SLEEP may not work
    # use WAIT or WHEN VISIBLE keywords instead
    Wait Until Element Is Visible    id:i0116
    Input Text    id:i0116    ${User}
    Click Element    id:idSIButton9
    Wait Until Element Is Visible    id:i0118
    Input Text    id:i0118    ${Password}
    Click Element    id:idSIButton9

    # I don't know why your automation was stopping here but I added in a wait just to make sure
    Wait Until Element Is Visible    id:KmsiCheckboxField
    Click Element    id:KmsiCheckboxField
    Click Element    id:idSIButton9

    Click Element When Visible    id:id-ifs-btn-azure_ifsoctest

    # because the IFS site was taking forever to load, the selenium default wait times were not long enough even with WAIT keywords
    # so I set the selenium default timeout to 60 seconds so it will wait longer for an element to show up
    ${o_timeout}=    Set Selenium Timeout    60

    Click Element When Visible    xpath=//span[contains(text(),"Reporting")]
    Click Element When Visible    xpath=//span[contains(text(),"Order Report")]
    Click Element When Visible    xpath=//button[@title="Export or copy & paste record(s)"]
    Click Element    xpath=//button[contains(text(),"Export All Rows")]
    Click Element    xpath=//button[contains(text(),"Visible Columns Only")]
    # Selenium has a habit of closing before a download is complete so after clicking the last button to download
    # I had to use SLEEP here so that the browser doesn't close before the download'
    Sleep    15
