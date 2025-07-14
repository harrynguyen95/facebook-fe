require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

LOCAL_SERVER = nil
DESTINATION_FILENAME = nil
getConfigServer()

if not LOCAL_SERVER or not DESTINATION_FILENAME then 
    alert('empty LOCAL_SERVER or DESTINATION_FILENAME')
    exit()
end 
if LOCAL_SERVER:sub(-1) == "/" then LOCAL_SERVER = text:sub(1, -2) end
local destination = rootDir() .. "/Device/".. DESTINATION_FILENAME

function getSourceFileContent() 
    local localIP = readFile(localIPFilePath)
    local localName = localIP[#localIP]

    if localName == nil then 
        toastr('No local device name.', 2)
        return false
    end 
    local splitted = split(localName, "|")

    local postData = {
        ['localIP']   = string.gsub(splitted[3], " ", ""),
    }

    local tries = 2
    for i = 1, tries do 
        local response, error = httpRequest {
            url = LOCAL_SERVER .. "/api/get_source_file_content",
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
                    return response.data
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
            log("Failed request device_config. Times ".. i ..  " - " .. tostring(error))
        end
    end
end 

local lines = getSourceFileContent() 
if lines and lines[#lines] ~= nil then
    for i, v in ipairs(lines) do
        addLineToFile(destination, v)
    end
end 

-- Lọc line trùng
local inputPath = destination
local outputPath = inputPath  

local uniqueLines = {}
local seen = {}

local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

for line in io.lines(inputPath) do
    local clean = trim(line)
    if clean ~= "" and not seen[clean] then
        table.insert(uniqueLines, clean)
        seen[clean] = true
    end
end

local f = io.open(outputPath, "w")
for _, line in ipairs(uniqueLines) do
    f:write(line .. "\n")
end
f:close()

