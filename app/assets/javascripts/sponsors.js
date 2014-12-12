// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){

    $(".validate-me").validate({
        validClass: 'has-success',
        errorElement: 'span',
        errorClass: 'help-block mt10',
        errorPlacement: function errorPlacement(error, element) {
            element.after(error);
        },
        highlight: function (element, errorClass, validClass) {
            $(element).parents("div.form-group").addClass("has-error").removeClass("has-success");

        },
        unhighlight: function (element, errorClass, validClass) {
            $(element).parents("div.form-group").removeClass("has-error").addClass("has-success");
        },
        messages: {
            "conference[slug]": {
                remote: $.validator.format("{0} is already in use")
            }
        }
    })

});