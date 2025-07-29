require(rootDir() .. '/Facebook/src/utils')
require(rootDir() .. '/Facebook/src/functions')

homeAndUnlockScreen()
swipeCloseApp()

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
local filePath = rootDir() .. "/PullCode.lua" 

local content = [[
local folderName = "Facebook"
local rootDir = rootDir()
local gitUrl = "https://github.com/harrynguyen95/facebook-fe.git"

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
require(rootDir() .. '/Facebook/src/utils')
require(rootDir() .. '/Facebook/src/functions')

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