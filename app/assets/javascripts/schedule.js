
$(function(){

    var appealTypeColors = ["red", "green"]

    function dataSource_error(e) {
        console.log(e.status); // displays "error"
    }

    window.dataSource = new kendo.data.SchedulerDataSource({
        batch: true,
        transport: {
            read: {
                url: "http://localhost:3000/conferences/dedecon/schedule.json",
                dataType: "json"
            },
            update: {
                url: "http://localhost:3000/conferences/dedecon/schedule.json",
                dataType: "json",
                type: "PUT"
            },
            create: {
                url: "http://localhost:3000/conferences/dedecon/schedule.json",
                dataType: "json",
                type: "POST"
            },
            destroy: {
                url: "http://localhost:3000/conferences/dedecon/schedule.json",
                dataType: "json",
                type: "DELETE"
            },
            parameterMap: function (options, operation) {
                if (operation !== "read" && options.models) {
                    return {models: kendo.stringify(options.models)};
                }
            }
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
                    type_id: { type: "number", from: "type_id", defaultValue: 25 }
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
                url: "http://localhost:3000/conferences/dedecon/rooms.json",
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
        }
    });

    var appealTypeSource = new kendo.data.SchedulerDataSource({
        batch: true,
        transport: {
            read: {
                url: "http://localhost:3000/conferences/dedecon/appeal_types.json",
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

                //Check whether a new event
                if (dataItem && slot && dataItem.attr("class").indexOf("draggable") != -1) {
                    var offsetMiliseconds = new Date().getTimezoneOffset() * 60000;
                    var newEvent = {
                        title: dataItem.data("subject"),
                        end: new Date(slot.startDate.getTime() + 1800000),
                        start: slot.startDate,
                        isAllDay: slot.isDaySlot,
                        room_id: room_id
                    };

                    scheduler.dataSource.add(newEvent);
                    scheduler.dataSource.sync();
                }

            }
        });
    }


})
//<td class="clickable-row1" data-hour="07:00" data-day="1" data-room="1">&nbsp;</td>