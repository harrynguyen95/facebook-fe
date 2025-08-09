require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

::label_start::
homeAndUnlockScreen()
swipeCloseApp()
toastr('respringAutotouch')

local dirPath = currentDir() .. "/images/"
att_icon = {dirPath .. "att_icon.png"}
att_respring = {dirPath .. "att_respring.png"}

if waitImageVisible(att_icon) then 
    findAndClickByImage(att_icon) sleep(2)
    press(640, 1280) sleep(1) -- btn setting
    swipe(600, 600, 610, 400) sleep(2)
    if waitImageVisible(att_respring) then 
        findAndClickByImage(att_respring) sleep(1)
        press(500, 790)
    else 
        goto label_start
    end 
else 
    alert('Not found Logo Att in home')
end 

-- usleep(math.random(1000000, 2000000));
-- io.popen('killall -9 SpringBoard');
-- usleep(math.random(3000000, 4000000));
