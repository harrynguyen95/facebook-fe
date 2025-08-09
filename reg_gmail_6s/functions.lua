ltn12 = require("ltn12")
https = require('ssl.https')
http = require("socket.http")
json = require "json"
socket = require("socket")
curl = require('lcurl')

PORT_PROXY = 10021

DEBUG = false

function url_encode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w%-%.%_%~])", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

function randomPassword(key, len)
    password = ""
    for i = len, 1, -1 do
        local index = math.random(1, #key)
        password = password .. string.sub(key, index, index)
    end
    return password
end

function sleep(timeout)
    usleep(timeout * 1000000)
end

function sleepToast(timeout)
    for i = timeout, 1, -1 do
        toast("Sleeping: " .. i .. " seconds remaining")
        usleep(1 * 1000000)
    end
end

function findAndClickByImage(path, threshold)
    if threshold == nil then
        threshold = 0.99
    end
    for i = 1, #path do
        local result = findImage(path[i], 1, threshold, nil, DEBUG, 1)
        for i, v in pairs(result) do
            if v ~= nil then
                local x = v[1]
                local y = v[2]
                tap(x, y)
                sleep(0.016)
                return true
            end
        end
    end

    return false
end

function findAndClickByImageWithX(path, x, threshold)
    if threshold == nil then
        threshold = 0.99
    end
    for i = 1, #path do
        local result = findImage(path[i], 1, threshold, nil, DEBUG, 1)
        print(path[i], result)
        for i, v in pairs(result) do
            if v ~= nil then
                local y = v[2]
                tap(x, y)
                sleep(0.016)
                return true
            end
        end
    end

    return false
end

function findAndClickByImageWithY(path, y, threshold)
    if threshold == nil then
        threshold = 0.99
    end
    for i = 1, #path do
        local result = findImage(path[i], 1, threshold, nil, DEBUG, 1)
        print(path[i], result)
        for i, v in pairs(result) do
            if v ~= nil then
                local x = v[1]
                tap(x, y)
                sleep(0.016)
                return true
            end
        end
    end

    return false
end

function splitPhoneNumber(phoneNumber)
    -- Remove leading "84" if it exists
    if phoneNumber:sub(1, 2) == "84" then
        phoneNumber = phoneNumber:sub(3)
    end

    -- Split the phone number
    local first = phoneNumber:sub(1, 2)
    local last = phoneNumber:sub(3)

    return first, last
end

function checkImageIsExist(path, threshold)
    if threshold == nil then
        threshold = 0.99
    end
    local result = findImage(path, 1, threshold, nil, DEBUG, 1)
    for i, v in pairs(result) do
        if v ~= nil then
            return true
        end
    end
    return false
end

function checkImageIsExists(path, threshold)
    if threshold == nil then
        threshold = 0.99
    end
    for i = 1, #path do
        local isExist = checkImageIsExist(path[i], threshold)
        if isExist then
            return path[i]
        end
    end

    return false
end

function waitImageNotVisible(path, timeout)
    for i = 1, timeout do
        if checkImageIsExists(path) == false then
            return true
        end
        sleepToast(1)
    end
    return false
end

function waitImageVisible(path, timeout)
    for i = 1, timeout do
        if checkImageIsExists(path) ~= false then
            return true
        end
        sleep(1)
    end
    return false
end

function swipe()
    touchDown(0, 500, 700)
    sleep(0.1)
    touchMove(0, 500, 600)
    sleep(0.1)
    touchMove(0, 500, 500)
    sleep(0.1)
    touchMove(0, 500, 400)
    sleep(0.1)
    touchMove(0, 500, 200)
    touchUp(0, 500, 200)
end

function randomInt(min, max)
    math.randomseed(os.time())
    local random_int = math.random(min, max)

    return random_int
end

function swipeBirthday()
    math.randomseed(socket.gettime() * 10000)
    time = math.random(200000, 250000)
    tap(math.random(487, 577), math.random(909, 940))
    usleep(time)
    tap(math.random(152, 195), math.random(909, 1278))
    usleep(time)
    tap(math.random(487, 577), math.random(909, 940))
    usleep(time)
    tap(math.random(263, 395), math.random(909, 1321))
    usleep(time)
    tap(math.random(152, 195), math.random(909, 1321))
    usleep(time)
    tap(math.random(487, 577), math.random(909, 940))
    usleep(time)
    tap(math.random(152, 195), math.random(909, 1321))
    usleep(time)
    tap(math.random(487, 577), math.random(909, 940))
    usleep(time)
    tap(math.random(487, 577), math.random(909, 940))
    usleep(time)
    tap(math.random(263, 395), math.random(909, 1321))
    usleep(time)
    tap(math.random(152, 195), math.random(909, 1321))
    usleep(time)
    tap(math.random(487, 577), math.random(909, 940))
    usleep(time)
    tap(math.random(152, 195), math.random(909, 1321))
    usleep(time)
    tap(math.random(487, 577), math.random(909, 1079))
    usleep(time)
    tap(math.random(487, 577), math.random(909, 1079))
    usleep(time)
    tap(math.random(263, 395), math.random(909, 1321))
    usleep(time)
    tap(math.random(152, 195), math.random(909, 1321))
    usleep(time)
    tap(math.random(487, 577), math.random(909, 1321))
    usleep(time * 3)
end

function getTempMail(type)
    local urlMail = "https://api.temp-mail.solutions/api/private/get_email"
    -- Khởi tạo thư viện HTTP và JSON cho Lua
    for i = 30, 1, -1 do
        toast(string.format("Get Email %d", i), 3)
        local result = {}
        local body, code, headers = http.request {
            url = urlMail,
            sink = ltn12.sink.table(result)
        }
        usleep(100000)
        if i == 3 then
            toast("not email", 3)
            usleep(3000000)
            return false
        end

        -- Chuyển đổi kết quả từ chuỗi JSON sang bảng Lua
        local parsed_result = json.decode(table.concat(result))

        -- Kiểm tra và lấy email
        if parsed_result and parsed_result["data"] and parsed_result["data"]["email"] then
            local email = parsed_result["data"]["email"]
            return email
        end

        sleep(1)
    end

    return false
end

function getOtpTempMail(email, type)
    -- Cấu hình URL tương ứng với loại email
    local urlMail = "https://api.temp-mail.solutions/api/private/get_inbox?email=" .. email

    for i = 120, 1, -1 do
        toast("Get OTP " .. i, 1)
        local result = {}
        local body, code, headers = http.request {
            url = urlMail,
            sink = ltn12.sink.table(result)
        }

        -- Phân tích cú pháp kết quả JSON
        local parsed_result = json.decode(table.concat(result))

        -- Kiểm tra và trích xuất OTP
        if parsed_result and parsed_result["data"] and #parsed_result["data"] > 0 then
            local subject = parsed_result["data"][1]["subject"]
            local otp = string.match(subject, "%d+")
            if otp then
                return otp
            end
        end

        if i == 1 then
            toast("Không có OTP", 3)
            sleep(3)
            return false
        end

        sleep(1)
    end

    return false
end

function getUID()
    local response, status = http.request("http://phonefarm.builuc1998.com/api/getUID")
    if status == 200 then
        local data = json.decode(response)

        return data
    else
        -- print("HTTP request failed with status: " .. tostring(status))
    end
    return false
end

function onOffAirplaneMode()
    io.popen("activator send switch-off.com.a3tweaks.switch.vpn")
    sleep(0.5)
    io.popen('activator send switch-on.com.a3tweaks.switch.airplane-mode');
    sleep(0.5)
    io.popen('activator send switch-on.com.a3tweaks.switch.airplane-mode');
    sleep(0.5)
    io.popen('activator send switch-off.com.a3tweaks.switch.airplane-mode');
    sleep(0.5)
    io.popen('activator send switch-off.com.a3tweaks.switch.airplane-mode');
    sleep(0.5)
    io.popen('activator send switch-off.com.a3tweaks.switch.wifi');
    sleep(0.5)
    io.popen('activator send switch-off.com.a3tweaks.switch.wifi');
    sleep(0.5)
    io.popen('activator send switch-on.com.a3tweaks.switch.cellular-data');
    sleep(0.5)
end

function respring()
    usleep(math.random(3000000, 4000000));
    io.popen('killall -9 SpringBoard');
end

function swipeCloseApp()
    keyPress(KEY_TYPE.HOME_BUTTON);
    sleep(0.1)
    keyPress(KEY_TYPE.HOME_BUTTON);
    sleep(2)
    for i = 1, 20, 1 do
        touchDown(1, 200, 800);
        for i = 800, 200, -30 do
            usleep(300);
            touchMove(1, 200, i);
        end
        touchUp(1, 200, 200);
        usleep(500000);
        checkmau = getColor(711, 17); -- 16777215, 0xFFFFFF
        if checkmau == 16777215 then
            break
        end
    end
    keyPress(KEY_TYPE.HOME_BUTTON);
    sleep(math.random(1, 2));
end

function wipeDataAppManager(packageName)
    ::appmanagerstart::
    -- io.popen("activator send switch-off.com.a3tweaks.switch.vpn")
    appKill("com.tigisoftware.ADManager");
    sleep(0.5);
    appKill("com.facebook.Messenger");
    sleep(0.5);
    appKill("com.facebook.Facebook");
    sleep(0.5);
    keyPress(KEY_TYPE.HOME_BUTTON);
    sleep(1);
    appRun("com.tigisoftware.ADManager");
    appActivate("com.tigisoftware.ADManager");
    sleep(3);
    state = appState("com.tigisoftware.ADManager");
    if (state == "ACTIVATED") then
        toast("Safari is activated", 1);
    else
        goto appmanagerstart
    end
    tap(265, 265)
    -- findAndClickByImage(TXT_SEARCH_APPMANAGER);
    sleep(2);
    inputText(packageName);
    sleep(2);
    tap(190, 192);
    sleep(2);
    swipeVertically(1);
    sleep(2);
    tap(147, 1142);
    sleep(2);
    tap(370, 1135);
    sleep(2);
    tap(147, 1142);
    sleep(2);
    tap(370, 1135);
    sleep(2);

    sleep(1);
    keyPress(KEY_TYPE.HOME_BUTTON);
    appKill("com.tigisoftware.ADManager");
    sleep(1);
end

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function BackupDataAppManager(packageName)
    ::appmanagerstart::
    -- io.popen("activator send switch-off.com.a3tweaks.switch.vpn")
    appKill("com.tigisoftware.ADManager");
    sleep(0.5);
    appKill("com.facebook.Messenger");
    sleep(0.5);
    appKill("com.facebook.Facebook");
    sleep(0.5);
    keyPress(KEY_TYPE.HOME_BUTTON);
    sleep(1);
    appRun("com.tigisoftware.ADManager");
    appActivate("com.tigisoftware.ADManager");
    sleep(5);
    state = appState("com.tigisoftware.ADManager");
    if (state == "ACTIVATED") then
        toast("Safari is activated", 1);
    else
        goto appmanagerstart
    end
    tap(265, 265)
    -- findAndClickByImage(TXT_SEARCH_APPMANAGER);
    sleep(2);
    inputText(packageName);
    sleep(2);
    tap(190, 192);
    sleep(2);
    swipeVertically(1);
    sleep(2);
    tap(85, 875);
    sleep(2);
    tap(370, 1135);

    sleep(5);
    waitImageNotVisible({currentPath() .. "/images/lb_backing_up.png"}, 120);

    keyPress(KEY_TYPE.HOME_BUTTON);
    sleep(1);
end

function backupAZ()
    appRun("com.builuc1998.changer")
    appActivate("com.builuc1998.changer")
    sleep(1);
    for i = 1, 60, 1 do
        findAndClickByImage({currentPath() .. "/images/az_facebook.png", currentPath() .. "/images/az_facebook2.png"})
        sleep(1);
        findAndClickByImage({currentPath() .. "/images/az_backup.png"})
        sleep(1);
        if checkImageIsExist(currentPath() .. "/images/az_complete.png") then
            return true
        end
    end
end

function swipeVertically(n)
    math.randomseed(os.time());
    local x = math.random(5, 15)
    local x1 = math.random(200, 250)
    local y = math.random(850, 1150)
    local y1 = math.random(90, 115)
    local timecholuot = math.random(5000, 10000)
    for i = 1, n, 1 do
        -- toast("vuot:"..i.."/"..n);
        touchDown(x, x1, y);
        usleep(timecholuot);
        for i = y, y1 + 20, -30 do
            usleep(timecholuot);
            touchMove(x, x1, i);
        end
        for i = y1 + 20, y1, -2 do
            usleep(timecholuot);
            touchMove(x, x1, i);
        end
        usleep(timecholuot);
        touchUp(x, x1, y1);

        usleep(1500000, 2000000);
    end
end

uid = ""
key2fa = ""
password = ""
email = ""
passemail = ""

function postDataToGoogleForm(data)
    toast("postDataToGoogleForm", 2)
    usleep(2000000)
    -- local cookie = clipText();
    postBody = "entry.1200788396=" .. data .. "&="
    local resultTable = {}
    local status, statusMsg = https.request {
        url = "https://docs.google.com/forms/d/e/1FAIpQLSdIme3a-MGeuxW1f0hQ7ku3hLwTj_IF8XKhYLvbkRK41fl5dA/formResponse",
        sink = ltn12.sink.table(resultTable),
        method = "POST",
        headers = {
            ["Accept"] = "*/*",
            ["Content-Length"] = postBody:len(),
            ["Content-Type"] = "application/x-www-form-urlencoded"
        },
        source = ltn12.source.string(postBody)
    }
    toast("Done", 2)
    usleep(2000000)
    return
end

function postDataToGoogleFormv2(data, url, entry)
    toast("Sending data to Google Form...", 2)
    usleep(2000000)

    -- Tạo nội dung post body
    local postBody = "entry." .. entry .. "=" .. data .. "&="

    -- Biến chứa kết quả request
    local resultTable = {}

    -- Gửi request
    local status, statusMsg = https.request {
        url = url,
        sink = ltn12.sink.table(resultTable),
        method = "POST",
        headers = {
            ["Accept"] = "*/*",
            ["Content-Length"] = postBody:len(),
            ["Content-Type"] = "application/x-www-form-urlencoded"
        },
        source = ltn12.source.string(postBody)
    }

    usleep(2000000)
    -- Kiểm tra trạng thái trả về
    if status == 1 then
        toast("Request sent successfully!", 2)
    else
        -- Nếu lỗi xảy ra
        if statusMsg == "timeout" then
            toast("Error: Request timeout. Check your network.", 3)
        elseif statusMsg == "closed" then
            toast("Error: Connection closed unexpectedly.", 3)
        else
            toast("Error: Failed to send request. Reason: " .. tostring(statusMsg), 3)
        end
    end

    usleep(2000000)
    return
end

function wipeapp(bundleid)
    local lfs = require('lfs');
    function isDir(name)
        if type(name) ~= "string" then
            return false
        end
        local cd = lfs.currentdir()
        local is = lfs.chdir(name) and true or false
        lfs.chdir(cd)
        return is
    end
    function deletedir(dir, rmdir)
        -- print(string.format("'dir ===== %s'", dir));
        if (isDir(dir)) then
            for file in lfs.dir(dir) do
                local file_path = dir .. '/' .. file
                if file ~= "." and file ~= ".." then
                    if lfs.attributes(file_path, 'mode') == 'file' then
                        os.remove(file_path);
                        -- print('remove file', file_path);
                    elseif lfs.attributes(file_path, 'mode') == 'directory' then
                        -- print('dir', file_path);
                        deletedir(file_path, 1);
                    else
                        os.remove(file_path);
                        -- print('remove file', file_path);
                    end
                end
            end
            if (rmdir == 1) then
                lfs.rmdir(dir)
            end
            -- print('remove dir', dir)
        else
            -- toast("Cant find " .. dir, 2);
        end
    end
    appKill(bundleid);
    appKill("com.apple.mobilesafari");
    appKill("com.apple.Preferences");

    io.popen("echo alpine | sudo -u root -S killall -9 MobileSafari");
    -- clean SystemCaches   
    io.popen("echo alpine | sudo -u root -S rm -rf /var/MobileSoftwareUpdate/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/Logs/*.log");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/logs/*.log*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/logs/AppleSupport/*.log");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/logs/CrashReporter/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/root/.bash_history");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/db/diagnostics/shutdown.log");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/Keychains/keychain-2.db-corrupt");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/root/Library/Logs/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Downloads/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/Caches/Snapshots/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/Caches/com.apple.Safari.SafeBrowsing/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/Caches/com.apple.WebKit.Networking/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/Caches/com.apple.WebKit.WebContent/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/com.apple.WebKit/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/CrashReporter/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/Logs/AppleSupport/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/Logs/CrashReporter/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/Recents/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/Safari/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/SafariSafeBrowsing/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/WebClips/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Library/WebKit/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /var/mobile/Media/Downloads/*");
    io.popen("echo alpine | sudo -u root -S rm -rf /private/var/mobile/Library/Caches/com.apple.mobilesafari");
    io.popen("echo alpine | sudo -u root -S rm -rf /private/var/mobile/Library/Caches/Safari");
    io.popen("echo alpine | sudo -u root -S rm /private/var/mobile/Library/Cookies/Cookies.binarycookies");
    io.popen("echo alpine | sudo -u root -S rm /private/var/root/Library/Cookies/Cookies.binarycookies");
    -- cleanKeychains

    -- io.popen("echo alpine | sudo -u root -S rm -rf /var/Keychains/");
    -- io.popen("echo alpine | sudo -u root -S cp -R /var/Keychains_bk /var/Keychains");
    -- io.popen("echo alpine | sudo -u root -S tar -xvf /private/var/Keychains.tar -C /private");
    -- io.popen("echo alpine | sudo -u root -S chown -R _securityd:wheel /var/Keychains");
    -- io.popen("echo alpine | sudo -u root -S chown -R _securityd:wheel /var/Keychains/Analytics");
    -- io.popen("echo alpine | sudo -u root -S chown -R _securityd:wheel /var/Keychains/Analytics/SupplementalsAssets");
    -- io.popen("echo alpine | sudo -u root -S chown -R _securityd:wheel /var/Keychains/crls");
    -- cleanPasteBoard
    io.popen("echo alpine | sudo -u root -S killall -9 pasted");
    io.popen("echo alpine | sudo -u root -S killall -9 pasteboardd");
    -- [self unloadServices:@"com.apple.UIKit.pasteboardd.plist;com.apple.pasteboard.pasted.plist"];	
    io.popen(
        "echo alpine | sudo -u root -S launchctl unload -w /System/Library/LaunchDaemons/com.apple.UIKit.pasteboardd.plist");
    io.popen(
        "echo alpine | sudo -u root -S launchctl unload -w /System/Library/LaunchDaemons/com.apple.pasteboard.pasted.plist");
    deletedir('private/var/mobile/Library/Caches/com.apple.UIKit.pboard');
    deletedir('private/var/mobile/Library/Caches/com.apple.Pasteboard');
    -- [self loadServices:@"com.apple.UIKit.pasteboardd.plist;com.apple.pasteboard.pasted.plist"];	
    io.popen(
        "echo alpine | sudo -u root -S launchctl load -w /System/Library/LaunchDaemons/com.apple.UIKit.pasteboardd.plist");
    io.popen(
        "echo alpine | sudo -u root -S launchctl load -w /System/Library/LaunchDaemons/com.apple.pasteboard.pasted.plist");

    -- clean LsdIdentity
    deletedir('private/var/db/lsd/com.apple.lsdidentifiers.plist');
    -- clean itunesstored
    io.popen(
        "echo alpine | sudo -u root -S rm -rf /private/var/mobile/Library/Caches/com.apple.itunesstored/fsCachedData");

    -- clean AppData	
    local result = appInfo(bundleid, 0)
    -- print(table.tostring(result))
    -- print(result["dataContainerPath"]:gsub("file:///", ""))
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'CloudKit', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'Documents', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'Library', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'SystemData', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'tmp', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//CloudKit', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//Documents', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//Library', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//SystemData', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//tmp', 0);
    -- clean AppGroup	
    deletedir('private/var/mobile/Containers/Shared/AppGroup/');

    io.popen("echo alpine | sudo -u root -S killall -9 itunesstored itunescloudd appstored");
    io.popen("echo alpine | sudo -u root -S killall -9 locationd Maps");

    deletedir('private/var/mobile/Library/Safari/');
    deletedir('private/var/mobile/Library/WebKit/');

    -- clean Pasteboard	
    deletedir('private/var/mobile/Library/Caches/com.apple.UIKit.pboard');
    deletedir('private/var/mobile/Library/Caches/com.apple.Pasteboard');

    -- clean ItunesCache
    deletedir('private/var/mobile/Library/Caches/com.apple.itunesstored/fsCachedData');

    io.popen("echo alpine | sudo -u root -S killall -9 securityd");
    usleep(1000000);
end

function getName()
    local names = readNamesFromFile(rootDir() .. "/nameTH.txt")
    local randomName = getRandomName(names)
    return splitName(randomName)
end

function split(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function splitName(fullname)
    local names = {}
    for name in string.gmatch(fullname, "%S+") do
        table.insert(names, name)
    end

    local firstName = names[1] -- First word is first name
    table.remove(names, 1) -- Remove first name from names
    local lastName = table.concat(names, ' ') -- Remaining words are last name

    return firstName, lastName
end

math.randomseed(os.time())

function readLinesFromFile(filename)
    local names = {}
    for name in io.lines(filename) do
        table.insert(names, name)
    end
    return names
end

function getRandomLineInFile(filename)
    local lines = readLinesFromFile(filename)
    local index = math.random(#lines)
    return trim(lines[index])
end

function readFirstLineAndRemove(filePath)
    local lines = {}
    local firstLine = nil

    -- Read all lines from the file
    local file = io.open(filePath, "r")
    if file then
        firstLine = file:read("*l") -- Read the first line
        if firstLine then
            firstLine = trim(firstLine) -- Trim any leading/trailing whitespace/newline
        end
        for line in file:lines() do
            table.insert(lines, line)
        end
        file:close()
    else
        error("Could not open file: " .. filePath)
    end

    -- Write the remaining lines back to the file
    file = io.open(filePath, "w")
    if file then
        for _, line in ipairs(lines) do
            file:write(line .. "\n")
        end
        file:close()
    else
        error("Could not open file for writing: " .. filePath)
    end

    return firstLine
end

function generateRandomPhoneNumber()
    local phoneNumber = "+668"
    math.randomseed(os.time())
    phoneNumber = phoneNumber .. tostring(math.random(3, 9)) .. tostring(math.random(1000000, 9999999))
    return phoneNumber
end

-- function generateRandomPhoneNumber()
--     local phoneNumber = "+24842"
--     math.randomseed(os.time())
--     phoneNumber = phoneNumber .. tostring(math.random(10000, 99999))
--     return phoneNumber
-- end

function sendRequest(url)
    local response_body, status_code

    if url:sub(1, 5) == 'https' then
        response_body, status_code = https.request(url)
    else
        response_body, status_code = http.request(url)
    end

    if status_code ~= 200 then
        toast('Error: ' .. status_code)
        return "nil"
    end

    return response_body
end

function changeIPProxy()
    http.TIMEOUT = 5
    https.TIMEOUT = 5
    io.popen("activator send switch-off.com.a3tweaks.switch.vpn")
    io.popen("activator send switch-off.com.a3tweaks.switch.vpn")
    sleep(1)
    ::start::
    toast(sendRequest("http://45.77.173.51:8000/rotate-ip?port=" .. PORT_PROXY), 3)
    swipeCloseApp()
    wipeapp("com.liguangming.Shadowrocket")
    local mime = require("mime")
    socks5 = "45.77.173.51:" .. PORT_PROXY
    local b64 = mime.b64(socks5)
    copyText("http://" .. b64)
    sleep(1)
    openURL("shadowrocket://route/proxy")
    sleep(1)
    if appState("com.liguangming.Shadowrocket") == "ACTIVATED" then
        io.popen("activator send switch-on.com.a3tweaks.switch.vpn");
        sleep(3)
        appKill("com.liguangming.Shadowrocket")
        -- if waitForInternet(10) == false then
        --     toast("Không có internet")
        --     goto start
        -- end
        openURL("https://ipconfig.io")
        sleep(5)
        return
    end
end

function readtxt(file)
    local f = io.open(rootDir() .. "/" .. file, "r");
    local content1 = f:read("*line");
    local content2 = f:read("all");
    f:close()
    if (content1 == nil) then
        return nil
    else
        return content1, content2
    end
end

function writetxt(file, content, style, time, enter) -- a or w
    local f = io.open(rootDir() .. "/" .. file, style)

    if f == nil then
        -- print("Unable to open file " .. file)
        return
    end

    -- print(rootDir() .. "/" .. file)
    if (enter == 1) then
        f:write(content, "\n");
    else
        f:write(content);
    end
    usleep(time);
    f:close();

    local x = readtxt(file);
    if (x == 0) then
        f = io.open(rootDir() .. "/" .. file, style)
        if f == nil then
            -- print("Unable to reopen file " .. file)
            return
        end
        if (enter == 1) then
            f:write(content, "\n");
        else
            f:write(content);
        end
        usleep(time);
        f:close();
    end
end

function hasInternetConnection()
    local testUrl = "https://www.google.com"
    local response, err = https.request("GET", testUrl)
    if response then
        toast(response.status)
        if response.status == 200 then
            return true
        end
    end
    return false
end

-- function waitForInternet(timeout)
--     for i = 1, timeout, 1 do
--         if hasInternetConnection() then
--             return true
--         end
--         sleep(1)
--     end
--     return false
-- end


function checkIP()
    local response, error = httpRequest { url = 'https://ipv4.icanhazip.com' }
    response = (response and string.gsub(response, "\n", "")) or nil
    toast('v4 check: ' .. (response or '-'), 2)
    sleep(2)
    if response then
        info.ipRegister = response
        return true
    else 
        sleep(1)
        local response, error = httpRequest { url = 'https://ipv6.icanhazip.com' }
        response = (response and string.gsub(response, "\n", "")) or nil
        toast('v6 check: ' .. (response or '-'), 2)
        sleep(2)
        if response then
            info.ipRegister = response
            return true
        end 
    end
    info.ipRegister = nil
    return false
end

function waitForInternet(timeout)
    sleep(1)
    for i = 1, timeout, 1 do
        if checkIP() then
            sleep(1)
            return true
        end
        sleep(1)
    end
    return false
end

function dieninfo(kitudien)
    stringX = tostring(kitudien);
    for i = 1, #stringX do
        math.randomseed(os.time());
        chucai = string.sub(stringX, i, i);
        local x = math.random(-10, 10);
        local y = math.random(-10, 10);
        local timecho = math.random(200000, 300000);
        local timechobatbuoc = math.random(300000, 400000);
        if string.sub(stringX, i, i) == "q" then
            tap(28 + x, 948 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == " " then
            tap(259 + x, 1279 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "w" then
            tap(102 + x, 947 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "e" then
            tap(178 + x, 946 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "r" then
            tap(254 + x, 946 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "t" then
            tap(331 + x, 945 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "y" then
            tap(405 + x, 951 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "u" then
            tap(481 + x, 950 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "i" then
            tap(554 + x, 947 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "o" then
            tap(629 + x, 955 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "p" then
            tap(706 + x, 952 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "a" then
            tap(72 + x, 1060 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "s" then
            tap(146 + x, 1058 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "d" then
            tap(221 + y, 1059 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "f" then
            tap(296 + x, 1056 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "g" then
            tap(366 + x, 1059 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "h" then
            tap(443 + x, 1056 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "j" then
            tap(523 + y, 1059 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "k" then
            tap(592 + y, 1054 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "l" then
            tap(671 + x, 1053 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "z" then
            tap(145 + x, 1166 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "x" then
            tap(218 + y, 1166 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "c" then
            tap(290 + x, 1167 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "v" then
            tap(369 + x, 1166 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "b" then
            tap(445 + x, 1162 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "n" then
            tap(522 + x, 1166 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "m" then
            tap(595 + x, 1163 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "0" then
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
            tap(704 + x, 945 + y); -- phim so
            usleep(timecho)
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
        elseif string.sub(stringX, i, i) == "1" then
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
            tap(29 + x, 947 + y);
            usleep(timecho)
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
        elseif string.sub(stringX, i, i) == "2" then
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
            tap(105 + y, 947 + y);
            usleep(timecho)
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
        elseif string.sub(stringX, i, i) == "3" then
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
            tap(179 + x, 946 + y);
            usleep(timecho)
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
        elseif string.sub(stringX, i, i) == "4" then
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
            tap(257 + x, 954 + y);
            usleep(timecho)
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
        elseif string.sub(stringX, i, i) == "5" then
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
            tap(328 + x, 952 + y);
            usleep(timecho)
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
        elseif string.sub(stringX, i, i) == "6" then
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
            tap(406 + x, 953 + y);
            usleep(timecho)
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
        elseif string.sub(stringX, i, i) == "7" then
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
            tap(479 + x, 953 + y);
            usleep(timecho)
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
        elseif string.sub(stringX, i, i) == "8" then
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
            tap(557 + x, 950 + y);
            usleep(timecho)
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
        elseif string.sub(stringX, i, i) == "9" then
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
            tap(629 + x, 950 + y);
            usleep(timecho)
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
        elseif string.sub(stringX, i, i) == "@" then
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
            tap(605 + x, 1028 + y);
            usleep(timecho)
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
        elseif string.sub(stringX, i, i) == " " then
            tap(317 + x, 1282 + y);
            usleep(timechobatbuoc);
        elseif string.sub(stringX, i, i) == "!" then
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
            tap(467 + x, 1165 + y);
            usleep(timecho)
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
        elseif string.sub(stringX, i, i) == "." then
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
            tap(115 + x, 1167 + y);
            usleep(timecho)
            tap(72 + x, 1273 + y); -- phim doi ban phim so
            usleep(timechobatbuoc)
        elseif string.sub(stringX, i, i) == "Q" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(28 + x, 948 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "W" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(102 + x, 947 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "E" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(178 + x, 946 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "R" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(254 + x, 946 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "T" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(331 + x, 945 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "Y" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(405 + x, 951 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "U" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(481 + x, 950 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "I" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(554 + x, 947 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "O" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(629 + x, 955 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "P" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(706 + x, 952 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "A" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(72 + x, 1060 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "S" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(146 + x, 1058 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "D" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(221 + y, 1059 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "F" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(296 + x, 1056 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "G" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(366 + x, 1059 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "H" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(443 + x, 1056 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "J" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(523 + y, 1059 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "K" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(592 + y, 1054 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "L" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(671 + x, 1053 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "Z" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(145 + x, 1166 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "X" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(218 + y, 1166 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "C" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(290 + x, 1167 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == "V" then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(369 + x, 1166 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == ("B") then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(445 + x, 1162 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == ("N") then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(522 + x, 1166 + y);
            usleep(timecho)
        elseif string.sub(stringX, i, i) == ("M") then
            tap(36 + x, 1162 + y); -- phim shit de viet chu hoa
            usleep(timechobatbuoc)
            tap(595 + x, 1163 + y);
            usleep(timecho)
        end
    end
end

function dienso(so)
    stringSo = " " .. so;
    for i = 1, #stringSo do
        dayso = string.sub(stringSo, i, i);
        math.randomseed(os.time());
        local x = math.random(-5, 5)
        local y = math.random(-5, 5)
        local timecho = math.random(300000, 500000)
        if string.sub(stringSo, i, i) == "0" then
            tap(356 + x, 1265 + y);
            usleep(timecho)
        elseif string.sub(stringSo, i, i) == "1" then
            tap(107 + x, 946 + y);
            usleep(timecho)
        elseif string.sub(stringSo, i, i) == "2" then
            tap(359 + x, 945 + y);
            usleep(timecho)
        elseif string.sub(stringSo, i, i) == "3" then
            tap(613 + x, 941 + y);
            usleep(timecho)
        elseif string.sub(stringSo, i, i) == "4" then
            tap(116 + x, 1051 + y);
            usleep(timecho)
        elseif string.sub(stringSo, i, i) == "5" then
            tap(359 + x, 1046 + y);
            usleep(timecho)
        elseif string.sub(stringSo, i, i) == "6" then
            tap(599 + x, 1048 + y);
            usleep(timecho)
        elseif string.sub(stringSo, i, i) == "7" then
            tap(126 + x, 1159 + y);
            usleep(timecho)
        elseif string.sub(stringSo, i, i) == "8" then
            tap(358 + x, 1157 + y);
            usleep(timecho)
        elseif string.sub(stringSo, i, i) == "9" then
            tap(610 + x, 1152 + y);
            usleep(timecho)
        elseif string.sub(stringSo, i, i) == "+" then
            tap(126 + x, 1273 + y); -- phim doi
            usleep(timecho)
            tap(372 + x, 1282 + y); -- phim +
            usleep(timecho)
        end
    end
end

function getPublicIP(retries)
    local url = "https://api.ipify.org"
    local response_body = {}
    local attempt = 0

    while attempt < retries do
        response_body = {} -- Reset the response body for each attempt
        local res, code, response_headers = http.request {
            url = url,
            method = "GET",
            sink = ltn12.sink.table(response_body)
        }

        if response_body and code == 200 then
            local response = table.concat(response_body)
            print("Public IP: " .. response)
            return response
        else
            print("HTTP request failed with code: " .. tostring(code) .. ". Retrying...")
            attempt = attempt + 1
            -- Optionally, you can add a delay here before retrying
            -- sleep(1) -- Sleep for 1 second before retrying (if you have a sleep function available)
        end
    end

    print("Failed to retrieve public IP address after " .. retries .. " attempts")
    return nil
end

function lockScreen()
    keyDown(KEY_TYPE.POWER_BUTTON);
    keyUp(KEY_TYPE.POWER_BUTTON);
end

-- How to simulate a screen unlock function?
function unlockScreen()
    keyDown(KEY_TYPE.POWER_BUTTON);
    keyUp(KEY_TYPE.POWER_BUTTON);

    usleep(1000000);

    local w, h = getScreenResolution();

    local x = 10;
    local gap = 120;
    touchDown(0, x, 200);
    while x < w do
        x = x + gap;
        usleep(16000);
        touchMove(0, x, 200);
    end
    touchUp(0, x, 200);
end

function lockAndUnlockScreen()
    lockScreen()
    sleep(1)
    local i = 0;
    while true do
        -- if checkImageIsExists(btn_cancel) then
        --     findAndClickByImage(btn_cancel)
        -- end
        i = i + 1;
        if getColor(711, 17) == 16777215 and i > 5 then
            break
        end

        keyDown(KEY_TYPE.HOME_BUTTON)
        keyUp(KEY_TYPE.HOME_BUTTON)
        sleep(1)
    end
end

function split(input, delimiter)
    local result = {}
    for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function cutCharacters(input, num)
    -- Kiểm tra nếu num lớn hơn độ dài chuỗi, trả về chuỗi rỗng
    if num > #input then
        return ""
    end

    -- Cắt chuỗi từ ký tự num+1 đến hết
    return input:sub(num + 1)
end

function isNullOrEmpty(str)
    return str == nil or str == ''
end

function checkInternetAndPublicIP()
    local url = "https://api.myip.com/?v=" .. math.random(1, 65535)
    local resultTable = {}

    -- Gửi yêu cầu GET đến ipconfig.io
    local status, statusMsg = https.request {
        url = url,
        sink = ltn12.sink.table(resultTable),
        method = "GET",
        headers = {
            ["Accept"] = "*/*"
        },
        timeout = 10 -- Thời gian chờ tối đa
    }

    -- Kiểm tra kết nối
    if status == 1 then
        local publicIP = table.concat(resultTable) -- Kết hợp các kết quả thành chuỗi
        if publicIP and publicIP ~= "" then
            print("Connected to the Internet. Public IP: " .. publicIP)
            toast("Internet OK. Public IP: " .. publicIP, 3)
            return publicIP
        else
            print("Connected, but failed to fetch public IP.")
            toast("Internet OK, but no public IP detected.", 3)
            return nil
        end
    else
        print("No internet connection. Error: " .. tostring(statusMsg))
        toast("No Internet. Error: " .. tostring(statusMsg), 3)
        return nil
    end
