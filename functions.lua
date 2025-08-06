
-- ====== CONFIG ======
PHP_SERVER = "https://tuongtacthongminh.com/reg_clone/"
MAIL_THUEMAILS_DOMAIN = "https://api.thuemails.com/api/"
MAIL_GMAIL66_DOMAIN = "http://gmail66.shop/api/v1/"
PHONE_IRONSIM_DOMAIN = "https://ironsim.com/api/"
URL_2FA_FACEBOOK = "https://2fa.live/tok/"
MAIL_FREE_DOMAIN = "https://api.temp-mailfree.com/"
TSPROXY_URL = "https://api.tsproxy.com/api/v1/"
TSPROXY_DEVICE_ID = "67ed584a8d2d4cf26e49d5c5"
TSPROXY_API_KEY = "yB2y6yitJ0"

defaultPasswordFilePath = rootDir() .. "/Facebook/input/password.txt"
accountFilePath = rootDir() .. "/Device/accounts.txt"
accountCodeFilePath = rootDir() .. "/Device/accounts_code.txt"
thuemailsFilePath = rootDir() .. "/Device/thuemails.txt"
gmail66FilePath = rootDir() .. "/Device/gmail66.txt"
localIPFilePath = rootDir() .. "/Device/local_ip.txt"
hotmailSourceFilePath = rootDir() .. "/Device/hotmail_source.txt"

math.randomseed(os.time() + math.random())

-- ====== LOGIC FUNCTION ======
function initCurrentAccountCode()
    local accounts = readFile(accountFilePath)
    local code = readFile(accountCodeFilePath)
    if code == nil or code[#code] == nil or code[#code] == '' then
        alert('Empty accounts_code.txt')
        exit()
    end

    local current = accounts[#accounts]
    local splitted = split(current, "|")

    if splitted[2] == 'INPROGRESS' then 
        if splitted[13] and splitted[13] ~= '' then 
        else 
            local accountCode = getRandomLineInFile(accountCodeFilePath)
            local splittedCode = split(accountCode, "|")

            info.status = 'INPROGRESS'
            info.profileUid = splittedCode[1]
            info.mailLogin = nil
            info.mailRegister = nil
            info.mailPrice = 'nvr'
            info.password = splittedCode[3]
            info.hotmailPassword = splittedCode[4]
            info.hotmailRefreshToken = splittedCode[5]
            info.hotmailClientId = splittedCode[6]
            info.verifyCode = splittedCode[7]
            info.twoFA = '-nvr'

            local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.mailOrderId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '')
            accounts[#accounts] = line
            writeFile(accountFilePath, accounts)
        end 
    else 
        local accountCode = getRandomLineInFile(accountCodeFilePath)
        local splittedCode = split(accountCode, "|")

        local newUuid = 1
        if splitted[1] and splitted[1] ~= '' then newUuid = floor(splitted[1] + 1) end
        info.uuid = newUuid
        info.status = 'INPROGRESS'
        info.profileUid = splittedCode[1]
        info.mailLogin = nil
        info.mailRegister = nil
        info.mailPrice = 'nvr'
        info.password = splittedCode[3]
        info.hotmailPassword = splittedCode[4]
        info.hotmailRefreshToken = splittedCode[5]
        info.hotmailClientId = splittedCode[6]
        info.verifyCode = splittedCode[7]
        info.twoFA = '-nvr'

        local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.mailOrderId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '')
        addLineToFile(accountFilePath, line)
    end
    return
end

function archiveCurrentAccount()
    local accounts = readFile(accountFilePath)

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
            info.mailRegister        = info.mailRegister or splitted[7]
            info.mailOrderId          = info.mailOrderId or splitted[8]
            info.mailPrice           = info.mailPrice or splitted[9]
            info.hotmailRefreshToken = info.hotmailRefreshToken or splitted[10]
            info.hotmailClientId     = info.hotmailClientId or splitted[11]
            info.hotmailPassword     = info.hotmailPassword or splitted[12]
            info.verifyCode          = info.verifyCode or splitted[13]
            info.finishSettingMail   = info.finishSettingMail or splitted[14]
            info.finishChangeInfo    = info.finishChangeInfo or splitted[15]
            info.finishAddFriend     = info.finishAddFriend or splitted[16]
            info.ipRegister          = info.ipRegister or splitted[17]
            if info.password == nil or info.password == '' then info.password = getRandomLineInFile(defaultPasswordFilePath) end

            local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.mailOrderId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '') .. "|" .. (info.finishSettingMail or 'false') .. "|" .. (info.finishChangeInfo or 'false') .. "|" .. (info.finishAddFriend or 'false') .. "|" .. (info.ipRegister or '')
            accounts[#accounts] = line
            writeFile(accountFilePath, accounts)
        else
            if splitted[1] and splitted[1] ~= '' then info.uuid = floor(splitted[1] + 1) else info.uuid = 1 end
            info.status = 'INPROGRESS'
            info.password = getRandomLineInFile(defaultPasswordFilePath)
            local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.mailOrderId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '') .. "|" .. (info.finishSettingMail or 'false') .. "|" .. (info.finishChangeInfo or 'false') .. "|" .. (info.finishAddFriend or 'false') .. "|" .. (info.ipRegister or '')
            addLineToFile(accountFilePath, line)
        end 
    else 
        info.uuid = 1
        info.status = 'INPROGRESS'
        info.password = getRandomLineInFile(defaultPasswordFilePath)
        local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.mailOrderId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '') .. "|" .. (info.finishSettingMail or 'false') .. "|" .. (info.finishChangeInfo or 'false') .. "|" .. (info.finishAddFriend or 'false') .. "|" .. (info.ipRegister or '')
        addLineToFile(accountFilePath, line)
    end

end

