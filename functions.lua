
-- ====== CONFIG ======
PHP_SERVER = "https://tuongtacthongminh.com/reg_clone/"
MAIL_THUEMAILS_DOMAIN = "https://api.thuemails.com/api/"
URL_2FA_FACEBOOK = "https://2fa.live/tok/"
MAIL_FREE_DOMAIN = "https://api.temp-mailfree.com/"
TSPROXY_URL = "https://api.tsproxy.com/api/v1/"
TSPROXY_DEVICE_ID = "67ed584a8d2d4cf26e49d5c5"
TSPROXY_API_KEY = "yB2y6yitJ0"

defaultPasswordFilePath = currentPath() .. "/input/password.txt"
accountFilePath = rootDir() .. "/Device/accounts.txt"
accountCodeFilePath = rootDir() .. "/Device/accounts_code.txt"
mailFilePath = rootDir() .. "/Device/thuemails.txt"
localIPFilePath = rootDir() .. "/Device/local_ip.txt"
hotmailSourceFilePath = rootDir() .. "/Device/hotmail_source.txt"

math.randomseed(os.time() + math.random())

-- ====== LOGIC FUNCTION ======
function initCurrentAccountCode()
    local accounts = readFile(accountFilePath)
    local code = readFile(accountCodeFilePath)
    if code == nil or code[#code] == nil or code[#code] == '' then
        alert('Empty UID and OTP')
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
            info.mailLogin = splittedCode[2]
            info.mailRegister = splittedCode[2]
            info.mailPrice = 'otp'
            info.password = splittedCode[3]
            info.hotmailPassword = splittedCode[4]
            info.hotmailRefreshToken = splittedCode[5]
            info.hotmailClientId = splittedCode[6]
            info.verifyCode = splittedCode[7]

            local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '')
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
        info.mailLogin = splittedCode[2]
        info.mailRegister = splittedCode[2]
        info.mailPrice = 'otp'
        info.password = splittedCode[3]
        info.hotmailPassword = splittedCode[4]
        info.hotmailRefreshToken = splittedCode[5]
        info.hotmailClientId = splittedCode[6]
        info.verifyCode = splittedCode[7]

        local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '')
        addLineToFile(accountFilePath, line)
    end
    return
end

function archiveCurrentAccount()
    local accounts = readFile(accountFilePath)
    local randomPass = getRandomLineInFile(defaultPasswordFilePath)

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
            info.thuemailId          = info.thuemailId or splitted[8]
            info.mailPrice           = info.mailPrice or splitted[9]
            info.hotmailRefreshToken = info.hotmailRefreshToken or splitted[10]
            info.hotmailClientId     = info.hotmailClientId or splitted[11]
            info.hotmailPassword     = info.hotmailPassword or splitted[12]
            info.verifyCode          = info.verifyCode or splitted[13]
            info.finishAddMail       = info.finishAddMail or splitted[14]
            info.ipRegister          = info.ipRegister or splitted[15]

            local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '') .. "|" .. info.finishAddMail .. "|" .. (info.ipRegister or '')
            accounts[#accounts] = line
            writeFile(accountFilePath, accounts)
        else
            if splitted[1] and splitted[1] ~= '' then info.uuid = floor(splitted[1] + 1) else info.uuid = 1 end
            info.status = 'INPROGRESS'
            info.password = randomPass
            local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '') .. "|" .. info.finishAddMail .. "|" .. (info.ipRegister or '')
            addLineToFile(accountFilePath, line)
        end 
    else 
        info.uuid = 1
        info.status = 'INPROGRESS'
        info.password = randomPass
        local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '') .. "|" .. info.finishAddMail .. "|" .. (info.ipRegister or '')
        addLineToFile(accountFilePath, line)
    end

    -- log(info, 'Archive')
end

