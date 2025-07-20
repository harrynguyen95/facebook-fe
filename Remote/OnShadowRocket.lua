require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

local dirPath = currentDir() .. "/images/"
shadowrocket_logo = {dirPath .. "shadowrocket_logo.png"}
shadowrocket_on = {dirPath .. "shadowrocket_on.png"}
shadowrocket_off = {dirPath .. "shadowrocket_off.png"}

toastr('OnShadowRocket')
openURL("shadowrocket://route/proxy")
sleep(1)

if waitImageVisible(shadowrocket_logo, 5) then
    if waitImageVisible(shadowrocket_on, 1) then 
        findAndClickByImage(shadowrocket_on) sleep(1)
        findAndClickByImage(shadowrocket_off)
    elseif waitImageVisible(shadowrocket_off, 1) then
        findAndClickByImage(shadowrocket_off)
    end
    toastr('OnShadowRocket', 5)
    sleep(3)
end
