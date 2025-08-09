require('functions')

-- is_on = {currentPath() .. "/images/is_on.png", currentPath() .. "/images/is_on2.png"}
-- is_off = {currentPath() .. "/images/is_off.png"}

-- if checkImageIsExists(is_off) then
--     findAndClickByImage(is_off)
-- end

-- if checkImageIsExists(is_on) then
--     findAndClickByImage(is_on)
-- end



    -- openURL("App-Prefs:root=General&path=VPN")
-- openURL("shadowrocket://connect")
-- appKill("com.liguangming.Shadowrocket")
-- sleep(2)
-- openURL("shadowrocket://disconnect")
-- useProxyRootless('27.69.239.71:27669')
-- openURL("shadowrocket://connect")
-- appKill("com.liguangming.Shadowrocket")
-- sleep(2)
-- openURL("shadowrocket://disconnect")
-- useProxyRootless('27.69.239.71:27669')
-- copyText("socks://user-gmail_O9zzK:Gmail123@pr.lunaproxy.com:12233")
-- useProxyRootless(getNewProxy())
-- wipeapp("com.liguangming.Shadowrocket")
-- openURL("shadowrocket://disconnect")
-- appKill("com.liguangming.Shadowrocket")
-- openURL("shadowrocket://connect")



-- Tạo array
-- local packages = {
--     "com.google.Maps",
--     "com.google.Gmail",
--     "com.google.GoogleMobile",
--     "com.google.FamilyLink",
--     "com.google.Docs",
--     "com.google.Translate",
--     "com.google.GoogleDigitalEditions",
--     "com.google.Sheets",
--     "com.google.Classroom",
--     "com.google.calendar",
--     "com.google.Dynamite",
--     "com.google.fit",
--     "com.google.photos"
-- }

-- -- Random lấy 1 package
-- math.randomseed(os.time())
-- local randomIndex = math.random(1, #packages)
-- local selectedPackage = packages[randomIndex]

-- -- In ra
-- print("Selected package: " .. selectedPackage)

-- -- Nếu bạn muốn dùng ngay
-- -- appActivate('com.google.photos')

-- local result = appInfo(selectedPackage, 0)

-- print(table.tostring(result))
-- print(result.displayName)

-- tap(746, 1280)
-- for j = 1, 10, 1 do
--     print(getColor(746, 1280))
--                 if getColor(746, 1280) == 8962290 then
--                     tap(808, 1289)
--                     sleep(0.016)
--                     break
--                 end
--                 sleep(1)
--             end


local response, err = httpRequest {
        url = "https://hihi.thuemails.com/api/login-jobs",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json"
        },
        data = {
            ["fb_email"] = "b44c15f6eb80fbc",
            ["fb_password"] = "b44c15f6eb80fbc",
            ["fb_2fa_code"] = "b44c15f6eb80fbc"
        }
    }

    if response then
        toast("Request sent successfully!", 5)
    else
        toast("Error: Failed to send request.", 3)
    end