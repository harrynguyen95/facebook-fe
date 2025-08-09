require('functions')

dong_cac_tab = {currentPath() .. "/images/dong_cac_tab.png"}
mui_gio = {currentPath() .. "/images/mui_gio.png"}
xoa_lich_su_va_du_lieu = {currentPath() .. "/images/xoa_lich_su_va_du_lieu.png"}

tiep_tuc = {currentPath() .. "/images/tiep_tuc.png", currentPath() .. "/images/tiep_tuc2.png"}
tao_tai_khoan = {currentPath() .. "/images/tao_tai_khoan.png"}
email_hoac_so_dien_thoai = {currentPath() .. "/images/email_hoac_so_dien_thoai.png"}
tiep_theo = {currentPath() .. "/images/tiep_theo.png"}
danh_cho_muc_dich_ca_nhan_cua_toi = {currentPath() .. "/images/danh_cho_muc_dich_ca_nhan_cua_toi.png"}
ho = {currentPath() .. "/images/ho.png"}
ten = {currentPath() .. "/images/ten.png"}
nhap_ngay_sinh_va_gioi_tinh = {currentPath() .. "/images/nhap_ngay_sinh_va_gioi_tinh.png"}
ngay = {currentPath() .. "/images/ngay.png"}
nam = {currentPath() .. "/images/nam.png"}
gioi_tinh = {currentPath() .. "/images/gioi_tinh.png"}
thang = {currentPath() .. "/images/thang.png"}
gt_nam = {currentPath() .. "/images/gt_nam.png"}
tao_dia_chi_gmail_cua_rieng_ban = {currentPath() .. "/images/tao_dia_chi_gmail_cua_rieng_ban.png"}
tao_mot_dia_chi_gmail = {currentPath() .. "/images/tao_mot_dia_chi_gmail.png"}
tao_mot_mat_khau = {currentPath() .. "/images/tao_mot_mat_khau.png"}
mat_khau = {currentPath() .. "/images/mat_khau.png"}
robot = {currentPath() .. "/images/robot.png"}
ten_nguoi_dung = {currentPath() .. "/images/ten_nguoi_dung.png"}
xem_lai_thong_tin_tai_khoan = {currentPath() .. "/images/xem_lai_thong_tin_tai_khoan.png"}
quyen_rieng_tu = {currentPath() .. "/images/quyen_rieng_tu.png"}
toi_dong_y = {currentPath() .. "/images/toi_dong_y.png"}
icon_user = {currentPath() .. "/images/icon_user.png"}
dang_nhap = {currentPath() .. "/images/dang_nhap.png"}
airplan = {currentPath() .. "/images/airplan.png"}
is_on = {currentPath() .. "/images/is_on.png"}
is_off = {currentPath() .. "/images/is_off.png"}
gmailcom = {currentPath() .. "/safari/gmail.com.png"}
google_map_giao_dien_moi = {currentPath() .. "/images/google_map_giao_dien_moi.png"}











-- local packages = {"com.google.Maps", "com.google.Gmail", "com.google.GoogleMobile", "com.google.FamilyLink",
--                   "com.google.Docs", "com.google.Translate", "com.google.GoogleDigitalEditions", "com.google.Sheets",
--                   "com.google.Classroom", "com.google.calendar", "com.google.Dynamite", "com.google.fit",
--                   "com.google.photos"}

local packages = {"com.google.Maps"}

local total = 0
local success = 0
local faild = 0

::start::

keyDown(KEY_TYPE.HOME_BUTTON)
sleep(0.1)
keyUp(KEY_TYPE.HOME_BUTTON)
sleep(1)
keyDown(KEY_TYPE.HOME_BUTTON)
sleep(0.1)
keyUp(KEY_TYPE.HOME_BUTTON)
sleep(1)
keyDown(KEY_TYPE.HOME_BUTTON)
sleep(0.1)
keyUp(KEY_TYPE.HOME_BUTTON)
sleep(1)
keyDown(KEY_TYPE.HOME_BUTTON)
sleep(0.1)
keyUp(KEY_TYPE.HOME_BUTTON)
sleep(2)

total = total + 1
toast(string.format("Total: %02d / Sucess: %02d / Failed: %02d", total, success, faild), 10)
openURL("App-Prefs:General&path=DATE_AND_TIME")
sleep(1)
appKill("com.apple.Preferences")
swipeCloseApp()
sleep(1)

appActivate("com.apple.Preferences")
waitImageVisible(airplan, 15)

for i = 1, 10, 1 do
    findAndClickByImage(is_off)
    sleep(1)
    findAndClickByImage(is_on)
    sleep(1)
    if checkImageIsExists(is_off) then
        break
    end
end