end

function fileExists(filePath)
    local file = io.open(filePath, "r")
    if file then
        file:close()
        return true
    else
        return false
    end
end

function addVersionToPlist(version)
    local plist = require("plist")
    local plistPath = "/var/mobile/Library/Preferences/com.builuc1998.azhelper.plist"

    -- Kiểm tra xem file plist có tồn tại không
    if not fileExists(plistPath) then
        -- Nếu file không tồn tại, tạo bảng rỗng
        toast("Plist file does not exist. Creating a new one.", 3)
        plistData = {}
    else
        -- Đọc file plist
        plistData = plist.read(plistPath)
        if not plistData then
            plistData = {} -- Nếu đọc không thành công, tạo bảng rỗng
        end
    end

    -- Cập nhật giá trị 'version'
    plistData["version"] = version

    -- Ghi lại file plist
    local success = plist.write(plistData, plistPath)

    if success then
        toast("Version added to plist successfully!", 3)
    else
        toast("Failed to write version to plist.", 3)
    end
end

-- Hàm kiểm tra sự tồn tại của file
local function fileExists(filePath)
    local file = io.open(filePath, "r")
    if file then
        file:close()
        return true
    end
    return false
end

-- Hàm lấy MIME type đơn giản dựa trên phần mở rộng file
local function detectMimeType(filePath)
    local ext = filePath:match("^.+(%..+)$") -- Lấy phần mở rộng từ đường dẫn
    local mimeTypes = {
        [".txt"] = "text/plain",
        [".jpg"] = "image/jpeg",
        [".jpeg"] = "image/jpeg",
        [".png"] = "image/png",
        [".gif"] = "image/gif",
        [".pdf"] = "application/pdf",
        [".json"] = "application/json",
        [".zip"] = "application/zip"
    }
    return mimeTypes[ext] or "application/octet-stream" -- MIME mặc định nếu không tìm thấy
