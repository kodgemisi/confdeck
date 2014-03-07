
$(function(){

    var appealTypeColors = ["#59ace2", "#A9D86E", "#8175c7", "#FCB322", "#FF6C60", "#a1a1a1", "#344860"]

    function dataSource_error(e) {
        if(e.xhr.status == 422){  // if unprocessable entry
            dataSource.remove(dataSource.get(0)) //Remove unsaved entries
            showError(e.xhr.responseText);
        }
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
                    topic_id: { type: "number", from: "topic_id" }
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
                        topic_id: response[i].topic_id,
                        start: new Date(parseInt(response[i].start)),
                        end: new Date(parseInt(response[i].end))
                    };
                    slots.push(slot);
                }
                return slots;
            }
        }
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
        if(e.response.length == 0){ //If there is no room open the create-room-window
            openCreateRoomWindow();
        }
    });

    var appealTypeSource = new kendo.data.SchedulerDataSource({
        batch: true,
        transport: {
            read: {
                url: appeal_types_url,
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
                        color: appealTypeColors[i]
                    };
                    types.push(type);
                }
                return types;
            }
        }
    });


    $("#scheduler").kendoScheduler({
        date: new Date(1392796800000),
        dataSource: dataSource,
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
                dataSource: appealTypeSource
            },
            {
                field: "room_id",
                dataValueField: "id",
                dataSource: roomSource
            }
        ]
    });
    window.scheduler = $("#scheduler").data("kendoScheduler");
    scheduler.bind("remove", function(e){
        var type_div = $(".appeal-type[data-type_id=" + e.event.id +"]") //Find appeal-type div

    })

    $(".draggable").kendoDraggable({
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
        dragend: function(row){
            if(scheduler.view()._slotByPosition(row.x.location, row.y.location)){ //Check whether its dropped to scheduler
                $(row.currentTarget).remove();
            }

        }
    });

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
                var topic_id = startResources.topic_id

                //Check whether a new event
                if (dataItem && slot && dataItem.attr("class").indexOf("draggable") != -1) {
                    var offsetMiliseconds = new Date().getTimezoneOffset() * 60000;
                    var newEvent = {
                        title: dataItem.data("subject"),
                        end: new Date(slot.startDate.getTime() + 1800000),
                        start: slot.startDate,
                        isAllDay: slot.isDaySlot,
                        room_id: room_id,
                        topic_id: dataItem.data("topic_id")
                    };

                    scheduler.dataSource.add(newEvent);
                    scheduler.dataSource.sync();
                    scheduler.dataSource.read();

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
    })

    var openCreateRoomWindow = function(){
        var win = $(".create-room-window").data("kendoWindow");
        win.center();
        win.open();
    }



})
//<td class="clickable-row1" data-hour="07:00" data-day="1" data-room="1">&nbsp;</td>