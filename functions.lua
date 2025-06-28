
-- ====== CONFIG ======
PHP_SERVER = "https://tuongtacthongminh.com/"
MAIL_THUEMAILS_THUEMAILS_API_KEY = "94a3a21c-40b5-4c48-a690-f1584c390e3e"
MAIL_THUEMAILS_DOMAIN = "https://api.thuemails.com/api/"
MAIL_DONGVANFB_API_KEY = "iFI7ppA8JNDJ52yVedbPlMpSh"
URL_2FA_FACEBOOK = "https://2fa.live/tok/"
MAIL_FREE_DOMAIN = "https://api.temp-mailfree.com/"

defaultPasswordFilePath = currentPath() .. "/input/password.txt"
searchTextFilePath = currentPath() .. "/input/searchtext.txt"
accountFilePath = rootDir() .. "/Device/accounts.txt"
mailFilePath = rootDir() .. "/Device/thuemails.txt"
localIPFilePath = rootDir() .. "/Device/local_ip.txt"

-- ====== LOGIC FUNCTION ======
function homeAndUnlockScreen()
    toast("Check Unlock Screen")

    local i = 0
    while true do
        i = i + 1
        if getColor(711, 17) == 16777215 and i > 3 then
            break
        end
        if i > 5 then
            lockAndUnlockScreen()
            i = 0
        end

        keyDown(KEY_TYPE.HOME_BUTTON)
        keyUp(KEY_TYPE.HOME_BUTTON)
        sleep(1)
    end
end

function archiveCurrentAccount()
    local accounts = readFile(accountFilePath)
    
    info.password = readFile(defaultPasswordFilePath)[1]

    if #accounts > 0 then
        local current = accounts[#accounts]
        local splitted = split(current, "|")
        if splitted[2] == 'INPROGRESS' then
            info.uuid         = splitted[1]
            info.status       = info.status or splitted[2]
            info.mailLogin    = info.mailLogin or splitted[3]
            info.password     = info.password or splitted[4]
            info.profileUid   = info.profileUid or splitted[5]
            info.twoFA        = info.twoFA or splitted[6]

            -- if splitted[7] and splitted[7] ~= '' then info.mailRegister = splitted[7] end
            -- if splitted[8] and splitted[8] ~= '' then info.thuemailId = splitted[8] end
            -- if splitted[9] and splitted[9] ~= '' then info.hotmailRefreshToken = splitted[9] end
            -- if splitted[10] and splitted[10] ~= '' then info.hotmailClientId = splitted[10] end
            -- if splitted[11] and splitted[11] ~= '' then info.hotmailPassword = splitted[11] end

            info.mailRegister        =  info.mailRegister or splitted[7]
            info.thuemailId          =  info.thuemailId or splitted[8]
            info.hotmailRefreshToken = info.hotmailRefreshToken or splitted[9]
            info.hotmailClientId     = info.hotmailClientId or splitted[10]
            info.hotmailPassword     = info.hotmailPassword or splitted[11]

            local line = info.uuid .. "|" .. info.status .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '')
            accounts[#accounts] = line
            writeFile(accountFilePath, accounts)
        else
            info.uuid = floor(splitted[1] + 1)
            info.status = 'INPROGRESS'
            if ADD_MAIL_DOMAIN then info.mailLogin = randomEmailLogin() end 
            local line = info.uuid .. "|" .. info.status .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '')
            addLineToFile(accountFilePath, line)
        end 
    else 
        info.uuid = 1
        info.status = 'INPROGRESS'
        if ADD_MAIL_DOMAIN then info.mailLogin = randomEmailLogin() end 
        local line = info.uuid .. "|" .. info.status .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '')
        addLineToFile(accountFilePath, line)
    end

    log(info, 'Archive')
end

