// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require schedule
//= require jquery.typewatch
//= require gmaps
//= require speakingurl.min
//= require selectize

$(document).ready(function(){

    var syncWizardData = function(){
        $("#conference_wizard_data").val($("#wizard").serialize());
        sendForm($("#conference_wizard_sync"))
    };

    $(".speech .show-comments").click(function(e){
        e.preventDefault();
        $(this).closest(".speech").find(".comments").slideToggle();
    });

    if($("#wizard")[0])
    {
        $("#wizard").steps({
            cssClass: "form-wizard",
            headerTag: ".wizard-title",
            bodyTag: ".wizard-container",
            onFinished: function () {
                this.submit();
            },
            onStepChanged: function (event, currentIndex, priorIndex) {
                if (currentIndex == 1) {
                    var currCenter = window.map.getCenter();
                    google.maps.event.trigger(map, 'resize'); //Refresh map on address step
                    window.map.setCenter(currCenter);
                }

                if (currentIndex == 3) { //details tab
                    initializeEditors()
                }
            },
            onStepChanging: function (event, currentIndex, priorIndex) {
                if (priorIndex < currentIndex) {
                    return true
                }
                $(this).validate().settings.ignore = ":disabled,:hidden";

                return $(this).valid();
            },
            onFinishing: function (event, currentIndex) {
                $(this).validate().settings.ignore = ":disabled";

                //Set WYSIWYG editor contents to hidden fields before submit
                var editors = $(".summernote-editor");
                for (var i = 0; i < editors.size(); i++) {
                    var editor = editors[i];
                    var hidden_field = $(editor).next().next();
                    $(hidden_field).val($(editor).code());
                }
                return $(this).valid();
            },
            showFinishButtonAlways: true,
            enableAllSteps: true
        });

        $("#wizard").on("cocoon:after-remove", function(e, item) {
            if($(".speech-types .nested-fields")[0] == undefined){
                $(".speech-types ").append(item)
            }
        });


        $("#wizard input").on("focusout", function(){
            syncWizardData();
        });

    }

    $("#from").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        onClose: function (selectedDate) {
            $("#to").datepicker("option", "minDate", selectedDate);
        },
        dateFormat:  $("#from").data("format")
    });
    $("#to").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        onClose: function (selectedDate) {
            $("#from").datepicker("option", "maxDate", selectedDate);
        },
        dateFormat:  $("#to").data("format")
    });

    $("#conference_name").on('change keyup input', function () {
        slug = getSlug($(this).val());
        $("#conference_slug").val(slug);
    });

    $('#conference-start-time').timepicker({showMeridian: false});
    $('#conference-end-time').timepicker({showMeridian: false});


    $(".validate-me").validate({
        validClass: 'has-success',
        errorElement: 'span',
        errorClass: 'help-block mt10',
        errorPlacement: function errorPlacement(error, element) {
            element.after(error);
        },
        highlight: function (element, errorClass, validClass) {
            $(element).closest("div.form-group").addClass("has-error").removeClass("has-success");

        },
        unhighlight: function (element, errorClass, validClass) {
            $(element).closest("div.form-group").removeClass("has-error").addClass("has-success");
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
                slug: function () {
                    return $("#conference_slug").val();
                }
            }
        }
    })


    $('#conference_one_day').change(function () {
        if ($(this).is(":checked")) {
            $("#to").val($("#from").val());
            $("#to").closest(".to-date-div").hide();
            $("#to").closest(".col-lg-6").find(".time-interval").show();
        } else {
            $("#to").closest(".to-date-div").show();
            $("#to").closest(".col-lg-6").find(".time-interval").hide();
        }
    });

});