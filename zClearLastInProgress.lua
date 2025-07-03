local path = rootDir() .. "/Device/accounts.txt"

local function removeLastIfInProgress(filePath)
    local fh = io.open(filePath, "r")
    if not fh then
        error("Không mở được file: " .. filePath)
    end

    local lines = {}
    for line in fh:lines() do
        table.insert(lines, line)
    end
    fh:close()

    if #lines > 0 and lines[#lines]:find("INPROGRESS") then
        table.remove(lines)   
        fh = io.open(filePath, "w")
        for i, l in ipairs(lines) do
            fh:write(l)
            if i < #lines then
                fh:write("\n")
            end
        end
        fh:close()
        print("Đã xoá dòng cuối chứa 'INPROGRESS'.")
    else
        print("Dòng cuối không chứa 'INPROGRESS' – không thay đổi gì.")
    end
end

function homeAndUnlockScreen()
    toast("Check Unlock Screen")

    local i = 0
    while true do
        i = i + 1
        if getColor(711, 17) == 16777215 and i > 3 then
            break
        end
        if i > 5 then
            lockAndUnlockScreen()
            i = 0
        end

        keyDown(KEY_TYPE.HOME_BUTTON)
        keyUp(KEY_TYPE.HOME_BUTTON)
        sleep(1)
    end
end

removeLastIfInProgress(path)
homeAndUnlockScreen()
