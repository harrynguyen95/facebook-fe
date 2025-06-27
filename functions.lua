
-- ====== CONFIG ======
PHP_SERVER = "https://tuongtacthongminh.com/"
MAIL_API_KEY = "94a3a21c-40b5-4c48-a690-f1584c390e3e"
MAIL_THUEMAIL_DOMAIN = "https://api.thuemails.com/api/"
URL_2FA_FACEBOOK = "https://2fa.live/tok/"
MAIL_FREE_DOMAIN = "https://api.temp-mailfree.com/"

-- accountFilePath = currentPath() .. "/output/" .. os.date("%Y-%m-%d") .. ".txt"
accountFilePath = currentPath() .. "/accounts.txt"
mailFilePath = currentPath() .. "/thuemails.txt"
defaultPasswordFilePath = currentPath() .. "/input/password.txt"
searchTextFilePath = currentPath() .. "/input/searchtext.txt"

-- ====== LOGIC FUNCTION ======
function homeAndUnlockScreen()
    local i = 0
    while true do
        toast("Check Unlock Screen")
        i = i + 1
        if getColor(711, 17) == 16777215 and i > 5 then
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
    -- 1|SUCCESS|test@yagisongs.com|1995|test@gmail.com|Sik51@mmo|UID|2FA
    local accounts = readFile(accountFilePath)

    
    info.password = readFile(defaultPasswordFilePath)[1]

    if #accounts > 0 then
        local current = accounts[#accounts]
        local splitted = split(current, "|")
        if splitted[2] == 'INPROGRESS' then
            info.uuid         = splitted[1]
            info.status       = info.status or splitted[2]
            info.thuemailId   = info.thuemailId or splitted[3]
            info.mailRegister = info.mailRegister or splitted[4]
            info.password     = info.password or splitted[5]
            info.mailLogin    = splitted[6] or info.mailLogin
            info.profileUid   = info.profileUid or splitted[7]
            info.twoFA        = info.twoFA or splitted[8]

            local line = info.uuid .. "|" .. info.status .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailRegister or '') .. "|" .. info.password .. "|" .. (info.mailLogin or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '')
            accounts[#accounts] = line
            writeFile(accountFilePath, accounts)
        else
            info.uuid = floor(splitted[1] + 1)
            info.status = 'INPROGRESS'
            info.mailLogin = randomEmailLogin()
            local line = info.uuid .. "|" .. info.status .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailRegister or '') .. "|" .. info.password .. "|" .. (info.mailLogin or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '')
            addLineToFile(accountFilePath, line)
        end 
    else 
        info.uuid = 1
        info.status = 'INPROGRESS'
        info.mailLogin = randomEmailLogin()
        local line = info.uuid .. "|" .. info.status .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailRegister or '') .. "|" .. info.password .. "|" .. (info.mailLogin or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '')
        addLineToFile(accountFilePath, line)
    end

    log(info, 'Archive')
end

function failedCurrentAccount()
    local accounts = readFile(accountFilePath)
    local splitted = split(accounts[#accounts], "|")

    if splitted[2] ~= 'SUCCESS' then 
        info.status = "FAILED"
        local line = info.uuid .. "|" .. info.status .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailRegister or '') .. "|" .. info.password .. "|" .. (info.mailLogin or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '')
        accounts[#accounts] = line

        writeFile(accountFilePath, accounts)
    end

    resetInfoObject()
end

function finishCurrentAccount()
    local accounts = readFile(accountFilePath)

    info.status = "SUCCESS"
    local line = info.uuid .. "|" .. info.status .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailRegister or '') .. "|" .. info.password .. "|" .. (info.mailLogin or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '')
    accounts[#accounts] = line

    writeFile(accountFilePath, accounts)
    saveToGoogleForm()

    resetInfoObject()
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
    }
end

function saveToGoogleForm()
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
            data = info
        }

        if response then
            log(info, "Sent request to Google Form" )
            return
        else
            log(error, "Error: Failed to send request. Reason")
        end
    end
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

