require('functions')

dong_cac_tab = {currentPath() .. "/images/dong_cac_tab.png"}
mui_gio = {currentPath() .. "/images/mui_gio.png"}
xoa_lich_su_va_du_lieu = {currentPath() .. "/images/xoa_lich_su_va_du_lieu.png"}

tiep_tuc = {currentPath() .. "/images/tiep_tuc.png", currentPath() .. "/images/tiep_tuc2.png"}
tao_tai_khoan = {currentPath() .. "/images/tao_tai_khoan.png"}
email_hoac_so_dien_thoai = {currentPath() .. "/images/email_hoac_so_dien_thoai.png"}
tiep_theo = {currentPath() .. "/images/tiep_theo.png", currentPath() .. "/safari/tiep_theo.png"}
danh_cho_muc_dich_ca_nhan_cua_toi = {currentPath() .. "/images/danh_cho_muc_dich_ca_nhan_cua_toi.png"}
ho = {currentPath() .. "/images/ho.png"}
ten = {currentPath() .. "/images/ten.png"}
nhap_ngay_sinh_va_gioi_tinh = {currentPath() .. "/images/nhap_ngay_sinh_va_gioi_tinh.png"}
ngay = {currentPath() .. "/safari/ngay.png"}
nam = {currentPath() .. "/safari/nam.png"}
gioi_tinh = {currentPath() .. "/safari/gioi_tinh.png"}
thang = {currentPath() .. "/safari/thang.png"}
gt_nam = {currentPath() .. "/safari/gt_nam.png"}
tao_dia_chi_gmail_cua_rieng_ban = {currentPath() .. "/safari/tao_dia_chi_gmail_cua_rieng_ban.png"}
tao_mot_dia_chi_gmail = {currentPath() .. "/safari/tao_mot_dia_chi_gmail.png"}
tao_mot_mat_khau = {currentPath() .. "/images/tao_mot_mat_khau.png"}
mat_khau = {currentPath() .. "/images/mat_khau.png"}
robot = {currentPath() .. "/images/robot.png"}
ten_nguoi_dung = {currentPath() .. "/safari/ten_nguoi_dung.png"}
xem_lai_thong_tin_tai_khoan = {currentPath() .. "/images/xem_lai_thong_tin_tai_khoan.png"}
quyen_rieng_tu = {currentPath() .. "/images/quyen_rieng_tu.png"}
toi_dong_y = {currentPath() .. "/images/toi_dong_y.png"}
icon_user = {currentPath() .. "/images/icon_user.png"}
dang_nhap = {currentPath() .. "/safari/dang_nhap.png"}
airplan = {currentPath() .. "/images/airplan.png"}
is_on = {currentPath() .. "/images/is_on.png", currentPath() .. "/images/is_on2.png"}
is_off = {currentPath() .. "/images/is_off.png"}
xac_nhan = {currentPath() .. "/safari/xac_nhan.png"}
dia_chi_email_khoi_phuc = {currentPath() .. "/safari/dia_chi_email_khoi_phuc.png"}
bo_qua = {currentPath() .. "/safari/bo_qua.png"}
gmailcom = {currentPath() .. "/safari/gmail.com.png"}

local total = 0
local success = 0
local faild = 0

::start::
total = total + 1

openURL("App-Prefs:General&path=DATE_AND_TIME")
sleep(1)
appKill("com.apple.Preferences")
sleep(1)

-- appActivate("com.liguangming.Shadowrocket")
-- click_on = false
-- for i = 1, 10, 1 do
--     if checkImageIsExists(is_off) then
--         if click_on then
--            break 
--         end
--         findAndClickByImage(is_off)
--     end

--     if checkImageIsExists(is_on) then
--         findAndClickByImage(is_on)
--         click_on = true
--     end
--     sleep(1)
-- end

-- ::getproxy::
-- proxy = getNewProxy()
-- if isNullOrEmpty(proxy) then
--     sleep(10)
--     goto getproxy
-- end
-- useProxyRootless(proxy)

swipeCloseApp()
-- appActivate("com.apple.Preferences")
-- waitImageVisible(airplan, 15)

-- for i = 1, 10, 1 do
--     findAndClickByImage(is_off)
--     sleep(1)
--     findAndClickByImage(is_on)
--     sleep(1)
--     if checkImageIsExists(is_off) then
--         break
--     end
-- end

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