end

function httpRequest(params)
    if not params.url then
        error("URL là bắt buộc")
    end

    local method = params.method or "GET"
    local headers = params.headers or {}
    local data = params.data or nil
    local file = params.file or nil
    local response = ""

    print("Debug: URL:" .. params.url)
    print("Debug: Phương thức:" .. method)
    print("Debug: Headers:")
    for k, v in pairs(headers) do
        print(k .. ": " .. v)
    end
    headers["Expect"] = ""

    local c = curl.easy {
        url = params.url,
        ssl_verifypeer = params.ssl_verifypeer or false,
        ssl_verifyhost = params.ssl_verifyhost or false,
        customrequest = method,
        writefunction = function(chunk)
            response = response .. tostring(chunk)
            return #chunk
        end
    }

    for key, value in pairs(headers) do
        print(key .. ": " .. value)
        c:setopt(curl.OPT_HTTPHEADER, {key .. ": " .. value})
    end

    if data or file then
        print("Debug: Dữ liệu gửi đi:")
        for k, v in pairs(data or {}) do
            print(k .. " = " .. tostring(v))
        end

        if headers["Content-Type"] == "application/x-www-form-urlencoded" then
            local encoded = {}
            for k, v in pairs(data) do
                table.insert(encoded, k .. "=" .. tostring(v))
            end
            c:setopt(curl.OPT_POSTFIELDS, table.concat(encoded, "&"))
        elseif headers["Content-Type"] == "application/json" then
            local json = require("json")
            local jsonString = json.encode(data)
            c:setopt(curl.OPT_POSTFIELDS, jsonString)
        else
            local post = curl.form()
            if data then
                for k, v in pairs(data) do
                    post:add_content(k, tostring(v))
                end
            end
            if file then
                local filePath = file
                local fileName = filePath:match("^.+/(.+)$")
                post:add_file("file", filePath, "application/octet-stream", fileName)
            end
            c:setopt(curl.OPT_HTTPPOST, post)
        end
    end

    local success, err = pcall(function()
        c:perform()
    end)

    c:close()

    if not success then
        return nil, "Lỗi khi thực hiện request: " .. tostring(err)
    end

    print("Response: " .. response)
    return response, nil
