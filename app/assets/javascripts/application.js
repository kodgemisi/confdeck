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
//= require jquery-ui/core
//= require jquery-ui/datepicker
//= require jquery-ui/datepicker-en-GB
//= require jquery-ui/datepicker-tr
//= require jquery-ui/effect-highlight
//= require jquery.validator
//= require bootstrap
//= require best_in_place
//= require core
//= require adminre
//= require adminre/jquery.steps
//= require cocoon
//= require bootstrap.timepicker
//= require summernote
//= require rails-timeago-all
//= require lib/summernote.plugins

$(document).ready(function(){
    $.datepicker.setDefaults( $.datepicker.regional[ current_locale ] );

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


window.showError = function(msg){
    console.log(msg)
}


function sendForm(item){
    $(item).trigger("submit.rails");
}


var initializeEditors = function(){
    $(".summernote-editor").summernote({ //must be here, otherwise buttons are not working
        height: 200,
        toolbar: [
            ["style", ["style"]],
            ["style", ["bold", "italic", "underline", "clear"]],
            ["fontsize", ["fontsize"]],
            ["color", ["color"]],
            ["para", ["ul", "ol", "paragraph"]],
            ["height", ["height"]],
            ["table", ["table"]],
            ["insert2", ["conferenceDropdown"]],
            ["insert3", ["topicDropdown"]]
        ]
    });

}

