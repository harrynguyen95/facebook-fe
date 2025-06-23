// ====== COMMON FUNCTION ======
global.wait = function (seconds) {
    usleep(seconds * 1000000);
};

global.press = function (x, y, duration = 100) {
    const randOffset = () => Math.floor(Math.random() * 11) - 5;

    const randX = x + randOffset();
    const randY = y + randOffset();

    at.tap(randX, randY);
    wait(duration / 1000);
};

global.log = function (val, txt = "-") {
    console.log(txt, val);
};

global.toast = function (val, time = 2, position = "center") {
    at.toast(typeof val === "object" ? JSON.stringify(val) : val, position, time);
};

global.randomBetween = function (min, max) {
    return Math.random() * (max - min) + min;
};

global.randomPointInRect = function (rect) {
    const x = randomBetween(rect.topLeft.x, rect.bottomRight.x);
    const y = randomBetween(rect.topLeft.y, rect.bottomRight.y);
    return { x, y };
};

global.tapImage = function (name, threshold = 0.9) {
    const options = {
        targetImagePath: "image/" + name,
        threshold: threshold,
    };
    const [result, error] = at.findImage(options);

    if (error) {
        toast("Failed to findImage, error: " + error);
        return false;
    } else if (result.length == 0) {
        toast("Not found image: " + name);
        return false;
    } else {
        press(result[0].x, result[0].y);
        return true;
    }
};

global.hasImage = function (name, threshold = 0.9) {
    const options = {
        targetImagePath: "image/" + name,
        threshold: threshold,
    };
    const [result, error] = at.findImage(options);

    if (error) {
        return false;
    } else if (result.length == 0) {
        return false;
    } else {
        return true;
    }
};

global.hasText = function (txt) {
    const [result, error] = at.findText(
        {},
        (text) => text.toLowerCase() === txt.toLowerCase()
    );

    if (error) {
        return false;
    } else if (result.length === 0) {
        return false;
    } else {
        return true;
    }
};

global.tapText = function (txt) {
    const [result, error] = at.findText(
        {},
        (text) => text.toLowerCase() === txt.toLowerCase()
    );

    if (error) {
        at.toast("Error: " + error.message);
        return false;
    } else if (result.length === 0) {
        toast("Not found text: " + txt);
        return false;
    } else {
        const point = randomPointInRect(result[0]);
        press(point.x, point.y);
        return true;
    }
};

global.getToday = function () {
    const now = new Date();
    const d = now.getDate();
    const m = now.getMonth() + 1;
    const y = now.getFullYear();

    return [d, m, y];
};

global.randomDOB = function () {
    const day = Math.floor(Math.random() * 28) + 1;
    const month = Math.floor(Math.random() * 12) + 1;
    const year = Math.floor(Math.random() * (2003 - 1990 + 1)) + 1990;

    return [day, month, year];
};

global.selectDobValue = function (x, y, target, maxValue) {
    const diff = maxValue - target;
    for (let i = 0; i < diff; i++) {
        press(x, y - 70); // kéo lên
        wait(0.1);
    }
};

global.typeText = function (text) {
    for (let i = 0; i < text.length; i++) {
        const ch = text[i];
        at.inputText(ch);
        wait(0.2);
    }
};

