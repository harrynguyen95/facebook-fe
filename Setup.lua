

toast(currentDir())
usleep(1000000)

local cmd = "ls -la " .. currentDir() .. " > " .. currentDir() .. "/terminal_log.txt"
io.popen(cmd)

usleep(2000000)
