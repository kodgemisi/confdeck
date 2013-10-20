//= require jquery
//= require bootstrap

$(function() {

  var slotDiv = '<div class="slot-div" data-slot-id="{ID}"><div>';
  
  // addSlot click handler on TDs
  $('td[data-hour]').click(function() {
    debugger
    var hour = $(this).data('hour');
    var jModal = $(this).closest('table').siblings('.modal');

    //fill hour&minute
    jModal.find('[name="slot[start_hour(4i)]"]').val(hour.split(':')[0]);
    jModal.find('[name="slot[start_hour(5i)]"]').val(hour.split(':')[1]);

    jModal.modal();// show modal
  });

  $('.slot-div').click(function(e) {
    debugger
    return false;
  });

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
    var cellHeight = startCell.outerHeight();
    var height = slot.duration / 30 * cellHeight;
    var top = (startMinute >= 30 ? startMinute - 30 : startMinute ) / 30 * cellHeight;
    top += 2; // 2px top margin
    height -= (height % cellHeight == 0 && top == 0 ? 5 : 0); // 2px bottom margin, this is equal to top, left and right margin
    startCell.append(slotDiv.replace('{ID}', slot.id));
    var currentSlotDiv = $('[data-slot-id="'+slot.id+'"]');
    currentSlotDiv.css('height', height).css('top', top).text('Duration: ' + slot.duration + ' minutes');
  }

  traverseSlots(window.slotsData);
});


//<td class="clickable-row1" data-hour="07:00" data-day="1" data-room="1">&nbsp;</td>