function failedCurrentAccount()
    local accounts = readFile(accountFilePath)
    local splitted = split(accounts[#accounts], "|")

    if splitted[2] ~= 'SUCCESS' then 
        info.status = "FAILED"
        local line = info.uuid .. "|" .. info.status .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '')
        accounts[#accounts] = line

        writeFile(accountFilePath, accounts)
    end

    resetInfoObject()
end

function finishCurrentAccount()
    local accounts = readFile(accountFilePath)

    info.status = "SUCCESS"
    local line = info.uuid .. "|" .. info.status .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '')
    accounts[#accounts] = line

    writeFile(accountFilePath, accounts)
    saveToGoogleForm()

    resetInfoObject()
end

function saveToGoogleForm()
    local localIP = readFile(localIPFilePath)
    local infoClone = info
    infoClone.localIP = localIP[#localIP]

    local tries = 2
    for i = 1, tries do 
        toast(i)
        sleep(3)

        local response, error = httpRequest {
            url = PHP_SERVER .. "google_form.php",
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json",
            },
            data = infoClone
        }

        if response then
            log(info, "Sent request to Google Form" )
            return
        else
            log(error, "Error: Failed to send request. Reason")
        end
    end
end

function resetInfoObject()
    info = {
        uuid = nil,
        status = nil,
        thuemailId = nil,
        mailRegister = nil,
        twoFA = nil,
        profileUid = nil,
        mailLogin = nil,
        password = nil,
        hotmailRefreshToken = nil,
        hotmailClientId = nil,
        hotmailPassword = nil,
    }
end

function saveMailThueMail()
    local mails = readFile(mailFilePath)

    if #mails > 0 then
        local isNew = true
        for i, v in ipairs(mails) do
            local splitted = split(v, "|")
            if splitted[1] == info.mailRegister then 
                isNew = false
                mails[i] = splitted[1] .. "|" .. floor(splitted[2] + 1)
            end
        end

        if isNew then
            table.insert(mails, info.mailRegister .. "|1")
        end

        writeFile(mailFilePath, mails)
    else 
        local line = info.mailRegister  .. "|1"
        addLineToFile(mailFilePath, line)
    end
end

function retrieveMailThueMail()
    local mails = readFile(mailFilePath)
    if #mails < 10 then
        return
    end

    shuffle(mails)
    for i, v in ipairs(mails) do
        local splitted = split(v, "|")
        if floor(splitted[2]) < 4 then 
            return splitted[1]
        end
    end
end

function removeMailThueMail(invalidMail)
    local mails = readFile(mailFilePath) 
    for i = #mails, 1, -1 do
        local email = mails[i]:match("^[^|]+")   
        if email == invalidMail then
            table.remove(mails, i)             
            break                             
        end
    end

    writeFile(mailFilePath, mails)
end

function executeGmailFromThueMail()
    local rerentMaxTries = 5
    local rerentTime = 1
    local autoCreateNew = true

    ::start_rerent_mail::
    local rerentSuccess = false
    local mailRerent = retrieveMailThueMail()

    if THUE_LAI_MAIL_THUEMAILS and mailRerent then
        rerentTime = floor(rerentTime + 1)
        log('Times mail rerent: ' .. rerentTime .. ' - ' .. mailRerent)

        local tries = 2
        for i = 1, tries do 
            toast(i)
            sleep(3)

            local postData = {
                api_key = MAIL_THUEMAILS_API_KEY,
                service_id = 1,
                email = mailRerent,
            }
            local response, error = httpRequest {
                url = MAIL_THUEMAILS_DOMAIN .. "rentals/re-rent",
                method = "POST",
                headers = {
                    ["Content-Type"] = "application/json",
                },
                data = postData
            }

            if response then
                response = json.decode(response)
                if response.status == 'success' then
                    rerentSuccess = true

                    local res = response.data
                    info.thuemailId = res.id
                    info.mailRegister = res.email

                    saveMailThueMail()
                    return
                else
                    toastr(response.message)
                    log(response.message)
                    if rerentTime <= rerentMaxTries then 
                        removeMailThueMail(mailRerent)
                        goto start_rerent_mail
                    end
                end
            else
                log("Error: Failed to send request. Reason: " .. tostring(error))
            end
        end
    end

    if (not mailRerent) or (not rerentSuccess) then
        local tries = 2
        for i = 1, tries do 
            toast(i)
            sleep(3)

            local postData = {
                api_key = MAIL_THUEMAILS_API_KEY,
                service_id = 1,
                provider_id = 1,
                quantity = 1,
            }
            local response, error = httpRequest {
                url = MAIL_THUEMAILS_DOMAIN .. "rentals?api_key=" .. MAIL_THUEMAILS_API_KEY,
                method = "POST",
                headers = {
                    ["Content-Type"] = "application/json",
                },
                data = postData
            }

            if response then
                response = json.decode(response)
                if response.status == 'success' then
                    local res = response.data[1]

                    info.thuemailId = res.id
                    info.mailRegister = res.email

                    saveMailThueMail()
                    return
                else
                    toastr(response.message)
                    log(response.message)
                end
            else
                log("Error: Failed to send request. Reason: " .. tostring(error))
            end
        end
    end
end

function executeHotmailFromDongVanFb()
    -- https://api.dongvanfb.net/user/buy?apikey=36458879248967a36&account_type=1&quality=1&type=full
    
    local account_type = {1, 2, 3, 5, 59, 60}
    for i, service_id in pairs(account_type) do
        local tries = 1
        for i = 1, tries do 
            toast('Mail id: ' .. service_id)
            sleep(3)

            local response, error = httpRequest {
                url = "https://api.dongvanfb.net/user/buy?apikey=" .. MAIL_DONGVANFB_API_KEY .. "&account_type=" .. service_id .. "&quality=1&type=full",
            }

            if response then
                response = json.decode(response)
                if response.status or response.status == 'true' then
                    local mailString = response.data.list_data[1]
                    local splitted = split(mailString, '|')

                    info.mailLogin = splitted[1]
                    info.mailRegister = splitted[1]
                    info.hotmailPassword = splitted[2]
                    info.hotmailRefreshToken = splitted[3]
                    info.hotmailClientId = splitted[4]
                    return
                else
                    toastr(response.message)
                    log(response.message)
                end
            else
                log("Error: Failed to send request. Reason: " .. tostring(error))
            end
        end
    end
end

function executeGetMailRequest()
    if MAIL_MODE == 1 then 
        executeHotmailFromDongVanFb()
    elseif MAIL_MODE == 2 then
        executeGmailFromThueMail()
    else 
        toast('MAIL_MODE invalid.', 5)
    end
end

function getThuemailConfirmCode()
    local tries = 10
    for i = 1, tries do 
        toast(i)
        sleep(10)

        local response, error = httpRequest {
            url = MAIL_THUEMAILS_DOMAIN .. "rentals/" .. info.thuemailId .. "?api_key=" .. MAIL_THUEMAILS_API_KEY,
            headers = {
                ["Content-Type"] = "application/json",
            },
        }

        if response then
            response = json.decode(response)
            if response.id and response.otp then
                return response.otp
            else
                toast('Empty thuemails.com code.')
                log('Empty thuemails.com code.')
            end
        else
            log("Error: Failed to send request. Reason: " .. tostring(error))
        end
    end
    return nil
end

function getDongvanfbConfirmCode()
    sleep(3)

    local tries = 10
    for i = 1, tries do 
        toast(i)
        sleep(5)

        local postData = {
            email = info.mailRegister,
            refresh_token = info.hotmailRefreshToken,
            client_id = info.hotmailClientId,
            type = "facebook",
        }
        local response, error = httpRequest {
            url = "https://tools.dongvanfb.net/api/get_code_oauth2",
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json",
            },
            data = postData
        }

        if response then
            response = json.decode(response)
            if response.status or response.status == 'true' then
                return response.code
            else
                toast('Empty dongvanfb code.')
                log('Empty dongvanfb code.')
            end
        else
            log("Error: Failed to send request. Reason: " .. tostring(error))
        end
    end
    return nil
end

function getCodeMailRegister()
    if MAIL_MODE == 1 then 
        return getDongvanfbConfirmCode()
    elseif MAIL_MODE == 2 then
        return getThuemailConfirmCode()
    else 
        toast('MAIL_MODE invalid.', 5)
    end
end

function getFreeMailConfirmCodeSecondTime()
    local tries = 3
    for i = 1, tries do 
        toast(i)
        sleep(5)

        local response, error = httpRequest {
            url = PHP_SERVER .. "/confirm_free_mail.php?email=" .. info.mailLogin,
        }
        log(response, 'getFreeMailConfirmCodeSecondTime')
        if response then
            response = json.decode(response)
            if response.code ~= '' then
                return response.code
            else
                toast("Empty response code.");
            end
        else
            log("Error: Failed to send request. Reason: " .. tostring(error))
        end
    end
end

function getFreeMailConfirmCode()
    local tries = 3
    for i = 1, tries do 
        toast(i)
        sleep(5)

        local response, error = httpRequest {
            url = PHP_SERVER .. "/add_free_mail.php?email=" .. info.mailLogin,
        }
        log(response, 'getFreeMailConfirmCode')

        if response then
            response = json.decode(response)
            if response.code ~= '' then
                return response.code
            else
                toast("Empty response code.");
            end
        else
            log("Error: Failed to send request. Reason: " .. tostring(error))
        end
    end
end

function getCodeMailConfirm()
    if MAIL_MODE == 1 then 
        return getDongvanfbConfirmCode()
    elseif MAIL_MODE == 2 then
        return getFreeMailConfirmCodeSecondTime()
    else 
        toast('MAIL_MODE invalid.', 5)
    end
end

function get2FACode()
    local response, error = httpRequest {
        url = "https://2fa.live/tok/" .. info.twoFA,
        headers = {
            ["Content-Type"] = "application/json",
        },
    }

    if response then
        response = json.decode(response)
        if response.token then
            return response.token
        else
            toast("Empty response get 2FA OTP.");
            log("Empty response get 2FA OTP.");
        end
    else
        log("Error: Failed to send request. Reason: " .. tostring(error))
    end
end

function getSearchText(no)
    if no == nil then
        no = 3
    end

    local lines = readFile(searchTextFilePath)
    local result = {}

    math.randomseed(os.time() + math.random())
    for _ = 1, math.min(no, #lines) do
        local i = math.random(#lines)
        table.insert(result, table.remove(lines, i))
    end
    return result
end

-- ====== FE FUNCTION ======
function removeAccount()
    if waitImageVisible(avatar_picture) or waitImageVisible(create_new_account) then
        press(695, 90) sleep(2) -- three dots icon
        press(300, 1250) sleep(3) -- remove profiles from this device
        press(600, 330) sleep(3) -- btn remove gray
        press(400, 1150) sleep(1) -- btn remove blue confirm

        if waitImageVisible(avatar_picture) or waitImageVisible(create_new_account) then 
            swipeCloseApp() sleep(1)
        end
    end
end

function checkSuspended(isPushData)
    toast('checkSuspended')
    if waitImageVisible(confirm_human) then
        failedCurrentAccount()

        if isPushData ~= nil and isPushData == 'push' then
            info.checkpoint = 1
            saveToGoogleForm()
        end

        press(680, 90) sleep(1) -- help text
        if waitImageVisible(logout_suspend_icon) then
            findAndClickByImage(logout_suspend_icon)
            press(520, 840) sleep(1) --logout text

            if waitImageVisible(logout_btn) then
                findAndClickByImage(logout_btn)
                sleep(3)
            end
            removeAccount()
        end
    end
    return false
end

function birthdayAndGender()
    if waitImageVisible(what_is_birthday, 1) then
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
        waitImageNotVisible(what_is_birthday)
    end

    if waitImageVisible(what_is_gender, 1) then
        toast("what_is_gender")
        sleep(1)

        local x = 590
        local y = 420
        math.randomseed(os.time() + math.random())

        local xRandom = math.random(1, 2)
        if xRandom == 2 then
            y = 520
        end
        press(x, y)

        findAndClickByImage(next)
        waitImageNotVisible(what_is_gender)
    end
end

function goBackToCreateNewAccount()
    sleep(0.5)
    press(55, 90) -- x icon

    if waitImageVisible(leave_button) then
        findAndClickByImage(next)
        waitImageNotVisible(leave_button)
    end
end

function openFacebook()
    toast('openFacebook')

    -- appActivate("com.facebook.Facebook")
    pressHome()
    if waitImageVisible(fb_logo_2) then
        findAndClickByImage(fb_logo_2)
        waitImageNotVisible(fb_logo_2)
    else
        toast('Not found Icon facebook', 3)
    end
    sleep(1)
end

function executeXoaInfo()
    toast('executeXoaInfo')

    if waitImageVisible(xoainfo_logo) then
        findAndClickByImage(xoainfo_logo)
        waitImageNotVisible(xoainfo_logo)

        if waitImageVisible(xoainfo_reset_data) then
            for i = 1, TIMES_XOA_INFO do
                findAndClickByImage(xoainfo_reset_data)
                sleep(1)
                
                if waitImageVisible(xoainfo_info_fake, 30) then
                    if i == TIMES_XOA_INFO then
                        pressHome()
                    end
                end
            end
        end
    else
        toast('Not found logo Xoainfo, Airplane mode.')
        onOffAirplaneMode()
    end
end
