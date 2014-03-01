// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(function () {
    $("#from").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        onClose: function (selectedDate) {
            $("#to").datepicker("option", "minDate", selectedDate);
        }
    });
    $("#to").datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 1,
        onClose: function (selectedDate) {
            $("#from").datepicker("option", "maxDate", selectedDate);
        }
    });

    $(".add-appeal-type").click(function(e){
        e.preventDefault();
        var cloneDiv = $(".appeal-types").find(".form-group").last().clone();
        var inputItem = $(cloneDiv).find("input[type=text]").clone(); //Gets input field
        $(cloneDiv).find("input[type=text]").remove(); // Removes input field
        $(cloneDiv).find("input[type=hidden]").remove(); // Removes hidden field
        var name = inputItem.attr("name").replace(/\[(\d+)\]/, // Increases the id in input's name
            function (str, p1) {
                return '[' + (parseInt(p1, 10) + 1) + ']';
            });
        $(inputItem).attr("name", name);
        $(inputItem).val("");
        $(cloneDiv).find(".input-group").prepend(inputItem);
        $(".appeal-types").append(cloneDiv);
    })

    $(".appeal-types").on("click", ".remove-appeal-type", function (e) { //Must be dynamic.
        e.preventDefault();

        if ($(".appeal-types").find(".form-group").length > 1){  //Dont remove if its last input
            if($(this).parent().parent().find("input[type=hidden]").length == 0){ // If it is not saved yet
                $(this).parent().parent().parent().remove(); // Remove div class=form-group
            }else{
                $(this).parent().parent().parent().find(".remove-link").trigger("click.rails")
            }
        }else{
            if ($(this).parent().parent().find("input[type=hidden]").length != 0) { //If its a saved one, just clear the form
                $(this).parent().parent().find("input[type=text]").val("");
                $(this).parent().parent().find("input[type=hidden]").remove("");
                $(this).parent().parent().parent().find(".remove-link").trigger("click.rails");
            }
        }
    })
});