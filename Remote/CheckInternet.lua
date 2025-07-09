require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

homeAndUnlockScreen()
swipeCloseApp()

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
