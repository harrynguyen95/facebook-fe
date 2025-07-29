require(rootDir() .. '/Facebook/src/utils')
require(rootDir() .. '/Facebook/src/functions')

homeAndUnlockScreen()

local dirPath = currentDir() .. "/images/"
xoainfo_reset_data = {dirPath .. "xoainfo_reset_data.png"}
xoainfo_info_fake = {dirPath .. "xoainfo_info_fake.png"}

toastr('executeXoaInfo')
appRun("com.ienthach.XoaInfo")
sleep(1)

if waitImageVisible(xoainfo_reset_data, 10) then
    findAndClickByImage(xoainfo_reset_data)
    sleep(1)
    
    if waitImageVisible(xoainfo_info_fake, 30) then
        toast('Finish...', 5)
    end
end
