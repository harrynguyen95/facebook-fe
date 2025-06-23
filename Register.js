const QR_CODE_SERVER = "https://tuongtacthongminh.com";
const MAIL_API_KEY = "94a3a21c-40b5-4c48-a690-f1584c390e3e";
const MAIL_THUEMAIL_DOMAIN = "https://api.thuemails.com/api/";
const MAIL_BUILUC_DOMAIN = "http://mail.builuc1998.com/"

const axios = require("axios");
require("utils");

var thuemailId = null;
var mail = "";
var password = "";
var twoFA = "";
var profileUid = "";
const mailYagisongs = randomEmailYagisongs()

// thuemailId = 2200
// mail = 'porteralecqb7064@gmail.com'
// password = 'lzKfkVVe'

var terminateApp = false;

// FEATURE FUNCTION
function openFacebook() {
    log('----------------------------------------------------------')
    log("-> Mail yagisongs: " + mailYagisongs);

    pressHome();

    if (hasImage("fb_logo_2.png") || hasText("facebook")) {
        tapImage("fb_logo_2.png");
        wait(3);

        press(380, 250)
        wait(1)
    }

    if (hasText("Create new account")) {
        tapText("Create new account");
        wait(5);
    } else {
        logoutAndRemoveAccount()
        check282Checkpoint()
    }

    wait(2);
    if (hasImage("join_facebook.png", 8) || hasImage("create_account_blue.png", 8) || hasText("Get started")) {
        hasImage("create_account_blue.png", 1) ? tapImage("create_account_blue.png") : null;
        hasText("Get started", 1) ? tapText("Get started") : null;
        wait(2);
    }
}

function setFirstName() {
    log('setFirstName()')
    toast('setFirstName()', 3, 'top')

    wait(3)
    if (hasText("What's your name?")) {
        const [first, last] = getRandomName();
        wait(1);

        press(140, 380);
        wait(1);
        typeText(first);
        wait(1);

        press(500, 380);
        wait(1);
        typeText(last);
        wait(1);

        tapImage("next.png");
        wait(3);
    }
}

function setBirthday() {
    log('setBirthday()')
    toast('setBirthday()', 3, 'top')

    wait(2)
    if (hasText("What's your birthday?"), 15) {
        press(200, 470);
        wait(1);

        const x_day = 150,
            y_day = 1120;
        const x_month = 400,
            y_month = 1120;
        const x_year = 550,
            y_year = 1120;

        const [day, month, year] = randomDOB();
        const [d, m, y] = getToday();

        log([day, month, year])
        log([d, m, y])

        press(x_year, y_year);
        selectDobValue(x_year, y_year, year, y);
        wait(1);

        press(x_month, y_month);
        selectDobValue(x_month, y_month, month, m, 'month');
        wait(1);

        press(x_day, y_day);
        selectDobValue(x_day, y_day, day, d);
        wait(2);

        tapImage("next.png");
        wait(3);
    }
}

function setGender() {
    log('setGender()')
    toast('setGender()', 3, 'top')

    wait(2)
    if (hasText("What's your gender?", 10)) {
        const x = 590;
        let y = 420;

        const xRandom = Math.floor(Math.random() * 2) + 1;
        if (xRandom === 2) {
            y = 520;
        }

        wait(1);
        press(x, y);
        wait(1);

        tapImage("next.png");
        wait(3);
    }
}

function signUpEmail() {
    log('signUpEmail()')
    toast('signUpEmail()', 10, 'top')

    if (hasText("What's your mobile number?")) {
        tapText("Sign up with email");
        wait(2);
    }

    if (hasText("What's your email?", 10)) {
        wait(1);

        isBreak = false;
        const postData = {
            api_key: MAIL_API_KEY,
            provider_id: 1,
            service_id: 1,
            quantity: 1,
        };
        for (let i = 1; i <= 5; i++) {
            toast("Request times: " + i, 3, "bottom");
            wait(1);
            axios
                .post(MAIL_THUEMAIL_DOMAIN + "rentals" + "?api_key=" + MAIL_API_KEY, postData)
                .then(function (response) {
                    const res = response.data;
                    if (res.data.length > 0) {
                        const selected = res.data[0];
                        if (selected) {
                            mail = selected.email;
                            thuemailId = selected.id;

                            isBreak = true;
                        } else {
                            toast("Register new mail failed, times: " + i);
                        }
                    } else {
                        toast("Empty response post register new mail.");
                    }
                })
                .catch(function (error) {
                    toast("Failed to make http request, error: " + error.message);
                    log(error.message, "Failed to make http request, error: ");
                });

            wait(3);
            if (isBreak) break;
        }

        wait(10);
        toast(mail || '-No mail.', 4);
        log("-> Mail: " + mail + " thuemail_id: " + thuemailId);

        if (!mail) {
            toast('Not found mail, Back.', 5, 'bottom')
            backWhenNotMail()
            terminateApp = true
            return;
        } else {
            press(110, 410);
            wait(1);
            typeText(mail);
            wait(1);
            tapImage("next.png");
            wait(5);
        }
    }
}

