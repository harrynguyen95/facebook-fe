-- usleep(math.random(1000000, 2000000));
-- io.popen('killall -9 SpringBoard');
-- usleep(math.random(3000000, 4000000));

require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

homeAndUnlockScreen()
swipeCloseApp()

local dirPath = currentDir() .. "/images/"
xoainfo_reset_data = {dirPath .. "xoainfo_reset_data.png"}

toastr('respringXoainfo')
appRun("com.ienthach.XoaInfo")
sleep(1)

if waitImageVisible(xoainfo_reset_data, 10) then
    press(700, 80) -- menu xoainfo
    sleep(1)
    press(450, 410) -- menu Add on
    sleep(1)
    swipe(600, 800, 610, 560) 
    sleep(1)
    swipe(600, 750, 610, 520) 
    sleep(2)
    press(380, 740) -- respring button
end
