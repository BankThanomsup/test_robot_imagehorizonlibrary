*** Settings ***
Library    SeleniumLibrary
Library    ImageHorizonLibrary
Library    OperatingSystem
Test Teardown    Test TearDown Capture
*** Variables ***
${SEARCH_IMG4}   Screenshot-4.png
${SEARCH_IMG5}   Screenshot-5.png

*** Test Cases ***
Create Reference Images
    [Documentation]    Create reference images for testing
    [Tags]    setup
    Open Browser    https://www.google.com    chrome    options=add_argument("--ignore-certificate-errors")
    Maximize Browser Window
    Sleep    5s
    Log    Now take manual screenshots and save as Screenshot-4.png and Screenshot-5.png    WARN
    Sleep    60s    # Sleep เพื่อ จับภาพ
    Close Browser

Google Search using ImageHorizonLibrary
    [Documentation]    Image-based approach (fragile). Ensure images match your screen and ImageHorizonLibrary is installed.
    [Tags]    image
    
    # เตรียม environment
    ImageHorizonLibrary.Set Reference Folder    ${CURDIR}
    ImageHorizonLibrary.Set Confidence          0.5
    Open Browser    https://www.google.com    chrome    options=add_argument("--ignore-certificate-errors")
    Maximize Browser Window
    Sleep    5s
    Capture Page Screenshot    google-homepage
    
    # สร้าง reference images ใหม่
    Log    Take manual screenshots now for reference    WARN
    Sleep    10s    # เวลาให้คุณจับภาพด้วยตัวเอง
    
    # ลองหาภาพด้วย confidence ต่ำ
    ${found_img5}=    Run Keyword And Return Status    ImageHorizonLibrary.Wait For    ${SEARCH_IMG5}    5
    Run Keyword If    ${found_img5}    ImageHorizonLibrary.Click Image    ${SEARCH_IMG5}
    Run Keyword If    not ${found_img5}    Log    Image ${SEARCH_IMG5} not found    WARN
    
    Sleep    3s
    
    ${found_img4}=    Run Keyword And Return Status    ImageHorizonLibrary.Wait For    ${SEARCH_IMG4}    5  
    Run Keyword If    ${found_img4}    ImageHorizonLibrary.Click Image    ${SEARCH_IMG4}
    Run Keyword If    not ${found_img4}    Log    Image ${SEARCH_IMG4} not found    WARN

    Sleep    10s

*** Keywords ***
Test TearDown Capture
    [Documentation]    Cleanup after test execution
    Close All Browsers
    Capture Page Screenshot
