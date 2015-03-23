// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require schedule
//= require jquery.typewatch
//= require gmaps
//= require speakingurl.min
//= require selectize

$(document).ready(function(){
    initValidators()

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
                if (currentIndex == 2) {
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
            //showFinishButtonAlways: true,
            enableKeyNavigation: false,
            enableAllSteps: true
        });

        $("#wizard").on("cocoon:after-remove", function(e, item) {
            if($(".speech-types .nested-fields")[0] == undefined){
                $(".speech-types ").append(item)
            }
        });
        $("#wizard .speech-types").on('cocoon:before-insert', function(e, insertedItem) {
            if($(".speech-types .nested-fields").find("input[type=text]").last().val() == ""){
                insertedItem[0].innerHTML = "";
            }
        });


        $("#wizard input").on("focusout", function(){
            syncWizardData();
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


    $(".reset-template").on("click", function(){
        content = $(this).closest(".email-template").find(".original-template").html()
        $(this).closest(".email-template").find(".summernote-editor").code(content)
    })


    $("label[for='conference_settings_conference_site_true']").click(function(){
        $("#conference_modules").show()
    })

    $("label[for='conference_settings_conference_site_false']").click(function(){
        $("#conference_modules").hide()
    })


    function initValidators(){

        $(".validate-me").validate({
            validClass: 'has-success',
            errorElement: 'span',
            errorClass: 'emptyclass',
//            errorPlacement: function errorPlacement(error, element) {
//                $(element).closest('.input-group').after(error);
//            },
//            highlight: function (element, errorClass, validClass) {
//                $(element).closest("div.form-group").addClass("has-error").removeClass("has-success");
//
//            },
//            unhighlight: function (element, errorClass, validClass) {
//                $(element).closest("div.form-group").removeClass("has-error").addClass("has-success");
//            },
            messages: {
                "conference[slug]": {
                    remote: $.validator.format(I18n.t("js.in_use", {name: "{0}"}))
                }
            }
        });
    }
});