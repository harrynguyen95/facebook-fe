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

if not waitForInternet(3) then alert("No Internet!") exit() else toast('Connected!', 2) end
getConfigServer()

-- ====== LOCALE IMAGE REQUIRED ======
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
    if checkImageIsExists(what_is_mobile_number) then goto label_what_is_mobile end
    if checkImageIsExists(what_is_your_email) then goto label_what_is_email end
    if checkImageIsExists(enter_the_confirmation_code) then goto label_confirmationcode end
    if checkImageIsExists(create_a_password) then goto label_createpassword end
    if checkImageIsExists(save_your_login_info) then goto label_saveyourlogin end
    if checkImageIsExists(profile_picture) then goto label_profilepicture end
    if checkImageIsExists(turn_on_contact) then goto label_turnoncontact end
    if checkImageIsExists(no_friend) then goto label_nofriend end
    if checkImageIsExists(find_friend) then goto label_findfriend_swipe end
    if checkImageIsExists(add_phone_number) then goto label_addphonenumber end
    if checkImageIsExists(agree_facebook_term) then goto label_agree end
    if checkImageIsExists(what_on_your_mind) then 
        if info.twoFA == nil or info.twoFA == '' then goto label_get2FA end 
        if info.twoFA ~= nil or info.twoFA ~= '' then goto label_searchtext end 
    end

    if waitImageVisible(create_new_account, 20) then
        if waitImageVisible(logo_fb_modern, 2) then
            toastr('not_support_this_FB_mode')
            swipeCloseApp()
            goto label_continue
        end

        toastr('create_new_account')
        findAndClickByImage(create_new_account) sleep(2)
        if waitImageNotVisible(logo_facebook_login, 30) then 
            sleep(3)
        else 
            toastr('Can not next')
            swipeCloseApp()
            goto label_continue
        end
    else         
        if checkSuspended() then goto label_continue end
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

    ::label_what_is_mobile::
    if waitImageVisible(what_is_mobile_number) or waitImageVisible(sign_up_with_email) then
        toastr("what_is_mobile_number")
        findAndClickByImage(sign_up_with_email)
        waitImageNotVisible(what_is_mobile_number)
    end

    ::label_what_is_email::
    if waitImageVisible(what_is_your_email) then
        toastr("what_is_your_email")
        -- or waitImageVisible(mail_did_not_receive_code) 

        if info.mailRegister ~= nil and info.mailRegister ~= '' then 
            press(310, 410)
            findAndClickByImage(x_input_icon)
            typeText(info.mailRegister)

            findAndClickByImage(next)
            archiveCurrentAccount()

            if waitImageVisible(exist_account_in_mail) then
                toastr('exist_account_in_mail')
                failedCurrentAccount('email_has_account')
                goto label_continue
            end
        else
            if executeGetMailRequest() then 
                if info.mailRegister ~= nil and info.mailRegister ~= '' then 
                    press(310, 410)
                    findAndClickByImage(x_input_icon)
                    typeText(info.mailRegister)

                    findAndClickByImage(next)
                    archiveCurrentAccount()

                    if waitImageVisible(exist_account_in_mail) then
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

        if not waitImageNotVisible(what_is_your_email, 30) then 
            if checkImageIsExists(what_is_your_email) then findAndClickByImage(next) end
            if not waitImageNotVisible(what_is_your_email, 30) then 
                toastr('Can not next')
                swipeCloseApp()
                goto label_openfacebook
            end
        end

        if waitImageVisible(continue_creating_account, 3) then
            toastr("continue_creating_account")
            failedCurrentAccount('email_has_account')
            goto label_continue
        end
    end

    if waitImageVisible(what_is_birthday, 3) then
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

        if not waitImageNotVisible(create_a_password, 40) then 
            if checkImageIsExists(create_a_password) then findAndClickByImage(next) end
            if not waitImageNotVisible(create_a_password, 30) then 
                toastr('Can not next')
                swipeCloseApp()
                goto label_openfacebook
            end 
        end 
    end

    ::label_saveyourlogin::
    if waitImageVisible(save_your_login_info) then
        toastr("save_your_login_info")
        findAndClickByImage(save)
        waitImageNotVisible(save_your_login_info)
    end

    ::label_agree::
    toastr('wait agree..')
    if waitImageVisible(agree_facebook_term) then
        toastr("agree_facebook_term")

        if waitImageVisible(dont_allow, 1) then findAndClickByImage(dont_allow) end
        findAndClickByImage(i_agree_btn)
        
        if waitImageVisible(can_not_agree) then 
            toastr('Can not agree')
            failedCurrentAccount('can_not_agree')
            goto label_continue
        end 

        if not waitImageNotVisible(agree_facebook_term, 90) then 
            toastr('Can not next')
            swipeCloseApp()
            goto label_openfacebook
        end 

        if waitImageVisible(already_have_account) then
            press(380, 600)
            waitImageNotVisible(already_have_account)
        end
    end

    ::label_confirmationcode::
    if waitImageVisible(enter_the_confirmation_code, 10) then
        toastr("enter_the_confirmation_code")

        if waitImageVisible(dont_allow, 1) then findAndClickByImage(dont_allow) end
        info.profileUid = getUIDFBLogin()

        local OTPcode = getCodeMailRegister()
        toastr('OTPcode: ' .. (OTPcode or '-'))
        if OTPcode then 
            info.verifyCode = OTPcode
            archiveCurrentAccount()

            if ENTER_VERIFY_CODE then 
                findAndClickByImage(input_confirm_code)
                findAndClickByImage(x_input_icon)
                typeText(OTPcode) sleep(1)
                findAndClickByImage(next)
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
    if waitImageVisible(no_friend) then
        toastr("no_friend")
        if waitImageVisible(skip, 1) then findAndClickByImage(skip) end 
        findAndClickByImage(next)
        waitImageVisible(no_friend)
    end

    ::label_findfriend_kill::
    if waitImageVisible(find_friend, 3) then
        toastr("find_friend_kill")
        swipeCloseApp()
        goto label_openfacebook
    end

    ::label_findfriend_swipe::
    if waitImageVisible(find_friend, 3) then
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

    if checkImageIsExists(enter_the_confirmation_code) then goto label_confirmationcode end 
    if checkImageIsExists(profile_picture) then goto label_profilepicture end
    if checkImageIsExists(turn_on_contact) then goto label_turnoncontact end
    if checkImageIsExists(no_friend) then goto label_nofriend end
    if checkImageIsExists(find_friend) then goto label_findfriend_kill end
    if checkImageIsExists(add_phone_number) then goto label_addphonenumber end

    if checkPageNotAvailable() then goto label_continue end
    if checkSuspended() then goto label_continue end
    modeMenuLeft = checkModeMenuLeft()

    ::label_get2FA::
    if waitImageVisible(what_on_your_mind) then 
        toastr('2FA what_on_your_mind')
        modeMenuLeft = checkModeMenuLeft()

        if modeMenuLeft then 
            press(40, 90) sleep(1) -- go to menu
            press(560, 1100) sleep(1) -- go to configuration
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
            swipe(600, 800, 610, 650) sleep(1)

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
            findAndClickByImage(identify_confirmation_btn)
            waitImageNotVisible(identify_confirmation_btn)
        end

        if waitImageVisible(confirm_your_identity, 15) then
            toastr('confirm_your_identity')
            findAndClickByImage(confirm_your_identity)
            press(130, 1290) -- protect your account
            waitImageNotVisible(confirm_your_identity)
        end

        if waitImageVisible(reenter_password, 15) then
            toastr('reenter_password')
            press(135, 530) -- input password
            findAndClickByImage(password_eye)
            typeText(info.password)
            press(370, 710) -- continue_btn
            waitImageNotVisible(reenter_password)
        end

        if waitImageVisible(check_your_email, 2) then
            toastr('check_your_email')
            if MAIL_SUPLY == 3 then 
                local code = getMailDomainOwnerConfirmCode()
                toastr('CODE: ' .. (code or '-'), 2)

                if code and code ~= '' then
                    press(100, 850) 
                    typeText(code) sleep(1)
                    if waitImageVisible(continue_code_mail) then
                        findAndClickByImage(continue_code_mail)

                        waitImageNotVisible(check_your_email)
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
                    if waitImageVisible(home_icon) then
                        press(60, 1290) -- back to homepage
                    end

                    goto label_searchtext
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
                if waitImageVisible(home_icon) then
                    press(60, 1290) -- back to homepage
                end

                goto label_searchtext
            end 
        end

        if waitImageVisible(help_protect_account, 10) then
            toastr('help_protect_account')
            findAndClickByImage(next)
            waitImageNotVisible(help_protect_account)
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
                waitImageNotVisible(next)
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
                if waitImageVisible(home_icon) then
                    press(60, 1290) -- back to homepage
                end
                
                goto label_searchtext
            end 
        end

        if waitImageVisible(two_factor_is_on, 10) then
            toastr('two_factor_is_on')
            press(380, 1160) -- btn done

            archiveCurrentAccount()
            finishCurrentAccount()

            waitImageNotVisible(two_factor_is_on)
            if waitImageVisible(reenter_password, 10) then
                press(55, 155) -- X on re-enter password
            end
            if waitImageVisible(protect_your_account) then
                press(40, 90) sleep(1) -- back on protect your account
                press(40, 90) sleep(1) -- back on confirm identity
                press(45, 90) sleep(1) -- back to setting menu
                if not modeMenuLeft then press(45, 90) end -- back to main menu
            end
            if waitImageVisible(home_icon) then
                press(60, 1290) -- back to homepage
            end
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
            -- swipe(500, 900, 500, 800) sleep(2)
            if i < #searchTexts then
                press(300, 90); -- click back into search box

                if waitImageVisible(x_icon_search, 2) then
                    findAndClickByImage(x_icon_search)
                else 
                    press(600, 90);
                end
            else
                if waitImageVisible(home_icon) then
                    press(60, 1290) -- back to homepage
                end

                sleep(1)
                resetInfoObject()
                toastr('+1 nick live', 3)
                goto label_continue
            end
        end
    end

    ::label_logout::
    if waitImageVisible(what_on_your_mind) then 
        toastr('Logout what_on_your_mind')

        if modeMenuLeft() then 
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
