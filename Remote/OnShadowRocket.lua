require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

local dirPath = currentDir() .. "/images/"
shadowrocket_logo = {dirPath .. "shadowrocket_logo.png"}
shadowrocket_on = {dirPath .. "shadowrocket_on.png"}
shadowrocket_off = {dirPath .. "shadowrocket_off.png"}

toastr('OnShadowRocket')
openURL("shadowrocket://")

if waitImageVisible(shadowrocket_logo) then
    if waitImageVisible(shadowrocket_on) then 
        findAndClickByImage(shadowrocket_on) sleep(1)
        findAndClickByImage(shadowrocket_off)
    elseif waitImageVisible(shadowrocket_off) then
        findAndClickByImage(shadowrocket_off)
    end
    toastr('OnShadowRocket', 5)
    sleep(3)
end
