// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require schedule
//= require gmaps

$(function () {


    $("#wizard").steps({
        cssClass: "form-wizard",
        headerTag: ".wizard-title",
        bodyTag: ".wizard-container",
        onInit: function(event, currentIndex){
            console.log("init")
            $('[data-validate]').on('keyup', function() {
                $this = $(this);
                $.get($this.data('validate'), {
                    user: $this.val()
                }).success(function() {
                    $this.removeClass('error');
                }).error(function() {
                    $this.addClass('error');
                });
            });
        },
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
        }
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
});