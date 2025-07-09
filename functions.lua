
-- ====== CONFIG ======
PHP_SERVER = "https://tuongtacthongminh.com/"
MAIL_THUEMAILS_API_KEY = "94a3a21c-40b5-4c48-a690-f1584c390e3e"
MAIL_THUEMAILS_DOMAIN = "https://api.thuemails.com/api/"
MAIL_DONGVANFB_API_KEY = "iFI7ppA8JNDJ52yVedbPlMpSh"
URL_2FA_FACEBOOK = "https://2fa.live/tok/"
MAIL_FREE_DOMAIN = "https://api.temp-mailfree.com/"

defaultPasswordFilePath = currentPath() .. "/input/password.txt"
searchTextFilePath = currentPath() .. "/input/searchtext.txt"
accountFilePath = rootDir() .. "/Device/accounts.txt"
mailFilePath = rootDir() .. "/Device/thuemails.txt"
localIPFilePath = rootDir() .. "/Device/local_ip.txt"
hotmailSourceFilePath = rootDir() .. "/Device/hotmail_source.txt"

-- ====== LOGIC FUNCTION ======

function archiveCurrentAccount()
    local accounts = readFile(accountFilePath)
    
    info.uuid = 1
    info.password = getRandomLineInFile(defaultPasswordFilePath)

    if #accounts > 0 then
        local current = accounts[#accounts]
        local splitted = split(current, "|")
        if splitted[2] == 'INPROGRESS' then
            info.uuid         = splitted[1]
            info.status       = info.status or splitted[2]
            info.mailLogin    = info.mailLogin or splitted[3]
            info.password     = splitted[4] or info.password
            info.profileUid   = info.profileUid or splitted[5]
            info.twoFA        = info.twoFA or splitted[6]
            info.mailRegister        = info.mailRegister or splitted[7]
            info.thuemailId          = info.thuemailId or splitted[8]
            info.mailPrice           = info.mailPrice or splitted[9]
            info.hotmailRefreshToken = info.hotmailRefreshToken or splitted[10]
            info.hotmailClientId     = info.hotmailClientId or splitted[11]
            info.hotmailPassword     = info.hotmailPassword or splitted[12]
            info.verifyCode          = info.verifyCode or splitted[13]

            local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '')
            accounts[#accounts] = line
            writeFile(accountFilePath, accounts)
        else
            info.uuid = floor(splitted[1] + 1)
            info.status = 'INPROGRESS'
            if ADD_MAIL_DOMAIN then info.mailLogin = randomEmailLogin() end 
            local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '')
            addLineToFile(accountFilePath, line)
        end 
    else 
        info.uuid = 1
        info.status = 'INPROGRESS'
        if ADD_MAIL_DOMAIN then info.mailLogin = randomEmailLogin() end 
        local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '')
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
    local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '')
    accounts[#accounts] = line

    log('finishCurrentAccount ' .. line)
    writeFile(accountFilePath, accounts)

    if HOTMAIL_SOURCE_FROM_FILE then 
        removeLineFromFile(hotmailSourceFilePath, info.mailLogin)
    end 
    if ENTER_VERIFY_CODE then saveAccToGoogleForm() else saveNoVerifyToGoogleForm() end

    resetInfoObject()
end

function failedCurrentAccount(code)
    if code == nil then code = 'unknown' end
    local accounts = readFile(accountFilePath)
    local splitted = split(accounts[#accounts], "|")

    info.status = "FAILED"
    info.checkpoint = code
    if not info.mailLogin or info.mailLogin == '' then info.mailLogin = info.mailRegister end 
    if not info.profileUid or info.profileUid == '' then info.profileUid = getUIDFBLogin() end 
    local line = (info.uuid or '') .. "|" .. (info.status or '') .. "|" .. (info.mailLogin or '') .. "|" .. (info.password or '') .. "|" .. (info.profileUid or '') .. "|" .. (info.twoFA or '') .. "|" .. (info.mailRegister or '') .. "|" .. (info.thuemailId or '') .. "|" .. (info.mailPrice or '') .. "|" .. (info.hotmailRefreshToken or '') .. "|" .. (info.hotmailClientId or '') .. "|" .. (info.hotmailPassword or '') .. "|" .. (info.verifyCode or '')
    accounts[#accounts] = line

    log(code .. ' - failedCurrentAccount ' .. line)
    writeFile(accountFilePath, accounts)

    if HOTMAIL_SOURCE_FROM_FILE then 
        removeLineFromFile(hotmailSourceFilePath, info.mailLogin)
    end 
    saveAccToGoogleForm()

    resetInfoObject()
end

function saveAccToGoogleForm()
    local localIP = readFile(localIPFilePath)
    info.localIP = localIP[#localIP]

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
    info.localIP = localIP[#localIP]

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
    if not HOTMAIL_SOURCE_FROM_FILE then
        local localIP = readFile(localIPFilePath)
        info.localIP = localIP[#localIP]

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
    }
    sleep(1)
end

function retrieveHotmailFromSource()
    local hotmailData = getRandomLineInFile(hotmailSourceFilePath)
    local splitted = split(hotmailData, "|")

    if #splitted >= 4 then 
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
    if #mails < 5 then
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
                        return 'success'
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
        local tries = 3
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

                        info.thuemailId = res.id
                        info.mailPrice = res.price
                        info.mailRegister = res.email

                        saveMailThueMail()
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

            sleep(3)
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

                        info.mailLogin = splitted[1]
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
            return callRegisterHotmailFromDongVanFb()
        end
    else 
        return callRegisterHotmailFromDongVanFb()
    end
    return false
end

function executeDomainMail()
    local mail = randomEmailLogin() 
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
    sleep(5)
    local tries = 10
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

        sleep(5)
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

        sleep(5)
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

function getConfigServer()
    -- Máy 3 | Hiến | 192.168.1.63
    local localIP = readFile(localIPFilePath)
    local localName = localIP[#localIP]

    if localName == nil then 
        toastr('No local device name.', 2)
        return false
    end 
    local splitted = split(localName, "|")

    local postData = {
        ['action']   = 'select',
        ['username'] = string.gsub(splitted[2], " ", ""),
        ['device']   = string.gsub(splitted[3], " ", ""),
    }

    local tries = 2
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
                    HOTMAIL_SERVICE_IDS      = parseStringToTable(config.hotmail_service_ids)
                    MAIL_SUPLY               = tonumber(config.mail_suply)
                    PROVIDER_MAIL_THUEMAILS  = tonumber(config.provider_mail_thuemails)
                    TIMES_XOA_INFO           = tonumber(config.times_xoa_info)
                    ENTER_VERIFY_CODE        = config.enter_verify_code ~= '0'
                    HOTMAIL_SOURCE_FROM_FILE = config.hot_mail_source_from_file ~= '0'
                    THUE_LAI_MAIL_THUEMAILS  = config.thue_lai_mail_thuemails ~= '0'
                    ADD_MAIL_DOMAIN          = config.add_mail_domain ~= '0'
                    REMOVE_REGISTER_MAIL     = config.remove_register_mail ~= '0'
                    PROXY                    = config.proxy

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

-- ====== FE FUNCTION ======
function removeAccount()
    sleep(2)
    if  waitImageVisible(create_new_account) or waitImageVisible(avatar_picture) then
        press(695, 90) sleep(5) -- three dots icon
        press(300, 1250) sleep(4) -- remove profiles from this device
        press(600, 330) sleep(5) -- btn remove gray
        press(400, 1150) sleep(1) -- btn remove blue confirm

        if waitImageVisible(avatar_picture) or waitImageVisible(create_new_account) then 
            swipeCloseApp() sleep(1)
        end
    end
end

function checkSuspended()
    if waitImageVisible(confirm_human, 1) then
        toastr('Die')

        failedCurrentAccount(282)

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
    end
end

function setGender()
    if waitImageVisible(what_is_gender, 2) then
        toastr("what_is_gender")

        if waitImageVisible(gender_options, 10) then 
            math.randomseed(os.time() + math.random())
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
            math.randomseed(os.time() + math.random())
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
    -- pressHome()
    -- if waitImageVisible(fb_logo_2) then
    --     findAndClickByImage(fb_logo_2)
    --     waitImageNotVisible(fb_logo_2)
    -- else
    --     toastr('Not found Icon facebook', 3)
    -- end
    -- sleep(1)
end

function homeAndUnlockScreen()
    toastr("Check Unlock Screen")

    local alertOK = {rootDir() .. "/Facebook/Remote/images/" .. "alert_ok.png"}
    if waitImageVisible(alertOK, 1) then findAndClickByImage(alertOK) end

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
                        pressHome()
                    end
                end
            end
        end
    else
        onOffAirplaneMode()
    end
    sleep(1)
end

function checkModeMenuLeft()
    return waitImageVisible(fb_logo_menu_left, 1)
end

-- function changeMailDomain()
--     ::label_addmail::
--     if ADD_MAIL_DOMAIN then
--         if waitImageVisible(what_on_your_mind) then 
--             toastr('Add mail what_on_your_mind')

--             press(690, 1290) -- go to menu

--             press(690, 1290) -- go to menu

--             if waitImageVisible(setting_menu, 8) then
--                 toastr('setting_menu')
--                 press(600, 90) -- setting cog icon
--                 waitImageNotVisible(setting_menu)
--             end

--             if waitImageVisible(setting_privacy, 12) then
--                 toastr('setting_privacy')
--                 if waitImageVisible(see_more_account_center, 10) then
--                     findAndClickByImage(see_more_account_center)
--                     waitImageNotVisible(see_more_account_center)
--                 end
--             end

--             if waitImageVisible(account_center, 12) then
--                 toastr('account_center')
--                 sleep(1)
--                 swipe(600, 800, 610, 650) sleep(1)

--                 if waitImageVisible(personal_details_btn) then
--                     findAndClickByImage(personal_details_btn)
--                 else
--                     if waitImageVisible(your_information_and_permission) then
--                         findAndClickByImage(your_information_and_permission)
--                     end
--                 end
--             end

--             if waitImageVisible(personal_details_page, 12) or waitImageVisible(your_information_and_per_btn, 12) then
--                 toastr('personal_details_page')
--                 press(630, 550) -- Contact info btn

--                 if waitImageVisible(contact_information) then
--                     press(370, 1260) -- Add new contact btn
--                 end
                
--                 if waitImageVisible(add_mail) then
--                     toastr('add_mail')
--                     sleep(1)
--                     findAndClickByImage(add_mail)
--                 else 
--                     toastr('add_mail else')
--                     press(130, 730) sleep(2) -- add mail options
--                 end

--                 if waitImageVisible(add_a_phone_number, 2) then
--                     toastr('add_a_phone_number')
--                     press(380, 1260) -- add email instead
--                 end
--             end

--             if waitImageVisible(add_email_address) then
--                 toastr('add_email_address')

--                 press(110, 560) -- Input new mail address
--                 typeText(info.mailLogin) sleep(0.5)
--                 press(700, 1280) -- enter done typing
--                 findAndClickByImage(next)

--                 if waitImageVisible(email_used_added) then
--                     press(55, 155) -- X icon
--                     press(45, 155) -- back
--                     press(45, 155) -- back
--                     press(55, 155) -- X icon
--                     press(45, 90) -- back
--                     press(60, 1290) -- back to homepage
--                 else 
--                     if waitImageVisible(enter_confirm_code, 10) then
--                         toastr('enter_confirm_code')
--                         local code = getMailDomainAddConfirmCode()
--                         toastr('CODE: ' .. (code or '-'), 2)
--                         if code then
--                             press(130, 500) -- input code
--                             press(660, 475) -- X icon
--                             typeText(code) sleep(0.5)
--                             press(530, 630) -- click to outside

--                             press(380, 1260) -- next btn
--                             waitImageNotVisible(enter_confirm_code)

--                             if waitImageVisible(added_email, 8) then 
--                                 press(380, 1260) -- close btn
--                             end

--                             if waitImageVisible(contact_information) then
--                                 if REMOVE_REGISTER_MAIL then
--                                     press(650, 600) -- mail register
--                                     if waitImageVisible(delete_mail) then
--                                         findAndClickByImage(delete_mail)
--                                         sleep(1)
--                                         press(240, 850)

--                                         if waitImageVisible(check_your_email, 3) then
--                                             toastr('check_your_email')
--                                             local code = getMailDomainOwnerConfirmCode()
--                                             toastr('CODE: ' .. (code or '-'), 2)

--                                             if code and code ~= '' then
--                                                 press(100, 850) -- code input
--                                                 typeText(code) sleep(1)
--                                                 if waitImageVisible(continue_code_mail) then
--                                                     findAndClickByImage(continue_code_mail)

--                                                     waitImageNotVisible(check_your_email)
--                                                 end
--                                             else 
--                                                 goto get2FA
--                                             end
--                                         end

--                                         if waitImageVisible(deleted_previous_mail, 8) then
--                                             press(380, 1260) -- close btn
--                                             if waitImageVisible(contact_information) then
--                                                 press(50, 155) -- back
--                                                 if waitImageVisible(personal_details_page) then
--                                                     press(50, 155) -- back
--                                                     press(55, 155) -- back

--                                                     press(45, 90) -- back to setting menu
--                                                     press(60, 1290) -- back to homepage
--                                                 end
--                                             end
--                                         end
--                                     end
--                                 else 
--                                     press(50, 155) -- back
--                                     if waitImageVisible(personal_details_page) then
--                                         press(50, 155) -- back
--                                         press(55, 155) -- back

--                                         press(45, 90) -- back to setting menu
--                                         press(60, 1290) -- back to homepage
--                                     end
--                                 end
--                             end
--                         else 
--                             info.mailLogin = info.mailRegister -- set mail register is mail login
--                         end
--                     end
--                 end
--             end
--         end
--     end
-- end
