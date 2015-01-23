// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){

    // Catch link click and add conference_name parameters to url
    $(".social-logins > li > a").click(function(e){
        e.preventDefault();
        var conference_name = $("#quick_signup_form_name").val()

        if(conference_name != "")
            window.location.href = $(this).attr("href") + '&name=' + conference_name
        else
            window.location.href = $(this).attr("href")
    })

})