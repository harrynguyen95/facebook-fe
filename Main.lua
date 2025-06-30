-- ====== CONFIG ======
MAIL_MODE = 1  -- 1|2 hotmail-dongvanfb|gmail-thuemails.com
THUE_LAI_MAIL_THUEMAILS = true -- 1-true|2-false
ADD_MAIL_DOMAIN = false
REMOVE_REGISTER_MAIL = true
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
require('images')
require('utils')
require('functions')

-- ====== MAIN ======
function main()

    ::continue::
    log('----------------------------------- Main running ---------------------------------------')
    archiveCurrentAccount()

    goto debug
    ::debug::

    ::xoainfo::
    if info.mailRegister == nil or info.mailRegister == '' then 
        -- Chưa lấy đc mail mới mới reset. Lấy được rồi thì thôi

        homeAndUnlockScreen()
        executeXoaInfo() sleep(1)
    end

    ::openFacebook::
    openFacebook()

    if waitImageVisible(page_not_available_now) then 
        swipeCloseApp()
        goto openFacebook
    end 

    if waitImageVisible(dont_allow, 2) then
        findAndClickByImage(dont_allow)
    end

    if waitImageVisible(create_new_account, 30) then
        if checkImageIsExists(fb_logo_mode_new) then 
            swipeCloseApp()
            goto continue
        end

        findAndClickByImage(create_new_account)

        if waitImageNotVisible(logo_facebook_2, 20) then 
        else 
            toast('Can not next Logo page')
            swipeCloseApp()
            goto openFacebook
        end
        sleep(3)
    end

    if checkSuspended() then goto continue end

    if waitImageVisible(join_facebook, 3) then
        toast('facebook mode new.')
        swipeCloseApp()
        goto openFacebook
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

        if waitImageNotVisible(what_is_birthday, 20) then 
        else 
            toast('Can not next birthday')
            swipeCloseApp()
            goto openFacebook
        end 
    end

    setGender()

    if waitImageVisible(what_is_mobile_number, 1) then
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

    if waitImageVisible(already_have_account, 2) then
        toast("already_have_account")
        findAndClickByImage(continue_creating_account)
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
        
        if waitImageNotVisible(what_is_birthday, 20) then 
        else 
            toast('Can not next birthday')
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
        waitImageNotVisible(create_a_password)
    end

    if waitImageVisible(you_are_logged_in, 2) then
        toast("you_are_logged_in")
        press(375, 805) -- OK btn
    end

    if waitImageVisible(save_your_login_info, 8) then
        toast("save_your_login_info")
        press(370, 510)
        findAndClickByImage(not_now)

        waitImageNotVisible(save_your_login_info)
    end

    if waitImageVisible(continue_creating_account, 2) then
        toast("continue_creating_account")
        findAndClickByImage(continue_creating_account)
    end

    if  waitImageVisible(to_sign_up_agree) or waitImageVisible(agree_facebook_term) or waitImageVisible(i_agree_btn) then
        toast("i_agree_btn")

        if waitImageVisible(dont_allow, 2) then
            findAndClickByImage(dont_allow)
        end

        findAndClickByImage(i_agree_btn)
        waitImageNotVisible(agree_facebook_term, 60)

        if checkImageIsExists(to_sign_up_agree) or checkImageIsExists(agree_facebook_term) or checkImageIsExists(i_agree_btn) then 
            goto xoainfo
        end

        if waitImageVisible(do_you_already_have_account) then
            press(380, 600)
            waitImageNotVisible(do_you_already_have_account, 30)
        end
    end

    if waitImageVisible(enter_the_confirmation_code, 10) then
        toast("enter_the_confirmation_code")
        sleep(3)

        if waitImageVisible(dont_allow, 2) then
            findAndClickByImage(dont_allow)
        end

        local OTPcode = getCodeMailRegister()
        if OTPcode then 
            press(130, 410)
            press(660, 410)
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

        waitImageNotVisible(enter_the_confirmation_code)

        info.profileUid = getUIDFBLogin()
        archiveCurrentAccount()

        if checkSuspended() then goto continue end
    end

    if waitImageVisible(profile_picture, 3) then
        toast("profile_picture")
        if waitImageVisible(not_now, 2) then
            findAndClickByImage(not_now)
        else 
            press(380, 1260) -- skip
        end
        
        waitImageNotVisible(profile_picture)
        sleep(2)
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

    if checkSuspended() then goto continue end

    if waitImageVisible(page_not_available_now) then 
        swipeCloseApp()
        goto openFacebook
    end 

    ::get2FA::
    if waitImageVisible(what_on_your_mind) then 
        toast('2FA what_on_your_mind')
        press(690, 1290) -- go to menu

        if waitImageVisible(setting_menu) then
            toast('setting_menu')
            press(600, 90) sleep(2) -- setting cog icon
        end

        if waitImageVisible(setting_privacy) then
            toast('setting_privacy')
            if waitImageVisible(see_more_account_center) then
                findAndClickByImage(see_more_account_center)
                waitImageNotVisible(setting_privacy)
            end
        end

        if waitImageVisible(account_center) then
            toast('account_center')
            swipe(600, 800, 610, 650) sleep(1)

            if waitImageVisible(personal_details_btn) then
                findAndClickByImage(personal_details_btn)
            else
                if waitImageVisible(your_information_and_permission) then
                    findAndClickByImage(your_information_and_permission)
                end
            end
        end

        if waitImageVisible(personal_details_page) or waitImageVisible(your_information_and_2) then
            toast('personal_details_page')
            findAndClickByImage(identify_confirmation_btn)
        end

        if waitImageVisible(confirm_your_identity) then
            toast('confirm_your_identity')
            findAndClickByImage(confirm_your_identity) sleep(0.5)
            press(130, 1290) -- protect your account
        end

        if waitImageVisible(reenter_password, 3) then
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

        if waitImageVisible(help_protect_account) then
            toast('help_protect_account')
            findAndClickByImage(next)
            waitImageNotVisible(help_protect_account)
        end

        if waitImageVisible(instructions_for_setup) and waitImageVisible(copy_key) then
            toast('instructions_for_setup')
            findAndClickByImage(copy_key) sleep(4)
            local secret = clipText()
            if secret then
                info.twoFA = string.gsub(secret, " ", "")
                findAndClickByImage(next)
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
        goto openFacebook
    else 
        resetInfoObject()
        goto continue
    end
end

main()
