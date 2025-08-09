math.randomseed(os.time() + math.random())


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
    if waitImageVisible(airplane_icon) then 
        if waitImageVisible(airplane_on_icon) then 
            findAndClickByImage(airplane_off_icon) sleep(1)
        elseif waitImageVisible(airplane_off_icon) then 
            findAndClickByImage(airplane_off_icon) sleep(1)
            findAndClickByImage(airplane_on_icon) sleep(1)
        end 
    end
end

function resetSafariData()
    ::label_startreset::
    toast('resetSafariData')

    swipeCloseApp()
    appRun("com.apple.Preferences")
    sleep(1)

    findAndClickByImage(accept)
    swipe(600, 1200, 610, 900) sleep(1)
    swipe(600, 1200, 610, 680) sleep(3)
    if waitImageVisible(safari_icon, 3) then
        findAndClickByImage(safari_icon) 
        sleep(2)
        swipe(600, 1200, 610, 640)
        sleep(3)
    else 
        goto label_startreset
    end 

    findAndClickByImage(accept)
    if not waitImageVisible(xoa_lich_su_du_lieu, 3) or not waitImageVisible(an_dia_chi_ip, 3) then goto label_startreset end 
    if waitImageVisible(xoa_lich_su_du_lieu, 3) then 
        toast('xoa_lich_su_du_lieu')
        findAndClickByImage(xoa_lich_su_du_lieu) sleep(2)
        press(390, 1130) sleep(1) -- xoa du lieu
        press(390, 1130) sleep(1) -- dong cac tab
    end 
    if waitImageVisible(an_dia_chi_ip, 3) then 
        toast('an_dia_chi_ip')
        findAndClickByImage(an_dia_chi_ip) sleep(2)
        press(500, 350) sleep(1) -- tat 
        press(500, 250) sleep(1) -- tu trinh theo doi
        press(90, 90) sleep(1) -- back

        press(90, 90) sleep(1) -- back to setting
        swipe(600, 650, 610, 1200) sleep(1)
        swipe(600, 700, 610, 1200) sleep(3)
    end

    if waitImageVisible(airplane_icon) then
        toast('airplane_icon')

        if isGreaterThan800() then 
            if waitImageVisible(airplane_off) then
                local off = findImage(airplane_off[#airplane_off], 1, threshold, nil, DEBUG_IMAGE, 1)
                if #off > 0 then 
                    local img = off[1]
                    local x = img[1] local y = img[2] -- 375, 689 -> 625, 689
                    press(x + 250, y) sleep(2) -- on air

                    if waitImageVisible(airplane_on) then
                        local off = findImage(airplane_on[#airplane_on], 1, threshold, nil, DEBUG_IMAGE, 1)
                        if #off > 0 then 
                            local img = off[1]
                            local x = img[1] local y = img[2]
                            press(x + 250, y) sleep(2) -- off air
                        end
                    end
                end 
            elseif waitImageVisible(airplane_on) then
                local off = findImage(airplane_on[#airplane_on], 1, threshold, nil, DEBUG_IMAGE, 1)
                if #off > 0 then 
                    local img = off[1]
                    local x = img[1] local y = img[2]
                    press(x + 250, y) sleep(2) -- off air
                end
            end
        else 
            if waitImageVisible(airplane_off_icon) then 
                findAndClickByImage(airplane_off_icon) sleep(1)
                findAndClickByImage(airplane_on_icon) sleep(2)
            elseif waitImageVisible(airplane_on_icon) then 
                findAndClickByImage(airplane_off_icon) sleep(2)
            end
        end
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
