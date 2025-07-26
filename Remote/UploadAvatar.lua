require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

-- homeAndUnlockScreen()
function fileExists(path)
    local f = io.open(path, "rb")
    if f then
        f:close()
        return true
    end
    return false
end
function saveRandomServerAvatar()
    toast('Đang tải avatar...', 2)

    local url = PHP_SERVER .. "random_avatar.php"
    local filename = "avatar_" .. os.time() .. ".jpg"
    local save_path = "/var/mobile/Media/DCIM/100APPLE/" .. filename

    local ok = false
    local f = io.open(save_path, "wb")
    if not f then
        print("❌ Không thể mở file để ghi: " .. save_path)
        return
    end

    local c = curl.easy{
        url = url,
        writefunction = function(buffer)
            if buffer then
                f:write(buffer)
                return #buffer
            else
                return 0
            end
        end,
        ssl_verifyhost = 0,
        ssl_verifypeer = 0,
        timeout = 15, -- tránh treo lâu quá
    }

    local ok, err = pcall(function()
        c:perform()
    end)

    f:close()

    if not ok then
        print("❌ Tải ảnh lỗi: " .. tostring(err))
        return
    end

    -- Đợi file ghi xong, đảm bảo hệ thống thấy
    usleep(500000) -- 0.5s

    if fileExists(save_path) then
        saveToSystemAlbum(save_path)
        toast("✅ Lưu avatar thành công!", 2)
    else
        print("❌ File không tồn tại sau khi tải")
    end

    sleep(3)
end

-- toast('Deleting..', 5)
-- clearSystemAlbum()
-- sleep(5)

saveRandomServerAvatar()

-- for i = 1, 10 do
--     toast('Images ' .. i, 1) sleep(1)
--     saveRandomServerAvatar()
-- end

-- openURL("photos-redirect://")
-- sleep(2)
toast('Done.')
