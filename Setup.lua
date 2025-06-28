

toast(rootDir())
usleep(1000000)

-- local cmd = "ls -la " .. rootDir() .. " > " .. currentDir() .. "/terminal_log.txt"
-- io.popen(cmd)

local repoDir = rootDir() .. '/facebook-fe'
local gitUrl = "https://github.com/harrynguyen95/facebook-fe.git"

-- local cmd = "cd " .. repoDir .. " && git clone " .. gitUrl 
local cmd = "cd " .. repoDir .. " && git pull " 

local f = io.popen(cmd)
local output = f:read("*a")
f:close()

-- In kết quả nếu muốn debug
print(output)

usleep(2000000)
