var exec = require('cordova/exec');

module.exports = {
    splashscreen: {
        show = function() {
            exec(null, null, "SplashScreen", "show", []);
        },
        hide = function() {
            exec(null, null, "SplashScreen", "hide", []);
        }
    }
};

require("cordova/tizen/commandProxy").add("SplashScreen", module.exports);
