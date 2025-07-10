require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

homeAndUnlockScreen()
swipeCloseApp()

local dirPath = currentDir() .. "/images/"
general_icon = {dirPath .. "general_icon.png"}
general_back = {dirPath .. "general_back.png"}
setting_back = {dirPath .. "setting_back.png", dirPath .. "setting_back2.png"}
setting_spanish = {dirPath .. "setting_spanish.png"}
setting_english = {dirPath .. "setting_english.png"}
english_us = {dirPath .. "english_us.png"}
result_english = {dirPath .. "result_english.png"}
result_spanish = {dirPath .. "result_spanish.png"}
region_setting = {dirPath .. "region_setting.png", dirPath .. "region_setting2.png"}
keyboard_setting = {dirPath .. "keyboard_setting.png", dirPath .. "keyboard_setting2.png"}

toastr('setup English')
appRun("com.apple.Preferences") 

if waitImageVisible(setting_english, 2) then goto label_finish end

if waitImageVisible(general_back, 2) then 
    press(100, 90) sleep(1) -- back
    press(100, 90) -- back 2
end 

if waitImageVisible(setting_back, 2) then 
    press(100, 90) -- back 
end 

if waitImageVisible(setting_english, 2) then goto label_finish end

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
    typeText('es') sleep(1)

    if waitImageVisible(english_us) then 
        findAndClickByImage(english_us) 
        sleep(2)
        press(350, 1130) sleep(10) -- confirm switch lang

        if waitImageVisible(result_english, 30) then 
            toast('English', 3)
            press(100, 90) sleep(1) -- back
            press(100, 90) -- back 2
            goto label_finish
        end 
    else 
        press(100, 430) -- first region
    end 
end

toast('FAILED...', 10)
exit()

::label_finish::
toast('-----English-----', 10)
exit()
