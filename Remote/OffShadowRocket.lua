require(rootDir() .. '/Facebook/src/utils')
require(rootDir() .. '/Facebook/src/functions')

local dirPath = currentDir() .. "/images/"
shadowrocket_logo = {dirPath .. "shadowrocket_logo.png"}
shadowrocket_on = {dirPath .. "shadowrocket_on.png"}
shadowrocket_off = {dirPath .. "shadowrocket_off.png"}

toastr('OffShadowRocket')
openURL("shadowrocket://")

if waitImageVisible(shadowrocket_logo) then
    if waitImageVisible(shadowrocket_on) then 
        findAndClickByImage(shadowrocket_on)
    end
    toastr('OffShadowRocket', 5)
    sleep(3)
end