function setPassword() {
    if (terminateApp) return

    log('setPassword()')
    toast('setPassword()', 5, 'top')

    wait(8);
    if (hasText("Create a password")) {
        wait(1);
        press(120, 450);
        wait(1);

        password = randomPassword();
        wait(1);

        typeText(password);
        log("-> Mail: " + mail + " password: " + password);
        wait(1);

        tapImage("next.png");
        wait(5);
    }

    wait(3)
    if (hasText("Save your login info?", 8)) {
        tapText("Not now");
        wait(2);
    }

    if (hasText("Don't Allow")) {
        tapText("Don't Allow");
        wait(1);
    }

    wait(1);
    if (hasText("I agree")) {
        tapText("I agree");
        wait(20);
    }

    if (hasText("You might already have a")) {
        tapText("Choose defferent account");
        wait(2);

        if (hasText("Find another account?")) {
            tapText("Create a new account");
            wait(5);
        }
    }
}

function setConfirmationCode() {
    if (terminateApp) return

    log('setConfirmationCode()')
    toast('setConfirmationCode()', 5, 'top')

    wait(5);
    if (hasText("Enter the confirmation code", 10)) {

        toast("Wait code mail...", 3);
        if (mail && thuemailId) {
            isBreak = false;
            let isMailActive = null;
            for (let i = 1; i <= 10; i++) {

                toast("Request times: " + i, 3, "bottom");
                axios
                    .get(MAIL_THUEMAIL_DOMAIN + "rentals/" + thuemailId + "?api_key=" + MAIL_API_KEY)
                    .then(function (response) {
                        const res = response.data;
                        isMailActive = res.status
        
                        if (res.id && res.otp) {
                            isBreak = true;

                            wait(1);
                            press(130, 410);
                            wait(1);
                            typeText(res.otp);
                            wait(1);
                            tapImage("next.png");
                            wait(3)
                        } else {
                            toast("Empty OTP code, times: " + i);
                        }
                    })
                    .catch(function (error) {
                        toast("Failed to make http request, error: " + error.message);
                        log(error.message, "Failed to make http request, error: ");
                    });

                wait(3);
                if (isBreak) break;
            }

            wait(2);
            if (!isBreak) {
                if (hasText("I didn't get the code") && isMailActive == 'active') {
                    tapText("I didn't get the code")
                    wait(2)

                    tapText("Resend confirmation code")
                    wait(3)

                    isBreak = false;
                    for (let i = 1; i <= 10; i++) {

                        toast("Request times: " + i, 3, "bottom");
                        axios
                            .get(MAIL_THUEMAIL_DOMAIN + "rentals/" + thuemailId + "?api_key=" + MAIL_API_KEY)
                            .then(function (response) {
                                const res = response.data;
                                if (res.id && res.otp) {
                                    isBreak = true;

                                    wait(1);
                                    press(130, 410);
                                    wait(1);
                                    typeText(res.otp);
                                    wait(1);
                                    tapImage("next.png");
                                    wait(3)
                                } else {
                                    toast("Empty OTP code, times: " + i);
                                }
                            })
                            .catch(function (error) {
                                toast("Failed to make http request, error: " + error.message);
                                log(error.message, "Failed to make http request, error: ");
                            });

                        wait(3);
                        if (isBreak) break;
                    }

                }
            }
        }
    }
    
}

function setNormalAccount() {
    if (terminateApp) return

    log('setNormalAccount()')
    toast('setNormalAccount()', 5, 'top')

    wait(5);
    if (hasText("Choose from Camera Roll", 8)) {
        press(55, 415)
        wait(1)
    }

    if (hasText("Add a profile picture")) {
        press(380, 1260)
        wait(7);
    }

    wait(5)
    if (hasText("Turn on contact uploading to", 10) || hasText("find friends faster", 10)) {
        tapImage("next.png");
        wait(2);

        tapText("Not Now");
        wait(5);
    }

    if (hasText("No friend suggestions yet")) {
        tapImage("next.png");
        wait(3);
    }

    if (hasText("Add a mobile number to your")) {
        tapText("Skip");
        wait(2);
    }

    wait(5)
    ignoreMessenger()

    wait(1)
    ignoreMessenger()

    wait(3)
}

