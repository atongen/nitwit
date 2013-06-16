/**
 * Nitwit geolocation module
 */
var Nitwit = (function(app, $) {
    var my = {};

    my.init = function(setPosition) {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(setPosition);
        }
    };

    app.geolocation = my;

    return app;
})(Nitwit || {}, jQuery);
