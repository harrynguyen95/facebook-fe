require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

homeAndUnlockScreen()
swipeCloseApp()

if not waitForInternet(5) then
toast('No Internet...', 10)
--     alert([[
-- +----------------------+
-- |                                           |
-- |          No Internet!          |
-- |                                           |
-- +----------------------+]])
else 
--     alert([[
-- +----------------------+
-- |                                           |
-- |                  OK                  |
-- |                                           |
-- +----------------------+]])
toast('-----OK-----', 10)
end

exit()