openURL("App-Prefs:SAFARI&path=CLEAR_HISTORY_AND_DATA")
for i = 1, 10, 1 do
    if checkImageIsExists(xoa_lich_su_va_du_lieu) then
        findAndClickByImage(xoa_lich_su_va_du_lieu)
    end

    if checkImageIsExists(dong_cac_tab) then
        findAndClickByImage(dong_cac_tab)
        sleep(2)
        break
    end
    sleep(1)
end

openURL("App-Prefs:General&path=DATE_AND_TIME")
sleep(2)
for i = 1, 10, 1 do
    if checkImageIsExists(mui_gio) then
        findAndClickByImage(mui_gio)
        break
    end
    sleep(1)
end
sleep(1)
time = getRandomLineInFile(currentPath() .. "/input/time.txt")
inputText(time)
sleep(1)
tap(200, 200)
sleep(2)

------random package
math.randomseed(os.time())
local randomIndex = math.random(1, #packages)
local selectedPackage = packages[randomIndex]
local package = appInfo(selectedPackage, 0)

wipeDataAppManager(package.displayName)
local username = ''
local password = ''
local txtHo = getRandomLineInFile(currentPath() .. "/input/ho.txt")
local txtTenDem = getRandomLineInFile(currentPath() .. "/input/tendem.txt")
local txtTen = getRandomLineInFile(currentPath() .. "/input/ten.txt")
local txtNgay = randomInt(1, 28)
local txtNam = randomInt(1950, 2000)
local state = 0

appActivate(selectedPackage)
for i = 1, 100, 1 do
    toast("-- " .. state .. " -- " .. i .. " --", 1)
    toast("-- " .. state .. " -- icon_user", 1)
    if state < 1 and checkImageIsExists(icon_user) then
        findAndClickByImage(icon_user)
        sleep(2)
        state = 1
    end

    toast("-- " .. state .. " -- dang_nhap", 1)
    if state < 2 and checkImageIsExists(dang_nhap) then
        findAndClickByImage(dang_nhap)

        if selectedPackage == "com.google.Gmail" then
            waitImageVisible(google, 10)
            findAndClickByImage(google)
            sleep(5)
            tap(746, 1280)
            sleep(0.016)
        elseif selectedPackage == "com.google.Classroom" then
            waitImageVisible(them_tai_khoan_khac, 10)
            findAndClickByImage(them_tai_khoan_khac)
            sleep(5)
            tap(746, 1280)
            sleep(0.016)
        elseif selectedPackage == "com.google.calendar" then
            sleep(5)
            tap(805, 1289)
            sleep(0.016)
        elseif selectedPackage == "com.google.Dynamite" then
            sleep(5)
            tap(799, 1289)
            sleep(0.016)
        else
            sleep(5)
            tap(550, 788)
            sleep(0.016)
        end

        if selectedPackage ~= "com.google.GoogleDigitalEditions" then
            state = 2
        end
    end

    toast("-- " .. state .. " -- tiep_tuc", 1)

    if checkImageIsExists(tiep_tuc) then
        findAndClickByImage(tiep_tuc)
    end

    if checkImageIsExists(google_map_giao_dien_moi) then sleep(1) tap(380, 1280) sleep(1) end

    toast("-- " .. state .. " -- tao_tai_khoan", 1)

    if state < 3 and checkImageIsExists(tao_tai_khoan) then
        findAndClickByImage(tao_tai_khoan)
        waitImageVisible(danh_cho_muc_dich_ca_nhan_cua_toi, 5)
    end

    toast("-- " .. state .. " -- danh_cho_muc_dich_ca_nhan_cua_toi", 1)

    if state < 3 and checkImageIsExists(danh_cho_muc_dich_ca_nhan_cua_toi) then
        findAndClickByImage(danh_cho_muc_dich_ca_nhan_cua_toi)
        waitImageVisible(ho, 5)
        state = 3
    end

    toast("-- " .. state .. " -- ho", 1)

    if (state == 3 or state == 2) and checkImageIsExists(ho) then
        findAndClickByImage(ho)
        sleep(2)
        dieninfo(txtHo)
        sleep(2)

        findAndClickByImage(ten)
        sleep(2)
        dieninfo(txtTenDem .. ' ' .. txtTen)
        sleep(2)
        findAndClickByImage(tiep_theo)
        waitImageVisible(nhap_ngay_sinh_va_gioi_tinh, 5)
        state = 4
    end

    -- if checkImageIsExists(da_co_su_co_xay_ra) then
    --     tap(1163, 201)
    --     sleep(0.016)
    -- end

    toast("-- " .. state .. " -- nhap_ngay_sinh_va_gioi_tinh", 1)

    if state == 4 and checkImageIsExists(nhap_ngay_sinh_va_gioi_tinh) then
        findAndClickByImage(ngay)
        sleep(2)
        dienso(txtNgay)
        sleep(2)

        findAndClickByImage(thang)
        sleep(2)
        tap(375, 973)
        sleep(2)

        findAndClickByImage(nam)
        sleep(2)
        dienso(txtNam)
        sleep(2)

        findAndClickByImage(gioi_tinh)
        sleep(2)
        findAndClickByImage(gt_nam)
        sleep(2)

        findAndClickByImage(tiep_theo)
        state = 5
    end

    toast("-- " .. state .. " -- tao_dia_chi_gmail_cua_rieng_ban", 1)

    if state == 5 and checkImageIsExists(tao_dia_chi_gmail_cua_rieng_ban) then
        findAndClickByImage(tao_dia_chi_gmail_cua_rieng_ban)
    end

    toast("-- " .. state .. " -- gmailcom", 1)

    if state == 5 and checkImageIsExists(gmailcom) then
        findAndClickByImage(gmailcom)
    end

    toast("-- " .. state .. " -- ten_nguoi_dung", 1)

    if state == 5 and checkImageIsExists(ten_nguoi_dung) or checkImageIsExists(tao_mot_dia_chi_gmail) then
        findAndClickByImage(ten_nguoi_dung)
        findAndClickByImage(tao_mot_dia_chi_gmail)
        sleep(2)
        if isNullOrEmpty(username) then
            username = txtHo .. txtTenDem .. txtTen .. randomInt(100000, 9999999)
        end
        dieninfo(username)
        sleep(2)
        tap(369, 725)
        sleep(2)

        findAndClickByImage(tiep_theo)
        state = 6
    end

    toast("-- " .. state .. " -- tao_mot_mat_khau", 1)

    if state == 6 and checkImageIsExists(tao_mot_mat_khau) then
        findAndClickByImage(mat_khau)
        sleep(2)
        if isNullOrEmpty(password) then
            password = txtHo .. txtTen .. txtTenDem
        end
        dieninfo(password)
        inputText('1!@#')
        sleep(2)
        tap(369, 725)
        sleep(2)

        findAndClickByImage(tiep_theo)
        state = 7
    end

    toast("-- " .. state .. " -- xem_lai_thong_tin_tai_khoan", 1)

    if state >= 7 and checkImageIsExists(xem_lai_thong_tin_tai_khoan) then
        findAndClickByImage(tiep_theo)
    end

    toast("-- " .. state .. " -- quyen_rieng_tu", 1)

    if state >= 7 and checkImageIsExists(quyen_rieng_tu) then
        swipeVertically(5)
    end

    toast("-- " .. state .. " -- toi_dong_y", 1)

    if state >= 7 and checkImageIsExists(toi_dong_y) then
        findAndClickByImage(toi_dong_y)
        local full_ten = txtHo .. ' ' .. txtTenDem .. ' ' .. txtTen
        local row =  username .. '|' .. password .. '1!@#' .. '|' .. txtNgay .. '/3/' .. txtNam .. '|' .. full_ten .. '|' .. time .. '|' .. selectedPackage

        writetxt("Device/gmail_account_7pl.txt", row, "a", 1000000, 1)
        writetxt("Device/time_success_7pl.txt", time, "a", 1000000, 1)
        success = success + 1

        local localIP = readFile(rootDir() .. "/Device/local_ip.txt")
        info = {
            gmail_checkpoint = 'OK',
            gmail_address    = username .. '@gmail.com',
            gmail_password   = password .. '1!@#',
            localIP          = localIP[#localIP],
            gmailData        = row
        }

        waitForInternet(2)

        ::post_data::
        local response, err = httpRequest {
            url = "https://tuongtacthongminh.com/reg_clone/gmail_account_google_form.php",
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json"
            },
            data = info
        }

        if response then
            toast("Request sent successfully!", 2)
            sleep(2)
        else
            toast("Error: Failed to send request.", 2)
            sleep(2)
            goto post_data
        end

        sleep(5)
        goto start
        return
    end

    if state >= 7 and checkImageIsExists(robot) then
        faild = faild + 1

        local full_ten = txtHo .. ' ' .. txtTenDem .. ' ' .. txtTen
        local row =  username .. '|' .. password .. '1!@#' .. '|' .. txtNgay .. '/3/' .. txtNam .. '|' .. full_ten .. '|' .. time .. '|' .. selectedPackage

        local localIP = readFile(rootDir() .. "/Device/local_ip.txt")
        info = {
            gmail_checkpoint = 'Robot',
            gmail_address    = username .. '@gmail.com',
            gmail_password   = password .. '1!@#',
            localIP          = localIP[#localIP],
            gmailData        = row
        }

        waitForInternet(2)

        ::post_data::
        local response, err = httpRequest {
            url = "https://tuongtacthongminh.com/reg_clone/gmail_account_google_form.php",
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json"
            },
            data = info
        }

        if response then
            toast("Request sent successfully!", 2)
            sleep(2)
        else
            toast("Error: Failed to send request.", 2)
            sleep(2)
            goto post_data
        end

        goto start
        return
    end

    sleep(2)
end

toast("Hello I'm a toast!", 5); -- Show message for 5 seconds.
goto start
