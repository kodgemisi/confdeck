// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.core
//= require jquery.ui.effect
//= require jquery.ui.effect-highlight
//= require jquery.ui.datepicker
//= require bootstrap
//= require gmaps
//= require best_in_place
//= require kendo.web
//= require kendo.scheduler
//= require kendo.scheduler.view
//= require kendo.scheduler.dayview
//= require kendo.scheduler.recurrence



$(document).ready(function(){
    $('.disable-enter').keypress(function (event) {
        if (event.keyCode == 13) {
            event.preventDefault();
        }
    });

    /* Activating Best In Place */
    if($.fn.best_in_place)
        jQuery(".best_in_place").best_in_place();

    $('.tt').tooltip();
    $("[data-toggle=tooltip]").tooltip()
    $("[data-toggle=popover]").popover({trigger: "hover"})

})
