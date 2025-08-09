-- ====== LIB REQUIRED ======
require(rootDir() .. "/Facebook/utils")
require(rootDir() .. "/Facebook/functions")
require(rootDir() .. "/Facebook/images/images_vn")
require(rootDir() .. "/Facebook/images/images_google")
clearAlert()

-- ====== INFO ======
info = {
    gmail_checkpoint = nil,
    gmail_firstname = nil,
    gmail_lastname = nil,
    gmail_address = nil,
    gmail_password = nil,
    ipRegister = nil,
}

-- ====== CONFIG ======
GMAIL_REGISTER = true 
IP_ROTATE_MODE = 2
REG_SOURCE = 3 -- 1|2|3 Gmail|Safari|gugo
u = math.random(1, 2)

function mainGmail()
    -- info.gmail_firstname = "Nguyen Thi"
    -- info.gmail_lastname = "Van"
    -- info.gmail_address = "nguyenthivan542567@gmail.com"
    -- info.gmail_password = "Supermoney12@"

    goto debug
    ::debug::

    offWifi()
    swipeCloseApp()

    ::label_continue::
    findAndClickByImage(accept)
    resetInfoObject()
    log('------------ Gmail Main running ------------')

    homeAndUnlockScreen()
    resetSafariData()

    if not waitForInternet(1) then 
        toast("No Internet 3", 5)
        swipeCloseApp()
        onOffAirplane() sleep(2) waitForInternet(1)
    end 

    if REG_SOURCE == 1 then 
        appRun("com.google.Gmail")
    elseif REG_SOURCE == 2 then
        appRun("com.apple.mobilesafari") sleep(2)
        openURL("https://accounts.google.com/signup")
        goto label_nhap_ten_cua_ban
    elseif REG_SOURCE == 3 then 
        appRun("com.beo.gugo")
    end
    sleep(3)
    findAndClickByImage(accept)

    if waitImageVisible(gmail_welcome) then
        sleep(1)
        press(380, 1220) sleep(1) -- btn dang nhap
        if waitImageVisible(page_them_tai_khoan, 2) then goto label_page_them_tai_khoan end

        if waitImageVisible(quan_ly_tai_khoan) then
            if waitImageVisible(them_tai_khoan_khac, 2) then goto label_them_tai_khoan_khac end
            swipe(600, 1200, 610, 900) sleep(u)
            swipe(600, 1000, 610, 500) sleep(1)
        end 
    end 

    if waitImageVisible(tim_trong_thu, 2) then 
        press(660, 110) sleep(1) -- icon logo user
        swipe(600, 1200, 610, 1000) sleep(1)
        swipe(600, 1200, 610, 1000) sleep(1)
    end 

    ::label_them_tai_khoan_khac::
    if waitImageVisible(them_tai_khoan_khac) then 
        findAndClickByImage(them_tai_khoan_khac)
    end 

    ::label_page_them_tai_khoan::
    if waitImageVisible(page_them_tai_khoan) then
        toast('page_them_tai_khoan')
        sleep(u)
        findAndClickByImage(google_option) sleep(u)
        if waitImageVisible(tiep_tuc) then findAndClickByImage(tiep_tuc) end
        waitImageNotVisible(page_them_tai_khoan)
    end 

    if waitImageVisible(dang_nhap, 10) then
        toast('dang_nhap')
        if waitImageVisible(tao_tai_khoan) then 
            findAndClickByImage(tao_tai_khoan) sleep(u)
            if waitImageVisible(danh_cho_ca_nhan) then findAndClickByImage(danh_cho_ca_nhan) end
        else 
            press(140, 1050) sleep(u) -- btn tao tai khoan
            if waitImageVisible(danh_cho_ca_nhan) then findAndClickByImage(danh_cho_ca_nhan) end
        end
    end 

    ::label_nhap_ten_cua_ban::
    if waitImageVisible(nhap_ten_cua_ban) then 
        toast('nhap_ten_cua_ban')
        info.gmail_firstname = getRandomLineInFile(rootDir() .. "/Facebook/input/firstname_google.txt")
        info.gmail_lastname = getRandomLineInFile(rootDir() .. "/Facebook/input/lastname_google.txt")
        sleep(1)
        findAndClickByImage(first_name_input) sleep(1)
        typeText(info.gmail_firstname) sleep(u)
        findAndClickByImage(last_name_input) sleep(1)
        typeText(info.gmail_lastname) sleep(u)
        findAndClickByImage(tiep_theo)
        waitImageNotVisible(nhap_ten_cua_ban)
    end 

    ::label_nhap_ngay_sinh::
    if waitImageVisible(nhap_ngay_sinh) then 
        toast('nhap_ngay_sinh')

        if waitImageVisible(ngay_input) then 
            findAndClickByImage(ngay_input) sleep(u)
            typeText(math.random(1, 28)) sleep(1)
        end

        if waitImageVisible(thang_input) then
            findAndClickByImage(thang_input) sleep(u)
            selectThangSinhNhat()
        end

        if waitImageVisible(nam_input) then
            findAndClickByImage(nam_input) sleep(u)
            typeText(math.random(1998, 2002)) sleep(u)
        end

        if waitImageVisible(gioi_tinh_input) then
            findAndClickByImage(gioi_tinh_input) sleep(2)
            local part = math.random(1, 2)
            if part == 1 then findAndClickByImage(gioitinh_nu_option) end
            if part == 2 then findAndClickByImage(gioitinh_nam_option) end
            sleep(u)
        end 

        findAndClickByImage(nhap_ngay_sinh) sleep(1)
        findAndClickByImage(tiep_theo)
    end 

    toast('wait chon_dia_chi_email')
    ::label_chon_dia_chi_email::
    if waitImageVisible(chon_dia_chi_email) then 
        toast('chon_dia_chi_email')
        local addressPrefix = randomGmailPrefix()
        info.gmail_address = addressPrefix .. "@gmail.com"

        findAndClickByImage(tao_dia_chi_gmail_rieng) sleep(u)
        typeText(addressPrefix) sleep(u)

        findAndClickByImage(xong) sleep(1)
        findAndClickByImage(tiep_theo)
    else
        if waitImageVisible(cach_ban_dang_nhap) then
            toast('cach_ban_dang_nhap')
            local addressPrefix = randomGmailPrefix()
            info.gmail_address = addressPrefix .. "@gmail.com"

            if waitImageVisible(ten_nguoi_dung) then 
                findAndClickByImage(ten_nguoi_dung) sleep(u)
            else 
                press(150, 720) sleep(u)
            end 
            typeText(addressPrefix) sleep(u)

            findAndClickByImage(xong) sleep(1)
            findAndClickByImage(tiep_theo)
        end
    end

    ::label_tao_mot_mat_khau::
    if waitImageVisible(tao_mot_mat_khau) then 
        toast('tao_mot_mat_khau')
        -- info.gmail_password = getRandomLineInFile(defaultPasswordFilePath)
        info.gmail_password = 'Supermoney12@'
        if REG_SOURCE == 2 then findAndClickByImage(hien_mat_khau) sleep(1) end

        findAndClickByImage(mat_khau_input) sleep(1)
        typeText(info.gmail_password) sleep(u)

        if waitImageVisible(xac_nhan_input, 2) then
            toast('xac_nhan_input')
            findAndClickByImage(xac_nhan_input) sleep(1)
            typeText(info.gmail_password) sleep(u)
        end 

        findAndClickByImage(xong) sleep(1)
        findAndClickByImage(tiep_theo)
    end 

    ::label_them_mail_khoi_phuc::
    if waitImageVisible(them_mail_khoi_phuc, 3) then
        toastr('them_mail_khoi_phuc')
        sleep(u)
        findAndClickByImage(bo_qua)
    end 

    if waitImageVisible(robot_confirm, 3) then
        toastr('Robot')
        saveGmailToGoogleSheet('Robot')
        goto label_continue
    end

    if waitImageVisible(xem_lai_thong_tin) then
        toast('xem_lai_thong_tin')
        sleep(1)
        findAndClickByImage(tiep_theo)
    end 

    ::label_quyen_rieng_tu::
    if waitImageVisible(quyen_rieng_tu) then
        toast('quyen_rieng_tu')
        swipe(600, 900, 610, 600) sleep(1)
        swipe(600, 800, 610, 600) sleep(1)
        swipe(600, 850, 610, 620) sleep(2)
        if waitImageVisible(toi_dong_y) then 
            findAndClickByImage(toi_dong_y) sleep(1)

            if REG_SOURCE == 3 then 
                saveGmailToGoogleSheet()
                toast('+1 Gmail')
                goto label_continue
            elseif REG_SOURCE == 2 then 
                if waitImageVisible(xin_chao, 20) then 
                    saveGmailToGoogleSheet()
                    toast('+1 Gmail')
                    goto label_continue
                end 
            else 
                if waitImageVisible(page_them_tai_khoan, 20) then 
                    saveGmailToGoogleSheet()
                    toast('+1 Gmail')
                    goto label_continue
                end 
            end
        end 
    end 

    toast('Last line.')
    sleep(3)
    goto label_continue
end

mainGmail()
