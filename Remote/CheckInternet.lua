require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

homeAndUnlockScreen()

if not waitForInternet(5) then
    alert([[
+----------------------+
|                                           |
|          No Internet!          |
|                                           |
+----------------------+]])
else 
    alert([[
+----------------------+
|                                           |
|                  OK                  |
|                                           |
+----------------------+]])
end

exit()
