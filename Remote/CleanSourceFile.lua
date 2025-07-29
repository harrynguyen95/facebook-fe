require(rootDir() .. '/Facebook/src/utils')
require(rootDir() .. '/Facebook/src/functions')

DESTINATION_FILENAME = nil
getConfigServer()

if not DESTINATION_FILENAME then 
    alert('empty DESTINATION_FILENAME')
    exit()
end 
local destination = rootDir() .. "/Device/".. DESTINATION_FILENAME

local file = io.open(destination, "w")
if file then
    file:close() 
else
    log("CleanSourceFile - Không thể mở file để xóa nội dung.")
end

