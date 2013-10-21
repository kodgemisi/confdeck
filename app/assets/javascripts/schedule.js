//= require jquery
//= require bootstrap
//= require jquery.ui.core

$(function() {

  var slotDiv = '<div class="slot-div" data-slot-id="{ID}"><div>';

  //calculate "room-container"s' widths
  (function() {
    var roomSize = $('.tab-pane').first().find('.room').length;
    var width = ($('.room').first().outerWidth(true) + 5) * roomSize;
    $('.room-container').css('width', width);
  }());

  if(editable){
    // addSlot click handler on TDs
    $('td[data-hour]').click(function() {
      var hour = $(this).data('hour');
      var jModal = $(this).closest('table').siblings('.modal');

      //fill hour&minute
      jModal.find('[name="slot[start_hour(1i)]"]').val(2000);
      jModal.find('[name="slot[start_hour(2i)]"]').val(1);
      jModal.find('[name="slot[start_hour(3i)]"]').val(1);

      jModal.find('[name="slot[start_hour(4i)]"]').val(hour.split(':')[0]);
      jModal.find('[name="slot[start_hour(5i)]"]').val(hour.split(':')[1]);

      jModal.modal();// show modal
    });
  }

  function traverseSlots(days) {
    for(dayKey in days){
      var day = days[dayKey];
      for(roomKey in day){
        var room = day[roomKey];
        for(slotKey in room){
          var slot = room[slotKey];
          renderSlot(slot, dayKey, roomKey);
        }
      }
    }
  }

  function renderSlot(slot, dayId, roomId) {
    var date = new Date(slot.start_hour);
    var startHour = (date.getUTCHours() < 10 ? '0' + date.getUTCHours() : date.getUTCHours());
    var startMinute = (date.getUTCMinutes() < 10 ? '0' + date.getUTCMinutes() : date.getUTCMinutes());

    //normalization of start minute
    if(parseInt(startMinute) < 30){
      var fullHour = startHour + ':00';
    }
    else{
      fullHour = startHour + ':30';
    }

    startMinute = parseInt(startMinute);

    var startCell = $('[data-hour="'+fullHour+'"][data-day="'+dayId+'"][data-room="'+roomId+'"]');
    var referenceCell = $('[data-day="'+1+'"][data-room="'+1+'"]').first();
    var cellHeight = referenceCell.outerHeight();
    var height = slot.duration / 30 * cellHeight;
    var top = (startMinute >= 30 ? startMinute - 30 : startMinute ) / 30 * cellHeight;
    top += 2; // 2px top margin
    height -= (height % cellHeight == 0 && startMinute % 30 == 0 ? 5 : 0); // 2px bottom margin, this is equal to top, left and right margin
    startCell.append(slotDiv.replace('{ID}', slot.id));
    var currentSlotDiv = $('[data-slot-id="'+slot.id+'"]');
    currentSlotDiv.css('height', height).css('top', top).html( (slot.topic ? slot.topic.subject : '<em>Topic not set</em>') + ' | ' + slot.duration + ' minutes');
  }

  traverseSlots(window.slotsData);

  // order is important for this handler addition, should be after 'traverseSlots'
  $('.slot-div').click(function(e) {
    var slotId = $(this).data('slot-id');

    $('#slotDetailsContainer').children().remove();
    $('#slotDetailsContainer').append('<div id="slotDetails" class="modal fade"></div>');

    var url = '/conferences/'+conferenceId+'/slots/'+slotId;

    if(editable){
      url += '/edit';
    }

    $('#slotDetails').modal({
      remote: url
    });
    return false;
  });

  //FIXME this shouldn't be necessary at all. In schedule page tabs work but in conference show page 
  //this is required for some reason!
  $('.schedule-tabs a').click(function (e) {
    e.preventDefault()
    $(this).tab('show')
  })

});


//<td class="clickable-row1" data-hour="07:00" data-day="1" data-room="1">&nbsp;</td>