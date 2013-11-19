( function() {

win = null;

module.exports = {
    show: function() {
        if ( win === null ) {
            win = window.open('splashscreen.html');
        }
    },

    hide: function() {
        if ( win !== null ) {
            win.close();
            win = null;
        }
    }
};

require("cordova/tizen/commandProxy").add("SplashScreen", module.exports);

})();
