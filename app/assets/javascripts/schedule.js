//= require jquery

$(function() {
  $('.add-slot').hide();

  $('td[data-hour]').click(function() {
    var hour = $(this).data('hour');
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

  var slotDiv = '<div class="slot-div" data-slot-id="{ID}"><div>';
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
    height -= 5; // 2px bottom margin, this is equal to top, left and right margin
    startCell.append(slotDiv.replace('{ID}', slot.id));
    var currentSlotDiv = $('[data-slot-id="'+slot.id+'"]');
    currentSlotDiv.css('height', height).css('top', top).text('Slot content');
  }

  traverseSlots(window.slotsData);

});


//<td class="clickable-row1" data-hour="07:00" data-day="1" data-room="1">&nbsp;</td>