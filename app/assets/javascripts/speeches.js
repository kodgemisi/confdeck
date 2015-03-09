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
            { "bSortable": false }
        ],
        "initComplete": function(){
            $('.tt').tooltip();

        }
    });

    $('.speech-filters button').click(function(){
        $('.speech-table').dataTable().fnSort( [ [5,'desc']] )
        $('.speech-table').dataTable().fnFilter(this.innerHTML)
    })

    $('.bulk-mail-table').dataTable( {
        "pageLength": 200,
        "aaSorting": [],
        "columns": [
            { "sortable": false },
            null,
            { "sortable": false },
            { "sortable": false },
            { "sortable": false },
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