function finishCurrentAccount()
    local accounts = readFile(accountFilePath)
    local splitted = split(accounts[#accounts], "|")

    info.status = "SUCCESS"
    info.checkpoint = 'OK'
    if not info.mailLogin or info.mailLogin == '' then info.mailLogin = info.mailRegister end 
    if not info.profileUid or info.profileUid == '' then info.profileUid = getUIDFBLogin() end 
    if not info.mailLogin or info.mailLogin == '' then return false end 

    local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '') .. "|" .. info.finishAddMail .. "|" .. (info.ipRegister or '')
    accounts[#accounts] = line

    log('finishCurrentAccount ' .. line)
    writeFile(accountFilePath, accounts)

    if HOTMAIL_SOURCE_FROM_FILE and info.mailLogin and info.mailLogin ~= '' then 
        removeLineFromFile(hotmailSourceFilePath, info.mailLogin)
    end 
    if LOGIN_WITH_CODE then 
        removeLineFromFile(accountCodeFilePath, info.profileUid)
    end 
    if ENTER_VERIFY_CODE then saveAccToGoogleForm() else saveNoVerifyToGoogleForm() end

    resetInfoObject()
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
    if not info.profileUid or info.profileUid == '' then info.profileUid = getUIDFBLogin() end 
    local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '') .. "|" .. info.finishAddMail .. "|" .. (info.ipRegister or '')
    accounts[#accounts] = line

    log(code .. ' - failedCurrentAccount ' .. line)
    writeFile(accountFilePath, accounts)

    if HOTMAIL_SOURCE_FROM_FILE and info.mailLogin and info.mailLogin ~= '' then 
        removeLineFromFile(hotmailSourceFilePath, info.mailLogin)
    end 
    if LOGIN_WITH_CODE then 
        removeLineFromFile(accountCodeFilePath, info.profileUid)
    end 
    saveAccToGoogleForm()

    resetInfoObject()
end

function saveAccToGoogleForm()
    -- if (info.checkpoint == 282 or info.checkpoint == '282') and (info.mailLogin == '' or info.mailLogin == nil) then return nil end

    local localIP = readFile(localIPFilePath)
    info.localIP = localIP[#localIP] .. " | " .. ACCOUNT_REGION .. " | " .. LANGUAGE .. " | " .. (LOGIN_WITH_CODE and 'otp' or (DUMMY_PHONE and 'phone' or (DUMMY_GMAIL and 'gmail' or (DUMMY_ICLOUD and 'icloud' or '-'))))

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
            -- log(info, "Sent request to Google Form" )
            return
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request acc_google_form. Times ".. i ..  " - " .. tostring(error))
        end
        sleep(3)
    end
end

function saveNoVerifyToGoogleForm()
    local localIP = readFile(localIPFilePath)
    info.localIP = localIP[#localIP] .. " | " .. ACCOUNT_REGION .. " | " .. LANGUAGE .. " | " .. (LOGIN_WITH_CODE and 'otp' or (DUMMY_PHONE and 'phone' or (DUMMY_GMAIL and 'gmail' or (DUMMY_ICLOUD and 'icloud' or '-'))))

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
            -- log(info, "Sent request to Google Form" )
            return
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request no_verify_google_form. Times ".. i ..  " - " .. tostring(error))
        end
        sleep(3)
    end
end

function saveMailToGoogleForm()
    local localIP = readFile(localIPFilePath)
    info.localIP = localIP[#localIP] .. " | " .. ACCOUNT_REGION .. " | " .. LANGUAGE .. " | " .. (LOGIN_WITH_CODE and 'otp' or (DUMMY_PHONE and 'phone' or (DUMMY_GMAIL and 'gmail' or (DUMMY_ICLOUD and 'icloud' or '-'))))

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
            -- log(info, "Sent request to Google Form" )
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
        thuemailId = nil,
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
        finishAddMail = 0,
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
        info.thuemailId          = 2000000

        return true
    end 
    return false
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
    if #mails < 4 then
        return
    end

    shuffle(mails)
    for i, v in ipairs(mails) do
        local splitted = split(v, "|")
        if floor(splitted[2]) <= THUE_LAI_MAIL_THUEMAILS then 
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

    if THUE_LAI_MAIL_THUEMAILS > 0 and mailRerent then
        rerentTime = floor(rerentTime + 1)
        -- log('Times mail rerent: ' .. rerentTime .. ' - ' .. mailRerent)

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
                        info.thuemailId = res.id
                        info.mailPrice = res.price
                        info.mailRegister = res.email

                        saveMailThueMail()
                        return true
                    else
                        toastr(response.message)
                        log(response.message)
                        if rerentTime <= rerentMaxTries then 
                            removeMailThueMail(mailRerent)
                            goto start_rerent_mail
                        end
                    end
                else 
                    toastr("Failed decode response.");
                    log("Failed decode response.");
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
                        info.thuemailId = res.id
                        info.mailPrice = res.price
                        info.mailRegister = res.email

                        if THUE_LAI_MAIL_THUEMAILS > 0 then saveMailThueMail() end
                        return true
                        
                    else
                        toastr(response.message)
                        log(response.message)
                    end
                else 
                    toastr("Failed decode response.");
                    log("Failed decode response.");
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
            -- log(response, 'executeHotmailFromDongVanFb')

            if response then
                local ok, response, err = safeJsonDecode(response)
                if ok then 
                    if response.status or response.status == 'true' then
                        local mailString = response.data.list_data[1]
                        local splitted = split(mailString, '|')

                        info.mailRegister = splitted[1]
                        info.mailPrice = response.data.price
                        info.thuemailId = 2000000
                        info.hotmailPassword = splitted[2]
                        info.hotmailRefreshToken = splitted[3]
                        info.hotmailClientId = splitted[4]

                        saveMailToGoogleForm()
                        return true
                    else
                        toastr(response.message)
                        log(response.message)
                    end
                else 
                    toastr("Failed decode response.");
                    log("Failed decode response.");
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

function executeDomainMail()
    local mail = randomMailDomain() 
    info.mailLogin = mail
    info.mailRegister = mail
    info.mailPrice = 'free'
    return true
end 

function executeGetMailRequest()
    if MAIL_SUPLY == 1 then 
        return executeHotmailFromDongVanFb()
    elseif MAIL_SUPLY == 2 then
        return executeGmailFromThueMail()
    elseif MAIL_SUPLY == 3 then
        return executeDomainMail()
    else 
        toastr('MAIL_SUPLY invalid.', 5)
        return false
    end
end

function getThuemailConfirmCode()
    if info.thuemailId == nil then return nil end
    
    sleep(10)
    local tries = 20
    for i = 1, tries do 
        toastr('Call times ' .. i)

        local response, error = httpRequest {
            url = MAIL_THUEMAILS_DOMAIN .. "rentals/" .. info.thuemailId .. "?api_key=" .. MAIL_THUEMAILS_API_KEY,
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
                toastr("Failed decode response.");
                log("Failed decode response.");
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

        -- log(response, 'getDongvanfbConfirmCode')

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.status or response.status == 'true' then
                    return response.code
                else
                    toastr('Empty code. Times ' .. i)
                end
            else 
                toastr("Failed decode response.");
                log("Failed decode response.");
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
        -- log(response, 'getMailDomainRegisterConfirmCode')
        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.code ~= '' then
                    return response.code
                else
                    toastr("Empty response code.");
                end
            else 
                toastr("Failed decode response.");
                log("Failed decode response.");
            end
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request mail_domain_register_confirm. Times ".. i ..  " - " .. tostring(error))
        end

        sleep(5)
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
        -- log(response, 'getMailDomainOwnerConfirmCode')
        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.code ~= '' then
                    return response.code
                else
                    toastr("Empty response code.");
                end
            else 
                toastr("Failed decode response.");
                log("Failed decode response.");
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
        -- log(response, 'getMailDomainAddConfirmCode')

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.code ~= '' then
                    return response.code
                else
                    toastr("Empty response code.");
                end
            else 
                toastr("Failed decode response.");
                log("Failed decode response.");
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
                    toastr("Empty response get 2FA OTP.");
                    log("Empty response get 2FA OTP.");
                end
            else 
                toastr("Failed decode response.");
                log("Failed decode response.");
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

    local searchTextFilePath = currentPath() .. "/input/searchtext_us.txt"
    if ACCOUNT_REGION == 'VN' then
        searchTextFilePath = currentPath() .. "/input/searchtext.txt"
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
                    THUE_LAI_MAIL_THUEMAILS  = tonumber(config.thue_lai_mail_thuemails)
                    ADD_MAIL_DOMAIN          = tonumber(config.add_mail_domain)
                    MAIL_DOMAIN_TYPE         = tonumber(config.mail_domain_type)
                    CHANGE_INFO              = tonumber(config.change_info) ~= 0
                    PROXY                    = config.proxy
                    IP_ROTATE_MODE           = tonumber(config.ip_rotate_mode)
                    MAIL_DONGVANFB_API_KEY   = config.api_key_dongvanfb
                    MAIL_THUEMAILS_API_KEY   = config.api_key_thuemails
                    LOCAL_SERVER             = config.local_server
                    DESTINATION_FILENAME     = config.destination_filename
                    LOGIN_WITH_CODE          = tonumber(config.login_with_code) ~= 0
                    DUMMY_MODE               = tonumber(config.reg_phone_first)
                    TSPROXY_ID               = tonumber(config.tsproxy_id)

                    return true
                else
                    toastr(response.info)
                    log(response.info)
                end
            else 
                toastr("Failed decode response.");
                log("Failed decode response.");
            end  
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request device_config. Times ".. i ..  " - " .. tostring(error))
        end
        sleep(3)
    end
    return false
end

function reloadTsproxy()
    if (not TSPROXY_ID or TSPROXY_ID == '') then alert('Empty TSPROXY_ID') exit() end 
    toast('reloadTsproxy', 20)

    local tries = 1
    for i = 1, tries do 
        local response, error = httpRequest {
            url = TSPROXY_URL .. "public/reload/".. TSPROXY_DEVICE_ID .."/" .. TSPROXY_ID,
            headers = {
                ["Content-Type"] = "application/json",
                ["x-api-key"] = TSPROXY_API_KEY,
            },
            timeout = 20
        }
        -- log(response, 'reloadTsproxy')
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
                    log(response.message)
                end
            else 
                toastr("Failed decode response.");
                log("Failed decode response.");
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

    toast('waitforTsproxyReady', 10)
    for i = 1, timeout, 1 do
        local response, error = httpRequest {
            url = TSPROXY_URL .. "public/proxy-list/".. TSPROXY_DEVICE_ID,
            headers = {
                ["Content-Type"] = "application/json",
                ["x-api-key"] = TSPROXY_API_KEY,
            },
            timeout = 10
        }
        -- log(response, 'checkActiveTsproxy')

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
                        sleep(1)
                        return true
                    end
                else
                    toastr(response.message)
                end
            else 
                toastr("Failed decode response.");
            end  
        else
            toastr('Times ' .. i .. "... ")
        end
       
        sleep(5)
    end
    return false
end

-- ====== FE FUNCTION ======
function removeAccount()
    sleep(2)
    if waitImageVisible(create_new_account) then
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

        -- press(680, 90) -- help text
        -- if waitImageVisible(logout_suspend_icon, 10) then
        --     findAndClickByImage(logout_suspend_icon)
        --     press(520, 840) sleep(1) --logout text

        --     if waitImageVisible(logout_btn) then
        --         findAndClickByImage(logout_btn)
        --         sleep(3)

        --         removeAccount()
        --     end
        -- end
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
        local firstname = getRandomLineInFile(currentPath() .. "/input/firstname.txt")
        local lastname = getRandomLineInFile(currentPath() .. "/input/lastname.txt")
        return { firstname, lastname }

    end
    if ACCOUNT_REGION == 'US' then 
        local firstname = getRandomLineInFile(currentPath() .. "/input/firstname_us.txt")
        local lastname = getRandomLineInFile(currentPath() .. "/input/lastname_us.txt")
        return { firstname, lastname }
    end
end

function getRandomCity()
    return getRandomLineInFile(currentPath() .. "/input/vn_city.txt")
end

function getRandomHighSchool()
    return getRandomLineInFile(currentPath() .. "/input/vn_highschool.txt")
end

function getRandomUniversity()
    return getRandomLineInFile(currentPath() .. "/input/vn_university.txt")
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

    local dirPath = currentDir() .. "/Remote/images/"
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

    local dirPath = currentDir() .. "/Remote/images/"
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

    local f = io.open(save_path, "wb")
    if not f then
        print("❌ Không thể mở file để ghi: " .. save_path)
        return
    end

    curl.easy{
        url = url,
        writefunction = function(buffer)
            f:write(buffer)
            return #buffer
        end
    }:perform()

    f:close()

    saveToSystemAlbum(save_path);
    sleep(5)
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