end

function getRandomString(length)
    local characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" -- Tập ký tự để random
    local result = ""
    for i = 1, length do
        local randomIndex = math.random(1, #characters) -- Lấy chỉ số ngẫu nhiên
        result = result .. string.sub(characters, randomIndex, randomIndex)
    end
    return result
end

function getRandomVietnamPhoneNumber()
    local prefix = "+84986" -- Đầu số cố định
    local randomPart = math.random(100000, 999999) -- 7 chữ số ngẫu nhiên
    return prefix .. randomPart
    -- local prefix = "+15058" -- Đầu số cố định
    -- local randomPart = math.random(100000, 999999) -- 7 chữ số ngẫu nhiên
    -- return prefix .. randomPart
end

function postDataToGoogleFormv3(data_post, url, entry)
    toast("Sending data to Google Form...", 1)
    -- usleep(2000000)

    local response, err = httpRequest {
        url = url,
        method = "POST",
        headers = {
            -- ["accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
            -- ["accept-language"] = "en-US,en;q=0.9",
            -- ["cache-control"] = "no-cache",
            ["Content-Type"] = "application/x-www-form-urlencoded"
        },
        data = {
            ["entry." .. entry] = data_post
        }
    }

    writetxt("log.html", data_post .. response, "w", 1000000, 1)
    -- usleep(2000000)
    -- Kiểm tra trạng thái trả về
    if response then
        toast("Request sent successfully!", 2)
    else
        toast("Error: Failed to send request. Reason: " .. tostring(statusMsg), 3)
    end

    -- usleep(2000000)
    return
end

function getUIDFBLogin()
    ::again::
    local plist = require("plist")
    local result = appInfo("com.facebook.Facebook")
    local path = string.gsub(result["dataContainerPath"] .. "Library/Preferences/com.facebook.Facebook.plist",
        "file://", "")

    local luaTable = plist.read(path);
    -- print(table.tostring(luaTable))
    local uid =
        luaTable["kFBQPLLoggingPolicyLastKnownOwnerFbID"] or luaTable["FBAnalyticsCurrentLoggedInUserIdentity"] or ""
    if uid == "" or uid == 0 or uid == "0" then
        goto again
    end
    return uid
end

function findAndClickIfExists(path, threshold)
    if threshold == nil then
        threshold = 0.99
    end
    for i = 1, #path do
        local result = findImage(path[i], 1, threshold, nil, DEBUG, 1)
        for _, v in pairs(result) do
            if v ~= nil then
                local x = v[1]
                local y = v[2]
                tap(x, y) -- Click vào vị trí
                sleep(0.016)
                return true -- Trả về true nếu tìm thấy và đã click
            end
        end
    end
    return false -- Trả về false nếu không tìm thấy
end

function cleanResponse(rawResponse)
    -- Ensure the response is not nil or empty
    if not rawResponse or rawResponse == "" then
        return nil, "Response is empty or nil"
    end

    -- Extract the JSON object or array
    local clean = rawResponse:match("%b{}") or rawResponse:match("%b[]")
    if not clean then
        return nil, "No valid JSON found in response"
    end

    return clean, nil
end

function getTime()
    local now = os.date("*t") -- trả về table thời gian hiện tại
    return string.format("%02d:%02d:%02d %02d:%02d:%02d", now.hour, now.min, now.sec, now.day, now.month, now.year)
end

function getNewProxy()
    toast("Sending data to Google Form...", 1)

    local response, err = httpRequest {
        url = "https://tmproxy.com/api/proxy/get-new-proxy",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json"
        },
        data = {
            ["api_key"] = "b44c15f6eb80fbc8b1b720ea50eda680",
            ["id_location"] = 0,
            ["id_isp"] = 0
        }
    }

    if response then
        toast("Request sent successfully!", 2)

        -- Parse JSON
        local json = require("json")
        local jsonData = json.decode(response)
        if jsonData and jsonData.data and jsonData.data.https then
            local socks5 = jsonData.data.https
            toast("Socks5: " .. socks5, 3)
            return socks5
        else
            toast("Invalid JSON or socks5 not found", 3)
        end
    else
        toast("Error: Failed to send request.", 3)
    end
end

function wipeAppRootless(bundleid)
    local lfs = require('lfs');
    function isDir(name)
        if type(name) ~= "string" then
            return false
        end
        local cd = lfs.currentdir()
        local is = lfs.chdir(name) and true or false
        lfs.chdir(cd)
        return is
    end
    function deletedir(dir, rmdir)
        -- print(string.format("'dir ===== %s'", dir));
        if (isDir(dir)) then
            for file in lfs.dir(dir) do
                local file_path = dir .. '/' .. file
                if file ~= "." and file ~= ".." then
                    if lfs.attributes(file_path, 'mode') == 'file' then
                        os.remove(file_path);
                        -- print('remove file', file_path);
                    elseif lfs.attributes(file_path, 'mode') == 'directory' then
                        -- print('dir', file_path);
                        deletedir(file_path, 1);
                    else
                        os.remove(file_path);
                        -- print('remove file', file_path);
                    end
                end
            end
            if (rmdir == 1) then
                lfs.rmdir(dir)
            end
            -- print('remove dir', dir)
        else
            -- toast("Cant find " .. dir, 2);
        end
    end
    appKill(bundleid);

    local result = appInfo(bundleid, 0)
    -- print(table.tostring(result))
    -- print(result["dataContainerPath"]:gsub("file:///", ""))
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'CloudKit', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'Documents', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'Library', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'SystemData', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. 'tmp', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//CloudKit', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//Documents', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//Library', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//SystemData', 0);
    deletedir(result["dataContainerPath"]:gsub("file:///", "") .. '//tmp', 0);
    -- clean AppGroup	
    deletedir('private/var/mobile/Containers/Shared/AppGroup/');
    usleep(1000000);
end

function useProxyRootless(proxyString)
    ::setup_proxy::
    wipeAppRootless("com.liguangming.Shadowrocket")

    local socks5 = ""
    if proxyString and proxyString ~= "" then
        -- Split the proxyString to check if it matches `user:pass:ip:port` format
        local ip, port, user, pass = proxyString:match("([^:]+):([^:]+):([^:]+):([^:]+)")
        if user and pass and ip and port then
            -- Convert to `user:pass@ip:port` format
            socks5 = user .. ":" .. pass .. "@" .. ip .. ":" .. port
        else
            -- Assume the string is in `ip:port` format if not matched
            socks5 = proxyString
        end
    else
        -- Randomly select a proxy from file if no parameter is passed
        socks5 = tostring(getRandomLineInFile(currentPath() .. "/proxy.txt"))
    end

    -- Base64 encode the proxy string
    local mime = require("mime")
    local b64 = mime.b64(socks5)
    socks5 = "http://" .. b64
    print(socks5)
    sleep(2)
    copyText(socks5)
    print("copy - " .. socks5)
    sleep(5)
    local text = clipText();
    toast(" --- " .. text, 2);

    for i = 1, 2, 1 do
        copyText(socks5)
        appKill("com.liguangming.Shadowrocket")
        openURL("shadowrocket://route/proxy")

        usleep(5000000)
    end

    local text = clipText();
    toast(text, 2);

    if appState("com.liguangming.Shadowrocket") == "ACTIVATED" then
        openURL("shadowrocket://connect")
        usleep(5000000)
        return
        -- for i = 1, 10, 1 do
        --     if checkInternetAndPublicIP() ~= nil then
        --         appKill("com.liguangming.Shadowrocket")
        --         usleep(2000000)
        --         openURL("shadowrocket://route/proxy")
        --         usleep(2000000)
        --         return
        --     else
        --         toast("No Internet", 2)
        --     end
        --     sleep(1)
        -- end
        -- goto setup_proxy
    end
end
