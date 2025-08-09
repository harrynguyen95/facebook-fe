require('functions')

function scrollBaoMat()
    touchDown(2, 454.69, 603.19);
    usleep(16694.04);
    touchMove(2, 433.14, 601.15);
    usleep(16762.33);
    touchMove(2, 396.18, 599.12);
    usleep(16752.21);
    touchMove(2, 330.49, 594.01);
    usleep(16539.58);
    touchMove(2, 240.18, 591.97);
    usleep(16998.58);
    touchMove(2, 118.03, 591.97);
    usleep(15938.08);
    touchUp(2, 9.24, 596.06);
    usleep(500533.29);

    touchDown(4, 426.98, 604.20);
    usleep(33432.00);
    touchMove(4, 389.00, 597.08);
    usleep(16409.62);
    touchMove(4, 337.68, 586.88);
    usleep(16862.54);
    touchMove(4, 253.52, 575.69);
    usleep(16665.04);
    touchMove(4, 157.04, 571.62);
    usleep(16279.58);
    touchMove(4, 61.58, 571.62);
    usleep(16454.88);
    touchMove(4, 15.39, 571.62);
    usleep(15893.92);
    touchUp(4, 11.28, 570.60);
    usleep(434441.17);

    touchDown(1, 426.98, 583.83);
    usleep(33607.71);
    touchMove(1, 392.07, 587.90);
    usleep(16516.54);
    touchMove(1, 353.07, 586.88);
    usleep(17027.33);
    touchMove(1, 277.12, 575.69);
    usleep(16293.17);
    touchMove(1, 181.66, 562.46);
    usleep(16749.92);
    touchMove(1, 78.00, 553.30);
    usleep(15632.21);
    touchUp(1, 73.89, 549.22);
end

function addMailRecovery()
    local quan_ly_tai_khoan = {currentPath() .. "/addmail_recovery/quan_ly_tai_khoan.png"}
    local bao_mat = {currentPath() .. "/addmail_recovery/bao_mat.png"}
    local them_dia_chi_email = {currentPath() .. "/addmail_recovery/them_dia_chi_email.png"}
    local nhap_mat_khau_cua_ban = {currentPath() .. "/addmail_recovery/nhap_mat_khau_cua_ban.png"}
    local them_email_khoi_phuc = {currentPath() .. "/addmail_recovery/them_email_khoi_phuc.png"}
    local ma_xac_minh = {currentPath() .. "/addmail_recovery/ma_xac_minh.png"}
    local xac_minh = {currentPath() .. "/addmail_recovery/xac_minh.png"}
    local trang_chu = {currentPath() .. "/addmail_recovery/trang_chu.png"}

    for i = 1, 100, 1 do
        if checkImageIsExists(quan_ly_tai_khoan) then
            findAndClickByImage(quan_ly_tai_khoan)
        end

        if checkImageIsExists(trang_chu) then
            scrollBaoMat()
        end

        if checkImageIsExists(bao_mat) then
            findAndClickByImage(bao_mat)
        end

        if checkImageIsExists(bao_mat) then
            findAndClickByImage(bao_mat)
        end

        if checkImageIsExists(them_dia_chi_email) then
            findAndClickByImage(them_dia_chi_email)
        end

        if checkImageIsExists(nhap_mat_khau_cua_ban) then
            findAndClickByImage(nhap_mat_khau_cua_ban)
        end

        
        sleep(1)
    end
end
inputText('a1@xzcv2.com')
-- addMailRecovery()
-- swipeVertically(1)
