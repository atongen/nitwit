window.console = console || { log: function(){} };

/**
 * Nitwit entry point
 */
var Nitwit = (function(app, $) {
    var my = {};

    /**
     * Initialize Nitwit!
     */
    my.init = function() {
        app.geolocation.init(app.search.setPosition);
        app.search.init();
    }

    my.search = function() {
        app.search.search();
    }

    my.loggedIn = function() {
        $('body').data('logged-in', '1');
    }

    return my;
})(Nitwit || {}, jQuery);

$(document).ready(function() {
    Nitwit.init();
});
