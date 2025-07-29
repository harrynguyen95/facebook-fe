require(rootDir() .. '/Facebook/src/utils')
require(rootDir() .. '/Facebook/src/functions')

LOCAL_SERVER = nil
DESTINATION_FILENAME = nil
getConfigServer()

if not LOCAL_SERVER or not DESTINATION_FILENAME then 
    alert('empty LOCAL_SERVER or DESTINATION_FILENAME')
    exit()
end 
if LOCAL_SERVER:sub(-1) == "/" then LOCAL_SERVER = text:sub(1, -2) end
local destination = rootDir() .. "/Device/".. DESTINATION_FILENAME

function execute() 
    local localIP = readFile(localIPFilePath)
    local localName = localIP[#localIP]

    if localName == nil then 
        toastr('No local device name.', 2)
        return false
    end 
    local splitted = split(localName, "|")

    local sourceFile = readFile(destination)

    local postData = {
        ['localIP']   = string.gsub(splitted[3], " ", ""),
        ['countLine'] = #sourceFile,
    }

    local tries = 2 
    for i = 1, tries do 
        local response, error = httpRequest {
            url = LOCAL_SERVER .. "/api/count_line_source_file",
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json",
            },
            data = postData
        }

        if response then
            local ok, response, err = safeJsonDecode(response)
            if ok then 
                if response.status and response.status == 'success' then
                    toast('Line: ' .. #sourceFile, 5)
                    -- return response.data
                else
                    toastr(response.info)
                    log(response.info)
                end
            else 
                toastr("Failed decode response.");
                log("Failed decode response.");
            end  
        else
            toastr('Times ' .. i .. " - " .. tostring(error), 2)
            log("Failed request count_line_source_file. Times ".. i ..  " - " .. tostring(error))
        end
    end
end 

execute() 
