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

::start::
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

print(currentPath() .. "/images/mui_gio.png")
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
time = getRandomLineInFile(currentPath() .. "/time.txt")
inputText(time)
sleep(1)
tap(200, 200)
sleep(2)

wipeDataAppManager("maps")
local username = ''
local password = ''
local txtHo = getRandomLineInFile(currentPath() .. "/ho.txt")
local txtTenDem = getRandomLineInFile(currentPath() .. "/tendem.txt")
local txtTen = getRandomLineInFile(currentPath() .. "/ten.txt")
local txtNgay = randomInt(1, 28)
local txtNam = randomInt(1950, 2000)

appActivate('com.google.Maps')
for i = 1, 100, 1 do

    if checkImageIsExists(icon_user) then
        findAndClickByImage(icon_user)
    end

    if checkImageIsExists(dang_nhap) then
        findAndClickByImage(dang_nhap)
        sleep(5)
        tap(550, 788)
    end

    if checkImageIsExists(tiep_tuc) then
        findAndClickByImage(tiep_tuc)
    end

    if checkImageIsExists(danh_cho_muc_dich_ca_nhan_cua_toi) then
        findAndClickByImage(danh_cho_muc_dich_ca_nhan_cua_toi)
    end

    if checkImageIsExists(tao_tai_khoan) then
        findAndClickByImage(tao_tai_khoan)
    end

    if checkImageIsExists(ho) then
        findAndClickByImage(ho)
        sleep(2)
        dieninfo(txtHo)
        sleep(2)

        findAndClickByImage(ten)
        sleep(2)
        dieninfo(txtTenDem .. ' ' .. txtTen)
        sleep(2)
        findAndClickByImage(tiep_theo)
    end

    if checkImageIsExists(nhap_ngay_sinh_va_gioi_tinh) then
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
    end

    if checkImageIsExists(tao_dia_chi_gmail_cua_rieng_ban) then
        findAndClickByImage(tao_dia_chi_gmail_cua_rieng_ban)
    end

    if checkImageIsExists(gmailcom) then
        findAndClickByImage(gmailcom)
    end

    if checkImageIsExists(ten_nguoi_dung) or checkImageIsExists(tao_mot_dia_chi_gmail) then
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
    end

    if checkImageIsExists(tao_mot_mat_khau) then
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
    end

    if checkImageIsExists(xem_lai_thong_tin_tai_khoan) then
        findAndClickByImage(tiep_theo)
    end

    if checkImageIsExists(quyen_rieng_tu) then
        swipeVertically(5)
    end

    if checkImageIsExists(toi_dong_y) then
        findAndClickByImage(toi_dong_y)
        local full_ten = txtHo .. ' ' .. txtTenDem .. ' ' .. txtTen
        writetxt("account.txt", username .. '|' .. password .. '1!@#' .. '|' .. txtNgay .. '/3/' .. txtNam .. '|' .. full_ten,
            "a", 1000000, 1)
        writetxt("time_success.txt", time, "a", 1000000, 1)
        sleep(5)
        goto start
        return
    end

    if checkImageIsExists(robot) then
        goto start
        return
    end

    sleep(2)
end

toast("Hello I'm a toast!", 5); -- Show message for 5 seconds.
goto start

