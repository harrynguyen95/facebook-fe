-- ====== LIB REQUIRED ======
require('utils')
require('functions')
clearAlert()

-- ====== CONFIG ======
LANGUAGE = 'VN'  -- EN|ES|VN English|Spanish|Vietnamese
ACCOUNT_REGION = 'VN'  
MAIL_SUPLY = 1  -- 1|2|3 hotmail_dongvanfb|thuemails.com|yagisongs
ENTER_VERIFY_CODE = true  -- true|false
HOTMAIL_SERVICE_IDS = {1, 3, 2, 6, 5}
HOTMAIL_SOURCE_FROM_FILE = false  -- true|false
THUE_LAI_MAIL_THUEMAILS = 0  
ADD_MAIL_DOMAIN = 0
CHANGE_INFO = false  -- true|false
PROVIDER_MAIL_THUEMAILS = 1  -- 1|3 gmail|icloud
TIMES_XOA_INFO = 2  -- 0|1|2|3
MAIL_THUEMAILS_API_KEY = "94a3a21c-40b5-4c48-a690-f1584c390e3e" -- Hải
MAIL_DONGVANFB_API_KEY = "iFI7ppA8JNDJ52yVedbPlMpSh" -- Hải
LOGIN_WITH_CODE = false
DUMMY_MODE = 0

if not waitForInternet(2) then toast("No Internet!", 5) end
if not getConfigServer() then alert("No config from server!") exit() end