function goPersonalSetting() {
    if (terminateApp) return

    log('goPersonalSetting()')
    toast('goPersonalSetting()', 5, 'top')

    wait(3);
    ignoreMessenger()
    wait(2)

    if (hasText("what's on your mind?") || hasImage("home_fb_logo.png")) {
        press(690, 1300); // menu icon
        wait(3);

        tapImage("setting_icon.png");
        wait(3);

        if (hasText("See more in Accounts Center", 5)) {
            tapText("See more in Accounts Center");
            wait(3);
        }

        swipe(600, 600, 600, 550);

        wait(2);
        tapText("Personal details");

        wait(4);
    }
}

function get2FAstring() {
    if (terminateApp) return

    log('get2FAstring()')
    toast('get2FAstring()', 5, 'top')

    if (hasText("Identity confirmation", 15)) {
        tapText("Identity confirmation");
        wait(2);
    }

    if (hasText("Confirm your identity")) {
        tapText("Confirm your identity");
        wait(1);

        tapText("Protect your account");
        wait(3);

        if (hasText("Please re-enter your")) {
            wait(1);
            press(120, 600);
            wait(1);

            typeText(password);
            wait(1);
            tapText("Continue");
            wait(4);
        }
    }

    if (hasText("Help protect your account", 5)) {
        tapImage("next.png");
        wait(2);
    }

    if (hasText("Instructions for setup", 5)) {
        swipe(600, 600, 600, 550);
        wait(1);

        if (hasImage("qr_code_btn.png")) {
            tapImage("qr_code_btn.png");
            wait(2);

            const now = new Date();
            const pad = (n) => n.toString().padStart(2, "0");
            const formattedDate = `${now.getFullYear()}${pad(
                now.getMonth() + 1
            )}${pad(now.getDate())}`;
            const formattedTime = `${pad(now.getHours())}${pad(
                now.getMinutes()
            )}${pad(now.getSeconds())}`;

            const qrCodeImage = `${formattedDate}-${formattedTime}-${thuemailId}.png`;
            const qrPathScreenshot = `screenshot/${qrCodeImage}`;
            const qrPath = at.rootDir() + "/Facebook/" + qrPathScreenshot;

            wait(8)
            at.screenshot(qrPathScreenshot, {
                x: 160,
                y: 500,
                width: 420,
                height: 420,
            });
            wait(3);
            toast('Screenshot captured')

            const base64String = at.exec(`base64 ${qrPath}`);
            wait(5);

            const [uid, secret] = decodeBase64QR(base64String);
            wait(10)

            toast([uid, secret]);
            log("-> Mail: " + mail + " uid: " + uid + " 2FA: " + secret);

            profileUid = uid;
            twoFA = secret;

            wait(2);
            press(50, 410);
            wait(1);

            tapImage("next.png");
            wait(5);

            if (hasText("Please re-enter your")) {
                wait(1);
                press(120, 600);
                wait(1);

                typeText(password);
                wait(1);
                tapText("Continue");
                wait(4);
            }

            wait(2);
            if (hasText("Enter code")) {
                wait(1);
                press(140, 520);
                wait(1);

                const token = get2FAOTP(twoFA);
                wait(1)

                typeText(token);
                wait(1);

                tapImage("next.png");
                wait(5);

                tapImage("done.png");
                wait(5);

                saveOutputData()

                if (hasText("Accounts Center")) {
                    // go back home
                    press(60, 150);
                    wait(1);

                    press(40, 85);
                    wait(1);
                }
            }
        }
    }
}

function setNewGmail() {
    if (terminateApp) return

    if (hasText("Personal details") || hasText("Contact info")) {
        tapText("Contact info")
        wait(3);
        if (hasText("Contact information")) {
            tapText("Add new contact")
            wait(5)

            if (hasText('Which would you like to add?') || hasText("Add email")) {
                tapText("Add email")
                wait(3)
                if (hasText("Add an email address")) {
                    press(100, 550)
                    wait(1)
                    typeText(mailYagisongs)
                    wait(1)

                    press(650, 1290)
                    wait(1)

                    tapImage("next.png");
                    wait(2)
                }

                if (hasText("Enter your confirmation code")) {
                    wait(5)

                    isBreak = false;
                    for (let i = 1; i <= 15; i++) {

                        log("Times request: " + i)
                        toast("Request times: " + i, 3, "bottom");
                        axios
                            .get(MAIL_BUILUC_DOMAIN + "?type=getcode&mail=" + mailYagisongs)
                            .then(function (response) {
                                const res = response.data;
                                if (res && res.length > 0 && res[0].code) {
                                    isBreak = true;

                                    log(res[0].code)

                                    wait(1);
                                    press(100, 480);
                                    wait(1);

                                    typeText(res[0].code);
                                    wait(1);

                                    press(100, 600)
                                    wait(1)

                                    tapImage("next.png");
                                    wait(3)

                                    tapImage("close_btn.png");
                                    wait(1)

                                    // remove old mail
                                    if (hasText("Contact information")) {
                                        press(660, 630)
                                        wait(3)

                                        tapText("Delete email")
                                        wait(1)

                                        tapImage("delete_btn.png")
                                        wait(1)

                                        press(50, 155)
                                        wait(1)
                                    }

                                    // back to home page
                                    press(50, 155)
                                    wait(1)

                                    press(55, 150)
                                    wait(1)

                                    press(60, 1280); // click to home screen
                                    wait(3);

                                    // back
                                } else {
                                    toast("Empty OTP code, times: " + i);
                                }
                            })
                            .catch(function (error) {
                                toast("Failed to make http request, error: " + error.message);
                                log(error.message, "Failed to make http request, error: ");
                            });
                
                        wait(3);
                        if (isBreak) break;
                    }
                }
            }
        }
    }
}

