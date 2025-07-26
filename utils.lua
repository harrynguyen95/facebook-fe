json = require "json"
curl = require('lcurl')
ltn12 = require("ltn12")

DEBUG_IMAGE = false
THRESHOLD = 0.99
math.randomseed(os.time() + math.random())

function sleep(timeout)
    usleep(timeout * 1000000)
end

function exit()
    stop()
end

function toastr(value, time)
    if time == nil then
        time = 1
    end

    if value == nil then
        value = 'null'
    end

    if type(value) == "table" or type(value) == "boolean" then
        toast(jsonStringify(value), time)
        -- print(jsonStringify(value))
    else
        toast(value, time)
        -- print(value)
    end
end

function dd(value)
    sleep(1)
    toastr(value, 5) exit()
end 

function showIphoneModel()
    local fh = io.popen("uname -m", "r")
    local model = fh:read("*l")
    fh:close()
    toastr(model or 'Unknown model', 1)
end

function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

function jsonStringify(tbl)
    local function encode(val)
        if type(val) == "table" then
            local isArray = #val > 0
            local result = {}
            if isArray then
                for _, v in ipairs(val) do
                    table.insert(result, encode(v))
                end
                return "[" .. table.concat(result, ",") .. "]"
            else
                for k, v in pairs(val) do
                    table.insert(result, '"' .. k .. '":' .. encode(v))
                end
                return "{" .. table.concat(result, ",") .. "}"
            end
        elseif type(val) == "string" then
            return '"' .. val .. '"'
        elseif type(val) == "number" or type(val) == "boolean" then
            return tostring(val)
        else
            return 'null'
        end
    end
    return encode(tbl)
end

local function epoch_vietnam()
    local now_utc = os.time(os.date("!*t"))
    return now_utc + (7 * 3600)
end

function log(value, prefix)
    if prefix == nil then
        prefix = ':'
    end
    local ts = os.date("- %m-%d %H:%M ", epoch_vietnam())
    prefix = ts .. prefix

    if type(value) == "table" then
        print(prefix .. ": " .. jsonStringify(value))
    elseif type(value) == "string" then
        print(prefix .. ": " .. value)
    else
        print(prefix .. ": " .. tostring(value))
    end
end

function press(x, y, duration)
    duration = duration or 0.3
    local randOffset = function()
        return math.random(-10, 10)
    end
    local randX = x + randOffset()
    local randY = y + randOffset()
    tap(randX, randY)
    usleep(duration * 1000000)
end