-- ====== VARIABLE REQUIRED ======
if LANGUAGE == 'ES' then require(currentDir() .. "/images_es") end
if LANGUAGE == 'EN' then require(currentDir() .. "/images_en") end
if LANGUAGE == 'VN' then require(currentDir() .. "/images_vn") end
if ACCOUNT_REGION == 'VN' then enter_confirm_code_phone = enter_confirm_code_phone_vn end
SHOULD_DUMMY = DUMMY_MODE ~= 0
DUMMY_PHONE = DUMMY_MODE == 1
DUMMY_GMAIL = DUMMY_MODE == 2
DUMMY_ICLOUD = DUMMY_MODE == 3

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
    if not waitForInternet(2) then toast("No Internet!", 5) end
    if info.mailRegister == nil or info.mailRegister == '' then 
        homeAndUnlockScreen()
        rotateShadowRocket()
        executeXoaInfo()
        fakeRandomContact()
    else 
        swipeCloseApp()
        checkOnShadowRocket()
    end
    if LOGIN_WITH_CODE then initCurrentAccountCode() end 

    ::label_openfacebook::
    openFacebook()

    if waitImageVisible(logo_fb_modern, 1) then
        toastr('not_support_this_FB_mode')
        swipeCloseApp()
        goto label_continue
    end

    findAndClickByImage(accept)
    if checkSuspended() then goto label_continue end
    if checkPageNotAvailable() then goto label_continue end
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
    if checkImageIsExists(what_on_your_mind) then goto label_changeinfo end

    ::label_createnewaccount::
    showIphoneModel()
    if waitImageVisible(create_new_account, 10) then
        if waitImageVisible(logo_fb_modern, 1) then
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
            else 
                toastr('Can not next')
                swipeCloseApp()
                goto label_continue
            end
        else 
            findAndClickByImage(create_new_account) sleep(2)
            if waitImageNotVisible(logo_facebook_login, 30) then 
            else 
                toastr('Can not next')
                swipeCloseApp()
                goto label_continue
            end
        end 
    else         
        if checkSuspended() then goto label_continue end
    end

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
    if checkImageIsExists(what_on_your_mind) then goto label_changeinfo end

    if LOGIN_WITH_CODE then 
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

                        if waitImageVisible(exist_account_in_mail, 3) or waitImageVisible(red_warning_icon, 3) then
                            toastr('exist_account_in_mail')
                            goto label_executegetmailrequest
                        end
                    end

                    if waitImageVisible(continue_creating_account, 3) or waitImageVisible(red_warning_icon, 3) then
                        toastr("email_has_account")
                        goto label_executegetmailrequest
                    end
                else 
                    toastr("Empty mail. Continue.", 10) sleep(5)
                    log("Empty mail. Continue.")
                    failedCurrentAccount('empty_email')
                    goto label_continue
                end
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
            if times < 3 then 
                times = times + 1
                onOffAirplaneMode()
                -- openFacebook()
                sleep(2)
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

        if waitImageVisible(already_have_account, 2) then
            press(380, 600)
            waitImageNotVisible(already_have_account)
        end
    end

    if checkImageIsExists(create_a_password) then goto label_createpassword end 

    ::label_enterconfirmcodedummy::
    if SHOULD_DUMMY then 
        if DUMMY_GMAIL or DUMMY_ICLOUD then
            if waitImageVisible(enter_the_confirmation_code, 10) then
                toastr("enter_the_confirmation_code gmail|iloud")
                findAndClickByImage(no_receive_code)
                if waitImageVisible(confirm_via_change_email, 10) then 
                    findAndClickByImage(confirm_via_change_email)
                    info.mailRegister = nil -- reset mailRegister
                    sleep(2)
                end
            end
        end

        if DUMMY_PHONE then
            if waitImageVisible(enter_confirm_code_phone, 10) then
                toastr("enter_confirm_code_phone")
                findAndClickByImage(no_receive_code)

                if waitImageVisible(confirm_via_email, 10) then 
                    findAndClickByImage(confirm_via_email)
                    sleep(2)
                end
            end
        end

        ::label_emailafterphone::
        if waitImageVisible(what_is_your_email, 3) or waitImageVisible(enter_an_email, 3) then
            toastr("what_is_your_email")

            if ADD_MAIL_DOMAIN > 0 then 
                toast('add_mail_domain')
                executeDomainMail() sleep(1)
                info.mailRegister = nil
                press(310, 420)
                findAndClickByImage(x_input_icon)
                typeText(info.mailLogin)
                findAndClickByImage(next)

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

                        if waitImageVisible(exist_account_in_mail, 3) or waitImageVisible(red_warning_icon, 3) then
                            toastr('exist_account_in_mail')
                            goto label_executegetmailrequest
                        end
                    end
                else 
                    toastr("Empty mail. Continue.", 10) sleep(5)
                    log("Empty mail. Continue.")
                    failedCurrentAccount('empty_email')
                    goto label_continue
                end
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

                sleep(2)
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

        if waitImageVisible(turn_on_contact_on, 3) then findAndClickByImage(turn_on_contact_on) end
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

    ::label_changeinfo::
    if CHANGE_INFO and LANGUAGE == 'VN' and waitImageVisible(what_on_your_mind) then 
        toastr('change_info what_on_your_mind')

        if waitImageVisible(what_on_your_mind) then openURL("fb://profile") sleep(3) end
        if waitImageVisible(welcome_to_profile) then 
            saveRandomServerAvatar()

            sleep(2)
            press(550, 1260) sleep(2) -- btn thêm ảnh
            if waitImageVisible(allow_access) then 
                findAndClickByImage(allow_access) sleep(2)
            end
            press(150, 480) sleep(1) -- chọn ảnh đầu tiên
            press(680, 95) sleep(5) -- btn lưu
            

            if waitImageVisible(add_coverphoto, 3) then findAndClickByImage(skip) sleep(1) end
            if waitImageVisible(lock_profile_page) then 
                waitImageVisible(skip, 10)
                findAndClickByImage(skip)
                waitImageNotVisible(lock_profile_page)
            end
            if waitImageVisible(current_city) then 
                findAndClickByImage(select_position)
                waitImageVisible(bio_search_icon)
                typeText(getRandomCity()) sleep(2)
                press(220, 280) -- select lựa chọn đầu tiên
                waitImageVisible(save) findAndClickByImage(save)
                waitImageNotVisible(current_city)
            end
            if waitImageVisible(add_hometown) then 
                findAndClickByImage(select_position)
                waitImageVisible(bio_search_icon)
                typeText(getRandomCity()) sleep(2)
                press(220, 280) -- select lựa chọn đầu tiên
                waitImageVisible(save) findAndClickByImage(save)
                waitImageNotVisible(current_city)
            end
            if waitImageVisible(add_school) then 
                findAndClickByImage(select_position)
                waitImageVisible(bio_search_icon)
                typeText(getRandomHighSchool()) sleep(2)
                press(220, 280) -- select lựa chọn đầu tiên
                waitImageVisible(save) findAndClickByImage(save)
                waitImageNotVisible(add_school)
            end
            if waitImageVisible(high_school) then 
                findAndClickByImage(select_position)
                waitImageVisible(bio_search_icon)
                typeText(getRandomHighSchool()) sleep(2)
                press(220, 280) -- select lựa chọn đầu tiên
                waitImageVisible(save) findAndClickByImage(save)
                waitImageNotVisible(high_school)
            end
            if waitImageVisible(add_university) then 
                findAndClickByImage(select_position)
                waitImageVisible(bio_search_icon)
                typeText(getRandomUniversity()) sleep(2)
                press(220, 280) -- select lựa chọn đầu tiên
                waitImageVisible(save) findAndClickByImage(save)
                waitImageNotVisible(add_university)
            end
            if waitImageVisible(add_company) then findAndClickByImage(skip) end
            if waitImageVisible(add_relationship) then findAndClickByImage(skip) end
            if waitImageVisible(add_coverphoto) then findAndClickByImage(skip) end
            if waitImageVisible(add_moreinformation) then findAndClickByImage(skip) end
            if waitImageVisible(view_profile_page) then findAndClickByImage(view_profile_page) end
        else 
            if waitImageVisible(profile_add_avatar, 2) then 
                findAndClickByImage(edit_profile_page)
                if waitImageVisible(edit_profile_page_edit) then 
                    press(700, 200) sleep(2) -- them
                    press(280, 1150) sleep(2)
                    if waitImageVisible(allow_access) then 
                        findAndClickByImage(allow_access) sleep(2)
                        press(150, 480) sleep(2)
                        press(700, 90) sleep(5)
                    end
                end
                if waitImageVisible(edit_profile_page_edit) then 
                    press(45, 90) sleep(1) -- back
                end
            end 
        end
        if waitImageVisible(edit_profile_page) then press(60, 1290) sleep(2) end
    end 

    ::label_removemail::
    if ADD_MAIL_DOMAIN > 0 and LANGUAGE == 'VN' and waitImageVisible(what_on_your_mind) then 
        toastr('remove_mail what_on_your_mind')

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
            if waitImageVisible(contact_information_btn) then
                findAndClickByImage(contact_information_btn)
            end
        end

        if waitImageVisible(add_new_contact_information) then
            toast('add_new_contact_information')
            local mailIcons = findImage(contact_email_icon[#contact_email_icon], 2, 0.99, nil, false, 1)
            if #mailIcons == 2 then 
                local v = mailIcons[1]
                press(v[1], v[2])
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
                    local v = mailIcons[2]
                    press(v[1], v[2])
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
                    press(380, 1260) -- btn đóng
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

    ::label_get2FA::
    swipe(600, 750, 610, 800) 
    modeMenuLeft = checkModeMenuLeft()
    if (info.twoFA == nil or info.twoFA == '') and waitImageVisible(what_on_your_mind) then 
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
            sleep(1)
            findAndClickByImage(input_password)
            findAndClickByImage(password_eye)
            typeText(info.password)
            findAndClickByImage(next)
            findAndClickByImage(continue)
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

            local code = ''
            if ADD_MAIL_DOMAIN > 0 then 
                code = getMailDomainOwnerConfirmCode()
            else 
                code = getCodeMailOwner()
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
                info.twoFA = nil                
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

    ::label_addcontactfriend::
    if LANGUAGE == 'VN' and waitImageVisible(what_on_your_mind) then 
        ::label_reopencontact::
        openURL("fb://friends")
        if waitImageVisible(friend_add_friend) then 
            findAndClickByImage(friend_add_friend)
            if waitImageVisible(friend_upload_contact, 2) then findAndClickByImage(friend_upload_contact) end
            if waitImageVisible(friend_allow_contact, 2) then 
                if checkImageIsExists(next) then 
                    findAndClickByImage(next)
                else 
                    press(380, 1320) -- next hidden btn
                end
                if waitImageVisible(contact_search_friend_page) then
                    sleep(10)
                    goto label_reopencontact
                end 
            end 
        end 
        if waitImageVisible(friend_send_add_friend) then 
            local totalAdd = math.random(10, 20)
            local added = 0
            while added < totalAdd do
                local found = findImage(friend_send_add_friend[#friend_send_add_friend], 0, 0.99, nil, false, 1)
                log(found, 'found')
                for i, v in pairs(found) do
                    if v ~= nil then
                        local x = v[1]
                        local y = v[2]
                        press(x, y)
                        added = added + 1
                    end
                    sleep(0,5)
                end
                if added < totalAdd then swipe(480, 800, 480, 650) sleep(2) end
            end
        end 
        press(60, 1290) sleep(2) -- homepage
    end 

    if waitImageVisible(what_on_your_mind, 2) then
        openURL("fb://profile")
        sleep(2)
        if waitImageVisible(profile_add_avatar) then 
            findAndClickByImage(edit_profile_page)
            if waitImageVisible(edit_profile_page_edit) then 
                press(700, 200) sleep(2) -- them
                press(280, 1150) sleep(2)
                if waitImageVisible(allow_access) then 
                    findAndClickByImage(allow_access) sleep(2)
                    press(150, 480) sleep(2)
                    press(700, 90) sleep(5)
                end
            end
            if waitImageVisible(edit_profile_page_edit) then 
                press(45, 90) sleep(1) -- back
            end
        end 
        if waitImageVisible(edit_profile_page, 3) then 
            press(60, 1290) sleep(2) -- homepage
        end 
    end

    ::label_searchtext::
    toastr('wait searchtext..')
    if waitImageVisible(what_on_your_mind) then
        toastr('Search what_on_your_mind')
        press(600, 90) -- go to search screen

        local searchTexts = getSearchText(math.random(2, 4))
        for i, line in ipairs(searchTexts) do
            typeText(line)
            press(700, 1300) sleep(2) -- btn search blue
            sleep(2)
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
    if waitImageVisible(what_on_your_mind) then 
        toastr('logout what_on_your_mind')

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

        finishCurrentAccount()
        resetInfoObject()
        toastr('+1 nick live', 3)
        goto label_continue
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
