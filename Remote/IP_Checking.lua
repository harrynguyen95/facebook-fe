require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')
require(rootDir() .. "/Facebook/images_vn")

homeAndUnlockScreen()

::label_continue::
onOffAirplane()
sleep(3)

local localIP = readFile(localIPFilePath)
local localName = localIP[#localIP]

if localName == nil then 
    toastr('No local device name.', 2)
    return false
end 
local splitted = split(localName, "|")
local device = splitted[1] .. " | " .. splitted[3]
local username = string.gsub(splitted[2], " ", "")

local ip_address = nil

function callCheckIP()
    local response, error = httpRequest { url = 'https://ipv4.icanhazip.com' }
    toast('v4 check: ' .. (response or '-'), 2)
    sleep(2)
    if response then
        ip_address = string.gsub(response, "\n", ""),
        sleep(0.5)
        toastr(ip_address, 2)
        return true
    end 

    sleep(3)
    local response, error = httpRequest { url = 'https://ipv4.icanhazip.com' }
    toast('v4 check: ' .. (response or '-'), 2)
    sleep(2)
    if response then
        ip_address = string.gsub(response, "\n", ""),
        sleep(0.5)
        toastr(ip_address, 2)
        return true
    else 
        local response, error = httpRequest { url = 'https://ipv6.icanhazip.com' }
        toast('v6 check: ' .. (response or '-'), 2)
        sleep(2)
        if response then
            ip_address = string.gsub(response, "\n", ""),
            sleep(0.5)
            toastr(ip_address, 2)
            return true
        end 
    end
    return false
end
callCheckIP()

if ip_address ~= nil then 
    local postData = {
        ['username'] = username,
        ['device'] = device,
        ['ip_address'] = ip_address,
    }

    local tries = 1
    for i = 1, tries do 
        local response, error = httpRequest {
            url = "https://tuongtacthongminh.com/reg_clone/ip_checkings.php",
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json",
            },
            data = postData
        }

        if response then
            log(response)    
            toastr(response)    
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request device_config. Times ".. i ..  " - " .. tostring(error))
        end
        sleep(3)
    end
end 

sleep(2)
toastr('Next..', 2)
sleep(2)
goto label_continue
