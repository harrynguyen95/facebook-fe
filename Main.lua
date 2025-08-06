-- ====== LIB REQUIRED ======
require(rootDir() .. "/Facebook/utils")
require(rootDir() .. "/Facebook/functions")
clearAlert()

-- ====== INFO ======
info = {
    checkpoint = nil,
    uuid = nil,
    status = nil,
    mailOrderId = nil,
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
    finishSettingMail = nil,
    finishChangeInfo = nil,
    finishAddFriend = nil,
    ipRegister = nil,
}

-- ====== CONFIG ======
LANGUAGE = 'VN'
ACCOUNT_REGION = 'VN'  
MAIL_SUPLY = 1
ENTER_VERIFY_CODE = true
HOTMAIL_SERVICE_IDS = {1, 3, 2, 6, 5}
HOTMAIL_SOURCE_FROM_FILE = false 
THUE_LAI_MAIL = 0  
ADD_MAIL_DOMAIN = 0
MAIL_DOMAIN_TYPE = 0
CHANGE_INFO = false
IP_ROTATE_MODE = 1
TSPROXY_ID = nil
TSPROXY_PORT = nil
PROVIDER_MAIL_THUEMAILS = 1 
TIMES_XOA_INFO = 2 
GMAIL_REGISTER = false 
MAIL_THUEMAILS_API_KEY = "94a3a21c-40b5-4c48-a690-f1584c390e3e" -- Hải
MAIL_DONGVANFB_API_KEY = "iFI7ppA8JNDJ52yVedbPlMpSh" -- Hải
MAIL_GMAIL66_API_KEY = "odjYxf6OURH6O7L4Fg57uJzDDwl9PcZT" -- Nam
PHONE_IRONSIM_API_KEY = "5ebn3408jldmw7ajk86or521o10pz316" -- Hải
LOGIN_NO_VERIFY = false
DUMMY_MODE = 0

if not waitForInternet(2) then alert("No Internet. RESPRING NOW!") exit() end
if not getConfigServer() then alert("No config from server!") exit() end

-- ====== VARIABLE REQUIRED ======
if LANGUAGE == 'ES' then require(rootDir() .. "/Facebook/img/images_es") end
if LANGUAGE == 'EN' then require(rootDir() .. "/Facebook/img/images_en") end
if LANGUAGE == 'VN' then require(rootDir() .. "/Facebook/img/images_vn") end
SHOULD_DUMMY = DUMMY_MODE ~= 0
DUMMY_PHONE = DUMMY_MODE == 1
DUMMY_GMAIL = DUMMY_MODE == 2
DUMMY_ICLOUD = DUMMY_MODE == 3
VERIFY_PHONE = MAIL_SUPLY == 5

