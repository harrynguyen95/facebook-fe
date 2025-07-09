require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')
clearAlert()

homeAndUnlockScreen()

PROXY = ''
if not waitForInternet(5) then alert("No internet!") exit() end
getConfigServer()

local dirPath = currentDir() .. "/images/"
xoainfo_reset_data = {dirPath .. "xoainfo_reset_data.png"}
xoainfo_sock5 = {dirPath .. "xoainfo_sock5.png"}
xoainfo_x_icon = {dirPath .. "xoainfo_x_icon.png"}
xoainfo_set_proxy = {dirPath .. "xoainfo_set_proxy.png"}
xoainfo_ip_adress = {dirPath .. "xoainfo_ip_adress.png"}
xoainfo_done_btn = {dirPath .. "xoainfo_done_btn.png"}
xoainfo_info_fake = {dirPath .. "xoainfo_info_fake.png"}
xoainfo_port_input = {dirPath .. "xoainfo_port_input.png"}

toastr('setProxyXoainfo')
appRun("com.ienthach.XoaInfo")
sleep(1)

if (PROXY ~= '') and waitImageVisible(xoainfo_reset_data, 10) then
    local splitted = split(PROXY, ':')
    local IP = splitted[1]
    local port = splitted[2]

    press(700, 80) -- menu xoainfo
    sleep(1)
    press(450, 480) -- menu Cai dat
    sleep(2)
    swipe(600, 800, 610, 550) 

    if waitImageVisible(xoainfo_sock5, 5) then
        sleep(2)

        -- IP typing
        local result = findImage(xoainfo_sock5[1], 1, 0.99, nil, false, 1)
        local sock5Pos = result[#result]
        local x = sock5Pos[1]
        local y = sock5Pos[2]

        press(x, y + 80) sleep(0.5) -- IP input
        findAndClickByImage(xoainfo_x_icon) sleep(0.5)
        typeTextLongSpace(IP) sleep(0.5)
        findAndClickByImage(xoainfo_done_btn)

        -- Port typing
        sleep(2)
        if waitImageVisible(xoainfo_port_input, 2) then 
            local result = findImage(xoainfo_sock5[1], 1, 0.99, nil, false, 1)
            local sock5Pos = result[#result]
            local x = sock5Pos[1]
            local y = sock5Pos[2]

            press(x, y + 150) sleep(0.5) -- IP input
            typeNumber(port) sleep(0.5)
            findAndClickByImage(xoainfo_done_btn)
        else 
            local result = findImage(xoainfo_sock5[1], 1, 0.99, nil, false, 1)
            local sock5Pos = result[#result]
            local x = sock5Pos[1]
            local y = sock5Pos[2]

            press(x, y + 150) sleep(0.5) -- IP input
            findAndClickByImage(xoainfo_x_icon) sleep(0.5)
            typeNumber(port) sleep(0.5)
            findAndClickByImage(xoainfo_done_btn)
        end 

        -- tap btn Set Proxy
        if findAndClickByImage(xoainfo_set_proxy) then
            sleep(5)
            press(30, 80) sleep(1)

            findAndClickByImage(xoainfo_reset_data)sleep(1)
            if waitImageVisible(xoainfo_info_fake, 30) then
                pressHome()
            end 
        end 
    end 
end
