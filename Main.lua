-- ====== CONFIG ======
LANGUAGE = 'ES' -- EN|ES English|Spanish
MAIL_MODE = 1  -- 1|2 hotmail-dongvanfb|gmail-thuemails.com
ADD_MAIL_DOMAIN = false
REMOVE_REGISTER_MAIL = false
THUE_LAI_MAIL_THUEMAILS = false
TIMES_XOA_INFO = 2 -- 0|1|2|3

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
local images = require(isES() and "images_es" or "images")
require('utils')
require('functions')


-- ====== MAIN ======
function main()

    ::continue::
    log('----------------------------------- Main running ---------------------------------------')
    archiveCurrentAccount()

    
    toastr(waitImageVisible(create_new_account), 5)
    exit()

    goto debug
    ::debug::

    if info.mailRegister == nil or info.mailRegister == '' then 
        homeAndUnlockScreen()
        executeXoaInfo() sleep(1)
    end

    ::openFacebook::
    openFacebook()
    sleep(5)
 
    if waitImageVisible(page_not_available_now) then 
        toast('page_not_available_now')
        swipeCloseApp()
        goto continue
    end 

    if checkSuspended() then goto continue end

    if  info.profileUid then goto continueAccountRegistered end 

    if waitImageVisible(create_new_account, 30) then
        if checkImageIsExists(fb_logo_mode_new) or waitImageVisible(join_facebook) then 
            toast('facebook mode new.')

            swipeCloseApp()
            goto openFacebook
        end

        findAndClickByImage(create_new_account)

        if waitImageNotVisible(logo_facebook_2, 20) then 
            sleep(3)
        else 
            toast('Can not next Logo page')
            swipeCloseApp()
            goto continue
        end
        sleep(3)
    end

    if waitImageVisible(get_started) then
        toast('get_started')
        findAndClickByImage(get_started)
        waitImageNotVisible(get_started)
    end

    if waitImageVisible(create_new_account_blue) then
        toast('create_new_account_blue')
        findAndClickByImage(create_new_account_blue)
        waitImageNotVisible(create_new_account_blue)
    end

    setFirstNameLastName()
    
    if waitImageVisible(what_is_birthday, 3) then
        toast("what_is_birthday")
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

        if waitImageNotVisible(what_is_birthday, 30) then 
        else 
            toast('Can not next')
            swipeCloseApp()
            goto openFacebook
        end 
    end

    setGender()

    if waitImageVisible(what_is_mobile_number) then
        toast("what_is_mobile_number")
        findAndClickByImage(sign_up_with_email)
        waitImageNotVisible(what_is_mobile_number)
    end

    if waitImageVisible(what_is_your_email, 6) then
        toast("what_is_your_email")

        ::findnewemmail::
        if info.mailRegister and info.mailRegister ~= '' then 
            press(660, 410) -- X icon click
            press(660, 410)
            typeText(info.mailRegister) sleep(0.5)

            findAndClickByImage(next)
            archiveCurrentAccount()

            if waitImageVisible(already_have_account, 2) then
                toast("already_have_account")
                findAndClickByImage(continue_creating_account)
            end

            if waitImageVisible(exist_account_in_mail, 8) then
                info.mailRegister = nil
                swipeCloseApp()
                goto continue
            end
        else
            executeGetMailRequest()
            if info.mailRegister and info.mailRegister ~= '' then 
                goto findnewemmail
            else 
                toast("Không có mail. Continue.", 10) sleep(6)

                swipeCloseApp()
                goto continue
            end
        end

        if not waitImageNotVisible(what_is_your_email) then 
            swipeCloseApp()
            goto openFacebook
        end
    end

    if waitImageVisible(what_is_birthday, 2) then
        toast("what_is_birthday")
        press(270, 470) sleep(0.5)

        for i = 1, math.random(2, 5) do
            press(200, math.random(1003, 1008))
        end
        for i = 1, math.random(3, 10) do
            press(400, math.random(1003, 1008))
        end
        for i = 1, math.random(12, 18) do
            press(600, math.random(1003, 1008))
        end
        findAndClickByImage(next)
        
        if waitImageNotVisible(what_is_birthday, 30) then 
        else 
            toast('Can not next')
            swipeCloseApp()
            goto openFacebook
        end 
    end

    setGender()

    if waitImageVisible(create_a_password) then
        toast("create_a_password")
        press(135, 450)
        press(660, 450)
        typeText(info.password) sleep(0.5)
        findAndClickByImage(next)

        if waitImageNotVisible(create_a_password, 30) then 
        else 
            toast('Can not next')
            swipeCloseApp()
            homeAndUnlockScreen()
            executeXoaInfo() sleep(1)
            goto openFacebook
        end 
    end

    if waitImageVisible(you_are_logged_in, 2) then
        toast("you_are_logged_in")
        press(375, 805) -- OK btn
    end

    if waitImageVisible(save_your_login_info, 8) then
        toast("save_your_login_info")
        findAndClickByImage(save)

        waitImageNotVisible(save_your_login_info)
    end

    if waitImageVisible(continue_creating_account, 3) then
        toast("continue_creating_account")
        findAndClickByImage(continue_creating_account)
    end

    if  waitImageVisible(to_sign_up_agree) or waitImageVisible(agree_facebook_term) or waitImageVisible(i_agree_btn) then
        toast("agree_facebook_term")

        if waitImageVisible(dont_allow, 2) then
            findAndClickByImage(dont_allow)
        end

        findAndClickByImage(i_agree_btn)
        waitImageNotVisible(agree_facebook_term, 60)

        if checkImageIsExists(to_sign_up_agree) or checkImageIsExists(agree_facebook_term) or checkImageIsExists(i_agree_btn) then 
            goto continue
        end 

        if waitImageVisible(already_have_account) then
            press(380, 600)
            waitImageNotVisible(already_have_account, 30)
        end
    end

    ::confirmationcode::
    if waitImageVisible(enter_the_confirmation_code, 10) or waitImageVisible(did_not_get_code, 10) then
        toast("enter_the_confirmation_code")
        sleep(3)

        if waitImageVisible(dont_allow, 2) then
            findAndClickByImage(dont_allow)
        end

        local OTPcode = getCodeMailRegister()
        if OTPcode then 
            findAndClickByImage(input_confirm_code)
            typeText(OTPcode) sleep(1)
            findAndClickByImage(next)
        else
            toast('empty OTP', 6)
            press(55, 90) sleep(1) -- X back icon
            press(240, 820) sleep(1) -- Leave btn

            -- Cancel all
            failedCurrentAccount()

            goBackToCreateNewAccount()
            removeAccount()
            goto continue
        end

        if waitImageNotVisible(enter_the_confirmation_code) then 
            info.profileUid = getUIDFBLogin()
            archiveCurrentAccount()
            sleep(5)
        end

        if checkSuspended() then goto continue end
    end

    ::continueAccountRegistered::
    if waitImageVisible(profile_picture, 8) or waitImageVisible(add_picture, 8) then
        toast("profile_picture")
        if waitImageVisible(not_now, 2) then
            findAndClickByImage(not_now)
        else 
            press(380, 1260) -- skip
        end
        
        if waitImageNotVisible(profile_picture, 20) then 
            sleep(3)
        else 
            swipeCloseApp()
            goto openFacebook
        end 

        if checkSuspended() then goto continue end

        if waitImageVisible(dont_allow, 2) then
            findAndClickByImage(dont_allow)
        end
    end

    if waitImageVisible(turn_on_contact) then
        toast("turn_on_contact")
        press(380, 1200) sleep(1) -- next

        if waitImageVisible(skip, 2) then
            findAndClickByImage(skip)
        end 

        if waitImageVisible(next, 2) then
            findAndClickByImage(next)
        end 

        if waitImageVisible(not_now, 2) then
            findAndClickByImage(not_now)
        end 

        if waitImageVisible(dont_allow, 2) then
            findAndClickByImage(dont_allow)
        end
        
        waitImageNotVisible(turn_on_contact)
        sleep(2)
    end

    if waitImageVisible(no_friend) then
        toast("no_friend")
        press(380, 1200) -- next
        waitImageVisible(no_friend)
    end

    if waitImageVisible(add_phone_number, 3) then
        toast("add_phone_number")
        press(380, 1220) -- skip
        waitImageVisible(add_phone_number)
    end

    if waitImageVisible(add_phone_number_home, 3) then
        toast("add_phone_number_home")
        findAndClickByImage(not_now)
    end

    if waitImageVisible(enter_the_confirmation_code, 1) then 
        goto confirmationcode
    end 

    if checkSuspended() then goto continue end

    if waitImageVisible(page_not_available_now) then 
        toast('page_not_available_now')
        swipeCloseApp()
        goto openFacebook
    end 

    ::get2FA::
    toast('2FA..')
    if waitImageVisible(what_on_your_mind) then 
        toast('2FA what_on_your_mind')
        press(690, 1290) -- go to menu

        if waitImageVisible(setting_menu, 8) then
            toast('setting_menu')
            press(600, 90)
            waitImageNotVisible(setting_menu)
            sleep(2) -- setting cog icon
        end

        if waitImageVisible(setting_privacy, 8) then
            toast('setting_privacy')
            if waitImageVisible(see_more_account_center, 10) then
                findAndClickByImage(see_more_account_center)
                waitImageNotVisible(setting_privacy)
            end
        end

        if waitImageVisible(account_center, 8) then
            toast('account_center')
            sleep(1)
            swipe(600, 800, 610, 650) sleep(2)

            if waitImageVisible(personal_details_btn) then
                findAndClickByImage(personal_details_btn)
            else
                if waitImageVisible(your_information_and_permission) then
                    findAndClickByImage(your_information_and_permission)
                end
            end
        end

        if waitImageVisible(personal_details_page, 8) or waitImageVisible(your_information_and_2, 8) then
            toast('personal_details_page')
            findAndClickByImage(identify_confirmation_btn)
            waitImageNotVisible(identify_confirmation_btn)
            sleep(3)
        end

        if waitImageVisible(confirm_your_identity, 10) then
            toast('confirm_your_identity')
            findAndClickByImage(confirm_your_identity) sleep(0.5)
            press(130, 1290) -- protect your account
        end

        if waitImageVisible(reenter_password, 10) then
            toast('reenter_password')
            press(135, 530) -- input password
            press(660, 525) -- input password
            typeText(info.password) sleep(0.5)
            press(370, 710) -- continue_btn
        end
        
        if waitImageVisible(check_your_email) then
            toast('check_your_email')
            local code = getCodeMailConfirm()
            toast('CODE: ' .. (code or '-'), 2)

            if code and code ~= '' then
                press(100, 850) -- code input
                typeText(code) sleep(1)
                if waitImageVisible(continue_code_mail) then
                    findAndClickByImage(continue_code_mail)

                    waitImageNotVisible(check_your_email)
                end
            else 
                finishCurrentAccount()
                goto searchtext
            end
        end

        if waitImageVisible(help_protect_account, 8) then
            toast('help_protect_account')
            findAndClickByImage(next)
            waitImageNotVisible(help_protect_account)
        end

        if waitImageVisible(instructions_for_setup, 8) and waitImageVisible(copy_key) then
            toast('instructions_for_setup')
            findAndClickByImage(copy_key) sleep(4)
            local secret = clipText()
            if secret then
                info.twoFA = string.gsub(secret, " ", "")
                findAndClickByImage(next)
                waitImageNotVisible(instructions_for_setup) sleep(2)
            end
        end

        if waitImageVisible(two_FA_code, 8) or waitImageVisible(enter_code_2fa, 8) then
            toast('two_FA_code')
            local otp = get2FACode()
            if otp then
                press(660, 525) -- input otp code
                press(660, 525)
                typeText(otp) sleep(0.5)
            end
            findAndClickByImage(next)
            waitImageNotVisible(next)
        else 
            info.twoFA = nil
            finishCurrentAccount()
            goto searchtext
        end

        if waitImageVisible(two_factor_is_on, 8) then
            toast('two_factor_is_on')
            press(380, 1160) -- btn done

            archiveCurrentAccount()
            finishCurrentAccount()

            waitImageNotVisible(two_factor_is_on)
            if waitImageVisible(reenter_password) then
                press(55, 155) -- X on re-enter password
            end
            if waitImageVisible(protect_your_account) then
                press(40, 90) -- back on protect your account
                press(40, 90) sleep(1) -- back on confirm identity
                press(45, 90) -- back to setting menu
            end
            if waitImageVisible(home_icon) then
                press(60, 1290) -- back to homepage
            end
        end
    end

    ::searchtext::
    if waitImageVisible(what_on_your_mind) then
        toast('Search what_on_your_mind')
        press(600, 90) -- go to search screen

        local searchTexts = getSearchText(math.random(4, 6))
        for i, line in ipairs(searchTexts) do
            typeText(line) sleep(0.5)
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

    ::logout::
    if waitImageVisible(what_on_your_mind) then 
        toast('Logout what_on_your_mind')
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
        toast('Done nick live')
    else 
        if checkSuspended() then goto continue end
    end

    sleep(2)
    if info.status == 'INPROGRESS' then 
        swipeCloseApp()
        goto openFacebook
    else 
        resetInfoObject()
        goto continue
    end
end

main()