function split(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function floor(num)
    return math.floor(num)
end

function writeFile(path, data)
    local f = io.open(path, "w")
    for i, v in ipairs(data) do
        f:write(v, "\n")
    end
    f:close()
end

function addLineToFile(path, line)
    (io.open(path, "a")):write("\n" .. line):close()
end

function readFile(path)
    local file = io.open(path, "r")
    if not file then
        log("File không tồn tại, tạo mới: " .. path, 3)

        file = io.open(path, "w")
        if not file then
            log("Không thể tạo file: " .. path, 3)
            return {}
        end
        file:close()

        file = io.open(path, "r")
        if not file then
            log("Không thể mở file vừa tạo: " .. path, 3)
            return {}
        end
    end

    local lines = {}
    for line in file:lines() do
        line = line:gsub("\r", ""):gsub("^%s*(.-)%s*$", "%1")
        
        if line ~= "" then
            table.insert(lines, line)
        end
    end
    file:close()
    return lines
end

function readLinesFromFile(filename)
    local f, err = io.open(filename, "r")
    if not f then return nil, "Không mở được file: " .. tostring(err) end

    local names = {}
    for name in io.lines(filename) do
        table.insert(names, name)
    end
    return names
end

function removeLineFromFile(filepath, pattern)
    local f, err = io.open(filepath, "r")
    if not f then return nil, "Không mở được file: " .. tostring(err) end

    local lines = {}
    for line in f:lines() do
        if not string.find(line, pattern, 1, true) then
            lines[#lines + 1] = line
        end
    end
    f:close()

    f, err = io.open(filepath, "w")
    if not f then return nil, "Không ghi được file: " .. tostring(err) end

    for i = 1, #lines do
        f:write(lines[i], "\n")
    end
    f:close()
    return true
end

function getRandomLineInFile(filename)
    local lines = readLinesFromFile(filename)
    if not lines or #lines == 0 then 
        return ""
    end
    local index = math.random(#lines)

    return trim(lines[index])
end

function parseStringToTable(s)
    local t = {}
    s = s:gsub("^%s*{%s*", ""):gsub("%s*}%s*$", "")
    for num in s:gmatch("%d+") do
        t[#t + 1] = tonumber(num)
    end
    return t
end

function findAndClickByImage(paths, threshold)
    if threshold == nil then
        threshold = THRESHOLD
    end
    sleep(0.2)

    if type(paths) == "table" then
        for i = 1, #paths do
            local result = findImage(paths[i], 1, threshold, nil, DEBUG_IMAGE, 1)
            for i, v in pairs(result) do
                if v ~= nil then
                    local x = v[1]
                    local y = v[2]
                    press(x, y)
                    return true
                end
            end
        end
    elseif type(paths) == "string" then
        local result = findImage(paths, 1, threshold, nil, DEBUG_IMAGE, 1)
        for i, v in pairs(result) do
            if v ~= nil then
                local x = v[1]
                local y = v[2]
                press(x, y)
                return true
            end
        end
    end
    return false
end

function checkImageIsExist(path, threshold)
    if threshold == nil then
        threshold = THRESHOLD
    end

    local file = io.open(path, "r")
    if file then
        local result = findImage(path, 1, threshold, nil, DEBUG_IMAGE, 1)
        for i, v in pairs(result) do
            if v ~= nil then
                return true
            end
        end
    else 
        -- log(path, 'Not found img')
        -- toastr('Not found img: ' .. path, 1)
    end
    return false
end

function checkImageIsExists(paths, threshold)
    if threshold == nil then
        threshold = THRESHOLD
    end
    if paths == nil then
        return false
    end
    for i = 1, #paths do
        local isExist = checkImageIsExist(paths[i], threshold)
        if isExist then
            return paths[i]
        end
    end

    return false
end

function waitImageVisible(paths, timeout)
    if timeout == nil then
        timeout = 5
    end

    for i = 1, timeout do
        if checkImageIsExists(paths) ~= false then
            return true
        end
        sleep(1)
    end
    return false
end

function waitImageNotVisible(paths, timeout)
    if timeout == nil then
        timeout = 15
    end

    for i = 1, timeout do
        if checkImageIsExists(paths) == false then
            return true
        end
        sleep(1)
    end
    return false
end

function randomBetween(min, max)
    return math.random() * (max - min) + min
end

function randomPointInRect(rect)
    local x = randomBetween(rect.topLeft.x, rect.bottomRight.x)
    local y = randomBetween(rect.topLeft.y, rect.bottomRight.y)
    return { x = x, y = y }
end

function getToday()
    local now = os.date("*t")
    return { now.day, now.month, now.year }
end

function randomDOB()
    local day = math.random(1, 28)
    local month = math.random(1, 12)
    local year = math.random(1990, 2003)
    return { day, month, year }
end

function selectDobValue(x, y, target, maxValue)
    local diff = maxValue - target
    local absDiff = math.abs(diff)
    for i = 1, absDiff do
        press(x, y - 70)
        sleep(0.1)
    end
end

function getRandomString(length)
    local characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, length do
        local randomIndex = math.random(1, #characters)
        result = result .. string.sub(characters, randomIndex, randomIndex)
    end
    return result
end

function randomPassword(length)
    length = length or 8
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local pass = ""

    for i = 1, length do
        local index = math.random(1, #chars)
        pass = pass .. string.sub(chars, index, index)
    end

    return pass
end

function removeVietnameseTones(str)
    local map = {
        ["á"]="a", ["à"]="a", ["ả"]="a", ["ã"]="a", ["ạ"]="a",
        ["ă"]="a", ["ắ"]="a", ["ằ"]="a", ["ẳ"]="a", ["ẵ"]="a", ["ặ"]="a",
        ["â"]="a", ["ấ"]="a", ["ầ"]="a", ["ẩ"]="a", ["ẫ"]="a", ["ậ"]="a",
        ["Á"]="A", ["À"]="A", ["Ả"]="A", ["Ã"]="A", ["Ạ"]="A",
        ["Ă"]="A", ["Ắ"]="A", ["Ằ"]="A", ["Ẳ"]="A", ["Ẵ"]="A", ["Ặ"]="A",
        ["Â"]="A", ["Ấ"]="A", ["Ầ"]="A", ["Ẩ"]="A", ["Ẫ"]="A", ["Ậ"]="A",

        ["é"]="e", ["è"]="e", ["ẻ"]="e", ["ẽ"]="e", ["ẹ"]="e",
        ["ê"]="e", ["ế"]="e", ["ề"]="e", ["ể"]="e", ["ễ"]="e", ["ệ"]="e",
        ["É"]="E", ["È"]="E", ["Ẻ"]="E", ["Ẽ"]="E", ["Ẹ"]="E",
        ["Ê"]="E", ["Ế"]="E", ["Ề"]="E", ["Ể"]="E", ["Ễ"]="E", ["Ệ"]="E",

        ["í"]="i", ["ì"]="i", ["ỉ"]="i", ["ĩ"]="i", ["ị"]="i",
        ["Í"]="I", ["Ì"]="I", ["Ỉ"]="I", ["Ĩ"]="I", ["Ị"]="I",

        ["ó"]="o", ["ò"]="o", ["ỏ"]="o", ["õ"]="o", ["ọ"]="o",
        ["ô"]="o", ["ố"]="o", ["ồ"]="o", ["ổ"]="o", ["ỗ"]="o", ["ộ"]="o",
        ["ơ"]="o", ["ớ"]="o", ["ờ"]="o", ["ở"]="o", ["ỡ"]="o", ["ợ"]="o",
        ["Ó"]="O", ["Ò"]="O", ["Ỏ"]="O", ["Õ"]="O", ["Ọ"]="O",
        ["Ô"]="O", ["Ố"]="O", ["Ồ"]="O", ["Ổ"]="O", ["Ỗ"]="O", ["Ộ"]="O",
        ["Ơ"]="O", ["Ớ"]="O", ["Ờ"]="O", ["Ở"]="O", ["Ỡ"]="O", ["Ợ"]="O",

        ["ú"]="u", ["ù"]="u", ["ủ"]="u", ["ũ"]="u", ["ụ"]="u",
        ["ư"]="u", ["ứ"]="u", ["ừ"]="u", ["ử"]="u", ["ữ"]="u", ["ự"]="u",
        ["Ú"]="U", ["Ù"]="U", ["Ủ"]="U", ["Ũ"]="U", ["Ụ"]="U",
        ["Ư"]="U", ["Ứ"]="U", ["Ừ"]="U", ["Ử"]="U", ["Ữ"]="U", ["Ự"]="U",

        ["ý"]="y", ["ỳ"]="y", ["ỷ"]="y", ["ỹ"]="y", ["ỵ"]="y",
        ["Ý"]="Y", ["Ỳ"]="Y", ["Ỷ"]="Y", ["Ỹ"]="Y", ["Ỵ"]="Y",

        ["đ"]="d", ["Đ"]="D",
    }

    return (str:gsub("[%z\1-\127\194-\244][\128-\191]*", function(c)
        return map[c] or c
    end))
end

function randomMailDomain()
    local firstname = getRandomLineInFile(currentPath() .. "/input/firstname.txt")
    local lastname = getRandomLineInFile(currentPath() .. "/input/lastname.txt")
    local fullname = lastname .. firstname
    local part1 = removeVietnameseTones(string.lower(fullname):gsub("%s+", ""))

    local digits = "0123456789"
    local part2 = ""
   
    for i = 1, 5 do
        local idx = math.random(1, #digits)
        part2 = part2 .. digits:sub(idx, idx)
    end

    local part3 = ""
    if MAIL_DOMAIN_TYPE == 1 then 
        part3 = "@yagisongs.com"
    elseif MAIL_DOMAIN_TYPE == 2 then 
        part3 = "@supermoney9x.com"
    elseif MAIL_DOMAIN_TYPE == 3 then 
        local arr = { "@yagisongs.com", "@supermoney9x.com" }
        part3 = arr[math.random(1, #arr)]
    end
    return part1 .. part2 .. part3
end

function randomGmail()
    local letters = "abcdefghijklmnopqrstuvwxyz"
    local digits = "0123456789"
    local part1, part2 = "", ""
    for i = 1, 12 do
        local idx = math.random(1, #letters)
        part1 = part1 .. letters:sub(idx, idx)
    end
    for i = 1, 5 do
        local idx = math.random(1, #digits)
        part2 = part2 .. digits:sub(idx, idx)
    end
    return part1 .. part2 .. "@gmail.com"
end

function randomIcloud()
    local letters = "abcdefghijklmnopqrstuvwxyz"
    local digits = "0123456789"
    local part1, part2 = "", ""
    for i = 1, 12 do
        local idx = math.random(1, #letters)
        part1 = part1 .. letters:sub(idx, idx)
    end
    for i = 1, 5 do
        local idx = math.random(1, #digits)
        part2 = part2 .. digits:sub(idx, idx)
    end
    return part1 .. part2 .. "@icloud.com"
end

function swipeForce(x1, y1, x2, y2, duration)
    duration = duration or 100000
    local steps = 30
    local sleepTime = duration / steps

    touchDown(1, x1, y1)
    for i = 1, steps do
        local xi = x1 + (x2 - x1) * i / steps
        local yi = y1 + (y2 - y1) * i / steps
        usleep(sleepTime)
        touchMove(1, xi, yi)
    end
    touchUp(1, x2, y2)
end

function swipeOld(x1, y1, x2, y2, duration)
    duration = duration or 200
    touchDown(0, x1, y1)
    usleep(50000)
    touchMove(0, x2, y2)
    usleep(duration * 1000)
    touchUp(0, x2, y2)
    usleep(100000)
end

function swipe(x1, y1, x2, y2, duration)
    duration = duration or 100
    local steps = math.random(12, 20)
    local sleepPerStep = math.floor(duration * 1000 / steps)

    touchDown(0, x1, y1)
    usleep( math.random(40000, 60000) )

    for i = 1, steps do
        local t = i / steps
        local x = x1 + (x2 - x1) * t
        local y = y1 + (y2 - y1) * t

        local jitterX = math.random(-1, 1)
        local jitterY = math.random(-1, 1)

        touchMove(0, x + jitterX, y + jitterY)
        usleep(sleepPerStep + math.random(-1000, 1000))
    end

    touchUp(0, x2, y2)
    usleep( math.random(80000, 120000) )
end

function swipeVertically(n)
    toast('swipeVertically')
    local x = math.random(5, 15)
    local x1 = math.random(200, 250)
    local y = math.random(850, 1150)
    local y1 = math.random(90, 115)
    local timecholuot = math.random(5000, 10000)
    for i = 1, n, 1 do
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

function getRandomSearchText(count)
    count = count or 3
    local searchtext = require("input/searchtext")
    local text = searchtext()
    if count > 10 then count = 10 end
    local shuffled = {}
    for i = 1, #text do shuffled[i] = text[i] end
    for i = #shuffled, 2, -1 do
        local j = math.random(1, i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
    local result = {}
    for i = 1, count do
        table.insert(result, shuffled[i])
    end
    return result
end

function pressHome()
    sleep(0.5)
    keyDown(KEY_TYPE.HOME_BUTTON)
    sleep(1)
    keyUp(KEY_TYPE.HOME_BUTTON)
    sleep(0.5)
end

function lockScreen()
    keyDown(KEY_TYPE.POWER_BUTTON);
    sleep(0.3)
    keyUp(KEY_TYPE.POWER_BUTTON);
end

function unlockScreen()
    keyDown(KEY_TYPE.POWER_BUTTON);
    sleep(0.3)
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

local function urlEncode(tbl)
    local t = {}
    for k, v in pairs(tbl) do
        table.insert(t, k .. "=" .. tostring(v):gsub("([^%w%.%-_])",
                     function(c) return string.format("%%%02X", string.byte(c)) end))
    end
    return table.concat(t, "&")
end

function httpRequest(params)
    if not params.url then
        error("URL là bắt buộc")
    end

    local method = params.method or "GET"
    local headers = params.headers or {}
    local data = params.data or nil
    local file = params.file or nil
    local timeout = params.timeout or 60
    local isForm = params.isForm or false
    local isEncodedParam = params.isEncodedParam or false
    local response = "" -- Khởi tạo biến chuỗi để lưu phản hồi

    local c = curl.easy {
        url = params.url,
        proxy = params.proxy or nil, 
        ssl_verifypeer = params.ssl_verifypeer or false,
        ssl_verifyhost = params.ssl_verifyhost or false,
        customrequest = method,
        followlocation = true,
        timeout = timeout,
        writefunction = function(chunk)
            response = response .. tostring(chunk) -- Đảm bảo `chunk` là chuỗi
            return #chunk
        end
    }

    -- Thêm headers
    local headerList = {}
    for key, value in pairs(headers) do
        table.insert(headerList, key .. ": " .. value)
    end

    c:setopt(curl.OPT_HTTPHEADER, headerList)

    -- Xử lý file nếu có
    if file then
        local post = curl.form()

        if file then
            local filePath = file
            local fileName = filePath:match("^.+/(.+)$")
            post:add_file("file", filePath, "application/octet-stream", fileName)
        end
        c:setopt(curl.OPT_HTTPPOST, post)

    -- Xử lý data json nếu có
    elseif data then
        if isForm then
            local post = curl.form()
            if data then
                for k, v in pairs(data) do
                    post:add_content(k, tostring(v))
                end
            end
            c:setopt(curl.OPT_HTTPPOST, post)
        elseif isEncodedParam then
            c:setopt(curl.OPT_POST, true)
            c:setopt(curl.OPT_POSTFIELDS, urlEncode(data))
        else
            c:setopt(curl.OPT_POST, true)
            c:setopt(curl.OPT_POSTFIELDS, jsonStringify(data))
        end
    end

    -- Thực hiện request
    local success, err = pcall(function()
        c:perform()
    end)

    -- Đóng curl
    c:close()
    collectgarbage()
    
    if not success then
        return nil, "Lỗi khi thực hiện request: " .. tostring(err)
    end

    return response, nil
end

function safeJsonDecode(raw, tag)
    tag = tag or "JSON"

    if type(raw) ~= "string" or raw == "" then
        local err = "Input is empty or not a string"
        log(("[%s] %s"):format(tag, err))
        return false, nil, err
    end

    local first = string.sub(raw, 1, 1)
    if first ~= "{" and first ~= "[" then
        local err = "Not valid JSON (doesn't start with { or [)"
        log(("[%s] %s -> %s"):format(tag, err, raw))
        return false, nil, err
    end

    local ok, decoded = pcall(json.decode, raw)
    if ok and decoded ~= nil then
        return true, decoded, nil
    else
        local err = decoded or "Unknown JSON decode error"
        log(("[%s] Decode failed: %s"):format(tag, err))
        return false, nil, err
    end
end

function typeText(text)
    if text == nil then return end
    usleep(300000)
    if checkImageIsExists(num_keyboard) then
        -- toastr('number keyboard')
        typeNumber(text)
    elseif checkImageIsExists(space_short) then
        -- toastr('short keyboard')
        -- typeTextShortSpace(text)
        inputText(text)
    else 
        -- toastr('long keyboard')
        -- typeTextLongSpace(text)
        inputText(text)
    end
    usleep(300000)
end

function typeTextShortSpace(text)
    local keymap = {
        q = {28, 948}, w = {102, 947}, e = {178, 946}, r = {254, 946}, t = {331, 945},
        y = {405, 951}, u = {481, 950}, i = {554, 947}, o = {629, 955}, p = {706, 952},
        a = {72, 1060}, s = {146, 1058}, d = {221, 1059}, f = {296, 1056}, g = {366, 1059},
        h = {443, 1056}, j = {523, 1059}, k = {592, 1054}, l = {671, 1053},
        z = {145, 1166}, x = {218, 1166}, c = {290, 1167}, v = {369, 1166}, b = {445, 1162},
        n = {522, 1166}, m = {595, 1163},
        [" "] = {317, 1282}
    }

    local shiftKey = {36, 1162}
    local numberToggleKey = {72, 1273}
    local symbolMap = {
        ["0"] = {704, 945}, ["1"] = {29, 947}, ["2"] = {105, 947}, ["3"] = {179, 946},
        ["4"] = {257, 954}, ["5"] = {328, 952}, ["6"] = {406, 953}, ["7"] = {479, 953},
        ["8"] = {557, 950}, ["9"] = {629, 950}, ["@"] = {422, 1282}, ["!"] = {467, 1165},
        ["."] = {180, 1180}
    }

    local function randomTap(pos)
        local x = math.random(-5, 5)
        local y = math.random(-5, 5)
        tap(pos[1] + x, pos[2] + y)
        usleep(math.random(200000, 300000))
    end

    local function tapSymbol(ch)
        randomTap(numberToggleKey)
        usleep(math.random(300000, 400000))
        randomTap(symbolMap[ch])
        usleep(math.random(200000, 300000))
        randomTap(numberToggleKey)
        usleep(math.random(300000, 400000))
    end

    if waitImageVisible(shift_keyboard_on, 1) then
        randomTap(shiftKey) -- click shift
        sleep(0.5)
    end

    for i = 1, #text do
        local ch = text:sub(i, i)
        local lowerCh = ch:lower()
        local isLower = ch == lowerCh
        local isUpper = ch ~= lowerCh

        if keymap[lowerCh] then
            if isUpper then
                randomTap(shiftKey) -- click shift
                usleep(math.random(600000, 800000))
            end

            randomTap(keymap[lowerCh])
        elseif symbolMap[ch] then
            tapSymbol(ch)
        elseif ch == " " then
            randomTap(keymap[" "])
        end
    end
end

function typeTextLongSpace(text)
    local keymap = {
        q = {28, 948}, w = {102, 947}, e = {178, 946}, r = {254, 946}, t = {331, 945},
        y = {405, 951}, u = {481, 950}, i = {554, 947}, o = {629, 955}, p = {706, 952},
        a = {72, 1060}, s = {146, 1058}, d = {221, 1059}, f = {296, 1056}, g = {366, 1059},
        h = {443, 1056}, j = {523, 1059}, k = {592, 1054}, l = {671, 1053},
        z = {145, 1166}, x = {218, 1166}, c = {290, 1167}, v = {369, 1166}, b = {445, 1162},
        n = {522, 1166}, m = {595, 1163},
        [" "] = {317, 1282}
    }

    local shiftKey = {36, 1162}
    local numberToggleKey = {72, 1273}
    local symbolMap = {
        ["0"] = {704, 945}, ["1"] = {29, 947}, ["2"] = {105, 947}, ["3"] = {179, 946},
        ["4"] = {257, 954}, ["5"] = {328, 952}, ["6"] = {406, 953}, ["7"] = {479, 953},
        ["8"] = {557, 950}, ["9"] = {635, 965}, ["@"] = {625, 1070}, ["!"] = {467, 1165},
        ["."] = {115, 1167}
    }

    local function randomTap(pos)
        local x = math.random(-5, 5)
        local y = math.random(-5, 5)
        tap(pos[1] + x, pos[2] + y)
        usleep(math.random(250000, 300000))
    end

    local function tapSymbol(ch)
        randomTap(numberToggleKey)
        usleep(math.random(350000, 400000))
        randomTap(symbolMap[ch])
        usleep(math.random(250000, 300000))
        randomTap(numberToggleKey)
        usleep(math.random(350000, 400000))
    end

    if waitImageVisible(shift_keyboard_on, 1) then
        randomTap(shiftKey) -- click shift
        sleep(0.5)
    end

    for i = 1, #text do
        local ch = text:sub(i, i)
        local lowerCh = ch:lower()
        local isLower = ch == lowerCh
        local isUpper = ch ~= lowerCh

        if keymap[lowerCh] then
            if isUpper then
                randomTap(shiftKey) -- click shift
                usleep(math.random(600000, 800000))
            end
            randomTap(keymap[lowerCh])
        elseif symbolMap[ch] then
            tapSymbol(ch)
        elseif ch == " " then
            randomTap(keymap[" "])
        end
    end
end

function typeNumber(so)
    stringSo = " " .. so;
    for i = 1, #stringSo do
        dayso = string.sub(stringSo, i, i);
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

function typeNumberLongSpace(text)
    sleep(0.5)
    local numberToggleKey = {72, 1273}
    local symbolMap = {
        ["0"] = {704, 945}, ["1"] = {29, 947}, ["2"] = {105, 947}, ["3"] = {179, 946},
        ["4"] = {257, 954}, ["5"] = {328, 952}, ["6"] = {406, 953}, ["7"] = {479, 953},
        ["8"] = {557, 950}, ["9"] = {635, 965}, ["@"] = {625, 1070}, ["!"] = {467, 1165},
        ["."] = {115, 1167}
    }

    local function randomTap(pos)
        local x = math.random(-5, 5)
        local y = math.random(-5, 5)
        tap(pos[1] + x, pos[2] + y)
        usleep(math.random(250000, 300000))
    end

    local function tapSymbol(ch)
        randomTap(symbolMap[ch])
        usleep(math.random(250000, 300000))
    end

    randomTap(numberToggleKey) sleep(0.5)
    for i = 1, #text do
        local ch = text:sub(i, i)

        if symbolMap[ch] then
            tapSymbol(ch)
        elseif ch == " " then
            randomTap(keymap[" "])
        end
    end
end

function getUIDFBLogin()
    local plist = require("plist")
    local result = appInfo("com.facebook.Facebook")
    local path = string.gsub(result["dataContainerPath"] .. "Library/Preferences/com.facebook.Facebook.plist",
        "file://", "")

    local luaTable = plist.read(path);

    return luaTable["kFBQPLLoggingPolicyLastKnownOwnerFbID"] or nil
end

function hasInternetConnection()
    -- local url = "https://api.ipify.org?v=" .. math.random(1, 65535)
    local url = 'https://icanhazip.com?format=json'

    local response, error = httpRequest { url = url }
    if response then
        reponse = string.gsub(response, "\n", "")
        toastr(response, 2)
        return true
    end
    return false
end


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

function onOffAirplaneMode2()
    appRun("com.apple.Preferences")
    if waitImageVisible(airplane_icon) then 
        if waitImageVisible(airplane_off) then
            local off = findImage(airplane_off[#airplane_off], 1, threshold, nil, DEBUG_IMAGE, 1)
            if #off > 0 then 
                local img = off[1]
                local x = img[1] local y = img[2] -- 375, 689 -> 625, 689
                press(x + 250, y) sleep(2) -- on air

                if waitImageVisible(airplane_on) then
                    local off = findImage(airplane_on[#airplane_on], 1, threshold, nil, DEBUG_IMAGE, 1)
                    if #off > 0 then 
                        local img = off[1]
                        local x = img[1] local y = img[2]
                        press(x + 250, y) sleep(2) -- off air
                    end
                end
            end 
        elseif waitImageVisible(airplane_on) then
            local off = findImage(airplane_on[#airplane_on], 1, threshold, nil, DEBUG_IMAGE, 1)
            if #off > 0 then 
                local img = off[1]
                local x = img[1] local y = img[2]
                press(x + 250, y) sleep(2) -- off air
            end
        end
        sleep(5)
    end 
end

function onOffAirplaneMode()
    appRun("com.apple.Preferences")
    if waitImageVisible(wifi_icon, 2) then 
        toast('wifi_icon')
        findAndClickByImage(wifi_icon)
        sleep(1)
    end 
    if waitImageVisible(wifi_on, 3) then 
        press(630, 250) sleep(2) -- off
        press(630, 250) sleep(3) -- on
    elseif waitImageVisible(wifi_off, 3) then
        press(630, 250) sleep(3) -- on
    end
end

function onOffAirplaneMode3()
    toastr('onOffAirplaneMode', 3)
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
    sleep(3)
end

function respring()
    sleep(1);
    io.popen('killall -9 SpringBoard');
    sleep(5);
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

function randomUSPhone()
    local area_codes = {
        ["New York"] = {"917", "929", "347"},
        ["California"] = {"213", "415", "818", "619", "323"},
        ["Florida"] = {"786", "954", "321"},
        ["Texas"] = {"832", "956", "469", "972"},
        ["Illinois"] = {"773", "872"},
        ["Georgia"] = {"678", "470"},
        ["Washington"] = {"360", "564"},
        ["Massachusetts"] = {"774", "857"},
        ["Arizona"] = {"602", "623"},
        ["Hawaii"] = {"808"},
        ["Utah"] = {"385"}
    }

    local function randomMobileNXX()
        local nxx
        repeat
            local first = math.random(2, 9)
            local second = math.random(0, 9)
            local third = math.random(0, 9)
            nxx = string.format("%d%d%d", first, second, third)
        until nxx ~= "555" and nxx ~= "911" and nxx ~= "411" and nxx ~= "000"
        return nxx
    end

    local function randomLineNumber()
        return string.format("%04d", math.random(0, 9999))
    end

    local function randomPhone()
        local states = {}
        for state in pairs(area_codes) do table.insert(states, state) end
        local randomState = states[math.random(#states)]
        local codes = area_codes[randomState]
        local areaCode = codes[math.random(#codes)]

        local prefixes = {"+1", ""}
        local prefix = prefixes[math.random(#prefixes)]

        local phone = prefix .. areaCode .. randomMobileNXX() .. randomLineNumber()
        return phone
    end

    return randomPhone()
end

function randomVNPhone()
    local area_codes = {
        ["Viettel"] = {"32", "33", "34", "35", "36", "37", "38", "39"},
        ["MobiFone"] = {"70", "76", "77", "78", "79"},
        ["VinaPhone"] = {"81", "82", "83", "84", "85"},
        ["Vietnamobile"] = {"56", "58"},
        ["Gmobile"] = {"59"},
        ["Khac"] = {"86", "88", "89"}
    }

    local function randomMobileNXX()
        return string.format("%07d", math.random(0, 9999999))
    end

    local function randomPhone()
        local telcos = {}
        for telco in pairs(area_codes) do table.insert(telcos, telco) end
        local randomTelco = telcos[math.random(#telcos)]
        local codes = area_codes[randomTelco]
        local areaCode = codes[math.random(#codes)]

        local prefixes = {"+84", "0"}
        local prefix = prefixes[math.random(#prefixes)]

        local phone = prefix .. areaCode .. randomMobileNXX()
        return phone
    end

    return randomPhone()
end

function hasUppercase(email)
    local count = 0
    for i = 1, #email do
        local char = email:sub(i, i)
        if char:match("%u") then
            count = count + 1
            if count >= 1 then
                return true
            end
        end
    end
    return false
end
