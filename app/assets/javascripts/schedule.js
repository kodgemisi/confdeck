//= require kendo.web
//= require kendo.validator
//= require kendo.scheduler
//= require kendo.scheduler.view
//= require kendo.scheduler.dayview
//= require kendo.scheduler.recurrence
//= require kendo.window

$(function(){
    if ($("#scheduler").length == 0)
        return;
    var speechTypeColors = ["#59ace2", "#A9D86E", "#8175c7", "#FCB322", "#FF6C60", "#a1a1a1", "#344860"]

    function dataSource_error(e) {
        if(e.xhr.status == 422){  // if unprocessable entry
            dataSource.remove(dataSource.get(0)) //Remove unsaved entries
            showError(e.xhr.responseText);
        }
        console.log(e)
    }

    window.dataSource = new kendo.data.SchedulerDataSource({
        batch: false,
        transport: {
            read: {
                url: schedule_url,
                dataType: "json"
            },
            update: {
                url: schedule_url,
                dataType: "json",
                type: "PUT"
            },
            create: {
                url: schedule_url,
                dataType: "json",
                type: "POST"
            },
            destroy: {
                url: schedule_url,
                dataType: "json",
                type: "DELETE"
            },
//            parameterMap: function (options, operation) {
//                if (operation !== "read" && options.models) {
//                    return {models: kendo.stringify(options.models)};
//                }
//            }
        },
        schema: {
            model: {
                id: "id",
                fields: {
                    id: { type: "number" },
                    title: { from: "title", defaultValue: "No title", editable: false},
                    start: { type: "date", from: "start" },
                    end: { type: "date", from: "end" },
                    room_id: { type: "number", from: "room_id", defaultValue: 1 },
                    type_id: { type: "number", from: "type_id", defaultValue: 25 },
                    speech_id: { type: "number", from: "speech_id" }
                }
            },
            parse: function (response) {
                var slots = [];
                for (var i = 0; i < response.length; i++) {
                    var slot = {
                        id: response[i].id,
                        title: response[i].title,
                        room_id: response[i].room_id,
                        type_id: response[i].type_id,
                        speech_id: response[i].speech_id,
                        start: new Date(parseInt(response[i].start)),
                        end: new Date(parseInt(response[i].end))
                    };
                    slots.push(slot);
                }
                return slots;
            }
        },
        requestEnd: function (e) {
            if(e.type == "destroy"){
                $(".speech-list").load(window.speech_list_url, function(){
                    $(".draggable").kendoDraggable(draggableConfig);

                });

            }
        },
        sync: function(e) {
            scheduler.dataSource.read();
        },
    });
    dataSource.bind("error", dataSource_error);

    var roomSource = new kendo.data.SchedulerDataSource({
        batch: true,
        transport: {
            read: {
                url: rooms_url,
                dataType: "json"
            }
        },
        schema: {
            model: {
                id: "id",
                fields: {
                    id: { type: "number" },
                    text: { from: "name", defaultValue: "No title", editable: false}
                }
            }
        },
        change: function (e) {
            refreshScheduler()
        }
    });
    roomSource.bind("error", dataSource_error);
    roomSource.bind("requestEnd", function(e){
        if(e.response && e.response.length == 0){ //If there is no room open the create-room-window
            openCreateRoomWindow();
        }
    });

    var speechTypeSource = new kendo.data.SchedulerDataSource({
        batch: true,
        transport: {
            read: {
                url: speech_types_url,
                dataType: "json"
            }
        },
        schema: {
            model: {
                id: "id",
                fields: {
                    id: { type: "number" },
                    text: { from: "type_name", defaultValue: "No title", editable: false},
                    color: { from: "color", defaultValue: "red"}
                }
            },
            parse: function (response) {
                var types = [];
                for (var i = 0; i < response.length; i++) {
                    var type = {
                        id: response[i].id,
                        text: response[i].type_name,
                        color: speechTypeColors[i]
                    };
                    types.push(type);
                }
                return types;
            }
        }
    });


    $("#scheduler").kendoScheduler({
        date: new Date(window.conference.start_date),
        dataSource: dataSource,
        majorTick: 30,
        timezone: "UTC",
        group: {
            resources: ["room_id"]
        },
        allDaySlot: false,
        edit: function (e) { //remove all day check box and recurrence rule editor
            e.container
                .find("[name=isAllDay]") // find the all day checkbox
                .parent()
                .prev()
                .remove()
                .end()
                .remove();
            e.container.find("*[for=recurrenceRule]").parent().remove()
            e.container.find("*[data-container-for=recurrenceRule]").remove()
        },
        remove: function (e) {
            console.log("Removing", e.event.title);
        },
        dataBound: function (e) {
            createDropArea(this);
        },
        resources: [
            {
                field: "type_id",
                dataValueField: "id",
                dataSource: speechTypeSource
            },
            {
                field: "room_id",
                dataValueField: "id",
                dataSource: roomSource
            }
        ]
    });
    window.scheduler = $("#scheduler").data("kendoScheduler");

    var draggableConfig = {
        hint: function (row) {

            //remove old selection
            row.parent().find(".k-state-selected").each(function () {
                $(this).removeClass("k-state-selected")
            })

            //add selected class to the current row
            row.addClass("k-state-selected");

            var dataItem = row
            var tooltipHtml = "<div class='k-event' id='dragTooltip'><div class='k-event-template'>" +
                "</div><div class='k-event-template'>" + dataItem.data("subject") +
                "</div></div>";

            return $(tooltipHtml).css("width", 300);
        },
        dragend: function (row) {
            //Removed due to event disappearing bug

            //if (true || scheduler.view()._slotByPosition(row.x.location, row.y.location)) { //Check whether its dropped to scheduler
            //    $(row.currentTarget).remove();
            //
            //}

        },
        cursorOffset: {
            top: -($('.draggable').height() / 2),
            left: -($('.draggable').width() / 2)
        },
    };
    $(".draggable").kendoDraggable(draggableConfig);

    function createDropArea(scheduler) {
        scheduler.view().content.kendoDropTargetArea({
            filter: ".k-scheduler-table td, .k-event",
            drop: function (e) {
                var view = scheduler.view();

                var offset = $(e.dropTarget).offset();
                var slot = scheduler.slotByPosition(offset.left, offset.top);
                var dataItem = e.draggable.element;

                //To get Room Id
                var startSlot = view._slotByPosition(offset.left, offset.top);
                var startResources = view._resourceBySlot(startSlot);
                var room_id = startResources.room_id
                var speech_id = startResources.speech_id

                //Check whether a new event
                if (dataItem && slot && dataItem.attr("class").indexOf("draggable") != -1) {
                    var offsetMiliseconds = new Date().getTimezoneOffset() * 60000;
                    var newEvent = {
                        title: dataItem.data("subject"),
                        end: new Date(slot.startDate.getTime() + 1800000),
                        start: slot.startDate,
                        isAllDay: slot.isDaySlot,
                        room_id: room_id,
                        speech_id: dataItem.data("speech_id")
                    };

                    scheduler.dataSource.add(newEvent);
                    scheduler.dataSource.sync();
                    $(e.draggable.element).remove()

                }


            }
        });
    };

    function refreshScheduler(){
        if (typeof(scheduler.view()) != "undefined")
            scheduler.view(scheduler.view().name); //re-render
    }

    $(".create-room-window").kendoWindow({
        actions: ["Close"],
        draggable: true,
        height: "200px",
        modal: true,
        pinned: false,
        resizable: false,
        visible: false,
        title: "Create Room",
        width: "500px"
    });

    var createRoomWindow = $(".create-room-window").data("kendoWindow");
    createRoomWindow.bind("close", function () {
        roomSource.read();
    })


    $(".create-room-button").click(function(){
        openCreateRoomWindow();
        $('.create-room-window').find('.k-notification-error').hide();
        $('#room_name').val('')
    })

    var openCreateRoomWindow = function(){
        var win = $(".create-room-window").data("kendoWindow");
        win.center();
        win.open();
    }


    window.scheduler.bind("navigate", function(e){
        start_date = new Date(new Date(window.conference.start_date).toDateString()); //monkey patch for timezone offsets
        end_date = new Date(new Date(window.conference.end_date).toDateString());
        if (e.date < start_date || e.date > end_date ) {
            e.preventDefault();
        }
    })

})
//<td class="clickable-row1" data-hour="07:00" data-day="1" data-room="1">&nbsp;</td>