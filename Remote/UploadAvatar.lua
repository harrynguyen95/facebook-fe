require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

homeAndUnlockScreen()

function saveRandomServerAvatar()
    toast('saveRandomServerAvatar', 3)

    local url = PHP_SERVER .. "random_avatar.php"
    local filename = "avatar_" .. os.time() .. ".jpg"
    local save_path = "/var/mobile/Media/DCIM/100APPLE/" .. filename

    local f = io.open(save_path, "wb")
    if not f then
        print("❌ Không thể mở file để ghi: " .. save_path)
        return
    end

    curl.easy{
        url = url,
        writefunction = function(buffer)
            f:write(buffer)
            return #buffer
        end
    }:perform()

    f:close()

    saveToSystemAlbum(save_path);
    sleep(3)
end

toast('Deleting..', 5)
clearSystemAlbum()
sleep(5)

for i = 1, 20 do
    saveRandomServerAvatar()
end

openURL("photos-redirect://")
sleep(2)
toast('Done.')
