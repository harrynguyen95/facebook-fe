require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

homeAndUnlockScreen()

local dirPath = currentDir() .. "/images/"
general_icon = {dirPath .. "general_icon.png"}
general_back = {dirPath .. "general_back.png", dirPath .. "general_back3.png"}
setting_back = {dirPath .. "setting_back.png", dirPath .. "setting_back2.png", dirPath .. "setting_back3.png"}
setting_vietnamese = {dirPath .. "setting_vietnamese2.png"}
vietnamese_vn = {dirPath .. "vietnamese_vn.png"}
result_vietnamese = {dirPath .. "result_vietnamese.png"}
region_setting = {dirPath .. "region_setting.png", dirPath .. "region_setting2.png", dirPath .. "region_setting3.png"}
keyboard_setting = {dirPath .. "keyboard_setting.png", dirPath .. "keyboard_setting2.png"}

toastr('setup Vietnamese')
appRun("com.apple.Preferences") 

if waitImageVisible(setting_vietnamese, 2) then goto label_finish end

if waitImageVisible(general_back, 2) then 
    press(100, 90) sleep(1) -- back
    press(100, 90) -- back 2
end 

if waitImageVisible(setting_back, 2) then 
    press(100, 90) -- back 
end 

if waitImageVisible(setting_vietnamese, 2) then goto label_finish end

swipe(600, 200, 610, 600) 
sleep(1)
swipe(600, 700, 610, 600) 
sleep(2)

toast('general_icon')
if waitImageVisible(general_icon) then
    findAndClickByImage(general_icon) sleep(1)

    swipe(600, 750, 610, 500) 
    sleep(2)

    findAndClickByImage(region_setting) sleep(1) -- go to region setting
    press(100, 250) sleep(1) -- select lang
    press(100, 230) sleep(1) -- input lang
    typeText('vi') sleep(1)

    if waitImageVisible(vietnamese_vn) then 
        findAndClickByImage(vietnamese_vn) 
        sleep(2)
        press(350, 1130) sleep(10) -- confirm switch lang

        if waitImageVisible(result_vietnamese, 30) then 
            toast('Vietnamese', 3)
            press(100, 90) sleep(1) -- back
            press(100, 90) -- back 2
            goto label_finish
        end 
    else 
        press(100, 430) -- first region
        sleep(2)
        press(350, 1130) sleep(10) -- confirm switch lang

        if waitImageVisible(result_vietnamese, 30) then 
            toast('Vietnamese', 3)
            press(100, 90) sleep(1) -- back
            press(100, 90) -- back 2
            goto label_finish
        end 
    end 
end

toast('FAILED...', 10)
exit()

::label_finish::
toast('-----Vietnamese-----', 10)
exit()