-- ====== MAIN ======
function main()
    if IP_ROTATE_MODE == 2 then offWifi() swipeCloseApp() end
    if IP_ROTATE_MODE == 3 or IP_ROTATE_MODE == 1 then checkOnShadowRocket() swipeCloseApp() end
    if IP_ROTATE_MODE == 4 then swipeCloseApp() end

    ::label_continue::
    log('------------ Main running ------------')
    archiveCurrentAccount()

    if LOGIN_NO_VERIFY then initCurrentAccountCode() end 
    log(info, 'Main')

    goto debug
    ::debug::

    if info.mailRegister == nil or info.mailRegister == '' then 
        homeAndUnlockScreen()
        if TIMES_XOA_INFO == 0 then wipeApp() end

        if IP_ROTATE_MODE == 1 then 
            alert('Mode not support now.') exit()
        elseif IP_ROTATE_MODE == 2 then 
            onOffAirplane()
        elseif IP_ROTATE_MODE == 3 then 
            local i = 1
            ::label_resetproxylan::
            reloadTsproxy()
            if waitforTsproxyReady(20) then 
                if not checkProxyAvailable() then
                    if i > 5 then failedCurrentAccount('ip_invalid') goto label_continue end
                    toast('Times reloadTsproxy: ' .. i) i = i + 1 sleep(2) goto label_resetproxylan
                end
            else 
                sleep(1) goto label_resetproxylan
            end 
        elseif IP_ROTATE_MODE == 4 then
            local i = 1
            ::label_resetproxytext::
            if not rotateProxyText() then
                if i > 5 then failedCurrentAccount('proxy_invalid') goto label_continue end
                swipeCloseApp()
                toast('Times rotateProxyText: ' .. i, 5) i = i + 1 sleep(10) goto label_resetproxytext 
            end
        end
        if TIMES_XOA_INFO > 0 then executeXoaInfo() end
    else 
        swipeCloseApp()
    end
    if not waitForInternet(1) then 
        toast("No Internet 3", 5)
        if IP_ROTATE_MODE == 2 then onOffAirplane() sleep(2) waitForInternet(1) end
    end 
   
    ::label_openfacebook::
    openFacebook()

    if waitImageVisible(logo_fb_modern) then
        toastr('not_support_this_FB_mode')
        swipeCloseApp()
        goto label_continue
    end

    findAndClickByImage(accept)
    if checkSuspended() then goto label_continue end
    if checkPageNotAvailable() then goto label_continue end
    if waitImageVisible(three_dot_icon) then removeAccount() end 
    if checkImageIsExists(what_on_your_mind) then goto label_whatisonyourmind end
    if checkImageIsExists(what_is_birthday) then goto label_birthday end
    if checkImageIsExists(what_is_mobile_number) then goto label_whatisyourmobile end
    if checkImageIsExists(enter_an_email, 1) then goto label_enterconfirmcodedummy end 
    if checkImageIsExists(enter_confirm_code_phone) then goto label_enterconfirmcodedummy end 
    if checkImageIsExists(enter_the_confirmation_code) then goto label_enterconfirmcodedummy end 
    if checkImageIsExists(create_a_password) then goto label_createpassword end
    if checkImageIsExists(save_your_login_info) then goto label_saveyourlogin end
    if checkImageIsExists(profile_picture) then goto label_profilepicture end
    if checkImageIsExists(turn_on_contact) then goto label_turnoncontact end
    if checkImageIsExists(find_friend) then goto label_findfriend_swipe end
    if checkImageIsExists(no_friend) then goto label_nofriend end
    if checkImageIsExists(add_phone_number) then goto label_addphonenumber end
    if checkImageIsExists(add_your_email_address) then goto label_addyouremailaddress end
    if checkImageIsExists(agree_facebook_term) then goto label_agree end

    ::label_createnewaccount::
    showIphoneModel()
    if waitImageVisible(create_new_account) then
        toastr('create_new_account')

        if waitImageVisible(logo_fb_modern, 3) then
            toastr('not_support_this_FB_mode')
            swipeCloseApp()
            goto label_continue
        end

        if LOGIN_NO_VERIFY then 
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
            else 
                press(380, 1160) 
            end
        else 
            findAndClickByImage(create_new_account) sleep(2)
            if not waitImageNotVisible(logo_facebook_login, 30) then press(380, 1160) end
        end 
    else         
        if checkSuspended() then goto label_continue end
    end

    if checkImageIsExists(logo_fb_modern) then toastr('not_support_this_FB_mode') swipeCloseApp() goto label_continue end
    if checkImageIsExists(what_on_your_mind) then goto label_whatisonyourmind end
    if checkImageIsExists(what_is_birthday) then goto label_birthday end
    if checkImageIsExists(what_is_mobile_number) then goto label_whatisyourmobile end
    if checkImageIsExists(enter_an_email) then goto label_enterconfirmcodedummy end 
    if checkImageIsExists(enter_confirm_code_phone) then goto label_enterconfirmcodedummy end 
    if checkImageIsExists(enter_the_confirmation_code) then goto label_enterconfirmcodedummy end
    if checkImageIsExists(create_a_password) then goto label_createpassword end
    if checkImageIsExists(save_your_login_info) then goto label_saveyourlogin end
    if checkImageIsExists(profile_picture) then goto label_profilepicture end
    if checkImageIsExists(turn_on_contact) then goto label_turnoncontact end
    if checkImageIsExists(find_friend) then goto label_findfriend_swipe end
    if checkImageIsExists(no_friend) then goto label_nofriend end
    if checkImageIsExists(add_phone_number) then goto label_addphonenumber end
    if checkImageIsExists(add_your_email_address) then goto label_addyouremailaddress end
    if checkImageIsExists(agree_facebook_term) then goto label_agree end

    if LOGIN_NO_VERIFY then 
        if waitImageVisible(wrong_credentials, 3) then 
            failedCurrentAccount('wrong_cre')
            goto label_continue
        end 
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

    if checkImageIsExists(join_facebook) then 
        toastr('not_support_this_FB_mode', 2)
        swipeCloseApp()
        goto label_continue
    end

    if waitForInternet(1) then archiveCurrentAccount() else alert("No Internet 4. RESPRING NOW!!") exit() end 

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
        for i = 1, math.random(10, 25) do
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

    findAndClickByImage(accept) 
    if checkImageIsExists(create_new_account) then goto label_createnewaccount end 
    if checkImageIsExists(create_new_account_blue) then goto label_createnewaccountblue end 
    if checkImageIsExists(get_started) then goto label_createnewaccountblue end 
    if checkImageIsExists(profile_picture) then goto label_profilepicture end
    if checkImageIsExists(enter_the_confirmation_code) then goto label_confirmationcode end
    if waitImageVisible(register_by_phone, 2) and waitImageVisible(what_is_your_email, 2) then
        findAndClickByImage(register_by_phone)
    end

    ::label_whatisyourmobile::
    if waitImageVisible(what_is_mobile_number) or waitImageVisible(sign_up_with_email) then
        toastr("what_is_mobile_number")
        if DUMMY_PHONE then 
            ::label_randomphone::
            press(320, 200)
            press(320, 450)
            findAndClickByImage(x_input_icon)
            typeText(randomPhone())
            findAndClickByImage(next)

            if waitImageVisible(red_warning_icon, 3) then
                toast('phone_invalid')
                goto label_randomphone
            end
            if waitImageVisible(continue_creating_account, 3) then
                toast('phone_has_account')
                findAndClickByImage(continue_creating_account)
            end
        else
            if not VERIFY_PHONE then 
                findAndClickByImage(sign_up_with_email)
                waitImageNotVisible(what_is_mobile_number) sleep(2)
            else 
                local max = 20
                local try = 1
                ::label_executegetmailrequest::
                if executeGetMailRequest() then 
                    if info.mailRegister ~= nil and info.mailRegister ~= '' then 
                        press(320, 200)
                        press(320, 450)
                        findAndClickByImage(x_input_icon)
                        typeText(info.mailRegister)
                        findAndClickByImage(next)

                        archiveCurrentAccount()
                    end

                    if waitImageVisible(red_warning_icon, 3) or waitImageVisible(continue_creating_account, 3) then
                        if checkImageIsExists(continue_creating_account) then press(55, 415) sleep(1) press(45, 90) sleep(1) end
                        toastr('cant_get_phone')
                        if try < max then
                            try = try + 1
                            toast('Try ' .. try, 2)
                            goto label_executegetmailrequest 
                        else
                            failedCurrentAccount('cant_get_phone')
                            goto label_continue
                        end
                    end
                else 
                    toastr("Empty phone. Continue.", 10) sleep(5)
                    failedCurrentAccount('empty_phone')
                    goto label_continue
                end
            end 
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
                    toastr('email_has_account')
                    failedCurrentAccount('email_has_account')
                    goto label_continue
                end
            else
                ::label_executegetmailrequest::
                if executeGetMailRequest() then 
                    if info.mailRegister ~= nil and info.mailRegister ~= '' then 
                        press(310, 420)
                        findAndClickByImage(x_input_icon)
                        typeText(info.mailRegister)

                        findAndClickByImage(next)
                        archiveCurrentAccount()
                    end

                    if waitImageVisible(red_warning_icon, 3) then
                        toastr('email_invalid')
                        removeMailThueMail(info.mailRegister)
                        goto label_executegetmailrequest
                    end

                    if waitImageVisible(continue_creating_account, 3) then
                        toastr("email_has_account")
                        failedCurrentAccount('email_has_account')
                        swipeCloseApp()
                        goto label_continue
                    end
                else 
                    toastr("Empty mail. Continue.", 10) sleep(5)
                    failedCurrentAccount('empty_email')
                    goto label_continue
                end
            end
            
            if not waitImageNotVisible(what_is_your_email, 10) or not waitImageNotVisible(enter_an_email, 10) then 
                if checkImageIsExists(what_is_your_email) or checkImageIsExists(enter_an_email) then findAndClickByImage(next) end
                if not waitImageNotVisible(what_is_your_email, 10) or not waitImageNotVisible(enter_an_email, 10) then 
                    failedCurrentAccount('cant_next_mail')
                    goto label_continue
                end
            end
        end
    end

    if waitImageVisible(what_is_birthday, 1) then
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
        press(135, 430)
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
    if checkImageIsExists(create_a_password, 1) then goto label_createpassword end 

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

        if waitImageVisible(dont_allow, 1) then findAndClickByImage(dont_allow) end
        findAndClickByImage(i_agree_btn)

        if waitImageVisible(can_not_agree, 15) then 
            failedCurrentAccount('can_not_agree')
            goto label_continue
        end 
        
        if not waitImageNotVisible(agree_facebook_term, 90) then 
            if checkImageIsExists(ban_ko_the_su_dung) then 
                failedCurrentAccount('can_not_agree')
                goto label_continue
            end
            
            toastr('Can not next')
            swipeCloseApp()
            goto label_openfacebook
        end 
        if waitImageVisible(already_have_account, 2) then
            press(380, 600)
            waitImageNotVisible(already_have_account)
        end
    end

    ::label_enterconfirmcodedummy::
    if SHOULD_DUMMY or LOGIN_NO_VERIFY then 
        if LOGIN_NO_VERIFY then 
            findAndClickByImage(no_receive_code)
            if VERIFY_PHONE then 
                alert('Can not verify by Phone now.') exit()
            else 
                if waitImageVisible(confirm_via_change_email, 10) then 
                    findAndClickByImage(confirm_via_change_email)
                    sleep(2)
                end
            end  
        end 
        if DUMMY_PHONE then
            if waitImageVisible(enter_confirm_code_phone, 10) then
                toastr("enter_confirm_code_phone")

                if not ENTER_VERIFY_CODE then 
                    info.profileUid = getUIDFBLogin()
                    info.mailPrice = 'dummy'
                    finishCurrentAccount()
                    resetInfoObject()

                    press(55, 90) sleep(1) -- X back icon
                    press(240, 820) sleep(1) -- Leave btn

                    if TIMES_XOA_INFO == 0 then removeAccount() end
                    goto label_continue
                end

                findAndClickByImage(no_receive_code)
                if waitImageVisible(confirm_via_email, 10) then 
                    findAndClickByImage(confirm_via_email)
                    sleep(2)
                end
            end
        end
        if DUMMY_GMAIL or DUMMY_ICLOUD then
            if waitImageVisible(enter_the_confirmation_code, 10) then
                toastr("enter_the_confirmation_code gmail|icloud")

                if not ENTER_VERIFY_CODE then 
                    info.profileUid = getUIDFBLogin()
                    info.mailPrice = 'dummy'
                    finishCurrentAccount()
                    resetInfoObject()
                    
                    press(55, 90) sleep(1) -- X back icon
                    press(240, 820) sleep(1) -- Leave btn

                    if TIMES_XOA_INFO == 0 then removeAccount() end
                    goto label_continue
                end

                findAndClickByImage(no_receive_code)
                if waitImageVisible(confirm_via_change_email, 10) then 
                    findAndClickByImage(confirm_via_change_email)
                    info.mailRegister = nil -- reset mailRegister
                    sleep(2)
                end
            end
        end

        ::label_emailafterphone::
        if waitImageVisible(what_is_your_email, 3) or waitImageVisible(enter_an_email, 3) or (ADD_MAIL_DOMAIN == 1 and waitImageVisible(enter_the_confirmation_code)) then
            toastr("what_is_your_email")

            if ADD_MAIL_DOMAIN == 1 then -- mail domain in dummy reg
                if waitImageVisible(what_is_your_email, 1) or waitImageVisible(enter_an_email, 1) then 
                    toast('add_mail_domain')
                    executeDomainMail() sleep(1)
                    info.mailRegister = nil
                    press(310, 420)
                    findAndClickByImage(x_input_icon)
                    typeText(info.mailLogin)
                    findAndClickByImage(next)
                end 
                if waitImageVisible(enter_the_confirmation_code) then
                    findAndClickByImage(no_receive_code)
                    if waitImageVisible(confirm_via_change_email, 10) then 
                        findAndClickByImage(confirm_via_change_email)
                        waitImageVisible(what_is_your_email)
                        toast('add_gmail')
                    end
                end
            end
            if info.mailRegister ~= nil and info.mailRegister ~= '' then 
                press(310, 420)
                findAndClickByImage(x_input_icon)
                typeText(info.mailRegister)

                findAndClickByImage(next)
                archiveCurrentAccount()

                if waitImageVisible(exist_account_in_mail, 3) or waitImageVisible(red_warning_icon, 3) then
                    toastr('email_has_account')
                    failedCurrentAccount('email_has_account')
                    goto label_continue
                end
            else
                ::label_executegetmailrequest::
                if executeGetMailRequest() then 
                    if info.mailRegister ~= nil and info.mailRegister ~= '' then 
                        press(310, 420)
                        findAndClickByImage(x_input_icon)
                        typeText(info.mailRegister)

                        findAndClickByImage(next)
                        archiveCurrentAccount()
                    end

                    if waitImageVisible(red_warning_icon, 3) then
                        toastr('email_invalid')
                        removeMailThueMail(info.mailRegister)
                        goto label_executegetmailrequest
                    end

                    if waitImageVisible(continue_creating_account, 3) then
                        toastr("email_has_account")
                        failedCurrentAccount('email_has_account')
                        swipeCloseApp()
                        goto label_continue
                    end
                else 
                    toastr("Empty mail. Continue.", 10) sleep(5)
                    failedCurrentAccount('empty_email')
                    goto label_continue
                end
            end
            if not waitImageNotVisible(what_is_your_email, 10) or not waitImageNotVisible(enter_an_email, 10) then 
                if checkImageIsExists(what_is_your_email) or checkImageIsExists(enter_an_email) then findAndClickByImage(next) end
                if not waitImageNotVisible(what_is_your_email, 10) or not waitImageNotVisible(enter_an_email, 10) then 
                    failedCurrentAccount('cant_next_mail')
                    goto label_continue
                end
            end
        end
    end

    ::label_confirmationcode::
    if waitImageVisible(enter_the_confirmation_code, 10) then
        toastr("enter_the_confirmation_code")
        if not VERIFY_PHONE and DUMMY_PHONE and checkImageIsExists(enter_confirm_code_phone) then goto label_enterconfirmcodedummy end
        if VERIFY_PHONE and checkImageIsExists(enter_confirm_code_whatsapp) then 
            findAndClickByImage(no_receive_code)
            if waitImageVisible(confirm_via_sms, 10) then 
                findAndClickByImage(confirm_via_sms)
                waitImageVisible(enter_confirm_code_phone)
                toast('confirm_via_sms')
            end
        end
        if not LOGIN_NO_VERIFY then info.verifyCode = nil end

        if waitImageVisible(dont_allow, 1) then findAndClickByImage(dont_allow) end
        info.profileUid = getUIDFBLogin()

        if not ENTER_VERIFY_CODE then 
            info.mailPrice = 'dummy'
            finishCurrentAccount()
            resetInfoObject()

            press(55, 90) sleep(1) -- X back icon
            press(240, 820) sleep(1) -- Leave btn

            if TIMES_XOA_INFO == 0 then removeAccount() end
            goto label_continue
        else 
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

                findAndClickByImage(input_confirm_code)
                findAndClickByImage(x_input_icon)
                typeText(OTPcode) sleep(1)
                findAndClickByImage(next)

                if waitImageVisible(red_warning_icon) then 
                    failedCurrentAccount('code_invalid')
                    goto label_continue
                end 
                sleep(2)
            else
                toastr('empty OTP', 6) sleep(3)
                failedCurrentAccount('empty_code')

                press(55, 90) sleep(1) -- X back icon
                press(240, 820) sleep(1) -- Leave btn
                if TIMES_XOA_INFO == 0 then removeAccount() end
                goto label_continue
            end
        end 
        
        if waitImageNotVisible(enter_the_confirmation_code, 20) then 
            if waitImageVisible(setting_up_for_fb, 2) then
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

    if checkImageIsExists(create_a_password) then goto label_createpassword end 
    if checkSuspended() then goto label_continue end

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

    if checkSuspended() then goto label_continue end
    if checkPageNotAvailable() then goto label_continue end

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
    if waitImageVisible(find_friend, 1) then
        toastr("find_friend_kill")
        swipeCloseApp()
        goto label_openfacebook
    end

    ::label_findfriend_swipe::
    if waitImageVisible(find_friend, 1) then
        toastr("find_friend_swipe")
        swipeForce(50, 500, 600, 500)
    end

    ::label_addphonenumber::
    if waitImageVisible(add_phone_number, 1) then
        toastr("add_phone_number")
        press(380, 1220) -- skip
        waitImageVisible(add_phone_number)
    end

    ::label_addyouremailaddress::
    if waitImageVisible(add_your_email_address, 1) then
        toastr("add_your_email_address")
        press(380, 1220) -- skip
        waitImageVisible(add_your_email_address)
    end

    if checkImageIsExists(create_a_password) then goto label_createpassword end 
    if checkImageIsExists(enter_an_email) then goto label_enterconfirmcodedummy end 
    if checkImageIsExists(enter_confirm_code_phone) then goto label_enterconfirmcodedummy end 
    if checkImageIsExists(enter_the_confirmation_code) then goto label_confirmationcode end 
    if checkImageIsExists(profile_picture) then goto label_profilepicture end
    if checkImageIsExists(turn_on_contact) then goto label_turnoncontact end
    if checkImageIsExists(no_friend) then goto label_nofriend end
    if checkImageIsExists(find_friend) then goto label_findfriend_kill end
    if checkImageIsExists(add_phone_number) then goto label_addphonenumber end
    if checkImageIsExists(add_your_email_address) then goto label_addyouremailaddress end

    if checkPageNotAvailable() then goto label_continue end
    if checkSuspended() then goto label_continue end
    if ADD_MAIL_DOMAIN == 0 then info.finishSettingMail = 'true' end

    ::label_whatisonyourmind::
    local forceLogout = false
    if info.status == 'INPROGRESS' and (info.mailRegister == nil or info.mailRegister == '') then forceLogout = true goto label_logout end
    if waitImageVisible(fb_logo_home, 1) or checkModeMenuLeft() then swipe(600, 600, 610, 900) modeMenuLeft = checkModeMenuLeft() else goto label_lastcheck end

    ::label_settingmail::
    if ADD_MAIL_DOMAIN > 0 and info.finishSettingMail == 'false' and LANGUAGE == 'VN' then 
        swipe(600, 600, 610, 900) 
        if waitImageVisible(what_on_your_mind) then 
            toastr('setting_mail what_on_your_mind')

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
            if waitImageVisible(account_center, 10) then
                toastr('account_center')
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
            if waitImageVisible(personal_details_page, 15) or waitImageVisible(your_information_and_per_btn, 15) then
                toastr('personal_details_page')
                if waitImageVisible(contact_information_btn) then
                    findAndClickByImage(contact_information_btn)
                end
            end
            if waitImageVisible(add_new_contact_information) then
                toast('add_new_contact_information')
                sleep(2)

                if ADD_MAIL_DOMAIN == 1 then 
                    local mailIcons = findImage(contact_email_icon[#contact_email_icon], 2, 0.99, nil, false, 1)
                    if #mailIcons == 2 then 
                        -- local v = mailIcons[1]
                        press(90, 470)
                        if waitImageVisible(contact_confirm_mail) then
                            findAndClickByImage(contact_confirm_mail)
                            if waitImageVisible(contact_checkbox_account) then findAndClickByImage(contact_checkbox_account) end
                            if waitImageVisible(next) then findAndClickByImage(next) end
                            if waitImageVisible(enter_confirm_code) then 
                                local code = getMailDomainOwnerConfirmCode()
                                if code and code ~= '' then
                                    press(200, 480)
                                    findAndClickByImage(x_input_icon)
                                    typeText(code) sleep(1)
                                    press(360, 580)
                                    findAndClickByImage(next)
                                end 
                            end
                            if waitImageVisible(contact_email_added, 10) then 
                                press(380, 1260) sleep(2) -- btn đóng
                            end 
                        else 
                            press(50, 155) sleep(1)
                        end 

                        if waitImageVisible(contact_email_icon) then 
                            -- local v = mailIcons[2]
                            press(90, 580)
                            if waitImageVisible(delete_mail) then
                                findAndClickByImage(delete_mail)
                                sleep(1) press(240, 850)
                                if waitImageVisible(deleted_previous_mail, 10) then
                                    press(380, 1260) sleep(2) -- btn đóng
                                end
                            end
                        end
                    end 
                    if waitImageVisible(contact_phone) then 
                        findAndClickByImage(contact_phone) 
                        if waitImageVisible(contact_delete_phone) then findAndClickByImage(contact_delete_phone) end
                        sleep(1) press(240, 850)
                        if waitImageVisible(deleted_previous_phone, 10) then
                            press(380, 1260) sleep(2) -- btn đóng
                        end
                    end

                    local mailIcons = findImage(contact_email_icon[#contact_email_icon], 2, 0.99, nil, false, 1)
                    if #mailIcons == 1 then 
                        info.finishSettingMail = 'true'
                        archiveCurrentAccount()
                    end
                end

                if ADD_MAIL_DOMAIN == 2 then 
                    findAndClickByImage(add_new_contact_information)

                    if waitImageVisible(add_mail) then
                        toastr('add_mail')
                        sleep(1)
                        findAndClickByImage(add_mail)
                    else 
                        press(130, 730) sleep(2) -- add mail options
                    end
                    if waitImageVisible(add_a_phone_number, 2) then press(380, 1260) end -- add email instead
                    if waitImageVisible(add_email_address) then
                        toastr('add_email_address')

                        getDomainMail() sleep(1)
                        press(310, 640)
                        findAndClickByImage(x_input_icon)
                        typeText(info.mailLogin)
                        press(680, 1290) -- btn enter

                        if waitImageVisible(contact_checkbox_account, 2) then findAndClickByImage(contact_checkbox_account) end
                        if waitImageVisible(next, 2) then findAndClickByImage(next) end
                        if waitImageVisible(enter_confirm_code) then 
                            toastr('enter_confirm_code')
                            local code = getMailDomainOwnerConfirmCode()
                            toastr('CODE: ' .. (code or '-'), 2)
                            if code and code ~= '' then
                                press(200, 480)
                                findAndClickByImage(x_input_icon)
                                typeText(code) sleep(1)
                                press(360, 580)
                                findAndClickByImage(next)
                            end 
                        end
                        if waitImageVisible(added_email, 8) then 
                            archiveCurrentAccount()
                            press(380, 1260) sleep(2)  -- close btn
                        end
                    end

                    -- remove gmail
                    if waitImageVisible(add_new_contact_information, 2) and THUE_LAI_MAIL > 0 then
                        press(650, 600) -- mail register
                        if waitImageVisible(delete_mail) then
                            findAndClickByImage(delete_mail)
                            sleep(1)
                            press(240, 850)

                            if waitImageVisible(check_your_email, 3) then
                                toastr('check_your_email')
                                local code = getMailDomainOwnerConfirmCode()
                                toastr('CODE: ' .. (code or '-'), 2)

                                if code and code ~= '' then
                                    press(100, 850) -- code input
                                    typeText(code) sleep(1)
                                    if waitImageVisible(continue_code_mail) then
                                        findAndClickByImage(continue_code_mail)

                                        waitImageNotVisible(check_your_email)
                                    end
                                end
                            end

                            if waitImageVisible(deleted_previous_mail, 8) then
                                press(380, 1260) sleep(2) -- close btn
                            end
                        end
                    end

                    local mailIcons = findImage(contact_email_icon[#contact_email_icon], 2, 0.99, nil, false, 1)
                    if (THUE_LAI_MAIL > 0 and #mailIcons == 1) or (THUE_LAI_MAIL == 0 and #mailIcons == 2) then 
                        info.finishSettingMail = 'true'
                        archiveCurrentAccount()
                    end
                end

                if waitImageVisible(add_new_contact_information) then
                    toast('add_new_contact_information')
                    press(50, 155) -- back
                    if waitImageVisible(personal_details_page) then
                        press(50, 155) -- back
                        press(55, 155) -- back
                        press(45, 90) -- back to setting menu
                        if not modeMenuLeft then press(45, 90) end -- back to main menu
                        press(60, 1290) sleep(2) -- back to homepage
                    end
                end
            end
        end 
    end 

    ::label_changeinfo::
    if CHANGE_INFO and info.finishChangeInfo == 'false' and LANGUAGE == 'VN' then 
        swipe(600, 600, 610, 900) 
        if waitImageVisible(what_on_your_mind) then 
            toastr('change_info what_on_your_mind')
            openURL("fb://profile") 
            if waitImageVisible(mo_trong_facebook, 2) then press(500, 725) end
            if waitImageVisible(welcome_to_profile) or waitImageVisible(tiep_tuc_thiet_lap_profile) or waitImageVisible(lock_profile_page) then 
                press(50, 90) sleep(1) -- x icon
                press(510, 830) sleep(1) -- dừng icon
            end 

            if waitImageVisible(add_coverphoto, 2) then findAndClickByImage(skip) sleep(1) end
            if waitImageVisible(profile_add_avatar, 2) then 
                findAndClickByImage(profile_add_avatar)
                if not saveRandomServerAvatar() then alert('RESPRING NOW!!') exit() end
                sleep(3)
                if waitImageVisible(chon_anh_dai_dien) then findAndClickByImage(chon_anh_dai_dien) end
                if waitImageVisible(allow_access) then 
                    findAndClickByImage(allow_access) sleep(2)
                end
                if waitImageVisible(thu_vien_anh) then 
                    press(150, 480) sleep(1) -- chọn ảnh đầu tiên
                    press(680, 95) sleep(5) -- btn lưu

                    if waitImageVisible(khong_the_thay_doi_avt) then press(375, 790) end 
                    if waitImageNotVisible(xem_truoc_anh_dai_dien, 20) then 
                        info.finishChangeInfo = 'true'
                        archiveCurrentAccount()
                    end 
                end 
                if waitImageVisible(edit_profile_page_edit, 2) then 
                    press(45, 90) sleep(1) -- back
                end
            else 
                info.finishChangeInfo = 'true'
                archiveCurrentAccount()
            end
            if waitImageVisible(edit_profile_page, 3) then press(60, 1290) sleep(2) end
        end 
    end

    ::label_searchfriend::
    if info.finishAddFriend == 'false' then 
        swipe(600, 600, 610, 900) 
        toastr('wait searchfriend..')
        if waitImageVisible(what_on_your_mind) then
            toastr('searchfriend what_on_your_mind')
            openURL("fb://friends")
            if waitImageVisible(contact_icon) or 1 then
                press(690, 90) sleep(1)
                press(690, 90) sleep(1)

                local searchUsername = getSearchUsername(math.random(3, 4))
                for i, line in ipairs(searchUsername) do
                    typeText(line)
                    press(700, 1300) -- btn search blue
                    sleep(4)
                    if waitImageVisible(friend_send_add_friend) then 
                        local totalAdd = math.random(4, 5)
                        local swiped = 0
                        local added = 0
                        while added < totalAdd and swiped < 3 do
                            local found = findImage(friend_send_add_friend[1], 0, 0.99, nil, false, 1)
                            for i, v in pairs(found) do
                                if v ~= nil then
                                    local x = v[1]
                                    local y = v[2]
                                    press(x, y)
                                    added = added + 1
                                end
                                sleep(0,5)
                            end
                            if added < totalAdd then swipe(480, 800, 480, 500) sleep(2) swiped = swiped + 1 end
                        end
                    end 

                    if i < #searchUsername then
                        press(300, 90); -- click back into search box
                        if waitImageVisible(x_icon_search, 2) then
                            findAndClickByImage(x_icon_search)
                        else 
                            press(600, 90);
                        end
                    else
                        press(60, 1290) -- back to homepage
                        sleep(1)
                    end
                end
            end

            openURL("fb://friends") sleep(2)
            press(690, 90) sleep(1)
            swipe(600, 600, 610, 900) sleep(2)
            if waitImageVisible(friend_send_add_friend) then 
                local totalAdd = math.random(10, 15)
                local swiped = 0
                local added = 0
                while added < totalAdd and swiped < 3 do
                    local found = findImage(friend_send_add_friend[2], 0, 0.99, nil, false, 1)
                    for i, v in pairs(found) do
                        if v ~= nil then
                            local x = v[1]
                            local y = v[2]
                            press(x, y)
                            added = added + 1
                        end
                        sleep(0,5)
                    end
                    if added < totalAdd then swipe(480, 800, 480, 500) sleep(2) swiped = swiped + 1 end
                    if waitImageVisible(gio_ban_chua_dung_tinh_nang_nay, 2) then press(375, 865) end 
                end
            end
            info.finishAddFriend = 'true'
            archiveCurrentAccount()
            press(60, 1290) -- back to homepage
            sleep(1)
        end
    end 

    ::label_get2FA::
    if (info.twoFA == nil or info.twoFA == '') then
        swipe(600, 600, 610, 900) 
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
            if waitImageVisible(account_center, 10) then
                toastr('account_center')
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
                sleep(1)
                findAndClickByImage(input_password)
                findAndClickByImage(password_eye)
                typeText(info.password)
                findAndClickByImage(next)
                findAndClickByImage(continue)
                waitImageNotVisible(reenter_password)
            end

            if LOGIN_NO_VERIFY then 
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

                local code = ''
                if ADD_MAIL_DOMAIN > 0 then
                    code = getMailDomainOwnerConfirmCode()
                else
                    failedCurrentAccount('cant_get_2fa')
                    goto label_continue
                end
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
                    info.twoFA = '-'  
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

            if LOGIN_NO_VERIFY then 
                if waitImageVisible(what_app, 2) then
                    failedCurrentAccount('other_device')
                    goto label_continue
                end

                if waitImageVisible(check_notification_device, 1) then
                    failedCurrentAccount('other_device')
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
                    info.twoFA = '-'                
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
    end

    toastr('Check nick live..')
    if info.finishAddFriend == 'true' and ((CHANGE_INFO and info.finishChangeInfo == 'true') or not CHANGE_INFO) and ((ADD_MAIL_DOMAIN > 0 and info.finishSettingMail == 'true') or ADD_MAIL_DOMAIN == 0) and (info.twoFA ~= nil and info.twoFA ~= '') then 
        finishCurrentAccount()
        toastr('+1 nick live', 3)
    end

    ::label_searchtext::
    if waitImageVisible(fb_logo_home, 1) or checkModeMenuLeft() then swipe(600, 600, 610, 900) else goto label_lastcheck end
    if waitImageVisible(what_on_your_mind) then
        toastr('searchtext what_on_your_mind')
        press(600, 90) -- go to search screen

        local searchTexts = getSearchText(math.random(2, 4))
        for i, line in ipairs(searchTexts) do
            typeText(line)
            press(700, 1300) -- btn search blue
            sleep(4)
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
            end
        end
    end

    ::label_logout::
    if forceLogout or (info.finishAddFriend == 'true' and ((CHANGE_INFO and info.finishChangeInfo == 'true') or not CHANGE_INFO) and ((ADD_MAIL_DOMAIN > 0 and info.finishSettingMail == 'true') or ADD_MAIL_DOMAIN == 0) and (info.twoFA ~= nil and info.twoFA ~= '')) then 
        swipe(600, 600, 610, 900) 
        if waitImageVisible(what_on_your_mind) then 
            toastr('logout what_on_your_mind')

            resetInfoObject()

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
            sleep(1)
            goto label_continue
        end
    end

    if waitImageVisible(enter_an_email, 1) then goto label_enterconfirmcodedummy end 
    if waitImageVisible(enter_confirm_code_phone, 1) then goto label_enterconfirmcodedummy end 
    if waitImageVisible(enter_the_confirmation_code, 1) then goto label_confirmationcode end 
    if waitImageVisible(profile_picture, 1) then goto label_profilepicture end
    if waitImageVisible(turn_on_contact, 1) then goto label_turnoncontact end
    if waitImageVisible(no_friend, 1) then goto label_nofriend end
    if waitImageVisible(find_friend, 1) then goto label_findfriend_kill end
    if waitImageVisible(add_phone_number, 1) then goto label_addphonenumber end
    if checkImageIsExists(add_your_email_address) then goto label_addyouremailaddress end
    if checkSuspended() then goto label_continue end

    ::label_lastcheck::
    toastr('Last check..')
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
