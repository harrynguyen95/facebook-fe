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

global.hasImage = function (name, maxWait = 5, threshold = 0.9) {
    maxWait = maxWait <= 1 ? 2 : maxWait

    wait(1)
    for (let i = 1; i <= maxWait - 1; i++) {
        wait(1)
        const options = {
            targetImagePath: "image/" + name,
            threshold: threshold,
        };
        const [result, error] = at.findImage(options);

        if (error || result.length === 0) {
            // return false;
        } else {
            return true;
        }
    }

    return false;
};

global.hasText = function (txt, maxWait = 5) {
    maxWait = maxWait <= 1 ? 2 : maxWait

    wait(1)
    for (let i = 1; i <= maxWait - 1; i++) {
        wait(1)
        const [result, error] = at.findText(
            {},
            (text) => text.toLowerCase() === txt.toLowerCase()
        );

        if (error || result.length === 0) {
            // return false;
        } else {
            return true;
        }
    }

    return false;
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
    absDiff = diff < 0 ? diff * -1 : diff

    for (let i = 0; i < absDiff; i++) {
        press(x, y - 70); // kéo lên
        wait(0.1);
    }
};

// global.typeText = function (text) {
//     for (let i = 0; i < text.length; i++) {
//         const ch = text[i];
//         at.inputText(ch);
//         wait(0.2);
//     }
// };

global.typeText = function (inputText) {
    const keyMap = {
        q: [28, 948], w: [102, 947], e: [178, 946], r: [254, 946], t: [331, 945],
        y: [405, 951], u: [481, 950], i: [554, 947], o: [629, 955], p: [706, 952],
        a: [72, 1060], s: [146, 1058], d: [221, 1059], f: [296, 1056], g: [366, 1059],
        h: [443, 1056], j: [523, 1059], k: [592, 1054], l: [671, 1053],
        z: [145, 1166], x: [218, 1166], c: [290, 1167], v: [369, 1166],
        b: [445, 1162], n: [522, 1166], m: [595, 1163],
        ' ': [259, 1279], '.': [115, 1167], '!': [467, 1165], '@': [605, 1028]
    };

    const shiftKey = [36, 1162];        // Shift để viết hoa
    const numSwitchKey = [72, 1273];    // Đổi sang bàn phím số

    const numKeyMap = {
        '0': [704, 945], '1': [29, 947], '2': [105, 947], '3': [179, 946],
        '4': [257, 954], '5': [328, 952], '6': [406, 953], '7': [479, 953],
        '8': [557, 950], '9': [629, 950]
    };

    const stringX = String(inputText);
    for (let i = 0; i < stringX.length; i++) {
        const ch = stringX[i];
        const isFirst = i === 0;

        const x = Math.floor(Math.random() * 21) - 10;
        const y = Math.floor(Math.random() * 21) - 10;
        const timecho = Math.floor(Math.random() * 100001) + 200000;
        const timechobatbuoc = Math.floor(Math.random() * 100001) + 300000;

        // Gõ số
        if (numKeyMap[ch]) {
            at.tap(numSwitchKey[0] + x, numSwitchKey[1] + y); // Bật bàn phím số
            at.usleep(timechobatbuoc);
            const [bx, by] = numKeyMap[ch];
            at.tap(bx + x, by + y);
            at.usleep(timecho);
            at.tap(numSwitchKey[0] + x, numSwitchKey[1] + y); // Tắt bàn phím số
            at.usleep(timechobatbuoc);
        }

        // Gõ ký tự thường
        else if (keyMap[ch]) {
            const [bx, by] = keyMap[ch];
            at.tap(bx + x, by + y);
            at.usleep(timecho);
        }

        // Gõ chữ hoa (A–Z)
        else if (ch >= 'A' && ch <= 'Z') {
            const lower = ch.toLowerCase();
            if (keyMap[lower]) {
                if (!isFirst) {
                    at.tap(shiftKey[0] + x, shiftKey[1] + y); // Nhấn Shift
                    at.usleep(1);
                }
                const [bx, by] = keyMap[lower];
                at.tap(bx + x, by + y);
                at.usleep(timecho);
            }
        }
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
// axios.get(MAIL_THUEMAIL_DOMAIN + "rentals" + "?api_key=" + MAIL_API_KEY)
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

    for (let i = 1; i <= 10; i++) {
        wait(2)
        if (uid && secret) {
            return [uid, secret]
        } else {
            toast("times: " + i, 2, "bottom");

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

    return [uid, secret]
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

            if (hasImage("remove_btn_red.png")) {
                tapImage("remove_btn_red.png");
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
        swipe(600, 600, 600, 400);

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

global.saveOutputData = function () {
    if (terminateApp) return

    log('saveOutputData()')
    toast('saveOutputData()', 3, 'top')

    wait(2);
    if (!hasFullData()) {
        return;
    }

    const row = `${profileUid}|${mailYagisongs}|${password}|${twoFA}|${mail}`;
    const accountOutput = at.rootDir() + "/Facebook/output.txt";
    const command = `echo '${row}' >> ${accountOutput}`;

    at.exec(command);

    wait(2);
    toast("Saved account: " + mail, 3);
}

global.randomEmailYagisongs = function () {
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    const digits = '0123456789';

    let part1 = '';
    for (let i = 0; i < 12; i++) {
        part1 += letters.charAt(Math.floor(Math.random() * letters.length));
    }

    let part2 = '';
    for (let i = 0; i < 5; i++) {
        part2 += digits.charAt(Math.floor(Math.random() * digits.length));
    }

    return 'iyxmtuiudvka84837@yagisongs.com';
    return `${part1}${part2}@yagisongs.com`;
}
