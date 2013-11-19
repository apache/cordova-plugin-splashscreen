var exec = require('cordova/exec');

module.exports = {
    splashscreen: {
        win: null,

        show = function() {
            win= window.open('splashscreen.html');
        },

        hide = function() {
            win.close();
            win = null;
        }
    }
};

require("cordova/tizen/commandProxy").add("SplashScreen", module.exports);
