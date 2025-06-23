
global.randomCity = function () {
    const usCities = [
        "New York, New York",
        "Los Angeles, California",
        "Chicago, Illinois",
        "Houston, Texas",
        "Phoenix, Arizona",
        "Philadelphia, Pennsylvania",
        "San Antonio, Texas",
        "San Diego, California",
        "Dallas, Texas",
        "San Jose, California",
        "Austin, Texas",
        "Jacksonville, Florida",
        "Fort Worth, Texas",
        "Columbus, Ohio",
        "Charlotte, North Carolina",
        "San Francisco, California",
        "Indianapolis, Indiana",
        "Seattle, Washington",
        "Denver, Colorado",
        "Washington, District of Columbia",
        "Boston, Massachusetts",
        "El Paso, Texas",
        "Nashville, Tennessee",
        "Detroit, Michigan",
        "Oklahoma City, Oklahoma",
        "Portland, Oregon",
        "Las Vegas, Nevada",
        "Memphis, Tennessee",
        "Louisville, Kentucky",
        "Baltimore, Maryland",
        "Milwaukee, Wisconsin",
        "Albuquerque, New Mexico",
        "Tucson, Arizona",
        "Fresno, California",
        "Sacramento, California",
        "Mesa, Arizona",
        "Kansas City, Missouri",
        "Atlanta, Georgia",
        "Long Beach, California",
        "Colorado Springs, Colorado",
        "Raleigh, North Carolina",
        "Miami, Florida",
        "Virginia Beach, Virginia",
        "Omaha, Nebraska",
        "Oakland, California",
        "Minneapolis, Minnesota",
        "Tulsa, Oklahoma",
        "Arlington, Texas",
        "Tampa, Florida",
        "New Orleans, Louisiana",
        "Wichita, Kansas",
        "Bakersfield, California",
        "Cleveland, Ohio",
        "Aurora, Colorado",
        "Anaheim, California",
        "Honolulu, Hawaii",
        "Santa Ana, California",
        "Riverside, California",
        "Corpus Christi, Texas",
        "Lexington, Kentucky",
        "Stockton, California",
        "Henderson, Nevada",
        "Saint Paul, Minnesota",
        "St. Louis, Missouri",
        "Cincinnati, Ohio",
        "Pittsburgh, Pennsylvania",
        "Greensboro, North Carolina",
        "Anchorage, Alaska",
        "Plano, Texas",
        "Lincoln, Nebraska",
        "Orlando, Florida",
        "Irvine, California",
        "Newark, New Jersey",
        "Toledo, Ohio",
        "Durham, North Carolina",
        "Chula Vista, California",
        "Fort Wayne, Indiana",
        "Jersey City, New Jersey",
        "St. Petersburg, Florida",
        "Laredo, Texas",
        "Madison, Wisconsin",
        "Chandler, Arizona",
        "Buffalo, New York",
        "Lubbock, Texas",
        "Scottsdale, Arizona",
        "Reno, Nevada",
        "Glendale, Arizona",
        "Gilbert, Arizona",
        "Winston–Salem, North Carolina",
        "North Las Vegas, Nevada",
        "Norfolk, Virginia",
        "Chesapeake, Virginia",
        "Garland, Texas",
        "Irving, Texas",
        "Hialeah, Florida",
        "Fremont, California",
        "Boise, Idaho",
        "Richmond, Virginia",
        "Baton Rouge, Louisiana",
        "Spokane, Washington",
    ];

    const index = Math.floor(Math.random() * usCities.length);
    return usCities[index];
};

function setProfileUser() {
    if (terminateApp) return

    wait(1);
    press(60, 1280); // click to home screen
    wait(3);

    press(65, 210); // click to profile avt
    wait(5);

    if (hasText("Continue Setting Up Your")) {
        tapText("Get Started");
        wait(2);
    }

    // skip avt
    if (hasText("Add profile photo")) {
        tapText("Skip");
        wait(1);
    }

    // skip avt
    if (hasText("Lock your profile")) {
        tapText("Skip");
        wait(1);
    }

    // select city
    wait(2);
    if (hasText("Add Current City")) {
        tapText("Select a location");
        wait(1);

        typeText(randomCity());
        wait(2);

        if (hasText("No Results Found")) {
            press(40, 80);
            wait(1);

            tapText("Skip");
        } else {
            press(60, 280);
            wait(1);

            tapText("Save");
        }
        wait(3);
    }

    // select hometown
    wait(1);
    if (hasText("Add your hometown")) {
        tapText("Select a location");
        wait(1);

        typeText(randomCity());
        wait(2);
        press(60, 280);
        wait(1);

        tapText("Save");
        wait(3);
    }

    // skip school
    if (hasText("Add Your School")) {
        tapText("Skip");
        wait(0.5);
    }

    // skip school
    if (hasText("Add Your College")) {
        tapText("Skip");
        wait(0.5);
    }

    // skip company
    if (hasText("Add Your Company")) {
        tapText("Skip");
        wait(0.5);
    }

    // skip relationship
    if (hasText("Add Your Relationship Status")) {
        tapText("Skip");
        wait(0.5);
    }

    // skip cover photo
    if (hasText("Add cover photo")) {
        tapText("Skip");
        wait(1);
    }

    // skip more than can add
    if (hasText("There's More You Can Add")) {
        tapText("Skip");
        wait(2);
    }

    if (hasText("View Your Profile")) {
        tapText("View Your Profile");
        wait(1);
    }
}