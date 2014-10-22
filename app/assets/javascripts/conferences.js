// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require schedule
//= require gmaps

$(function () {


    $("#wizard").steps({
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
        }
    }).validate({
        errorPlacement: function errorPlacement(error, element) { element.before(error); }
    });

    $("#from").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        onClose: function (selectedDate) {
            $("#to").datepicker("option", "minDate", selectedDate);
        },
        dateFormat: 'dd/mm/yy'
    });
    $("#to").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        onClose: function (selectedDate) {
            $("#from").datepicker("option", "maxDate", selectedDate);
        },
        dateFormat: 'dd/mm/yy'
    });
});