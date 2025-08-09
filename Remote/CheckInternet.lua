require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

info = { ipRegister = nil }

homeAndUnlockScreen()
swipeCloseApp()

if not waitForInternet(5) then
toast('--1------------------- No Internet ------------------------------ ', 5)
else 
toast('--------------------- OK ----------------------------- ', 5)
end

local filePath = rootDir() .. "/Run.lua" 

local content = [[
dofile(rootDir() .. "/Facebook/Main.lua")
]]

local file = io.open(filePath, "w")

if file then
    file:write(content)
    file:close()
    toastr("✅ Đã ghi: " .. filePath)
else
    toastr("❌ Không thể tạo hoặc ghi vào file.")
end

--------------------------------------------------
function removeFolderIfExists(path)
    io.popen("cd " .. rootDir() .. " && rm -rf " .. path)
    toastr("🗑️ Đã xoá: " .. path)
end

local folderPath = rootDir() .. "/Examples"
local filePath = rootDir() .. "/WhatIsAutoTouch.at"

removeFolderIfExists(folderPath)
removeFolderIfExists(filePath)

--------------------------------------------------------------------------------------------------------
local filePath = rootDir() .. "/Device/Setup.lua" 

local content = [[
require(rootDir() .. '/Facebook/utils')

local folderName = "Facebook"
local rootDir = rootDir()

local tokens = readFile(rootDir .. "/Device/github_token.txt")
local token = tokens[#tokens]

local gitUrl = "https://".. token .."@github.com/harrynguyen95/facebook-fe.git"

io.popen("cd " .. rootDir .. " && rm -rf " .. folderName .. " && mkdir " .. folderName)
usleep(1000000)
io.popen("cd " .. rootDir .. "/" .. folderName .. " && git clone " .. gitUrl .. " .")

usleep(2000000)
]]

local file = io.open(filePath, "w")

if file then
    file:write(content)
    file:close()
    toastr("✅ Đã ghi nội dung vào file: " .. filePath)
else
    toastr("❌ Không thể tạo hoặc ghi vào file.")
end

--------------------------------------------------------------------------------------------------------
local filePath = rootDir() .. "/PullCode.lua" 

local content = [[
require(rootDir() .. '/Facebook/utils')

local folderName = "Facebook"
local rootDir = rootDir()

local tokens = readFile(rootDir .. "/Device/github_token.txt")
local token = tokens[#tokens]

local gitUrl = "https://".. token .."@github.com/harrynguyen95/facebook-fe.git"

io.popen("cd " .. rootDir .. " && rm -rf " .. folderName .. " && mkdir " .. folderName)
usleep(1000000)
io.popen("cd " .. rootDir .. "/" .. folderName .. " && git clone " .. gitUrl .. " .")

usleep(2000000)
]]

local file = io.open(filePath, "w")

if file then
    file:write(content)
    file:close()
    toastr("✅ Đã ghi nội dung vào file: " .. filePath)
else
    toastr("❌ Không thể tạo hoặc ghi vào file.")
end

--------------------------------------------------------------------------------------------------------
local filePath = rootDir() .. "/OnWifi.lua" 

local content = [[
require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

local dirPath = rootDir() .. "/Facebook/Remote/images/"
wifi_icon = {dirPath .. "wifi_icon.png"}
wifi_off = {dirPath .. "wifi_off.png"}

toast('onWifi', 2)
appRun("com.apple.Preferences")
if waitImageVisible(wifi_icon, 2) then 
    findAndClickByImage(wifi_icon)
    sleep(1)
end 
if waitImageVisible(wifi_off, 3) then 
    findAndClickByImage(wifi_off)
    sleep(1)
end
swipeCloseApp()
]]

local file = io.open(filePath, "w")

if file then
    file:write(content)
    file:close()
    toastr("✅ Đã ghi nội dung vào file: " .. filePath)
else
    toastr("❌ Không thể tạo hoặc ghi vào file.")
end

----------------------------------------------------------------------------------------------
local filePath = rootDir() .. "/Respring.lua" 

local content = [[
require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

local dirPath = rootDir() .. "/Facebook/Remote/images/"
xoainfo_reset_data = {dirPath .. "xoainfo_reset_data.png"}

toastr('respringXoainfo')
appRun("com.ienthach.XoaInfo")
sleep(1)

if waitImageVisible(xoainfo_reset_data, 10) then
    press(700, 80) -- menu xoainfo
    sleep(1)
    press(450, 410) -- menu Add on
    sleep(1)
    swipe(600, 900, 610, 500) 
    sleep(2)
    press(380, 740) -- respring button
end
]]

local file = io.open(filePath, "w")

if file then
    file:write(content)
    file:close()
    toastr("✅ Đã ghi nội dung vào file: " .. filePath)
else
    toastr("❌ Không thể tạo hoặc ghi vào file.")
end
