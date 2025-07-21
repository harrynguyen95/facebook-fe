require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

homeAndUnlockScreen()

toast('Deleting..', 5)
clearSystemAlbum()

sleep(5)
openURL("photos-redirect://")
sleep(2)
toast('Done.')
