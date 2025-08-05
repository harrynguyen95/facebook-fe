-- ====== LIB REQUIRED ======
require(rootDir() .. "/Facebook/utils")
require(rootDir() .. "/Facebook/functions")
require(rootDir() .. "/Facebook/images_vn")
require(rootDir() .. "/Facebook/images_google")
clearAlert()

-- ====== INFO ======
info = {
    gmail_status = nil,
    gmail_firstname = nil,
    gmail_lastname = nil,
    gmail_address = nil,
    gmail_password = nil,
    ipRegister = nil,
}

-- ====== CONFIG ======
GMAIL_REGISTER = true 
IP_ROTATE_MODE = 2

if not waitForInternet(2) then alert("No Internet. RESPRING NOW!") exit() end
-- if not getConfigServer() then alert("No config from server!") exit() end

function mainGmail()
    goto debug
    ::debug::

    if IP_ROTATE_MODE == 2 then offWifi() swipeCloseApp() end

    ::label_continue::
    resetInfoObject()
    log('------------ Gmail Main running ------------')

    homeAndUnlockScreen()
    if IP_ROTATE_MODE == 2 then 
        resetGmailSetting()
    else
        alert('Mode not support in Gmail.') exit()
    end

    if not waitForInternet(1) then 
        toast("No Internet 3", 5)
        if IP_ROTATE_MODE == 2 then onOffAirplane() sleep(2) waitForInternet(1) end
    end 

    appRun("com.google.Gmail")
    sleep(3)

    if waitImageVisible(tim_trong_thu) then 
        press(660, 110) sleep(1) -- icon logo user
        swipe(600, 1200, 610, 1000) 
        swipe(600, 1200, 610, 1000)
        sleep(3)
        if waitImageVisible(them_tai_khoan_khac) then 
            findAndClickByImage(them_tai_khoan_khac)
            if waitImageVisible(page_them_tai_khoan) then 
                press(150, 450) sleep(2) -- google add
                press(500, 790) sleep(1) -- tiep tuc btn
            end 
        end 
    end 

    if waitImageVisible(safari_google_url) then
        sleep(3)
    else
        alert('Can not open Safari.') exit()
    end

    if waitImageVisible(dang_nhap, 10) then
        toast('dang_nhap')
        if waitImageVisible(tao_tai_khoan) then 
            findAndClickByImage(tao_tai_khoan)
            if waitImageVisible(danh_cho_ca_nhan) then findAndClickByImage(danh_cho_ca_nhan) end
        else 
            press(140, 1050) -- btn tao tai khoan
            if waitImageVisible(danh_cho_ca_nhan) then findAndClickByImage(danh_cho_ca_nhan) end
        end
    end 

    if waitImageVisible(nhap_ten_cua_ban) then 
        toast('nhap_ten_cua_ban')
        info.gmail_firstname = getRandomLineInFile(rootDir() .. "/Facebook/input/firstname_google.txt")
        info.gmail_lastname = getRandomLineInFile(rootDir() .. "/Facebook/input/lastname_google.txt")
        sleep(1)
        findAndClickByImage(first_name_input) sleep(1)
        typeText(info.gmail_firstname) sleep(1)
        findAndClickByImage(last_name_input) sleep(1)
        typeText(info.gmail_lastname) sleep(2)
        findAndClickByImage(tiep_theo)
        waitImageNotVisible(nhap_ten_cua_ban)
    end 

    if waitImageVisible(nhap_ngay_sinh) then 
        toast('nhap_ngay_sinh')

        press(110, 680) sleep(1)
        typeText(math.random(1, 28)) sleep(1)
        findAndClickByImage(xong) sleep(1)

        press(350, 680) sleep(1)
        if waitImageVisible(thang_4) then 
            local section = math.random(1, 3)
            if section == 1 then 
                local part = math.random(1, 4)
                if part == 1 then press(380, 800) end
                if part == 2 then press(380, 900) end
                if part == 3 then press(380, 1000) end
                if part == 4 then press(380, 1100) end
            elseif section == 2 then 
                swipe(360, 1120, 370, 790) sleep(2)
                local part = math.random(1, 4)
                if part == 1 then press(380, 800) end
                if part == 2 then press(380, 900) end
                if part == 3 then press(380, 1000) end
                if part == 4 then press(380, 1100) end
            elseif section == 3 then 
                swipe(360, 1120, 370, 790) sleep(1)
                swipe(360, 1120, 370, 790) sleep(2)
                local part = math.random(1, 4)
                if part == 1 then press(380, 800) end
                if part == 2 then press(380, 900) end
                if part == 3 then press(380, 1000) end
                if part == 4 then press(380, 1100) end
            end 
            sleep(1)
        end 
        
        press(580, 680) sleep(1)
        typeText(math.random(1998, 2002)) sleep(1)
        findAndClickByImage(xong) sleep(1)

        if waitImageVisible(gioi_tinh_input, 2) then
            findAndClickByImage(gioi_tinh_input) sleep(1)
            local part = math.random(1, 2)
            if part == 1 then press(200, 420) end
            if part == 2 then press(220, 510) end
            sleep(1)
        end 

        findAndClickByImage(tiep_theo)
    end 

    toast('wait cach_ban_dang_nhap..')
    if waitImageVisible(cach_ban_dang_nhap) then
        toast('cach_ban_dang_nhap')
        local addressPrefix = randomGmailPrefix()
        info.gmail_address = addressPrefix .. "@gmail.com"

        press(220, 720) sleep(1)
        typeText(addressPrefix) sleep(1)
        findAndClickByImage(tiep_theo)
    end

    if waitImageVisible(chon_dia_chi_email) then 
        toast('chon_dia_chi_email')
        local addressPrefix = randomGmailPrefix()
        info.gmail_address = addressPrefix .. "@gmail.com"

        swipe(550, 1000, 550, 700) sleep(2)
        findAndClickByImage(tao_dia_chi_gmail_rieng) sleep(2)
        typeText(addressPrefix) sleep(1)
        findAndClickByImage(tiep_theo)
    end 

    if waitImageVisible(tao_mot_mat_khau) then 
        toast('tao_mot_mat_khau')
        info.gmail_password = getRandomLineInFile(defaultPasswordFilePath)

        press(190, 800) sleep(1)
        typeText(info.gmail_password)
        findAndClickByImage(tiep_theo)
    end 

    if waitImageVisible(robot_confirm) then
        toastr('Robot')
        info.gmail_status = 'Robot'
        saveGmailToGoogleSheet('robot')
        goto label_continue
    end

    toast('Last line.')
    goto label_continue
end

mainGmail()
