// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery.datatables

$(document).ready(function(){
    bulk_ids = [];


    $(".speech .show-comments").click(function(e){
        e.preventDefault();
        $(this).closest(".speech").find(".comments").slideToggle();
    });

    $(".speech-table").dataTable({
        "aoColumns": [
            null,
            { "bSortable": false },
            { "bSortable": false },
            { "bSortable": false },
            null,
            null,
            null,
            { "bSortable": false }
        ],
        "lengthMenu": [ [ 100, 250, -1], [100, 250, "All"] ],
        "initComplete": function(){
            $('.tt').tooltip();
        }
    });

    $('.speech-filters .filter').click(function(){
        var _this = this
        $.each($('.speech-table'), function( index, value ) {
            $(value).dataTable().fnSort( [ [5,'desc']] )
            $(value).dataTable().fnFilter(_this.innerHTML)
        });


    })

    $('.bulk-mail-table').dataTable( {
        "pageLength": 200,
        "aaSorting": [],
        "columns": [
            null,
            { "sortable": false },
            { "sortable": false },
            { "sortable": false },
            null,
            null,
            { "sortable": false }
        ],
        "initComplete": function(){
            $('.tt').tooltip();

        }
    } );

    $("#send_bulk_mail").click(function(e){
        e.preventDefault();
        $("input[type=checkbox]:checked").each(function() {
            bulk_ids.push($(this).val());
        });
    })


    $(".speech-table").on( 'draw.dt', function () {
        $('.tt').tooltip();
    } );

})
