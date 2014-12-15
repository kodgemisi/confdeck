//= require best_in_place
//= require bootstrap/modal
//= require jquery_ujs
//= require sweet-alert

$(function () {
    $('a[href*=#]:not([href=#])').click(function () {
        if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '')
            || location.hostname == this.hostname) {

            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
            if (target.length) {
                $('html,body').animate({
                    scrollTop: target.offset().top
                }, 1000);
                return false;
            }
        }
    });


    /* Activating Best In Place */
    if($.fn.best_in_place)
        jQuery(".best_in_place").best_in_place();
});
