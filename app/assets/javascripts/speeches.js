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
        "columns": [
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
    });

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


//
//(function () {
//    'use strict';
//    var $ = jQuery;
//    $.fn.extend({
//        filterTable: function () {
//            return this.each(function () {
//                $(this).on('keyup', function (e) {
//                    $('.filterTable_no_results').remove();
//                    var $this = $(this), search = $this.val().toLowerCase(), target = $this.attr('data-filters'), $target = $(target), $rows = $target.find('tbody tr');
//                    if (search == '') {
//                        $rows.show();
//                    } else {
//                        $rows.each(function () {
//                            var $this = $(this);
//                            $this.text().toLowerCase().indexOf(search) === -1 ? $this.hide() : $this.show();
//                        })
//                        if ($target.find('tbody tr:visible').size() === 0) {
//                            var col_count = $target.find('tr').first().find('td').size();
//                            var no_results = $('<tr class="filterTable_no_results"><td colspan="' + col_count + '">No results found</td></tr>')
//                            $target.find('tbody').append(no_results);
//                        }
//                    }
//                });
//            });
//        }
//    });
//    $('[data-action="filter"]').filterTable();
//})(jQuery);
//
//$(function () {
//    // attach table filter plugin to inputs
//    $('[data-action="filter"]').filterTable();
//
//    $('.container').on('click', '.panel-heading span.filter', function (e) {
//        var $this = $(this),
//            $panel = $this.parents('.panel');
//
//        $panel.find('.panel-body').slideToggle();
//        if ($this.css('display') != 'none') {
//            $panel.find('.panel-body input').focus();
//        }
//        return false;
//    });
//    $('[data-toggle="tooltip"]').tooltip();
//})