function swipeRandom() {
    if (terminateApp) return

    log('swipeRandom()')
    toast('swipeRandom()', 3, 'top')

    wait(1);
    press(60, 1280); // click to home screen
    wait(3);

    if (hasText("what's on your mind?") || hasImage("home_fb_logo.png")) {
        swipe(680, 500, 680, 450);
        wait(1);
        swipe(650, 400, 650, 250);
        wait(1);
        swipe(600, 400, 600, 200);
        wait(1);
        swipe(600, 400, 600, 550);
        wait(1);

        press(60, 1280); // click to home screen
        wait(3);
    }
}

function searchRandomKeyword() {
    if (terminateApp) return

    log('searchRandomKeyword()')
    toast('searchRandomKeyword()', 5, 'top')

    wait(3);
    if (hasText("what's on your mind?") || hasImage("home_fb_logo.png")) {
        press(600, 90); // search icon
        wait(2);

        // search
        const times = 3;
        const randomed = getRandomSearchText(times)
        wait(2)
        for (let i = 1; i <= times; i++) {
            toast("Search no." + i, 2, "bottom");

            wait(1);
            typeText(randomed[i - 1]);
            wait(1);

            press(700, 1300);
            wait(4);

            swipe(500, 900, 500, 800);
            wait(3);

            if (i < times) {
                press(280, 90); // click back into search box
                wait(1);

                hasImage("cancel_search_btn.png")
                    ? tapImage("cancel_search_btn.png")
                    : null;
            } else {
                press(60, 1280); // click to home screen
                wait(3);
            }
        }
    }
}

function logoutAtEnd() {
    if (terminateApp) return

    log('logoutAndRemoveAccount()')
    toast('logoutAndRemoveAccount()', 3, 'top')

    wait(1);
    press(60, 1280); // click to home screen
    wait(2);

    logoutAndRemoveAccount()
}

function resetWifi() {
    log('resetWifi()')
    toast('resetWifi()', 3, 'top')

    wait(1);
    pressHome();

    if (hasImage("iphone_setting.png")) {
        tapImage("iphone_setting.png");
        wait(3);

        if (hasImage("iphone_wifi.png") || hasImage("wifi_on.png")) {
            tapImage("iphone_wifi.png");
            wait(3);

            press(660, 250);
            wait(2);

            press(660, 250);
            wait(2);

            if (hasImage("settings_back.png")) {
                tapImage("settings_back.png");
                wait(1);
            }

            pressHome();
            wait(1);
        }
    }
}

// === MAIN ===
function main() {
    openFacebook();

    setFirstName();
    setBirthday();
    setGender();

    signUpEmail();
    setPassword();

    setConfirmationCode();
    setNormalAccount();

    check282Checkpoint();

    goPersonalSetting();
    get2FAstring();
    setNewGmail()

    swipeRandom();
    searchRandomKeyword();

    setNewGmail();
    logoutAtEnd();
    resetWifi();
}
// === END MAIN ===

// === RUNTIME ===
var waitSecond = 3;
var runTime = 1;
function runInterval() {
    while (runTime && !terminateApp) {
        wait(2);
        toast("Run app at " + runTime + " times.", 3, "bottom");
        wait(2);

        main();

        if (terminateApp) {
            toast("282 error. Terminated.", 3, "bottom");
            wait(5);
        } else {
            for (let i = waitSecond; i >= 1; i--) {
                wait(2);
                toast("Next run after " + i + "s.", 1, "bottom");
            }

            wait(2);
            toast("Done app at " + runTime + " times.", 3, "bottom");
            wait(5);
            runTime++;
        }
    }
}

// runInterval()

main()
