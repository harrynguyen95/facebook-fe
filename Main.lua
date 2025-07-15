-- ====== LIB REQUIRED ======
require('utils')
require('functions')
clearAlert()

-- ====== CONFIG ======
LANGUAGE = 'ES'  -- EN|ES English|Spanish
MAIL_SUPLY = 1  -- 1|2|3 hotmail_dongvanfb|thuemails.com|yagisongs
ENTER_VERIFY_CODE = true  -- true|false
HOTMAIL_SERVICE_IDS = {1, 3, 2, 6, 5, 59, 60}
HOTMAIL_SOURCE_FROM_FILE = false  -- true|false
THUE_LAI_MAIL_THUEMAILS = false  -- true|false
ADD_MAIL_DOMAIN = false  -- true|false
REMOVE_REGISTER_MAIL = false  -- true|false
PROVIDER_MAIL_THUEMAILS = 1  -- 1|3 gmail|icloud
TIMES_XOA_INFO = 3  -- 0|1|2|3
MAIL_THUEMAILS_API_KEY = "94a3a21c-40b5-4c48-a690-f1584c390e3e" -- Hải
MAIL_DONGVANFB_API_KEY = "iFI7ppA8JNDJ52yVedbPlMpSh" -- Hải
LOGIN_WITH_CODE = false
DUMMY_MODE = '0'

if not waitForInternet(3) then alert("No Internet!") exit() else toast('Connected!', 2) end
getConfigServer()

-- ====== VARIABLE REQUIRED ======
SHOULD_DUMMY = DUMMY_MODE ~= '0'
DUMMY_PHONE = DUMMY_MODE == '1'
DUMMY_GMAIL = DUMMY_MODE == '2'
DUMMY_ICLOUD = DUMMY_MODE == '3'

if LANGUAGE == 'ES' then require(currentDir() .. "/images_es") end
if LANGUAGE == 'EN' then require(currentDir() .. "/images_en") end

-- ====== INFO ======
info = {
    checkpoint = nil,
    uuid = nil,
    status = nil,
    thuemailId = nil,
    twoFA = nil,
    profileUid = nil,
    mailLogin = nil,
    password = nil,
    mailRegister = nil,
    mailPrice = nil,
    hotmailRefreshToken = nil,
    hotmailClientId = nil,
    hotmailPassword = nil,
    verifyCode = nil,
}