function executeThueMailRequest()
    local rerentMaxTries = 5
    local rerentTime = 1
    local autoCreateNew = true

    ::start_rerent_mail::
    local rerentSuccess = false
    local mailRerent = retrieveMailThueMail()

    if THUE_LAI_MAIL and mailRerent then
        rerentTime = floor(rerentTime + 1)
        log('Times mail rerent: ' .. rerentTime .. ' - ' .. mailRerent)

        local tries = 2
        for i = 1, tries do 
            toast(i)
            sleep(3)

            local postData = {
                api_key = MAIL_API_KEY,
                service_id = 1,
                email = mailRerent,
            }
            local response, error = httpRequest {
                url = MAIL_THUEMAIL_DOMAIN .. "rentals/re-rent",
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
        toast('Create new mail.')
        local tries = 2
        for i = 1, tries do 
            toast(i)
            sleep(3)

            local postData = {
                api_key = MAIL_API_KEY,
                service_id = 1,
                provider_id = 1,
                quantity = 1,
            }
            local response, error = httpRequest {
                url = MAIL_THUEMAIL_DOMAIN .. "rentals?api_key=" .. MAIL_API_KEY,
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

function getThuemailConfirmCode()
    local tries = 10
    for i = 1, tries do 
        toast(i)
        sleep(10)

        local response, error = httpRequest {
            url = MAIL_THUEMAIL_DOMAIN .. "rentals/" .. info.thuemailId .. "?api_key=" .. MAIL_API_KEY,
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
        press(300, 1250) sleep(2) -- remove profiles from this device
        press(600, 330) sleep(2) -- btn remove gray
        press(400, 1150) sleep(2) -- btn remove blue confirm

        if waitImageVisible(avatar_picture) or waitImageVisible(create_new_account) then 
            swipeCloseApp() sleep(1)
        end
    end
end

function checkSuspended()
    if checkImageIsExists(confirm_human) then
        print("confirm_human")
        failedCurrentAccount()
        press(680, 90) sleep(3) -- help text

        if waitImageVisible(logout_suspend_icon) then
            findAndClickByImage(logout_suspend_icon)
            press(520, 840) sleep(1) --logout text
            removeAccount()
        end
    end
end

function birthdayAndGender()
    if waitImageVisible(what_is_birthday, 1) then
        toast("what_is_birthday")
        press(270, 470) sleep(0.5)
        
        math.randomseed(os.time() + math.random())
        time = math.random(200000, 250000)
        tap(math.random(487, 577), math.random(909, 940))
        usleep(time)
        tap(math.random(152, 195), math.random(909, 1278))
        usleep(time)
        tap(math.random(487, 577), math.random(909, 940))
        usleep(time)
        tap(math.random(263, 395), math.random(909, 1321))
        usleep(time)
        tap(math.random(152, 195), math.random(909, 1321))
        usleep(time)
        tap(math.random(487, 577), math.random(909, 940))
        usleep(time)
        tap(math.random(152, 195), math.random(909, 1321))
        usleep(time)
        tap(math.random(487, 577), math.random(909, 940))
        usleep(time)
        tap(math.random(487, 577), math.random(909, 940))
        usleep(time)
        tap(math.random(263, 395), math.random(909, 1321))
        usleep(time)
        tap(math.random(152, 195), math.random(909, 1321))
        usleep(time)
        tap(math.random(487, 577), math.random(909, 940))
        usleep(time)
        tap(math.random(152, 195), math.random(909, 1321))
        usleep(time)
        tap(math.random(487, 577), math.random(909, 1079))
        usleep(time)
        tap(math.random(487, 577), math.random(909, 1079))
        usleep(time)
        tap(math.random(263, 395), math.random(909, 1321))
        usleep(time)
        tap(math.random(152, 195), math.random(909, 1321))
        usleep(time)
        tap(math.random(487, 577), math.random(909, 1321))
        usleep(time * 3)

        -- for i = 1, math.random(5, 10) do
        --     press(200, 1055)
        -- end
        -- for i = 1, math.random(10, 15) do
        --     press(400, 1055)
        -- end
        -- for i = 1, math.random(20, 35) do
        --     press(600, 1055)
        -- end
        findAndClickByImage(next)
        waitImageNotVisible(what_is_birthday)
    end

    if waitImageVisible(what_is_gender, 1) then
        toast("what_is_gender")
        sleep(1)
        press(math.random(80, 525), math.random(365, 525))
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
    -- appActivate("com.facebook.Facebook")
    pressHome()
    if waitImageVisible(fb_logo_2) then
        findAndClickByImage(fb_logo_2)
        waitImageNotVisible(fb_logo_2)
    end
end