global.randomPassword = function (length = 8) {
    const chars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    let pass = "";
    for (let i = 0; i < length; i++) {
        pass += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return pass;
};

global.getRandomName = function () {
    require("input/firstname");
    require("input/lastname");

    const firstnames = firstnameData();
    const lastnames = lastnameData();

    const first = firstnames[Math.floor(Math.random() * firstnames.length)];
    const last = lastnames[Math.floor(Math.random() * lastnames.length)];

    return [first, last];
};

global.swipe = function (x1, y1, x2, y2, duration = 300) {
    at.touchDown(0, x1, y1);
    at.usleep(50000);

    at.touchMove(0, x2, y2);
    at.usleep(duration * 1000);

    at.touchUp(0, x2, y2);
    at.usleep(100000);
};

global.findEmailFromScreen = function () {
    wait(2);
    const [result, error] = at.ocr({
        x: 0,
        y: 200,
        useVision: true,
        lang: "en-US",
    });

    if (error) {
        toast("Error OCR: " + error);
        return null;
    }

    const cleaned = result.replace(/\.corn/gi, ".com").replace("\n", "");

    const match = cleaned.match(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/gi);

    if (match && match.length > 0) {
        return match[0];
    } else {
        toast("Not found mail.");
        return null;
    }
};

global.logAllText = function () {
    const [result, error] = at.ocr({
        x: 0,
        y: 200,
        useVision: true,
        lang: "en-US",
    });

    if (error) {
        toast("Error OCR: " + error);
        return null;
    }

    const cleaned = result.replace(/\.corn/gi, ".com").replace("\n", "");
    log(cleaned);
    return;
};

// Find current actived mail
// axios.get(MAIL_DOMAIN + "rentals" + "?api_key=" + MAIL_API_KEY)
//     .then(function (response) {
//         const res = response.data
//         if (res.data) {
//             const selected = res.data.filter(e => e.status == "active")[0];
//             if (selected) {
//                 mail = selected.email
//                 thuemailId = selected.id
//             } else {
//                 registerMail()
//             }
//         } else {
//             toast('Empty response get wait OTP mail.')
//         }
//     })
//     .catch(function (error) {
//         toast('Failed to make http request, error: ' + error.message)
//         log(error.message, 'Failed to make http request, error: ')
//     })


global.getRandomSearchText = function (count = 3) {
    require("input/searchtext");

    const text = searchTextData();

    if (count > 10) {
        count = 10
    }

    const shuffled = [...text].sort(() => 0.5 - Math.random());
    return shuffled.slice(0, count);
};

global.decodeBase64QR = function (base64String) {
    let uid = null;
    let secret = null;

    for (let i = 1; i <= 3; i++) {
        if (uid && secret) {
            return [uid, secret]
        } else {
            toast("times: " + i, 2, "bottom");
            wait(2)

            axios({
                method: "post",
                url: QR_CODE_SERVER,
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                },
                data: `base64String=${encodeURIComponent(base64String)}`,
            })
                .then(function (response) {
                    const res = response.data;
                    if (res && res.length > 0) {
                        const data = res[0];
                        if (
                            data.symbol &&
                            data.symbol.length > 0 &&
                            (data.symbol[0].error != null || data.symbol[0].error != "null")
                        ) {
                            const decoded = data.symbol[0].data;
                            const match = decoded.match(/ID:(\d+)\?secret=([A-Z0-9]+)/);

                            if (match) {
                                uid = match[1];
                                secret = match[2];
                            } else {
                                toast("Can not find uid and 2FA in decoded.");
                            }
                        }
                    } else {
                        toast("Can not decode.");
                    }
                })
                .catch(function (error) {
                    toast("Failed to make http request, error: " + error.message);
                    log(error.message, "Failed to make http request, error: ");
                });
        }
    }

    if (uid && secret) {
        return [uid, secret]
    }
};

global.get2FAOTP = function (secret) {
    let token = null;
    axios
        .get("https://2fa.live/tok/" + secret)
        .then(function (response) {
            const res = response.data;
            if (res.token) {
                token = res.token;
            } else {
                toast("Empty response get2FAOTP.");
            }
        })
        .catch(function (error) {
            toast("Failed to make http request, error: " + error.message);
            log(error.message, "Failed to make http request, error: ");
        });

    wait(6);
    return token;
};

global.pressHome = function () {
    wait(0.5);
    at.keyDown(KEY_TYPE.HOME_BUTTON);
    wait(1);
    at.keyUp(KEY_TYPE.HOME_BUTTON);
    wait(1);
};

global.hasFullData = function () {
    return mail && password && twoFA && profileUid;
};

global.removeAccount = function () {
    wait(2);
    if (hasText("Use another profile") || hasText("Log into another account")) {
        press(700, 90);
        wait(3);

        if (hasText("Remove profiles from this device")) {
            tapText("Remove profiles from this device");
            wait(2);

            press(600, 330);
            wait(1);

            if (hasImage("remove_btn.png")) {
                tapImage("remove_btn.png");
                wait(2);
            }
        }
    }
};

global.clearPrevData = function () {
    thuemailId = null;
    mail = "";
    password = "";
    twoFA = "";
    profileUid = "";
};

global.ignoreMessenger = function () {
    if (hasText("Messaging on Facebook is")) {
        press(50, 95)
        wait(5)
    }

    if (hasText("Add friends to start chatting")) {
        press(45, 90)
        wait(5)
    }
}

global.logoutAndRemoveAccount = function () {
    if (hasText("what's on your mind?")) {
        press(690, 1300); // menu icon

        wait(3);
        swipe(600, 600, 600, 450);

        wait(1);
        if (hasText("Log out")) {
            tapText("Log out");
            wait(2);

            if (hasText("Save your login info?")) {
                tapText("Not now");
                wait(2);
            }

            if (hasImage("logout_btn.png")) {
                tapImage("logout_btn.png");
                wait(5);
            }

            removeAccount();
        }
    }

    wait(3)
}

global.check282Checkpoint = function () {
    if (hasImage("facebook_with_help_txt.png")) {
        press(690, 85);
        wait(3);

        hasText("Log out") ? tapText("Log out") : null;
        wait(2);

        if (hasText("This account will be disabled")) {
            tapImage("logout_btn_2.png");
            wait(3);

            removeAccount();

            wait(1);
            terminateApp = true;
        }
    }
}

global.backWhenNotMail = function () {
    wait(0.5)

    press(50, 90);
    wait(1);

    press(50, 90);
    wait(1);

    press(50, 90);
    wait(1);

    press(50, 90);
    wait(1);

    press(50, 90);
    wait(1);

    press(50, 90);
    wait(1);

    if (hasText('Stop creating account')) {
        tapText('Stop creating account')
        wait(2);
    }
}