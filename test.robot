*** Settings ***
Library    SeleniumLibrary
Library    ImageHorizonLibrary
Library    OperatingSystem
Test Teardown    Test TearDown Capture

*** Variables ***
${SEARCH_IMG4}   Screenshot-4.png
${SEARCH_IMG5}   Screenshot-5.png
${input_google_img}   google-input.png
${search_bar}   search_bar.png
${setting_bar}   setting_bar.png
${about_me}   about_me.png
${ihavecpu_logo}   ihavecpu_logo.png

*** Keywords ***
Test TearDown Capture
    [Documentation]    Cleanup after test execution
    # Close All Browsers
    Capture Page Screenshot

Scroll Until Image Found
    [Arguments]    ${image}    ${max_scroll}=40
    ${found}=    Set Variable    ${False}
    Log To Console    --- Start scrolling to find image: ${image} ---
    FOR    ${i}    IN RANGE    ${max_scroll}
        ${exists}=    Run Keyword And Return Status      Wait For       ${image}       5 
        # ถ้าเจอ
        IF    ${exists}
            Log To Console    ✅ Found image ${image}
            ${found}=    Set Variable    ${True}
            Exit For Loop
        END
        # ถ้าไม่เจอ เลื่อนลงมาเรื่อยๆ
        Press Combination    Key.PAGEDOWN
        Sleep    1s
    END

    IF    not ${found}
        Fail    Image ${image} not found after ${max_scroll} scrolls
    END
    Log To Console    --- Finished scrolling ---

*** Test Cases ***
Create Reference Images
    [Documentation]    Create reference images for testing
    [Tags]    setup
    Open Browser    https://www.google.com    chrome    options=add_argument("--ignore-certificate-errors")
    Maximize Browser Window
    Sleep    5s
    Log    Now take manual screenshots and save as Screenshot-4.png and Screenshot-5.png    WARN
    Sleep    60s    # Sleep เพื่อ จับภาพ




IHAVECPU using ImageHorizonLibrary
    [Documentation]    Image-based approach (fragile). Ensure images match your screen and ImageHorizonLibrary is installed.
    [Tags]    image
    
    # เตรียม environment
    ImageHorizonLibrary.Set Reference Folder    ${CURDIR}
    ImageHorizonLibrary.Set Confidence          0.5
    Open Browser    http://ihavecpu.com/    chrome    options=add_argument("--ignore-certificate-errors")
    Maximize Browser Window
    Sleep    5s
    
    
    # ${found_img5}=    Run Keyword And Return Status    ImageHorizonLibrary.Wait For    ${SEARCH_IMG5}    10
    # Run Keyword If    ${found_img5}    ImageHorizonLibrary.Click Image    ${SEARCH_IMG5}
    # Run Keyword If    '${found_img5}'=='False'    Fail    Image ${image} not found
    # Sleep    5s

    # ${found_img4}=    Run Keyword And Return Status    ImageHorizonLibrary.Wait For    ${SEARCH_IMG4}    10  
    # Run Keyword If    ${found_img4}    ImageHorizonLibrary.Click Image    ${SEARCH_IMG4}
    # Run Keyword If    '${found_img4}'=='False'    Fail    Image ${image} not found
    # Sleep   5s

    # ${setting_bar_status}=    Run Keyword And Return Status    ImageHorizonLibrary.Wait For    ${setting_bar}    10
    # Run Keyword If    ${setting_bar_status}    Run Keywords
    # ...    ImageHorizonLibrary.Click To The Right Of Image     ${setting_bar}    50
    # ...    AND    Sleep   5s
    # ...    AND    ImageHorizonLibrary.Type    http://ihavecpu.com/
    # ...    AND    Sleep   3s
    # ...    AND    ImageHorizonLibrary.Type    Key.enter
    # Run Keyword If    '${setting_bar_status}'=='False'    Fail    Image ${image} not found
    # Sleep   5s
    # เลื่อนจอ
    # เลื่อนจอทีละ step จนกว่าจะเจอรูป
    Wait For    ${ihavecpu_logo}    30
    Scroll Until Image Found    ${about_me}    25