-- ====== MAIN ======
function main()

    ::label_continue::
    log('------------ Main running ------------')
    archiveCurrentAccount()

    goto debug
    ::debug::

    log(info, 'Main')
    if not waitForInternet(3) then alert("No Internet!") exit() else toast('Connected!', 2) end
    if info.mailRegister == nil or info.mailRegister == '' then 
        homeAndUnlockScreen()
        executeXoaInfo()
    else 
        swipeCloseApp()
    end
    if LOGIN_WITH_CODE then initCurrentAccountCode() end 

    ::label_openfacebook::
    openFacebook()
    sleep(5)

    if waitImageVisible(logo_fb_modern, 3) then
        toastr('not_support_this_FB_mode')
        swipeCloseApp()
        goto label_continue
    end

    findAndClickByImage(accept)
    if checkSuspended() then goto label_continue end
    if checkPageNotAvailable() then goto label_continue end
    if checkImageIsExists(find_friend) then goto label_findfriend_swipe end

    ::label_createnewaccount::
    showIphoneModel()

    sleep(1)
    if checkImageIsExists(what_is_birthday) then goto label_birthday end
    if checkImageIsExists(what_is_mobile_number) then goto label_whatisyourmobile end
    if checkImageIsExists(enter_confirm_code_phone) then goto label_enterconfirmcodedummy end 
    if checkImageIsExists(enter_the_confirmation_code) then goto label_confirmationcode end
    if checkImageIsExists(create_a_password) then goto label_createpassword end
    if checkImageIsExists(save_your_login_info) then goto label_saveyourlogin end
    if checkImageIsExists(profile_picture) then goto label_profilepicture end
    if checkImageIsExists(turn_on_contact) then goto label_turnoncontact end
    if checkImageIsExists(find_friend) then goto label_findfriend_swipe end
    if checkImageIsExists(no_friend) then goto label_nofriend end
    if checkImageIsExists(add_phone_number) then goto label_addphonenumber end
    if checkImageIsExists(agree_facebook_term) then goto label_agree end
    if checkImageIsExists(what_on_your_mind) then 
        if info.twoFA == nil or info.twoFA == '' then goto label_get2FA end 
        if info.twoFA ~= nil or info.twoFA ~= '' then goto label_searchtext end 
    end

    if waitImageVisible(create_new_account, 20) then
        if waitImageVisible(logo_fb_modern, 3) then
            toastr('not_support_this_FB_mode')
            swipeCloseApp()
            goto label_continue
        end

        toastr('create_new_account')

        if LOGIN_WITH_CODE then 
            findAndClickByImage(mobile_or_email)
            typeNumberLongSpace(info.profileUid)
            findAndClickByImage(login_password)
            findAndClickByImage(password_eye)
            typeText(info.password)
            findAndClickByImage(login_button)
            if waitImageNotVisible(logo_facebook_login, 30) then 
                if waitImageVisible(accept) then 
                    findAndClickByImage(accept) sleep(0.5)
                    findAndClickByImage(login_button)
                end 
                if waitImageVisible(wrong_credentials) then 
                    failedCurrentAccount('wrong_cre')
                    goto label_continue
                end 
                sleep(3)
            else 
                toastr('Can not next')
                swipeCloseApp()
                goto label_continue
            end
        else 
            findAndClickByImage(create_new_account) sleep(2)
            if waitImageNotVisible(logo_facebook_login, 30) then 
                sleep(3)
            else 
                toastr('Can not next')
                swipeCloseApp()
                goto label_continue
            end
        end 
    else         
        if checkSuspended() then goto label_continue end
    end

    if LOGIN_WITH_CODE then 
        if waitImageVisible(save_your_login_info, 3) then 
            findAndClickByImage(save) 
            sleep(1)
        end 
        if waitImageVisible(enter_the_confirmation_code, 20) then
            goto label_confirmationcode
        end
        if checkImageIsExists(profile_picture) then goto label_profilepicture end
        if checkImageIsExists(turn_on_contact) then goto label_turnoncontact end
        if checkImageIsExists(find_friend) then goto label_findfriend_swipe end
        if checkImageIsExists(no_friend) then goto label_nofriend end
    end 

    if waitImageVisible(join_facebook, 2) then 
        toastr('not_support_this_FB_mode', 2)
        swipeCloseApp()
        goto label_continue
    end

    ::label_createnewaccountblue::
    if waitImageVisible(create_new_account_blue) then
        toastr('create_new_account_blue')
        findAndClickByImage(create_new_account_blue)
        waitImageNotVisible(create_new_account_blue)
    else 
        if waitImageVisible(get_started) then
            toastr('get_started')
            findAndClickByImage(get_started)
            waitImageNotVisible(get_started)
        end
    end

    if checkSuspended() then goto label_continue end
    if checkPageNotAvailable() then goto label_continue end
    if checkImageIsExists(no_friend) then goto label_nofriend end

    setFirstNameLastName()

    ::label_birthday::
    toastr('wait birthday..')
    if waitImageVisible(what_is_birthday) then
        toastr("what_is_birthday")
        press(270, 470) sleep(0.5)

        for i = 1, math.random(2, 5) do
            press(200, math.random(1003, 1008))
        end
        for i = 1, math.random(3, 10) do
            press(400, math.random(1003, 1008))
        end
        for i = 1, math.random(10, 18) do
            press(600, math.random(1003, 1008))
        end
        findAndClickByImage(next)

        if not waitImageNotVisible(what_is_birthday, 20) then 
            if checkImageIsExists(what_is_birthday) then findAndClickByImage(next) end
            if not waitImageNotVisible(what_is_birthday, 20) then 
                toastr('Can not next')
                swipeCloseApp()
                goto label_openfacebook
            end 
        end 
    end

    setGender()

    sleep(1)
    findAndClickByImage(accept) 
    if checkImageIsExists(create_new_account) then goto label_createnewaccount end 
    if checkImageIsExists(create_new_account_blue) then goto label_createnewaccountblue end 
    if checkImageIsExists(get_started) then goto label_createnewaccountblue end 
    if checkImageIsExists(profile_picture) then goto label_profilepicture end
    if checkImageIsExists(enter_the_confirmation_code) then goto label_confirmationcode end

    ::label_whatisyourmobile::
    if waitImageVisible(what_is_mobile_number) or waitImageVisible(sign_up_with_email) then
        toastr("what_is_mobile_number")
        if DUMMY_PHONE then 
            typeText(randomUSPhone())
            findAndClickByImage(next)

            if waitImageVisible(red_warning_icon) then
                press(320, 380)
                findAndClickByImage(x_input_icon)
                typeText(randomUSPhone())
                findAndClickByImage(next)
                if waitImageVisible(continue_creating_account) then
                    failedCurrentAccount('phone_has_account')
                    goto label_continue
                end
            end

            if waitImageVisible(continue_creating_account, 2) then
                failedCurrentAccount('phone_has_account')
                goto label_continue
            end
        else
            findAndClickByImage(sign_up_with_email)
            waitImageNotVisible(what_is_mobile_number)
            sleep(2)
        end
    end

    ::label_whatisyouremail::
    if not DUMMY_PHONE then 
        if waitImageVisible(what_is_your_email) or waitImageVisible(enter_an_email) then
            toastr("what_is_your_email")

            if DUMMY_GMAIL then info.mailRegister = randomGmail() end
            if DUMMY_ICLOUD then info.mailRegister = randomIcloud() end

            if info.mailRegister ~= nil and info.mailRegister ~= '' then 
                press(310, 420)
                findAndClickByImage(x_input_icon)
                typeText(info.mailRegister)

                findAndClickByImage(next)
                archiveCurrentAccount()

                if waitImageVisible(exist_account_in_mail, 3) or waitImageVisible(red_warning_icon, 3) then
                    toastr('exist_account_in_mail')
                    failedCurrentAccount('email_has_account')
                    goto label_continue
                end
            else
                if executeGetMailRequest() then 
                    if info.mailRegister ~= nil and info.mailRegister ~= '' then 
                        press(310, 420)
                        findAndClickByImage(x_input_icon)
                        typeText(info.mailRegister)

                        findAndClickByImage(next)
                        archiveCurrentAccount()

                        if waitImageVisible(exist_account_in_mail, 3) or waitImageVisible(red_warning_icon, 3) then
                            toastr('exist_account_in_mail')
                            failedCurrentAccount('email_has_account')
                            goto label_continue
                        end
                    end
                else 
                    toastr("Empty mail. Continue.", 10) sleep(5)
                    log("Empty mail. Continue.")
                    failedCurrentAccount('empty_email')
                    goto label_continue
                end
            end

            if waitImageVisible(continue_creating_account, 3) or waitImageVisible(red_warning_icon, 3) then
                toastr("continue_creating_account")
                failedCurrentAccount('email_has_account')
                goto label_continue
            end
            
            if not waitImageNotVisible(what_is_your_email, 20) then 
                if checkImageIsExists(what_is_your_email) then findAndClickByImage(next) end
                if not waitImageNotVisible(what_is_your_email, 20) then 
                    toastr('Can not next')
                    swipeCloseApp()
                    goto label_openfacebook
                end
            end
        end
    end

    if waitImageVisible(what_is_birthday, 2) then
        toastr("what_is_birthday")
        press(270, 470) sleep(0.5)

        for i = 1, math.random(2, 5) do
            press(200, math.random(1003, 1008))
        end
        for i = 1, math.random(3, 10) do
            press(400, math.random(1003, 1008))
        end
        for i = 1, math.random(10, 18) do
            press(600, math.random(1003, 1008))
        end
        findAndClickByImage(next)

        if not waitImageNotVisible(what_is_birthday, 20) then 
            if checkImageIsExists(what_is_birthday) then findAndClickByImage(next) end
            if not waitImageNotVisible(what_is_birthday, 20) then 
                toastr('Can not next')
                swipeCloseApp()
                goto label_openfacebook
            end 
        end 

        setGender()
    end

    ::label_createpassword::
    toastr('wait password..')
    if waitImageVisible(create_a_password) then
        toastr("create_a_password")
        press(135, 450)
        findAndClickByImage(password_eye)
        typeText(info.password)
        findAndClickByImage(next)

        if not waitImageNotVisible(create_a_password, 30) then 
            if checkImageIsExists(create_a_password) then findAndClickByImage(next) end
            if not waitImageNotVisible(create_a_password, 20) then 
                toastr('Can not next')
                swipeCloseApp()
                goto label_openfacebook
            end 
        end 
    end

    if checkImageIsExists(continue_creating_account) then failedCurrentAccount('phone_has_account') goto label_continue end
    if checkImageIsExists(what_is_your_email) and not DUMMY_PHONE then goto label_whatisyouremail end 

    ::label_saveyourlogin::
    if waitImageVisible(save_your_login_info, 3) then
        toastr("save_your_login_info")
        findAndClickByImage(save)
        waitImageNotVisible(save_your_login_info)
    end

    ::label_agree::
    toastr('wait agree..')
    if waitImageVisible(agree_facebook_term) then
        toastr("agree_facebook_term")

        local times = 1
        ::label_clickagree::
        if waitImageVisible(dont_allow, 1) then findAndClickByImage(dont_allow) end
        findAndClickByImage(i_agree_btn)

        if waitImageVisible(can_not_agree, 15) then 
            if times < 4 then 
                times = times + 1
                onOffAirplaneMode()
                openFacebook()
                goto label_clickagree
            else 
                failedCurrentAccount('can_not_agree')
                goto label_continue
            end 
        end 

        if not waitImageNotVisible(agree_facebook_term, 60) then 
            toastr('Can not next')
            swipeCloseApp()
            goto label_openfacebook
        end 

        if waitImageVisible(already_have_account) then
            press(380, 600)
            waitImageNotVisible(already_have_account)
        end
    end

    if checkImageIsExists(create_a_password) then goto label_createpassword end 

    ::label_enterconfirmcodedummy::
    if SHOULD_DUMMY then 
        if DUMMY_PHONE then
            if waitImageVisible(enter_confirm_code_phone, 10) then
                toastr("enter_confirm_code_phone")
                findAndClickByImage(no_receive_code)
                if waitImageVisible(confirm_via_email, 20) then 
                    findAndClickByImage(confirm_via_email)
                    sleep(2)
                end
            end
        end

        if DUMMY_GMAIL or DUMMY_ICLOUD then
            if waitImageVisible(enter_the_confirmation_code, 10) then
                toastr("enter_the_confirmation_code gmail|iloud")
                findAndClickByImage(no_receive_code)
                if waitImageVisible(confirm_via_change_email, 20) then 
                    findAndClickByImage(confirm_via_change_email)
                    info.mailRegister = nil -- reset mailRegister
                    sleep(2)
                end
            end
        end

        ::label_emailafterphone::
        if waitImageVisible(what_is_your_email, 3) or waitImageVisible(enter_an_email, 3) then
            toastr("what_is_your_email")

            if info.mailRegister ~= nil and info.mailRegister ~= '' then 
                press(310, 420)
                findAndClickByImage(x_input_icon)
                typeText(info.mailRegister)

                findAndClickByImage(next)
                archiveCurrentAccount()

                if waitImageVisible(exist_account_in_mail, 3) or waitImageVisible(red_warning_icon, 3) then
                    toastr('exist_account_in_mail')
                    failedCurrentAccount('email_has_account')
                    goto label_continue
                end
            else
                if executeGetMailRequest() then 
                    if info.mailRegister ~= nil and info.mailRegister ~= '' then 
                        press(310, 420)
                        findAndClickByImage(x_input_icon)
                        typeText(info.mailRegister)

                        findAndClickByImage(next)
                        archiveCurrentAccount()

                        if waitImageVisible(exist_account_in_mail, 3) or waitImageVisible(red_warning_icon, 3) then
                            toastr('exist_account_in_mail')
                            failedCurrentAccount('email_has_account')
                            goto label_continue
                        end
                    end
                else 
                    toastr("Empty mail. Continue.", 10) sleep(5)
                    log("Empty mail. Continue.")
                    failedCurrentAccount('empty_email')
                    goto label_continue
                end
            end

            if waitImageVisible(continue_creating_account, 3) or waitImageVisible(red_warning_icon, 3) then
                toastr("continue_creating_account")
                failedCurrentAccount('email_has_account')
                goto label_continue
            end

            if not waitImageNotVisible(what_is_your_email, 20) then 
                if checkImageIsExists(what_is_your_email) then findAndClickByImage(next) end
                if not waitImageNotVisible(what_is_your_email, 20) then 
                    toastr('Can not next')
                    swipeCloseApp()
                    goto label_openfacebook
                end
            end
        end

        if checkImageIsExists(confirm_via_email) then goto label_emailafterphone end 
    end

    ::label_confirmationcode::
    if waitImageVisible(enter_the_confirmation_code, 10) then
        toastr("enter_the_confirmation_code")
        if DUMMY_PHONE and checkImageIsExists(enter_confirm_code_phone) then goto label_enterconfirmcodedummy end

        if waitImageVisible(dont_allow, 1) then findAndClickByImage(dont_allow) end
        info.profileUid = getUIDFBLogin()

        local OTPcode = nil
        if (info.verifyCode and info.verifyCode ~= '') then
            OTPcode = info.verifyCode
        else
            OTPcode = getCodeMailRegister()
        end 

        toastr('OTPcode: ' .. (OTPcode or '-'))
        if OTPcode then 
            info.verifyCode = OTPcode
            archiveCurrentAccount()

            if ENTER_VERIFY_CODE then 
                findAndClickByImage(input_confirm_code)
                findAndClickByImage(x_input_icon)
                typeText(OTPcode) sleep(1)
                findAndClickByImage(next)

                if waitImageVisible(red_warning_icon) then 
                    failedCurrentAccount('code_invalid')
                    goto label_continue
                end 
            else 
                finishCurrentAccount()
                goto label_continue
            end 
        else
            toastr('empty OTP', 6) sleep(3)
            press(55, 90) sleep(1) -- X back icon
            press(240, 820) sleep(1) -- Leave btn

            failedCurrentAccount('empty_code')
            goto label_continue
        end
        
        if waitImageNotVisible(enter_the_confirmation_code, 20) then 
            if waitImageVisible(setting_up_for_fb) then
                toastr('setting_up_for_fb')
                waitImageNotVisible(setting_up_for_fb)
            end
        else 
            findAndClickByImage(next)
        end

        info.profileUid = getUIDFBLogin()
        toastr("UID: " .. (info.profileUid or '-'))
        archiveCurrentAccount()
    end

    ::label_profilepicture::
    if waitImageVisible(profile_picture) then
        toastr("profile_picture")

        if waitImageVisible(dont_allow, 1) then findAndClickByImage(dont_allow) end

        if waitImageVisible(not_now, 1) then
            findAndClickByImage(not_now)
        else 
            press(380, 1260) -- skip
        end
        
        if not waitImageNotVisible(profile_picture, 20) then
            swipeCloseApp()
            goto label_openfacebook
        end 

        waitImageVisible(turn_on_contact)
    end

    if checkSuspended() then goto label_continue end
    if checkPageNotAvailable() then goto label_continue end
    if checkImageIsExists(what_on_your_mind) then goto label_get2FA end 

    ::label_turnoncontact::
    toastr('wait contact..')
    if waitImageVisible(turn_on_contact) then
        toastr("turn_on_contact")

        if waitImageVisible(dont_allow, 1) then findAndClickByImage(dont_allow) end
        if waitImageVisible(not_now, 1) then findAndClickByImage(not_now) end 
        if waitImageVisible(next, 1) then findAndClickByImage(next) end 
        if waitImageVisible(skip, 1) then findAndClickByImage(skip) end 

        if waitImageVisible(not_now, 1) then findAndClickByImage(not_now) end 
        if waitImageVisible(skip, 1) then findAndClickByImage(skip) end 

        waitImageNotVisible(turn_on_contact)
        waitImageVisible(no_friend)
    end

    ::label_nofriend::
    if waitImageVisible(no_friend, 3) then
        toastr("no_friend")
        if waitImageVisible(skip, 1) then findAndClickByImage(skip) end 
        findAndClickByImage(next)
        if not waitImageNotVisible(no_friend, 10) then 
            swipeCloseApp()
            goto label_openfacebook
        end
    end

    ::label_findfriend_kill::
    if waitImageVisible(find_friend, 2) then
        toastr("find_friend_kill")
        swipeCloseApp()
        goto label_openfacebook
    end

    ::label_findfriend_swipe::
    if waitImageVisible(find_friend, 2) then
        toastr("find_friend_swipe")
        swipeForce(50, 500, 600, 500)
    end

    findAndClickByImage(accept)
    if checkImageIsExists(profile_picture) then goto label_profilepicture end
    if checkSuspended() then goto label_continue end

    ::label_addphonenumber::
    if waitImageVisible(add_phone_number) then
        toastr("add_phone_number")
        press(380, 1220) -- skip
        waitImageVisible(add_phone_number)
    end

    if checkImageIsExists(create_a_password) then goto label_createpassword end 
    if checkImageIsExists(enter_confirm_code_phone) then goto label_enterconfirmcodedummy end 
    if checkImageIsExists(enter_the_confirmation_code) then goto label_confirmationcode end 
    if checkImageIsExists(profile_picture) then goto label_profilepicture end
    if checkImageIsExists(turn_on_contact) then goto label_turnoncontact end
    if checkImageIsExists(no_friend) then goto label_nofriend end
    if checkImageIsExists(find_friend) then goto label_findfriend_kill end
    if checkImageIsExists(add_phone_number) then goto label_addphonenumber end

    if checkPageNotAvailable() then goto label_continue end
    if checkSuspended() then goto label_continue end
    swipe(600, 750, 610, 800) 

    ::label_get2FA::
    modeMenuLeft = checkModeMenuLeft()
    if waitImageVisible(what_on_your_mind) then 
        toastr('2FA what_on_your_mind')

        if modeMenuLeft then 
            toast('modeMenuLeft')
            press(40, 90) sleep(2) -- go to menu
            press(560, 1100) sleep(2) -- go to configuration
            press(110, 210) -- go to privacy
        else 
            press(690, 1290) -- go to menu
            if waitImageVisible(setting_menu, 10) then
                toastr('setting_menu')
                press(600, 90) -- setting cog icon
                waitImageNotVisible(setting_menu)
            end
        end 

        if waitImageVisible(setting_privacy, 20) then
            toastr('setting_privacy')
            if waitImageVisible(see_more_account_center, 20) then
                findAndClickByImage(see_more_account_center)
                waitImageNotVisible(see_more_account_center)
            end
        end

        if checkPageNotAvailable() then goto label_continue end

        if waitImageVisible(account_center, 20) then
            toastr('account_center')
            sleep(1)
            swipe(600, 800, 610, 720) sleep(2)

            if waitImageVisible(personal_details_btn) then
                findAndClickByImage(personal_details_btn)
            else
                if waitImageVisible(your_information_and_permission) then
                    findAndClickByImage(your_information_and_permission)
                end
            end
        end

        if waitImageVisible(personal_details_page, 15) or waitImageVisible(your_information_and_per_btn, 15) then
            toastr('personal_details_page')
            
            waitImageVisible(identify_confirmation_btn)
            findAndClickByImage(identify_confirmation_btn)
            waitImageNotVisible(identify_confirmation_btn)
        end

        if waitImageVisible(confirm_your_identity, 15) then
            toastr('confirm_your_identity')
            findAndClickByImage(confirm_your_identity)
            press(130, 1290) -- protect your account
            waitImageNotVisible(confirm_your_identity)
        end

        if waitImageVisible(reenter_password, 10) then
            toastr('reenter_password')

            press(135, 530) -- input password
            findAndClickByImage(password_eye)
            typeText(info.password)
            press(370, 710) -- continue_btn
            waitImageNotVisible(reenter_password)
        end

        if LOGIN_WITH_CODE then 
            if waitImageVisible(continue_code_mail) then
                toast('continue_code_mail')
                findAndClickByImage(continue_code_mail)
                waitImageVisible(check_your_email, 10)
            end
        end 

        if waitImageVisible(check_your_email, 3) then
            toastr('check_your_email')
            local again = 1

            ::label_getownercodeagain::
            sleep(5)
            local code = getCodeMailOwner()
            toastr('CODE: ' .. (code or '-'), 2)
            again = again + 1

            if code and code ~= '' and (#code == 8 or #code == 6) then 
                press(100, 850) 
                swipe(600, 330, 600, 500)
                sleep(1)
                findAndClickByImage(x_input_icon)
                typeText(code) sleep(1)
                if waitImageVisible(continue_code_mail) then
                    findAndClickByImage(continue_code_mail)
                    waitImageNotVisible(check_your_email)
                else 
                    findAndClickByImage(next)
                    waitImageNotVisible(check_your_email)
                end 

                if checkImageIsExists(red_warning_icon) and again < 3 then 
                    goto label_getownercodeagain
                end 
            else 
                finishCurrentAccount()
                press(55, 160) -- X

                if waitImageVisible(protect_your_account) then
                    press(40, 90) sleep(1) -- back on protect your account
                    press(40, 90) sleep(1) -- back on confirm identity
                    press(45, 90) sleep(1) -- back to setting menu
                    if not modeMenuLeft then press(45, 90) end -- back to main menu
                end
                press(60, 1290) -- back to homepage

                goto label_searchtext
            end 
        end

        if waitImageVisible(help_protect_account, 10) then
            toastr('help_protect_account')
            findAndClickByImage(next)
            waitImageNotVisible(help_protect_account)
        end

        if LOGIN_WITH_CODE then 
            if waitImageVisible(what_app, 2) then
                finishCurrentAccount('other_device')
                goto label_continue
            end

            if waitImageVisible(check_notification_device, 1) then
                finishCurrentAccount('other_device')
                goto label_continue
            end
        end 

        if waitImageVisible(instructions_for_setup, 10) and waitImageVisible(copy_key, 10) then
            toastr('instructions_for_setup')
            findAndClickByImage(copy_key) sleep(4)
            local secret = clipText()
            if secret then
                info.twoFA = string.gsub(secret, " ", "")
                findAndClickByImage(next)
                waitImageNotVisible(instructions_for_setup) sleep(2)
            end
        end

        if waitImageVisible(enter_code_2fa, 10) or waitImageVisible(two_FA_code, 10) then
            toastr('two_FA_code')
            local otp = get2FACode()
            if otp then
                press(660, 525) -- input otp code
                typeText(otp)

                findAndClickByImage(next)
                waitImageNotVisible(enter_code_2fa, 10)
            else 
                info.twoFA = nil
                finishCurrentAccount()
                
                if waitImageVisible(reenter_password, 10) then
                    press(55, 155) -- X on re-enter password
                end
                if waitImageVisible(protect_your_account) then
                    press(40, 90) sleep(1) -- back on protect your account
                    press(40, 90) sleep(1) -- back on confirm identity
                    press(45, 90) sleep(1) -- back to setting menu
                    if not modeMenuLeft then press(45, 90) end -- back to main menu
                end
                press(60, 1290) -- back to homepage
                
                goto label_searchtext
            end 
        end

        if waitImageVisible(two_factor_is_on, 10) then
            toastr('two_factor_is_on')
            press(380, 1160) -- btn done

            archiveCurrentAccount()
            finishCurrentAccount()

            waitImageNotVisible(two_factor_is_on)
            if waitImageVisible(reenter_password) then
                press(55, 155) -- X on re-enter password
            end
            if waitImageVisible(protect_your_account) then
                press(40, 90) sleep(1) -- back on protect your account
                press(40, 90) sleep(1) -- back on confirm identity
                press(45, 90) sleep(1) -- back to setting menu
                if not modeMenuLeft then press(45, 90) end -- back to main menu
            end
            press(60, 1290) -- back to homepage
        end
    end

    ::label_searchtext::
    toastr('wait searchtext..')
    if waitImageVisible(what_on_your_mind) then
        toastr('Search what_on_your_mind')
        press(600, 90) -- go to search screen

        local searchTexts = getSearchText(math.random(3, 5))
        for i, line in ipairs(searchTexts) do
            typeText(line)
            press(700, 1300) sleep(2) -- btn search blue
            sleep(3)
            if i < #searchTexts then
                press(300, 90); -- click back into search box

                if waitImageVisible(x_icon_search, 2) then
                    findAndClickByImage(x_icon_search)
                else 
                    press(600, 90);
                end
            else
                press(60, 1290) -- back to homepage

                sleep(1)
                resetInfoObject()
                toastr('+1 nick live', 3)
                goto label_continue
            end
        end
    end

    ::label_logout::
    if waitImageVisible(what_on_your_mind, 2) then 
        toastr('Logout what_on_your_mind')

        if modeMenuLeft then 
            press(40, 90) sleep(1) -- go to menu
            swipe(500, 600, 500, 350) sleep(1)
        else 
            press(690, 1290) -- go to menu
            swipe(500, 900, 500, 800) sleep(1)
            swipe(550, 600, 600, 350) sleep(2)
        end 

        if waitImageVisible(logout_btn) then
            findAndClickByImage(logout_btn) sleep(1)
        end
        if waitImageVisible(not_now, 2) then
            findAndClickByImage(not_now) sleep(1)
            waitImageNotVisible(not_now)
        end
        if waitImageVisible(logout_btn) then
            findAndClickByImage(logout_btn) sleep(1)
            waitImageNotVisible(logout_btn)
        end

        removeAccount()
    end

    if waitImageVisible(enter_confirm_code_phone, 1) then goto label_enterconfirmcodedummy end 
    if waitImageVisible(enter_the_confirmation_code, 1) then goto label_confirmationcode end 
    if waitImageVisible(profile_picture, 1) then goto label_profilepicture end
    if waitImageVisible(turn_on_contact, 1) then goto label_turnoncontact end
    if waitImageVisible(no_friend, 1) then goto label_nofriend end
    if waitImageVisible(find_friend, 1) then goto label_findfriend_kill end
    if waitImageVisible(add_phone_number, 1) then goto label_addphonenumber end
    if checkSuspended() then goto label_continue end

    toastr('last check..')
    sleep(2)
    if info.status == 'INPROGRESS' then 
        if info.mailRegister ~= nil and info.mailRegister ~= '' then 
            swipeCloseApp()
            goto label_openfacebook
        else 
            resetInfoObject()
            goto label_continue
        end 
    else 
        resetInfoObject()
        goto label_continue
    end
end

main()