function finishCurrentAccount()
    local accounts = readFile(accountFilePath)
    local splitted = split(accounts[#accounts], "|")

    info.status = "SUCCESS"
    info.checkpoint = 'OK'
    if not info.mailLogin or info.mailLogin == '' then info.mailLogin = info.mailRegister end 
    if not info.profileUid or info.profileUid == '' then info.profileUid = (getUIDFBLogin() or '') end 
    if not info.mailLogin or info.mailLogin == '' then return false end 

    local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.mailOrderId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '') .. "|" .. (info.finishSettingMail or 'false') .. "|" .. (info.finishChangeInfo or 'false') .. "|" .. (info.finishAddFriend or 'false') .. "|" .. (info.ipRegister or '')
    accounts[#accounts] = line

    log('finishCurrentAccount ' .. line)
    writeFile(accountFilePath, accounts)

    if HOTMAIL_SOURCE_FROM_FILE and info.mailLogin and info.mailLogin ~= '' then 
        removeLineFromFile(hotmailSourceFilePath, info.mailLogin)
    end 
    if LOGIN_NO_VERIFY then 
        removeLineFromFile(accountCodeFilePath, info.profileUid)
    end 
    if ENTER_VERIFY_CODE then saveAccToGoogleForm() else saveNoVerifyToGoogleForm() end
end

function failedCurrentAccount(code)
    if code == nil then code = 'unknown' end
    if code == 'phone_has_account' then return end

    local accounts = readFile(accountFilePath)
    local splitted = split(accounts[#accounts], "|")

    info.status = "FAILED"
    info.checkpoint = code
    if code == '282' and info.verifyCode ~= '' and info.verifyCode ~= nil then info.checkpoint = code .. '_has_code' end
    if not info.mailLogin or info.mailLogin == '' then info.mailLogin = info.mailRegister end 
    if not info.profileUid or info.profileUid == '' then info.profileUid = (getUIDFBLogin() or '') end 
    local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.mailOrderId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '') .. "|" .. (info.finishSettingMail or 'false') .. "|" .. (info.finishChangeInfo or 'false') .. "|" .. (info.finishAddFriend or 'false') .. "|" .. (info.ipRegister or '')
    accounts[#accounts] = line

    log(code .. ' - failedCurrentAccount ' .. line)
    writeFile(accountFilePath, accounts)

    if HOTMAIL_SOURCE_FROM_FILE and info.mailLogin and info.mailLogin ~= '' then 
        removeLineFromFile(hotmailSourceFilePath, info.mailLogin)
    end 
    if LOGIN_NO_VERIFY then 
        removeLineFromFile(accountCodeFilePath, info.profileUid)
    end 
    saveAccToGoogleForm()

    resetInfoObject()
end

function saveAccToGoogleForm()
    -- if (info.checkpoint == 282 or info.checkpoint == '282') and (info.mailLogin == '' or info.mailLogin == nil) then return nil end
    -- if (info.checkpoint == 282 or info.checkpoint == '282') and (info.profileUid == '' or info.profileUid == nil) then return nil end
    -- info.localIP = localIP[#localIP] .. " | " .. ACCOUNT_REGION .. " | " .. LANGUAGE .. " | " .. (LOGIN_WITH_CODE and 'otp' or (DUMMY_PHONE and 'phone' or (DUMMY_GMAIL and 'gmail' or (DUMMY_ICLOUD and 'icloud' or '-'))))

    local typeReg = '-'
    if TSPROXY_ID > 35 then typeReg = 'FPT' elseif (TSPROXY_ID > 0 and TSPROXY_ID < 36) then typeReg = 'Viettel' else typeReg = '-' end
    if IP_ROTATE_MODE == 2 then typeReg = 'Sim' end 
    if IP_ROTATE_MODE == 4 then typeReg = 'Text' end 

    local dummy = VERIFY_PHONE and 'verify_phone' or (LOGIN_NO_VERIFY and 'nvr' or (DUMMY_PHONE and 'phone' or (DUMMY_GMAIL and 'gmail' or (DUMMY_ICLOUD and 'icloud' or '-'))))
    local localIP = readFile(localIPFilePath)
    info.localIP = localIP[#localIP] .. " | " .. typeReg .. " | " .. dummy

    local tries = 3
    for i = 1, tries do 
        local response, error = httpRequest {
            url = PHP_SERVER .. "account_google_form.php",
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json",
            },
            data = info
        }

        if response then
            return true
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request acc_google_form. Times ".. i ..  " - " .. tostring(error))
        end
        sleep(3)
    end
end

function saveNoVerifyToGoogleForm()
    local typeReg = '-'
    if TSPROXY_ID > 35 then typeReg = 'FPT' elseif (TSPROXY_ID > 0 and TSPROXY_ID < 36) then typeReg = 'Viettel' else typeReg = '-' end
    if IP_ROTATE_MODE == 2 then typeReg = 'Sim' end 
    if IP_ROTATE_MODE == 4 then typeReg = 'Text' end 

    local dummy = VERIFY_PHONE and 'verify_phone' or (LOGIN_NO_VERIFY and 'nvr' or (DUMMY_PHONE and 'phone' or (DUMMY_GMAIL and 'gmail' or (DUMMY_ICLOUD and 'icloud' or '-'))))
    local localIP = readFile(localIPFilePath)
    info.localIP = localIP[#localIP] .. " | " .. typeReg .. " | " .. dummy

    local tries = 3
    for i = 1, tries do 
        local response, error = httpRequest {
            url = PHP_SERVER .. "no_verify_google_form.php",
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json",
            },
            data = info
        }

        if response then
            return
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request no_verify_google_form. Times ".. i ..  " - " .. tostring(error))
        end
        sleep(3)
    end
end

function saveMailToGoogleForm()
    local typeReg = '-'
    if TSPROXY_ID > 35 then typeReg = 'FPT' elseif (TSPROXY_ID > 0 and TSPROXY_ID < 36) then typeReg = 'Viettel' else typeReg = '-' end
    if IP_ROTATE_MODE == 2 then typeReg = 'Sim' end 
    if IP_ROTATE_MODE == 4 then typeReg = 'Text' end 

    local dummy = VERIFY_PHONE and 'verify_phone' or (LOGIN_NO_VERIFY and 'nvr' or (DUMMY_PHONE and 'phone' or (DUMMY_GMAIL and 'gmail' or (DUMMY_ICLOUD and 'icloud' or '-'))))
    local localIP = readFile(localIPFilePath)
    info.localIP = localIP[#localIP] .. " | " .. typeReg .. " | " .. dummy
    
    local tries = 3
    for i = 1, tries do 
        local response, error = httpRequest {
            url = PHP_SERVER .. "mail_google_form.php",
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json",
            },
            data = info
        }

        if response then
            return
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request mail_google_form. Times ".. i ..  " - " .. tostring(error))
        end
        sleep(3)
    end
end

function resetInfoObject()
    info = {
        uuid = nil,
        status = nil,
        mailOrderId = nil,
        mailRegister = nil,
        twoFA = nil,
        profileUid = nil,
        mailLogin = nil,
        password = nil,
        mailPrice = nil,
        hotmailRefreshToken = nil,
        hotmailClientId = nil,
        hotmailPassword = nil,
        checkpoint = nil,
        verifyCode = nil,
        finishSettingMail = nil,
        finishChangeInfo = nil,
        finishAddFriend = nil,
        ipRegister = nil,
        gmail_status = nil,
        gmail_firstname = nil,
        gmail_lastname = nil,
        gmail_address = nil,
        gmail_password = nil,
    }
    sleep(1)
end

function retrieveHotmailFromSource()
    local hotmailData = getRandomLineInFile(hotmailSourceFilePath)

    if hotmailData and hotmailData ~= '' then 
        local splitted = split(hotmailData, "|")

        info.mailRegister        = splitted[1]
        info.mailLogin           = splitted[1]
        info.hotmailPassword     = splitted[2]
        info.hotmailRefreshToken = splitted[3]
        info.hotmailClientId     = splitted[4]
        info.mailPrice           = 're-use'
        info.mailOrderId          = 2000000

        return true
    end 
    return false
end

function saveMailThueMail()
    local mails = readFile(thuemailsFilePath)

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

        writeFile(thuemailsFilePath, mails)
    else 
        local line = info.mailRegister  .. "|1"
        addLineToFile(thuemailsFilePath, line)
    end
end

function retrieveMailThueMail()
    local mails = readFile(thuemailsFilePath)
    if #mails < 4 then
        return
    end

    shuffle(mails)
    for i, v in ipairs(mails) do
        local splitted = split(v, "|")
        if floor(splitted[2]) <= THUE_LAI_MAIL then 
            return splitted[1]
        end
    end
end

function removeMailThueMail(invalidMail)
    local mails = readFile(thuemailsFilePath) 
    for i = #mails, 1, -1 do
        local email = mails[i]:match("^[^|]+")   
        if email == invalidMail then
            table.remove(mails, i)             
            break                             
        end
    end

    writeFile(thuemailsFilePath, mails)
end

function saveMailGmail66()
    local mails = readFile(gmail66FilePath)

    if #mails > 0 then
        local isNew = true
        for i, v in ipairs(mails) do
            local splitted = split(v, "|")
            if splitted[1] == info.mailRegister then 
                isNew = false
                mails[i] = splitted[1] .. "|" .. floor(splitted[2] + 1) .. "|" .. info.mailOrderId
            end
        end

        if isNew then
            table.insert(mails, info.mailRegister .. "|1|" .. info.mailOrderId)
        end

        writeFile(gmail66FilePath, mails)
    else 
        local line = info.mailRegister  .. "|1|" .. info.mailOrderId
        addLineToFile(gmail66FilePath, line)
    end
end

function retrieveMailGmail66()
    local mails = readFile(gmail66FilePath)
    if #mails < 4 then
        return
    end

    shuffle(mails)
    for i, v in ipairs(mails) do
        local splitted = split(v, "|")
        if floor(splitted[2]) <= THUE_LAI_MAIL then 
            return splitted
        end
    end
end

function removeMailGmail66(invalidMail)
    local mails = readFile(gmail66FilePath) 
    for i = #mails, 1, -1 do
        local email = mails[i]:match("^[^|]+")   
        if email == invalidMail then
            table.remove(mails, i)             
            break                             
        end
    end

    writeFile(gmail66FilePath, mails)
end

function executeGmailFromThueMail()
    local rerentMaxTries = 5
    local rerentTime = 1
    local autoCreateNew = true

    ::start_rerent_mail::
    local rerentSuccess = false
    local mailRerent = retrieveMailThueMail()

    if THUE_LAI_MAIL > 0 and mailRerent then
        rerentTime = floor(rerentTime + 1)

        local tries = 5
        for i = 1, tries do 
            toastr('Call times ' .. i)

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
                local ok, response, err = safeJsonDecode(response)
                if ok then 
                    if response.status == 'success' then
                        rerentSuccess = true

                        local res = response.data
                        info.mailOrderId = res.id
                        info.mailPrice = res.price
                        info.mailRegister = res.email

                        saveMailThueMail()
                        return true
                    else
                        toastr(response.message)
                        if rerentTime <= rerentMaxTries then 
                            removeMailThueMail(mailRerent)
                            goto start_rerent_mail
                        end
                    end
                else 
                    toastr("Failed decode response.")
                end
            else
                toastr('Times ' .. i .. " - " .. tostring(error), 2)
                log("Failed request rentals/re-rent. Times ".. i ..  " - " .. tostring(error))
            end

            sleep(3)
        end
    end

    if (not mailRerent) or (not rerentSuccess) then
        local tries = 30
        for i = 1, tries do 
            toastr('Call times ' .. i)

            local postData = {
                api_key = MAIL_THUEMAILS_API_KEY,
                service_id = 1,
                provider_id = PROVIDER_MAIL_THUEMAILS or 1,
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
                local ok, response, err = safeJsonDecode(response)
                if ok then 
                    if response.status == 'success' then
                        local res = response.data[1]

                        -- if not hasUppercase(res.email) then -- end 
                        info.mailOrderId = res.id
                        info.mailPrice = res.price
                        info.mailRegister = res.email

                        if THUE_LAI_MAIL > 0 then saveMailThueMail() end
                        return true
                        
                    else
                        toastr(response.message)
                    end
                else 
                    toastr("Failed decode response.")
                end
            else
                toastr('Times ' .. i .. " - " .. tostring(error), 2)
                log("Failed request rentals. Times ".. i ..  " - " .. tostring(error))
            end

            sleep(10)
        end
    end
    return false
end

function callRegisterHotmailFromDongVanFb()
    local account_type = HOTMAIL_SERVICE_IDS
    for i, service_id in pairs(account_type) do
        local tries = 1
        for i = 1, tries do 
            toastr('Mail id: ' .. service_id)

            local response, error = httpRequest {
                url = "https://api.dongvanfb.net/user/buy?apikey=" .. MAIL_DONGVANFB_API_KEY .. "&account_type=" .. service_id .. "&quality=1&type=full",
            }

            if response then
                local ok, response, err = safeJsonDecode(response)
                if ok then 
                    if response.status or response.status == 'true' then
                        local mailString = response.data.list_data[1]
                        local splitted = split(mailString, '|')

                        info.mailRegister = splitted[1]
                        info.mailPrice = response.data.price
                        info.mailOrderId = 2000000
                        info.hotmailPassword = splitted[2]
                        info.hotmailRefreshToken = splitted[3]
                        info.hotmailClientId = splitted[4]

                        saveMailToGoogleForm()
                        return true
                    else
                        toastr(response.message)
                    end
                else 
                    toastr("Failed decode response.")
                end
            else
                toastr('Times ' .. i .. " - " .. tostring(error), 2)
                log("Failed request user/buy. Times ".. i ..  " - " .. tostring(error))
            end

            sleep(3)
        end
    end
    return false
end

function executeHotmailFromDongVanFb()
    -- https://api.dongvanfb.net/user/buy?apikey=36458879248967a36&account_type=1&quality=1&type=full

    if HOTMAIL_SOURCE_FROM_FILE then 
        local hasHotmailFromSource = retrieveHotmailFromSource()
        if hasHotmailFromSource then
            return true
        else 
            alert('Out of hotmail.')
            exit()
            -- return callRegisterHotmailFromDongVanFb()
        end
    else 
        return callRegisterHotmailFromDongVanFb()
    end
    return false
end

function executeGmailFromGmail66()
    local rerentSuccess = false
    local mailRerent = retrieveMailGmail66()

    if THUE_LAI_MAIL > 0 and mailRerent then
        info.mailRegister = mailRerent[1]
        info.mailOrderId = mailRerent[3]
        info.mailPrice = 100
        rerentSuccess = true

        saveMailGmail66()
        return true
    end 

    if (not mailRerent) or (not rerentSuccess) then
        local tries = 30
        for i = 1, tries do 
            toastr('Call times ' .. i)
            
            local response, error = httpRequest {
                url = MAIL_GMAIL66_DOMAIN .. "rent-mail?api_key=" .. MAIL_GMAIL66_API_KEY,
                headers = {
                    ["Content-Type"] = "application/json",
                },
            }

            if response then
                local ok, response, err = safeJsonDecode(response)
                if ok then 
                    if response.success == true or response.success == 'true' then
                        local res = response

                        info.mailOrderId = res.order_id
                        info.mailPrice = string.match(res.message, "trừ%s+(%d+)%s+xu")
                        info.mailRegister = res.mail

                        if THUE_LAI_MAIL > 0 then saveMailGmail66() end
                        return true
                        
                    else
                        toastr(response.message)
                    end
                else 
                    toastr("Failed decode response.")
                end
            else
                toastr('Times ' .. i .. " - " .. tostring(error), 2)
                log("Failed request rent-mail. Times ".. i ..  " - " .. tostring(error))
            end

            sleep(10)
        end
    end
    return false
end

function executePhoneFromIronSim()
    local tries = 1
    for i = 1, tries do 
        toastr('Call times ' .. i)

        local response, error = httpRequest {
            url = PHONE_IRONSIM_DOMAIN .. "phone/new-session?service=7&token=" .. PHONE_IRONSIM_API_KEY,
            headers = {
                ["Content-Type"] = "application/json",
            },
        }

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.status_code == 200 or response.status_code == '200' then
                    local res = response.data

                    info.mailOrderId = res.session
                    info.mailPrice = res.price
                    info.mailRegister = res.phone_number

                    return true
                else
                    toastr(response.message)
                end
            else 
                toastr("Failed decode response.")
            end
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request phone/new-session. Times ".. i ..  " - " .. tostring(error))
        end

        sleep(10)
    end
    return false
end

function executeDomainMail()
    local mail = randomMailDomain() 
    info.mailLogin = mail
    info.mailRegister = mail
    info.mailPrice = 'free'
    return true
end 

function getDomainMail()
    local mail = randomMailDomain() 
    info.mailLogin = mail
    return true
end 

function executeGetMailRequest()
    if MAIL_SUPLY == 1 then 
        return executeHotmailFromDongVanFb()
    elseif MAIL_SUPLY == 2 then
        return executeGmailFromThueMail()
    elseif MAIL_SUPLY == 3 then
        return executeDomainMail()
    elseif MAIL_SUPLY == 4 then
        return executeGmailFromGmail66()
    elseif MAIL_SUPLY == 5 then
        return executePhoneFromIronSim()
    else 
        toastr('MAIL_SUPLY invalid.', 5)
        return false
    end
end

function getThuemailConfirmCode()
    if info.mailOrderId == nil then return nil end
    
    sleep(3)
    local tries = 10
    for i = 1, tries do 
        toastr('Call times ' .. i)

        local response, error = httpRequest {
            url = MAIL_THUEMAILS_DOMAIN .. "rentals/" .. info.mailOrderId .. "?api_key=" .. MAIL_THUEMAILS_API_KEY,
            headers = {
                ["Content-Type"] = "application/json",
            },
        }

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.id and response.otp then
                    saveMailToGoogleForm()
                    return response.otp
                else
                    toastr('Empty code. Times ' .. i)
                end
            else 
                toastr("Failed decode response.")
            end
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request rentals/id. Times ".. i ..  " - " .. tostring(error))
        end

        sleep(10)
    end
    return nil
end

function getDongvanfbConfirmCode()
    sleep(5)

    local tries = 10
    for i = 1, tries do 
        toastr('Call times ' .. i)

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
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.status or response.status == 'true' then
                    return response.code
                else
                    toastr('Empty code. Times ' .. i)
                end
            else 
                toastr("Failed decode response.")
            end
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request api/get_code_oauth2. Times ".. i ..  " - " .. tostring(error))
        end

        sleep(5)
    end
    return nil
end

function getMailDomainRegisterConfirmCode()
    local tries = 3
    for i = 1, tries do 
        toastr('Call times ' .. i)

        local response, error = httpRequest {
            url = PHP_SERVER .. "/mail_domain_register_confirm.php?email=" .. info.mailLogin,
        }

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.code ~= '' then
                    return response.code
                else
                    toastr("Empty response code.")
                end
            else 
                toastr("Failed decode response.")
            end
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request mail_domain_register_confirm. Times ".. i ..  " - " .. tostring(error))
        end

        sleep(5)
    end
    return nil
end

function getGmail66ConfirmCode()
    if info.mailOrderId == nil then return nil end
    toastr('getGmail66ConfirmCode..', 5)

    sleep(10)
    local tries = 10
    for i = 1, tries do 
        toastr('Call times ' .. i)

        local response, error = httpRequest {
            url = MAIL_GMAIL66_DOMAIN .. "check-otp/" .. info.mailOrderId .. "?api_key=" .. MAIL_GMAIL66_API_KEY,
            headers = {
                ["Content-Type"] = "application/json",
            },
        }

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.success == true or response.success == 'true' then
                    saveMailToGoogleForm()
                    return response.otp
                else
                    toastr('Empty code. Times ' .. i)
                end
            else 
                toastr("Failed decode response.")
            end
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request check-otp. Times ".. i ..  " - " .. tostring(error))
        end

        sleep(10)
    end
    return nil
end

function getIronSimConfirmCode()
    if info.mailOrderId == nil then return nil end
    toastr('getIronSimConfirmCode', 5)

    sleep(10)
    local tries = 20
    for i = 1, tries do 
        toastr('Call times ' .. i)

        local response, error = httpRequest {
            url = PHONE_IRONSIM_DOMAIN .. "session/" .. info.mailOrderId .. "/get-otp?token=" .. PHONE_IRONSIM_API_KEY,
            headers = {
                ["Content-Type"] = "application/json",
            },
        }

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                local data = response.data
                if response.status_code == 200 and data.status == 0 and data.messages then
                    saveMailToGoogleForm()
                    return data.messages[1].otp
                else
                    toastr('Empty code. Times ' .. i)
                end
            else 
                toastr("Failed decode response.")
            end
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request session/get-otp. Times ".. i ..  " - " .. tostring(error))
        end

        sleep(10)
    end
    return nil
end

function getCodeMailRegister()
    if MAIL_SUPLY == 1 then 
        return getDongvanfbConfirmCode()
    elseif MAIL_SUPLY == 2 then
        return getThuemailConfirmCode()
    elseif MAIL_SUPLY == 3 then
        return getMailDomainRegisterConfirmCode()
    elseif MAIL_SUPLY == 4 then
        return getGmail66ConfirmCode()
    elseif MAIL_SUPLY == 5 then
        return getIronSimConfirmCode()
    else 
        toastr('MAIL_SUPLY invalid.', 5)
    end
end

function getMailDomainOwnerConfirmCode()
    local tries = 3
    for i = 1, tries do 
        toastr('Call times ' .. i)

        local response, error = httpRequest {
            url = PHP_SERVER .. "/mail_domain_owner_confirm.php?email=" .. info.mailLogin,
        }

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.code ~= '' then
                    return response.code
                else
                    toastr("Empty response code.")
                end
            else 
                toastr("Failed decode response.")
            end
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request mail_domain_owner_confirm. Times ".. i ..  " - " .. tostring(error))
        end

        sleep(10)
    end
    return nil
end

function getCodeMailOwner()
    if MAIL_SUPLY == 1 then 
        return getDongvanfbConfirmCode()
    elseif MAIL_SUPLY == 3 then
        return getMailDomainOwnerConfirmCode()
    else 
        toastr('MAIL_SUPLY invalid.', 5)
    end
end

function getMailDomainAddConfirmCode()
    sleep(3)

    local tries = 3
    for i = 1, tries do 
        toastr('Call times ' .. i)

        local response, error = httpRequest {
            url = PHP_SERVER .. "/mail_domain_add_confirm.php?email=" .. info.mailLogin,
        }

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.code ~= '' then
                    return response.code
                else
                    toastr("Empty response code.")
                end
            else 
                toastr("Failed decode response.")
            end
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request mail_domain_add_confirm. Times ".. i ..  " - " .. tostring(error))
        end

        sleep(5)
    end
    return nil
end

function get2FACode()
    local tries = 3
    for i = 1, tries do 
        toastr('Call times ' .. i)

        local response, error = httpRequest {
            url = "https://2fa.live/tok/" .. info.twoFA,
            headers = {
                ["Content-Type"] = "application/json",
            },
        }

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.token then
                    return response.token
                else
                    toastr("Empty response get 2FA OTP.")
                end
            else 
                toastr("Failed decode response.")
            end  
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request 2fa.live. Times ".. i ..  " - " .. tostring(error))
        end

        sleep(3)
    end
    return nil
end

function getSearchText(no)
    if no == nil then
        no = 3
    end

    local searchTextFilePath = rootDir() .. "/Facebook/input/searchtext_us.txt"
    if ACCOUNT_REGION == 'VN' then
        searchTextFilePath = rootDir() .. "/Facebook/input/searchtext.txt"
    end

    local lines = readFile(searchTextFilePath)
    local result = {}

    for _ = 1, math.min(no, #lines) do
        local i = math.random(#lines)
        table.insert(result, table.remove(lines, i))
    end
    return result
end

function getSearchUsername(no)
    if no == nil then
        no = 3
    end

    local searchTextFilePath = rootDir() .. "/Facebook/input/lastname_us.txt"
    if ACCOUNT_REGION == 'VN' then
        searchTextFilePath = rootDir() .. "/Facebook/input/lastname.txt"
    end

    local lines = readFile(searchTextFilePath)
    local result = {}

    for _ = 1, math.min(no, #lines) do
        local i = math.random(#lines)
        table.insert(result, table.remove(lines, i))
    end
    return result
end

function getConfigServer()
    -- Máy 3 | Hiến | 192.168.1.63
    local localIP = readFile(localIPFilePath)
    local localName = localIP[#localIP]

    if localName == nil then 
        toastr('No local device name.', 2)
        return false
    end 
    local splitted = split(localName, "|")
    local username = string.gsub(splitted[2], " ", "")

    local postData = {
        ['action']   = 'select',
        ['username'] = username,
        ['device']   = string.gsub(splitted[3], " ", ""),
    }

    local tries = 3
    for i = 1, tries do 
        local response, error = httpRequest {
            url = PHP_SERVER .. "device_config.php",
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json",
            },
            data = postData
        }

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.status and response.status == 'success' then
                    local config = response.data

                    LANGUAGE                 = config.language
                    ACCOUNT_REGION           = config.account_region
                    HOTMAIL_SERVICE_IDS      = parseStringToTable(config.hotmail_service_ids)
                    MAIL_SUPLY               = tonumber(config.mail_suply)
                    PROVIDER_MAIL_THUEMAILS  = tonumber(config.provider_mail_thuemails)
                    TIMES_XOA_INFO           = tonumber(config.times_xoa_info)
                    ENTER_VERIFY_CODE        = tonumber(config.enter_verify_code) ~= 0
                    HOTMAIL_SOURCE_FROM_FILE = tonumber(config.hot_mail_source_from_file) ~= 0
                    THUE_LAI_MAIL            = tonumber(config.thue_lai_mail_thuemails)
                    ADD_MAIL_DOMAIN          = tonumber(config.add_mail_domain)
                    MAIL_DOMAIN_TYPE         = tonumber(config.mail_domain_type)
                    CHANGE_INFO              = tonumber(config.change_info) ~= 0
                    PROXY                    = config.proxy
                    IP_ROTATE_MODE           = tonumber(config.ip_rotate_mode)
                    MAIL_DONGVANFB_API_KEY   = config.api_key_dongvanfb
                    MAIL_THUEMAILS_API_KEY   = config.api_key_thuemails
                    MAIL_GMAIL66_API_KEY     = config.api_key_gmail66
                    PHONE_IRONSIM_API_KEY    = config.api_key_ironsim
                    LOCAL_SERVER             = config.local_server
                    DESTINATION_FILENAME     = config.destination_filename
                    LOGIN_NO_VERIFY          = tonumber(config.login_with_code) ~= 0
                    DUMMY_MODE               = tonumber(config.reg_phone_first)
                    TSPROXY_ID               = tonumber(config.tsproxy_id)
                    TSPROXY_PORT             = tonumber(config.tsproxy_port)

                    return true
                else
                    toastr(response.info)
                end
            else 
                toastr("Failed decode response.")
            end  
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request device_config. Times ".. i ..  " - " .. tostring(error))
        end
        sleep(3)
    end
    return false
end

function checkProxyAvailable()
    toast('checkProxyAvailable')
    sleep(1)

    -- Máy 38 | Hiến | 192.168.31.160
    local localIP = readFile(localIPFilePath)
    local localName = localIP[#localIP]

    if localName == nil then 
        toastr('No local device name.', 2)
        return false
    end 
    local splitted = split(localName, "|")

    local postData = {
        ['ip_address']  = info.ipRegister,
        ['username'] = string.gsub(splitted[2], " ", ""),
        ['device_name'] = string.gsub(splitted[1], " ", ""),
        ['device_ip']   = string.gsub(splitted[3], " ", ""),
    }

    local tries = 3
    for i = 1, tries do 
        local response, error = httpRequest {
            url = PHP_SERVER .. "ip_upsert.php",
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json",
            },
            data = postData
        }

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                toastr(response.message, 2)
                sleep(2)
                if response.status or response.status == 'true' then
                    return true
                elseif not response.status or response.status == 'false' then
                    return false
                end
            else 
                toastr("Failed decode response.")
            end  
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request ip_upsert. Times ".. i ..  " - " .. tostring(error))
        end
        sleep(3)
    end
    return false
end

function reloadTsproxy()
    if (not TSPROXY_ID or TSPROXY_ID == '') then alert('Empty TSPROXY_ID') exit() end 
    toast('reloadTsproxy', 5)

    local tries = 1
    for i = 1, tries do 
        local response, error = httpRequest {
            url = TSPROXY_URL .. "public/reload/".. TSPROXY_DEVICE_ID .."/" .. TSPROXY_ID,
            headers = {
                ["Content-Type"] = "application/json",
                ["x-api-key"] = TSPROXY_API_KEY,
            },
            timeout = 10
        }

        sleep(1)
        if 1 then return true end

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.statusCode and response.statusCode == 200 then
                    toastr(response.data, 2)
                    return true
                else
                    toastr(response.message)
                end
            else 
                toastr("Failed decode response.")
            end  
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request reloadTsproxy. Times ".. i ..  " - " .. tostring(error))
        end
        sleep(3)
    end
    return false
end 

function waitforTsproxyReady(timeout)
    if (not TSPROXY_ID or TSPROXY_ID == '') then alert('Empty TSPROXY_ID') exit() end 

    toast('waitforTsproxyReady', 3)
    for i = 1, timeout, 1 do
        local response, error = httpRequest {
            url = TSPROXY_URL .. "public/proxy-list/".. TSPROXY_DEVICE_ID,
            headers = {
                ["Content-Type"] = "application/json",
                ["x-api-key"] = TSPROXY_API_KEY,
            },
            timeout = 10
        }

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.statusCode and response.statusCode == 200 then
                    local currentIP = {}
                    for _, item in ipairs(response.data) do
                        if item.id == tostring(TSPROXY_ID) then
                            currentIP = item
                        end
                    end

                    if currentIP.status == 'running' then 
                        toastr("Ready: " .. currentIP.ipPublic, 2)
                        info.ipRegister = currentIP.ipPublic
                        sleep(3)
                        return true
                    end
                else
                    toastr(response.message)
                end
            else 
                toastr("Failed decode response.")
            end  
        else
            toastr('waitforTsproxyReady times ' .. i)
        end
       
        sleep(5)
    end
    info.ipRegister = nil
    return false
end

-- ====== FE FUNCTION ======
function removeAccount()
    sleep(2)
    if waitImageVisible(create_new_account) or waitImageVisible(logo_facebook_login) then
        if LANGUAGE == 'VN' then 
            press(695, 90) -- three dots icon
            if waitImageVisible(remove_account_from_device, 10) then 
                findAndClickByImage(remove_account_from_device)
            end 
            if waitImageVisible(go_xoa_account) then 
                findAndClickByImage(go_xoa_account)
            end 
            if waitImageVisible(go_xoa_account_blue) then 
                findAndClickByImage(go_xoa_account_blue)
            end 
        else   
            press(695, 90) sleep(5) -- three dots icon
            press(300, 1250) sleep(4) -- remove profiles from this device
            press(600, 330) sleep(5) -- btn remove gray
            press(400, 1150) sleep(1) -- btn remove blue confirm
        end
    end
end

function checkSuspended()
    if waitImageVisible(confirm_human, 1) then
        toastr('Die')
        failedCurrentAccount('282')

        if TIMES_XOA_INFO == 0 then 
            press(680, 90) -- help text
            if waitImageVisible(logout_suspend_icon, 10) then
                findAndClickByImage(logout_suspend_icon)
                press(520, 840) sleep(1) --logout text

                if waitImageVisible(logout_btn) then
                    findAndClickByImage(logout_btn)
                    sleep(2)

                    if waitImageVisible(create_new_account) or waitImageVisible(logo_facebook_login) then removeAccount() end 
                end
            end
        end
        return true
    end

    toastr('OK')
    return false
end

function checkPageNotAvailable()
    if waitImageVisible(page_not_available_now, 1) then 
        toastr('page_not_available_now')
        swipeCloseApp()
        return true
    end 
    return false
end

function getRandomName()
    if ACCOUNT_REGION == 'VN' then 
        local firstname = getRandomLineInFile(rootDir() .. "/Facebook/input/firstname.txt")
        local lastname = getRandomLineInFile(rootDir() .. "/Facebook/input/lastname.txt")
        return { firstname, lastname }

    end
    if ACCOUNT_REGION == 'US' then 
        local firstname = getRandomLineInFile(rootDir() .. "/Facebook/input/firstname_us.txt")
        local lastname = getRandomLineInFile(rootDir() .. "/Facebook/input/lastname_us.txt")
        return { firstname, lastname }
    end
end

function getRandomCity()
    return getRandomLineInFile(rootDir() .. "/Facebook/input/vn_city.txt")
end

function getRandomHighSchool()
    return getRandomLineInFile(rootDir() .. "/Facebook/input/vn_highschool.txt")
end

function getRandomUniversity()
    return getRandomLineInFile(rootDir() .. "/Facebook/input/vn_university.txt")
end

function setFirstNameLastName()
    if waitImageVisible(what_name) then
        toastr("what_name")

        ::label_input_name::
        local name = getRandomName()
        press(200, 380) sleep(0.5)
        findAndClickByImage(x_input_icon)
        typeText(name[1]) sleep(0.5)
        press(600, 380) sleep(0.5)
        findAndClickByImage(x_input_icon)
        typeText(name[2]) sleep(0.5)
        findAndClickByImage(next)

        if not waitImageNotVisible(what_name, 10) then 
            if waitImageVisible(first_name_invalid, 2) or waitImageVisible(red_warning_icon, 2) then goto label_input_name end 
        end

        if waitImageVisible(select_your_name, 2) then 
            if waitImageVisible(gender_options, 10) then 
                findAndClickByImage(gender_options)
                findAndClickByImage(next)
            end
        end 
    end
end

function setGender()
    if waitImageVisible(what_is_gender, 2) then
        toastr("what_is_gender")

        if waitImageVisible(gender_options, 10) then 
            local x = math.random(500, 560)
            local y = 440

            local xRandom = math.random(1, 2)
            if xRandom == 2 then
                y = 540
            end
            press(x, y)
            findAndClickByImage(next)
            waitImageNotVisible(what_is_gender)
        else 
            local x = math.random(500, 560)
            local y = 440

            local xRandom = math.random(1, 2)
            if xRandom == 2 then
                y = 540
            end
            press(x, y)
            findAndClickByImage(next)
            waitImageNotVisible(what_is_gender)
        end
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
    toastr('openFacebook')
    appActivate("com.facebook.Facebook")
end

function clearAlert()
    local alertOK = {rootDir() .. "/Facebook/Remote/images/" .. "alert_ok.png"}
    if waitImageVisible(alertOK, 1) then 
        findAndClickByImage(alertOK)
        sleep(0.5)
    end
end 

function homeAndUnlockScreen()
    toastr("Unlock Screen")

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

function executeXoaInfo()
    if TIMES_XOA_INFO > 0 then
        toastr('executeXoaInfo')
        appRun("com.ienthach.XoaInfo")

        if waitImageVisible(xoainfo_reset_data, 10) then
            for i = 1, TIMES_XOA_INFO do
                findAndClickByImage(xoainfo_reset_data)
                sleep(1)
                
                if waitImageVisible(xoainfo_info_fake, 30) then
                    if i == TIMES_XOA_INFO then
                        sleep(1)
                        pressHome()
                    end
                end
            end
        end
    end
    sleep(1)
end

function rotateShadowRocket()
    toastr('OnShadowRocket')
    openURL("shadowrocket://")

    local dirPath = rootDir() .. "/Facebook/Remote/images/"
    shadowrocket_logo = {dirPath .. "shadowrocket_logo.png"}
    shadowrocket_on = {dirPath .. "shadowrocket_on.png"}
    shadowrocket_off = {dirPath .. "shadowrocket_off.png"}

    if waitImageVisible(shadowrocket_logo) then
        if waitImageVisible(shadowrocket_on, 2) then 
            findAndClickByImage(shadowrocket_on) sleep(2)

            local random = math.random(1, 2)
            if random == 1 then press(390, 720) sleep(2) else press(390, 640) sleep(2) end
            findAndClickByImage(shadowrocket_off)
        elseif waitImageVisible(shadowrocket_off, 2) then
            findAndClickByImage(shadowrocket_off)
        end
        toastr('OnShadowRocket', 4)
        sleep(3)
    end
end

function checkOnShadowRocket()
    toastr('checkOnShadowRocket')
    openURL("shadowrocket://")

    local dirPath = rootDir() .. "/Facebook/Remote/images/"
    shadowrocket_logo = {dirPath .. "shadowrocket_logo.png"}
    shadowrocket_on = {dirPath .. "shadowrocket_on.png"}
    shadowrocket_off = {dirPath .. "shadowrocket_off.png"}

    if waitImageVisible(shadowrocket_logo) then
        if waitImageVisible(shadowrocket_off) then 
            findAndClickByImage(shadowrocket_off)
        end
        toastr('OnShadowRocket', 2)
        sleep(2)
    end
end

function randomPhone() 
    if ACCOUNT_REGION == 'VN' then 
        return randomVNPhone()
    elseif ACCOUNT_REGION == 'US' then
        return randomUSPhone()
    end
    return '00000'
end 

function checkModeMenuLeft()
    return waitImageVisible(fb_logo_menu_left, 2)
end

function saveRandomServerAvatar()
    toast('saveRandomServerAvatar', 3)
    clearSystemAlbum()

    local url = PHP_SERVER .. "random_avatar.php"
    local filename = "avatar_" .. os.time() .. ".jpg"
    local save_path = "/var/mobile/Media/DCIM/100APPLE/" .. filename

    local MAX_RETRIES = 2
    local attempt = 0
    local success = false

    while attempt <= MAX_RETRIES do
        attempt = attempt + 1

        local f = io.open(save_path, "wb")
        if not f then
            toast("❌ Không thể mở file để ghi: " .. save_path)
            return
        end

        local c = curl.easy{
            url = url,
            writefunction = function(buffer)
                if buffer then
                    f:write(buffer)
                    return #buffer
                else
                    return false
                end
            end,
            ssl_verifyhost = 0,
            ssl_verifypeer = 0,
            timeout = 60,
        }

        local ok, err = pcall(function()
            c:perform()
        end)

        f:close()

        if ok and fileExists(save_path) then
            saveToSystemAlbum(save_path)
            toast("✅ Lưu avatar thành công!", 2)
            sleep(2)
            return true
        else
            if attempt <= MAX_RETRIES then
                toast("⚠️ Thử lại lần " .. (attempt + 1), 2)
                usleep(500000) -- chờ 0.5s trước khi retry
            else
                toast("❌ Lỗi tải ảnh sau " .. attempt .. " lần thử: " .. tostring(err), 3)
            end
        end
    end

    return false
end

function fakeRandomContact()
    toast('fakeRandomContact..', 4)
    function sendAddContact(cmd)
        local shellCmd = string.format('echo "%s" | socat - UNIX-CONNECT:/private/var/tmp/addcontact.sock', cmd)
        local handle = io.popen(shellCmd)
        local result = handle:read("*a")
        handle:close()
    end

    local count = math.random(200, 500)
    sendAddContact(string.format("add %d +849 12", count))
    sleep(4)
end

function getNextProxyInText()
    local now = os.time()
    local path = rootDir() .. "/Device/proxy.txt"
    local proxies = readFile(path)

    if #proxies > 0 then
        for i, v in ipairs(proxies) do
            local splitted = split(v, "|")
            if not splitted[2] then 
                proxies[i] = splitted[1] .. "|" .. now
                writeFile(path, proxies)
                return splitted[1]
            else 
                if now - splitted[2] > 60 * 60 then 
                    proxies[i] = splitted[1] .. "|" .. now
                    writeFile(path, proxies)
                    return splitted[1]
                end 
            end 
        end

    end
    return nil
end 

function rotateProxyText(proxyString)
    if not proxyString then 
        proxyString = getNextProxyInText() 
    end 

    local dirPath = rootDir() .. "/Facebook/Remote/images/"
    local shadowrocket_logo = {dirPath .. "shadowrocket_logo.png"}
    local shadowrocket_on = {dirPath .. "shadowrocket_on.png"}
    local shadowrocket_off = {dirPath .. "shadowrocket_off.png"}
    local shadowrocket_add = {dirPath .. "shadowrocket_add.png"}
    local shadowrocket_xoa = {dirPath .. "shadowrocket_xoa.png"}
    local shadowrocket_xoa_confirm = {dirPath .. "shadowrocket_xoa_confirm.png"}
    
    local socks5 = ""
    if proxyString and proxyString ~= "" then
        local ip, port, user, pass = proxyString:match("([^:]+):([^:]+):([^:]+):([^:]+)")
        if user and pass and ip and port then
            socks5 = user .. ":" .. pass .. "@" .. ip .. ":" .. port
        else
            socks5 = proxyString
        end
    else
        return false
    end

    local mime = require("mime")
    local b64 = mime.b64(socks5)
    copyText("http://" .. b64)

    sleep(1)
    openURL("shadowrocket://route/proxy")
    sleep(3)

    if appState("com.liguangming.Shadowrocket") == "ACTIVATED" then
        if waitImageVisible(shadowrocket_add) then
            findAndClickByImage(shadowrocket_add) sleep(2)
            press(250, 640) sleep(1) -- first proxy

            ::label_onshadowrocket::
            if waitImageVisible(shadowrocket_on) then 
                findAndClickByImage(shadowrocket_on) sleep(1)
                findAndClickByImage(shadowrocket_off) sleep(2)
            elseif waitImageVisible(shadowrocket_off, 2) then
                findAndClickByImage(shadowrocket_off) sleep(2)
            end

            if checkImageIsExists(shadowrocket_on) then 
                swipe(520, 720, 350, 720)
                if waitImageVisible(shadowrocket_xoa) then 
                    findAndClickByImage(shadowrocket_xoa) sleep(1)
                    findAndClickByImage(shadowrocket_xoa_confirm) sleep(1)
                end 
                return true
            else 
                goto label_onshadowrocket
            end 
        end
    end
end

function getTsproxy()
    if not TSPROXY_PORT then alert('Empty tsproxy Port') exit() end
    return 'chip.tsproxy.xyz:' .. TSPROXY_PORT
end 

function addProxyShadowRocket(proxyString)
    if not proxyString then 
        if IP_ROTATE_MODE == 3 then proxyString = getTsproxy() end
        if IP_ROTATE_MODE == 4 then proxyString = getNextProxyInText() end
    end 

    local dirPath = rootDir() .. "/Facebook/Remote/images/"
    local shadowrocket_logo = {dirPath .. "shadowrocket_logo.png"}
    local shadowrocket_add = {dirPath .. "shadowrocket_add.png"}
    local shadowrocket_on = {dirPath .. "shadowrocket_on.png"}
    local shadowrocket_off = {dirPath .. "shadowrocket_off.png"}
    local shadowrocket_xoa = {dirPath .. "shadowrocket_xoa.png"}
    local shadowrocket_xoa_confirm = {dirPath .. "shadowrocket_xoa_confirm.png"}
    
    local socks5 = ""
    if proxyString and proxyString ~= "" then
        local ip, port, user, pass = proxyString:match("([^:]+):([^:]+):([^:]+):([^:]+)")
        if user and pass and ip and port then
            socks5 = user .. ":" .. pass .. "@" .. ip .. ":" .. port
        else
            socks5 = proxyString
        end
    else
        return false
    end

    local mime = require("mime")
    local b64 = mime.b64(socks5)

    copyText("http://" .. b64)

    sleep(1)
    openURL("shadowrocket://route/proxy")
    sleep(3)

    if appState("com.liguangming.Shadowrocket") == "ACTIVATED" then
        ::label_onshadowrocket::
        sleep(2)

        if waitImageVisible(shadowrocket_add) then
            findAndClickByImage(shadowrocket_add) sleep(1)
        end 
        if waitImageVisible(shadowrocket_off) then
            findAndClickByImage(shadowrocket_off) sleep(3)
        elseif waitImageVisible(shadowrocket_on, 2) then 
            findAndClickByImage(shadowrocket_on) sleep(1)
            findAndClickByImage(shadowrocket_off) sleep(3)
        end

        if checkImageIsExists(shadowrocket_on) then 
            sleep(1)
            return true
        else 
            goto label_onshadowrocket
        end 
    end
end

function wipeApp(bundleid)
    toast('wipeApp', 2)
    if not bundleid then bundleid = nil end 

    local lfs = require('lfs')
    function isDir(name)
        if type(name) ~= "string" then
            return false
        end
        local cd = lfs.currentdir()
        local is = lfs.chdir(name) and true or false
        lfs.chdir(cd)
        return is
    end
    function deletedir(dir, rmdir)
        if (isDir(dir)) then
            for file in lfs.dir(dir) do
                local file_path = dir .. '/' .. file
                if file ~= "." and file ~= ".." then
                    if lfs.attributes(file_path, 'mode') == 'file' then
                        os.remove(file_path)
                    elseif lfs.attributes(file_path, 'mode') == 'directory' then
                        deletedir(file_path, 1)
                    else
                        os.remove(file_path)
                    end
                end
            end
            if (rmdir == 1) then
                lfs.rmdir(dir)
            end
        end
    end
    if bundleid then appKill(bundleid) end
    appKill("com.apple.mobilesafari")
    appKill("com.apple.Preferences")

    io.popen("echo 1 | sudo -u root -S killall -9 MobileSafari")
    io.popen("echo 1 | sudo -u root -S launchctl remove com.apple.mobilesafari")

    -- clean SystemCaches   
    io.popen("echo 1 | sudo -u root -S rm -rf /var/MobileSoftwareUpdate/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/Logs/*.log")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/logs/*.log*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/logs/AppleSupport/*.log")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/logs/CrashReporter/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/root/.bash_history")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/db/diagnostics/shutdown.log")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/Keychains/keychain-2.db-corrupt")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/root/Library/Logs/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Downloads/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/Caches/Snapshots/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/Caches/com.apple.Safari.SafeBrowsing/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/Caches/com.apple.WebKit.Networking/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/Caches/com.apple.WebKit.WebContent/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/com.apple.WebKit/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/CrashReporter/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/Logs/AppleSupport/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/Logs/CrashReporter/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/Recents/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/Safari/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/SafariSafeBrowsing/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/WebClips/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/WebKit/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Media/Downloads/*")
    io.popen("echo 1 | sudo -u root -S rm -rf /private/var/mobile/Library/Caches/com.apple.mobilesafari")
    io.popen("echo 1 | sudo -u root -S rm -rf /private/var/mobile/Library/Caches/Safari")
    io.popen("echo 1 | sudo -u root -S rm /private/var/mobile/Library/Cookies/Cookies.binarycookies")
    io.popen("echo 1 | sudo -u root -S rm /private/var/root/Library/Cookies/Cookies.binarycookies")
    io.popen("echo 1 | sudo -u root -S security delete-keychain login.keychain")

    -- cleanPasteBoard
    -- io.popen("echo 1 | sudo -u root -S killall -9 pasted")
    -- io.popen("echo 1 | sudo -u root -S killall -9 pasteboardd")

    -- [self unloadServices:@"com.apple.UIKit.pasteboardd.plist;com.apple.pasteboard.pasted.plist"];	
    -- io.popen("echo 1 | sudo -u root -S launchctl unload -w /System/Library/LaunchDaemons/com.apple.UIKit.pasteboardd.plist")
    -- io.popen("echo 1 | sudo -u root -S launchctl unload -w /System/Library/LaunchDaemons/com.apple.pasteboard.pasted.plist")
    -- deletedir('private/var/mobile/Library/Caches/com.apple.UIKit.pboard')
    -- deletedir('private/var/mobile/Library/Caches/com.apple.Pasteboard')

    -- [self loadServices:@"com.apple.UIKit.pasteboardd.plist;com.apple.pasteboard.pasted.plist"];	
    -- io.popen("echo 1 | sudo -u root -S launchctl load -w /System/Library/LaunchDaemons/com.apple.UIKit.pasteboardd.plist")
    -- io.popen("echo 1 | sudo -u root -S launchctl load -w /System/Library/LaunchDaemons/com.apple.pasteboard.pasted.plist")

    -- clean LsdIdentity
    deletedir('private/var/db/lsd/com.apple.lsdidentifiers.plist')

    -- clean itunesstored
    io.popen("echo 1 | sudo -u root -S rm -rf /private/var/mobile/Library/Caches/com.apple.itunesstored/fsCachedData")

    if bundleid then 
        -- clean AppData	
        local result = appInfo(bundleid, 0)
        -- print(table.tostring(result))
        deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'CloudKit', 0)
        deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'Documents', 0)
        deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'Library', 0)
        deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'SystemData', 0)
        deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'tmp', 0)
        deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//CloudKit', 0)
        deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//Documents', 0)
        deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//Library', 0)
        deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//SystemData', 0)
        deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//tmp', 0)
        deletedir(result["bundleContainerPath"]:gsub("file://", ""), 0)
    end

    if GMAIL_REGISTER then 
        -- clean AppGroup	
        deletedir('private/var/mobile/Containers/Shared/AppGroup/')

        -- Google cache
        io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Library/Preferences/com.google.*")
        io.popen("echo 1 | sudo -u root -S rm -rf /var/mobile/Containers/Data/Application/*/Library/Preferences/com.google.*")
    end

    io.popen("echo 1 | sudo -u root -S killall -9 itunesstored itunescloudd appstored")
    io.popen("echo 1 | sudo -u root -S killall -9 locationd Maps")

    deletedir('private/var/mobile/Library/Safari/')
    deletedir('private/var/mobile/Library/WebKit/')

    -- clean Pasteboard	
    -- deletedir('private/var/mobile/Library/Caches/com.apple.UIKit.pboard')
    -- deletedir('private/var/mobile/Library/Caches/com.apple.Pasteboard')

    -- clean ItunesCache
    deletedir('private/var/mobile/Library/Caches/com.apple.itunesstored/fsCachedData')

    io.popen("echo 1 | sudo -u root -S killall -9 securityd")
    io.popen("echo 1 | sudo -u root -S dscacheutil -flushcache")
    sleep(1)
end

function selectThangSinhNhat()
    if waitImageVisible(thang_4) then 
        if REG_SOURCE == 2 then
            local section = math.random(1, 2)
            if section == 2 then swipe(360, 1000, 370, 800) sleep(2) end 

            local part = math.random(1, 6)
            if part == 1 then press(380, 525) end
            if part == 2 then press(380, 625) end
            if part == 3 then press(380, 725) end
            if part == 4 then press(380, 825) end
            if part == 5 then press(380, 925) end
            if part == 6 then press(380, 1025) end
        else
            local section = math.random(1, 3)
            if section == 1 then 
            elseif section == 2 then 
                swipe(360, 1120, 370, 990) sleep(2)
            elseif section == 3 then 
                swipe(360, 1120, 370, 990) sleep(1)
                swipe(360, 1120, 370, 990) sleep(2)
            end 

            local part = math.random(1, 4)
            if part == 1 then press(380, 800) end
            if part == 2 then press(380, 900) end
            if part == 3 then press(380, 1000) end
            if part == 4 then press(380, 1100) end
        end 

        sleep(1)
    end 
end

function onOffAirplaneGmail()
    ::label_startreset::

    toast('onOffAirplaneGmail')
    swipeCloseApp()
    appRun("com.apple.Preferences")
    sleep(2)

    if waitImageVisible(airplane_icon) then 
        if waitImageVisible(airplane_on) then 
            findAndClickByImage(airplane_off) sleep(1)
        elseif waitImageVisible(airplane_off) then 
            findAndClickByImage(airplane_off) sleep(1)
            findAndClickByImage(airplane_on) sleep(1)
        end 
    else 
        goto label_startreset
    end
end

function resetSafariData()
    ::label_startreset::

    toast('resetSafariData')
    swipeCloseApp()
    appRun("com.apple.Preferences")
    sleep(3)

    if waitImageVisible(airplane_icon) then 
        toast('airplane_icon')
        if waitImageVisible(airplane_off) then findAndClickByImage(airplane_off) sleep(1) end 
    else 
        goto label_startreset
    end

    swipe(600, 1200, 610, 900) sleep(1)
    swipe(600, 1200, 610, 680) sleep(3)
    if waitImageVisible(safari_icon, 3) then
        toast('safari_icon')
        findAndClickByImage(safari_icon) 
        sleep(2)
        swipe(600, 1200, 610, 640)
        sleep(3)
    else 
        goto label_startreset
    end 

    if not waitImageVisible(xoa_lich_su_du_lieu, 3) or not waitImageVisible(an_dia_chi_ip, 3) then goto label_startreset end 
    -- if waitImageVisible(xoa_lich_su_du_lieu, 3) then 
    --     toast('xoa_lich_su_du_lieu 1')
    --     findAndClickByImage(xoa_lich_su_du_lieu) sleep(2)
    --     press(390, 1130) sleep(1) -- xoa du lieu
    --     press(390, 1130) sleep(1) -- dong cac tab
    -- end 
    -- if waitImageVisible(an_dia_chi_ip, 3) then 
    --     toast('an_dia_chi_ip 1')
    --     findAndClickByImage(an_dia_chi_ip) sleep(2)
    --     press(500, 350) sleep(1) -- tat 
    --     press(500, 250) sleep(1) -- tu trinh theo doi
    --     press(90, 90) sleep(1) -- back
    -- end
    if waitImageVisible(xoa_lich_su_du_lieu, 3) then 
        toast('xoa_lich_su_du_lieu 2')
        findAndClickByImage(xoa_lich_su_du_lieu) sleep(2)
        press(390, 1130) sleep(1) -- xoa du lieu
        press(390, 1130) sleep(1) -- dong cac tab
    end 
    if waitImageVisible(an_dia_chi_ip, 3) then 
        toast('an_dia_chi_ip 2')
        findAndClickByImage(an_dia_chi_ip) sleep(2)
        press(500, 350) sleep(1) -- tat 
        press(500, 250) sleep(1) -- tu trinh theo doi
        press(90, 90) sleep(1) -- back

        press(90, 90) sleep(1) -- back to setting
        swipe(600, 650, 610, 1200) sleep(1)
        swipe(600, 900, 610, 1200) sleep(3)
    end
    if waitImageVisible(airplane_icon) then
        toast('airplane_icon')
        if waitImageVisible(airplane_on) then findAndClickByImage(airplane_on) sleep(1) end
    end 

    sleep(1)
end 


function saveGmailToGoogleSheet(code)
    if not code then code = "OK" end
    info.gmail_checkpoint = code

    local typeReg = '-'
    if TSPROXY_ID and TSPROXY_ID > 35 then typeReg = 'FPT' elseif TSPROXY_ID and (TSPROXY_ID > 0 and TSPROXY_ID < 36) then typeReg = 'Viettel' else typeReg = '-' end
    if IP_ROTATE_MODE == 2 then typeReg = 'Sim' end 
    if IP_ROTATE_MODE == 4 then typeReg = 'Text' end 

    local localIP = readFile(localIPFilePath)
    info.localIP = localIP[#localIP] .. " | " .. typeReg

    local tries = 3
    for i = 1, tries do 
        local response, error = httpRequest {
            url = PHP_SERVER .. "gmail_account_google_form.php",
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json",
            },
            data = info
        }

        if response then
            return true
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request gmail_account_google_form. Times ".. i ..  " - " .. tostring(error))
        end
        sleep(3)
    end
end
