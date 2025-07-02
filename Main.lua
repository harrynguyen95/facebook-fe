-- ====== CONFIG ======
LANGUAGE = 'ES'  -- EN|ES English|Spanish
MAIL_SUPLY = 2  -- 1|2 hotmail_dongvanfb|thuemails.com
THUE_LAI_MAIL_THUEMAILS = true  -- true|false
ADD_MAIL_DOMAIN = false
REMOVE_REGISTER_MAIL = false
PROVIDER_MAIL_THUEMAILS = 1  -- 1|3 gmail|icloud
TIMES_XOA_INFO = 1  -- 0|1|2|3

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
    hotmailRefreshToken =nil,
    hotmailClientId = nil,
    hotmailPassword = nil,
}

-- ====== LIB REQUIRED ======
function isES() return LANGUAGE == 'ES' end
local images = require(isES() and (currentDir() .. "/images_es") or (currentDir() .. "images"))
require('utils')
require('functions')

-- ====== MAIN ======
function main()

    ::label_continue::
    log('----------------------------------- Main running ---------------------------------------')
    archiveCurrentAccount()

    goto debug
    ::debug::

    if info.mailRegister == nil or info.mailRegister == '' then 
        homeAndUnlockScreen()
        executeXoaInfo() sleep(1)
    else 
        swipeCloseApp()
    end

    ::label_openfacebook::
    openFacebook()
    showIphoneModel()
    sleep(10)
 
    if waitImageVisible(page_not_available_now, 2) then 
        toastr('page_not_available_now')
        failedCurrentAccount()
        goto label_continue
    end 

    ::label_createnewaccount::
    toastr('wait login..')
    if waitImageVisible(create_new_account, 50) then
        toastr('create_new_account')

        if waitImageVisible(logo_fb_modern, 3) then
            toastr('not_support_this_FB_mode')

            swipeCloseApp()
            goto label_continue
        end

        findAndClickByImage(create_new_account)

        if waitImageNotVisible(logo_facebook_2, 50) then 
            sleep(3)
        else 
            toastr('Can not next')
            swipeCloseApp()
            goto label_continue
        end
    else 
        toastr('not login..')
        if checkSuspended() then goto label_continue end
        if checkImageIsExists(what_is_birthday) then goto label_birthday end
        if checkImageIsExists(what_is_mobile_number) then goto label_what_is_mobile end
        if checkImageIsExists(what_is_your_email) then goto label_what_is_email end
        if checkImageIsExists(enter_the_confirmation_code) then goto label_confirmationcode end
        if checkImageIsExists(create_a_password) then goto label_createpassword end
        if checkImageIsExists(save_your_login_info) then goto label_saveyourlogin end
        if checkImageIsExists(profile_picture) then goto label_profilepicture end
        if checkImageIsExists(turn_on_contact) then goto label_turnoncontact end
        if checkImageIsExists(no_friend) then goto label_nofriend end
        if checkImageIsExists(add_phone_number) then goto label_addphonenumber end
        if checkImageIsExists(to_sign_up_agree) or checkImageIsExists(agree_facebook_term) then goto label_agree end
        if checkImageIsExists(what_on_your_mind) then 
            if info.twoFA == '' then goto label_get2FA end 
            if info.twoFA ~= '' then goto label_searchtext end 
        end
    end

    if waitImageVisible(join_facebook, 2) then 
        toastr('not_support_this_FB_mode')

        swipeCloseApp()
        goto label_continue
    end

    toastr('wait create_new_account_blue..')
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

    if checkImageIsExists(create_new_account) then goto label_createnewaccount end 

    setFirstNameLastName()

    ::label_birthday::
    toastr('wait birthday..')
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
            if findAndClickByImage(next) then 
                if not waitImageNotVisible(what_is_birthday, 20) then 
                    toastr('Can not next')
                    swipeCloseApp()
                    goto label_openfacebook
                end 
            end
        end 
    end

    setGender()
    sleep(2)

    ::label_what_is_mobile::
    toastr('wait mobile..')
    if waitImageVisible(what_is_mobile_number) or waitImageVisible(sign_up_with_email) then
        toastr("what_is_mobile_number")
        findAndClickByImage(sign_up_with_email)
        waitImageNotVisible(what_is_mobile_number)
    end

    ::label_what_is_email::
    toastr('wait email..')
    if waitImageVisible(what_is_your_email) then
        toastr("what_is_your_email")
        -- or waitImageVisible(mail_did_not_receive_code) 

        if info.mailRegister ~= nil and info.mailRegister ~= '' then 
            press(310, 410)
            findAndClickByImage(x_input_icon)
            typeText(info.mailRegister)

            findAndClickByImage(next)
            archiveCurrentAccount()

            if waitImageVisible(already_have_account, 2) then
                toastr("already_have_account")
                findAndClickByImage(continue_creating_account)
                sleep(2)
            end

            if waitImageVisible(exist_account_in_mail) then
                toastr('exist_account_in_mail')
                failedCurrentAccount()
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

                    if waitImageVisible(already_have_account, 2) then
                        toastr("already_have_account")
                        findAndClickByImage(continue_creating_account)
                        sleep(2)
                    end

                    if waitImageVisible(exist_account_in_mail) then
                        toastr('exist_account_in_mail')
                        failedCurrentAccount()
                        goto label_continue
                    end
                end
            else 
                toastr("Không có mail. Continue.", 10) sleep(5)
                failedCurrentAccount()
                goto label_continue
            end
        end

        if waitImageNotVisible(what_is_your_email, 60) then 
        else 
            toastr('Can not next')
            swipeCloseApp()
            goto label_openfacebook
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
            if findAndClickByImage(next) then 
                if not waitImageNotVisible(what_is_birthday, 20) then 
                    toastr('Can not next')
                    swipeCloseApp()
                    goto label_openfacebook
                end 
            end
        end 
    end

    setGender()

    ::label_createpassword::
    toastr('wait password..')
    if waitImageVisible(create_a_password) then
        toastr("create_a_password")
        press(135, 450)
        findAndClickByImage(password_eye)
        typeText(info.password)
        findAndClickByImage(next)

        if not waitImageNotVisible(create_a_password, 60) then 
            toastr('Can not next')
            swipeCloseApp()
            goto label_openfacebook
        end 
    end

    -- if waitImageVisible(you_are_logged_in, 2) then
    --     toastr("you_are_logged_in")
    --     press(375, 805) -- OK btn
    -- end

    ::label_saveyourlogin::
    if waitImageVisible(save_your_login_info) then
        toastr("save_your_login_info")
        findAndClickByImage(save)

        waitImageNotVisible(save_your_login_info)
    end

    if waitImageVisible(continue_creating_account, 3) then
        toastr("continue_creating_account")
        findAndClickByImage(continue_creating_account)
    end

    ::label_agree::
    toastr('wait agree..')
    if  waitImageVisible(to_sign_up_agree) or waitImageVisible(agree_facebook_term) then
        toastr("agree_facebook_term")

        findAndClickByImage(dont_allow)
        findAndClickByImage(i_agree_btn)

        if waitImageVisible(dont_allow, 10) then 
            -- toastr('Can not agree')
            -- failedCurrentAccount()
            -- goto label_continue
        end 
        
        if not waitImageNotVisible(agree_facebook_term, 60) then 
            toastr('Can not agree')
            failedCurrentAccount()
            goto label_continue
        end 

        if waitImageVisible(already_have_account) then
            press(380, 600)
            waitImageNotVisible(already_have_account)
        end

        sleep(5)
    end

    ::label_confirmationcode::
    toastr('wait confirmcode..')
    if waitImageVisible(enter_the_confirmation_code, 20) then
        toastr("enter_the_confirmation_code")

        sleep(1)
        findAndClickByImage(dont_allow)

        local OTPcode = getCodeMailRegister()
        toastr('OTPcode: ' .. (OTPcode or '-'))
        if OTPcode then 
            findAndClickByImage(input_confirm_code)
            typeText(OTPcode) sleep(1)
            findAndClickByImage(next)
        else
            toastr('empty OTP', 6) sleep(3)
            press(55, 90) sleep(1) -- X back icon
            press(240, 820) sleep(1) -- Leave btn

            failedCurrentAccount()
            goto label_continue
        end
        
        if waitImageNotVisible(enter_the_confirmation_code) then 
            if waitImageVisible(setting_up_for_fb) then
                toastr('setting_up_for_fb')
                waitImageNotVisible(setting_up_for_fb)
            end
        end

        info.profileUid = getUIDFBLogin()
        archiveCurrentAccount()
        
        if checkSuspended() then goto label_continue end
    end

    ::label_profilepicture::
    toastr('wait profilepicture..')
    if waitImageVisible(profile_picture) then
        toastr("profile_picture")

        if waitImageVisible(dont_allow, 1) then
            findAndClickByImage(dont_allow)
        end

        if waitImageVisible(not_now, 3) then
            findAndClickByImage(not_now)
        else 
            press(380, 1260) -- skip
        end
        
        waitImageNotVisible(profile_picture) 

        if checkSuspended() then goto label_continue end
        waitImageVisible(turn_on_contact)
    end

    ::label_turnoncontact::
    toastr('wait contact..')
    if waitImageVisible(turn_on_contact) then
        toastr("turn_on_contact")
        press(380, 1200) sleep(1) -- next

        if waitImageVisible(skip, 1) then findAndClickByImage(skip) end 
        if waitImageVisible(next, 1) then findAndClickByImage(next) end 
        if waitImageVisible(not_now, 1) then findAndClickByImage(not_now) end 
        if waitImageVisible(dont_allow, 1) then findAndClickByImage(dont_allow) end
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

    ::label_addphonenumber::
    if waitImageVisible(add_phone_number) then
        toastr("add_phone_number")
        press(380, 1220) -- skip
        waitImageVisible(add_phone_number)
    end

    if checkSuspended() then goto label_continue end

    if checkImageIsExists(enter_the_confirmation_code) then goto label_confirmationcode end 

    if checkImageIsExists(page_not_available_now) then 
        toastr('page_not_available_now')
        failedCurrentAccount()
        goto label_continue
    end 

    if waitImageVisible(add_phone_number_home) then
        toastr("add_phone_number_home")
        findAndClickByImage(not_now)
    end

    if checkImageIsExists(profile_picture) then goto label_profilepicture end
    if checkImageIsExists(turn_on_contact) then goto label_turnoncontact end
    if checkImageIsExists(no_friend) then goto label_nofriend end
    if checkImageIsExists(add_phone_number) then goto label_addphonenumber end

    ::label_get2FA::
    toastr('wait 2FA..')
    if waitImageVisible(what_on_your_mind) then 
        toastr('2FA what_on_your_mind')
        press(690, 1290) -- go to menu

        if waitImageVisible(setting_menu, 8) then
            toastr('setting_menu')
            press(600, 90) -- setting cog icon
            waitImageNotVisible(setting_menu)
        end

        if waitImageVisible(setting_privacy, 12) then
            toastr('setting_privacy')
            if waitImageVisible(see_more_account_center, 10) then
                findAndClickByImage(see_more_account_center)
                waitImageNotVisible(see_more_account_center)
            end
        end

        if waitImageVisible(account_center, 12) then
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

        if waitImageVisible(personal_details_page, 12) or waitImageVisible(your_information_and_per_btn, 12) then
            toastr('personal_details_page')
            findAndClickByImage(identify_confirmation_btn)
            waitImageNotVisible(identify_confirmation_btn)
        end

        if waitImageVisible(confirm_your_identity, 12) then
            toastr('confirm_your_identity')
            findAndClickByImage(confirm_your_identity)
            press(130, 1290) -- protect your account
            waitImageNotVisible(confirm_your_identity)
        end

        if waitImageVisible(reenter_password, 12) then
            toastr('reenter_password')
            press(135, 530) -- input password
            findAndClickByImage(password_eye)
            typeText(info.password)
            press(370, 710) -- continue_btn
            waitImageNotVisible(reenter_password)
        end
        
        if waitImageVisible(check_your_email, 3) then
            toastr('check_your_email')
            local code = getCodeMailConfirm()
            toastr('CODE: ' .. (code or '-'), 2)

            if code ~= nil and code ~= '' then
                press(100, 850) -- code input
                typeText(code) sleep(1)
                if waitImageVisible(continue_code_mail) then
                    findAndClickByImage(continue_code_mail)

                    waitImageNotVisible(check_your_email)
                end
            else 
                finishCurrentAccount()
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

        if waitImageVisible(two_FA_code, 10) or waitImageVisible(enter_code_2fa, 10) then
            toastr('two_FA_code')
            local otp = get2FACode()
            if otp then
                press(660, 525) -- input otp code
                typeText(otp)
            end
            findAndClickByImage(next)
            waitImageNotVisible(next)
        else 
            info.twoFA = nil
            finishCurrentAccount()
            goto label_searchtext
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
                press(45, 90)          -- back to main menu
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

        local searchTexts = getSearchText(math.random(4, 6))
        for i, line in ipairs(searchTexts) do
            typeText(line)
            press(700, 1300) sleep(2) -- btn search blue
            sleep(3)
            swipe(500, 900, 500, 800) sleep(2)
            if i < #searchTexts then
                press(300, 90); -- click back into search box

                if waitImageVisible(x_icon_search, 2) then
                    findAndClickByImage(x_icon_search)
                else 
                    press(600, 90);
                end
            else
                press(60, 1290) -- back to homepage
            end
        end
    end

    ::label_logout::
    toastr('wait logout..')
    if waitImageVisible(what_on_your_mind) then 
        toastr('Logout what_on_your_mind')
        press(690, 1290) -- go to menu
        swipe(500, 900, 500, 800) sleep(1)
        swipe(550, 600, 600, 350) sleep(2)

        if waitImageVisible(logout_btn) then
            findAndClickByImage(logout_btn) sleep(1)
        end
        if waitImageVisible(not_now) then
            findAndClickByImage(not_now) sleep(1)
            waitImageNotVisible(not_now)
        end
        if waitImageVisible(logout_btn) then
            findAndClickByImage(logout_btn) sleep(1)
            waitImageNotVisible(logout_btn)
        end

        removeAccount()
        toastr('Done 1 nick live')
    end

    if checkSuspended() then goto label_continue end

    toastr('end..')
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
