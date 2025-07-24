require(rootDir() .. '/Facebook/utils')
require(rootDir() .. '/Facebook/functions')

toastr('onOffAirplaneMode', 3)
io.popen("activator send switch-off.com.a3tweaks.switch.vpn")
sleep(0.5)
io.popen('activator send switch-on.com.a3tweaks.switch.airplane-mode');
sleep(0.5)
io.popen('activator send switch-on.com.a3tweaks.switch.airplane-mode');
sleep(0.5)
io.popen('activator send switch-off.com.a3tweaks.switch.airplane-mode');
sleep(0.5)
io.popen('activator send switch-off.com.a3tweaks.switch.airplane-mode');
sleep(0.5)
io.popen('activator send switch-off.com.a3tweaks.switch.wifi');
sleep(0.5)
io.popen('activator send switch-off.com.a3tweaks.switch.wifi');
sleep(0.5)
io.popen('activator send switch-on.com.a3tweaks.switch.cellular-data');
sleep(0.5)
sleep(3)
