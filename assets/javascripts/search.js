/**
 * Nitwit search module
 */
var Nitwit = (function(app, $) {
    var my = {};
    var query,
        latitude,
        longitude,
        max_id;

    my.init = function() {
        bind();
    };

    my.setPosition = function(position) {
        latitude  = position.coords.latitude;
        longitude = position.coords.longitude;
    }

    my.search = function(append) {
        $.post(
            '/search',
            {
                query:     query,
                latitude:  latitude,
                longitude: longitude,
                max_id:    max_id
            },
            function(data) {
                window.location.hash = 'result';
                if (append) {
                    $('.pager').remove();
                    $('#result').append(data);
                } else {
                    $('#result').html(data);
                }
            }
        );
    }

    my.login = function() {
        window.open('/login', 'twitterWindow', 'location=0,status=0,width=640,height=480');
        document.cookie = 'twitter_oauth_popup=1; path=/';
    }

    var bind = function() {
        $('.container').on('click', '.btn', function(e) {
            e.preventDefault();
            query = $('.search-query').val();
            max_id = $(this).data('max-id');
            if (isLoggedIn()) {
                my.search(!!max_id);
            } else {
                my.login();
            }
        })
    }

    var isLoggedIn = function() {
        return $('body').data('logged-in') == '1';
    }

    app.search = my;

    return app;
})(Nitwit || {}, jQuery);
