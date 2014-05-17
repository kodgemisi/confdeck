/*! ========================================================================
 * App.js v1.1.2
 * Copyright 2014 pampersdry
 * ========================================================================
 *
 * pampersdry@gmail.com
 *
 * This script will be use in my other projects too.
 * Your support ensure the continuity of this script and it projects.
 * ======================================================================== */

if (typeof jQuery === "undefined") { throw new Error("This application requires jQuery"); }

/* ========================================================================
 * BEGIN APP SCRIPT
 *
 * NOTE : This script is for demo purpose only, but you can alway use it
 * in your real project :)
 * ======================================================================== */
var APP = {
    // Core init
    // NOTE: init at html element
    // ================================
    init: function () {
        $("html").Core();
    },

    // Template sidebar sparklines
    // NOTE: require sparkline plugin
    // ================================
    sidebarSparklines: {
        init: function () {
            $("aside .sidebar-sparklines").sparkline("html", { enableTagOptions: true });
        }
    },

    // Template header dropdown
    // ================================
    headerDropdown: {
        init: function (options) {
            // the dropdown
            $(options.dropdown).one("shown.bs.dropdown", coreDropdown);

            // core dropdown function
            function coreDropdown (e) {
                // define variable
                var $target         = $(e.target),
                    $mediaList      = $target.find(".media-list"),
                    $indicator      = $target.find(".indicator");

                // show indicator
                $indicator
                    .addClass("animation animating fadeInDown")
                    .one("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", function () {
                        $(this).removeClass("animation animating fadeInDown");
                    });

                // Check for content via ajax
                $.ajax({
                    url: options.url,
                    cache: false,
                    type: "POST",
                    dataType: "json"
                }).done(function (data) {
                    // define some variable
                    var template    = $target.find(".mustache-template").html(),
                        rendered    = Mustache.render(template, data);

                    // hide indicator
                    $indicator.addClass("hide");

                    // update data total
                    $target.find(".count").html("("+data.data.length+")");

                    // render mustache template
                    $mediaList.prepend(rendered);

                    // add some intro animation
                    $mediaList.find(".media.new").each(function () {
                        $(this)
                            .addClass("animation animating flipInX")
                            .one("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", function () {
                                $(this).removeClass("animation animating flipInX");
                            });
                    });
                });
            }
        }
    }
};

// Init template on DOM ready
// ===================================
$(function () {
    // Init template core
    APP.init();

    // Init template sidebar summary
    APP.sidebarSparklines.init();

    // Init template message dropdown
    APP.headerDropdown.init({
        "dropdown": "#header-dd-message",
        "url": "server/message.php"
    });

    // Init template notification dropdown
    APP.headerDropdown.init({
        "dropdown": "#header-dd-notification",
        "url": "server/notification.php"
    });
});