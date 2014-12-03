// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require schedule
//= require jquery.typewatch
//= require gmaps

$(function () {


    $("#wizard").steps({
        cssClass: "form-wizard",
        headerTag: ".wizard-title",
        bodyTag: ".wizard-container",
        onFinished: function () {
            this.submit();
        },
        onStepChanged: function (event, currentIndex, priorIndex) {
            if(currentIndex == 1){
                google.maps.event.trigger(map, 'resize'); //Refresh map on address step
            }
        },
        onStepChanging: function (event, currentIndex, priorIndex) {

            $(this).validate().settings.ignore = ":disabled,:hidden";

            return $(this).valid();
        },
        onFinishing: function (event, currentIndex)
        {
            $(this).validate().settings.ignore = ":disabled";
            return $(this).valid();
        },
        showFinishButtonAlways: true,
        enableAllSteps: true
    }).validate({
        validClass:'has-success',
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
    });

    $("#conference_slug").rules("add", {
        remote: {
            url: $("#conference_slug").data("validate"),
            data: {
                slug: function() {
                    return $( "#conference_slug" ).val();
                }
            }
        }
    })

    $('#conference_one_day').change(function() {
        if($(this).is(":checked")) {
            $("#to").val($("#from").val());
            $("#to").closest(".to-date-div").hide();
            $("#to").closest(".col-lg-6").find(".time-interval").show();
        }else{
            $("#to").closest(".to-date-div").show();
            $("#to").closest(".col-lg-6").find(".time-interval").hide();
        }
    });

    $("#from").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        onClose: function (selectedDate) {
            $("#to").datepicker("option", "minDate", selectedDate);
        },
        //dateFormat:  $("#from").attr("placeholder")
    });
    $("#to").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        onClose: function (selectedDate) {
            $("#from").datepicker("option", "maxDate", selectedDate);
        },
        //dateFormat:  $("#to").attr("placeholder")
    });

    $('#conference-start-time').timepicker({showMeridian: false});
    $('#conference-end-time').timepicker({showMeridian: false});
});