toast(string.format("Total: %02d / Sucess: %02d / Failed: %02d", total, success, faild), 10)
openURL("https://google.com/")

-- wipeDataAppManager("maps")
local username = ''
local password = ''
local txtHo = getRandomLineInFile(currentPath() .. "/ho.txt")
local txtTenDem = getRandomLineInFile(currentPath() .. "/tendem.txt")
local txtTen = getRandomLineInFile(currentPath() .. "/ten.txt")
local txtNgay = randomInt(1, 28)
local txtNam = randomInt(1950, 2000)

for i = 1, 100, 1 do

    if checkImageIsExists(icon_user) then
        findAndClickByImage(icon_user)
    end

    if checkImageIsExists(dang_nhap) then
        findAndClickByImage(dang_nhap)
        -- sleep(5)
        -- tap(550, 788)
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

        sleep(1)
        if isNullOrEmpty(username) then
            username = txtHo .. txtTenDem .. txtTen .. randomInt(100000, 9999999)
        end
        dieninfo(username)
        -- sleep(2)
        -- tap(369, 725)
        sleep(1)

        findAndClickByImage(tiep_theo)
    end

    if checkImageIsExists(gmailcom) then
        findAndClickByImage(gmailcom)
        sleep(1)
    end

    if checkImageIsExists(ten_nguoi_dung) or checkImageIsExists(tao_mot_dia_chi_gmail) then
        findAndClickByImage(ten_nguoi_dung)
        findAndClickByImage(tao_mot_dia_chi_gmail)
        sleep(2)
        if isNullOrEmpty(username) then
            username = txtHo .. txtTenDem .. txtTen .. randomInt(100000, 9999999)
        end
        dieninfo(username)
        -- sleep(2)
        -- tap(369, 725)
        sleep(1)

        findAndClickByImage(tiep_theo)
    end

    if checkImageIsExists(tao_mot_mat_khau) or checkImageIsExists(xac_nhan) then

        findAndClickByImage(xac_nhan)
        sleep(2)
        if isNullOrEmpty(password) then
            password = txtHo .. txtTen .. txtTenDem
        end
        dieninfo(password)
        inputText('1!@#')
        sleep(2)

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

    if checkImageIsExists(dia_chi_email_khoi_phuc) or checkImageIsExists(bo_qua) then
        findAndClickByImage(dia_chi_email_khoi_phuc)
        sleep(2)
        inputText(username .. '@xzcv2.com')
        sleep(2)
        findAndClickByImage(tiep_theo)
    end

    if checkImageIsExists(xem_lai_thong_tin_tai_khoan) then
        findAndClickByImage(tiep_theo)
    end

    if checkImageIsExists(quyen_rieng_tu) then
        swipeVertically(5)
    end

    -- if checkImageIsExists(bo_qua) then
    --     findAndClickByImage(toi_dong_y)
    --     local full_ten = txtHo .. ' ' .. txtTenDem .. ' ' .. txtTen
    --     writetxt("account.txt",
    --         username .. '|' .. password .. '1!@#' .. '|' .. txtNgay .. '/3/' .. txtNam .. '|' .. full_ten, "a", 1000000,
    --         1)
    --     writetxt("time_success.txt", time, "a", 1000000, 1)
    --     toast("Success !", 5)
    --     sleep(5)
    -- end

    if checkImageIsExists(toi_dong_y) then
        findAndClickByImage(toi_dong_y)
        local full_ten = txtHo .. ' ' .. txtTenDem .. ' ' .. txtTen
        writetxt("account.txt",
            username .. '|' .. password .. '1!@#' .. '|' .. username .. '@xzcv2.com' .. '|' .. txtNgay .. '/3/' ..
                txtNam .. '|' .. full_ten .. '|' .. getTime(), "a", 1000000, 1)
        writetxt("time_success.txt", time, "a", 1000000, 1)
        sleep(5)
        success = success + 1
        goto start
        return
    end

    if checkImageIsExists(robot) then
        toast("Failed !", 2)
        faild = faild + 1
        goto start
        return
    end

    sleep(2)
end

toast("Hello I'm a toast!", 5); -- Show message for 5 seconds.
goto start

