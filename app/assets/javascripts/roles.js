//= require selectize

$(document).ready(function(){
    $("#confadmins, #confusers").selectize({
        persist: false,
        maxItems: null,
        valueField: "id",
        labelField: "email",
        searchField: "email",
        render: {
            option: function (item, escape) {
                var organizations = ""
                for(var i = 0, n = item.organizations.length; i < n; i++) {
                    org = item.organizations[i]

                    if(i==n-1){
                        organizations += org.name
                    }else{
                        organizations += org.name + ", "
                    }
                }

                //TODO NAME WILL BE ADDED
                var label =  item.email;

                var caption = true;
                return "<div>" +
                    "<span class=\"text-primary\">" + escape(label) + "</span><br/>" +
                    (caption ? "<small class=\"text-muted\">" + escape(organizations) + "</small>" : "") +
                    "</div>";
            }
        },
        load: function(query, callback) {
            if (!query.length) return callback();
            $.ajax({
                url: $($(this)[0].$input[0]).data("ajax-path"),
                type: 'GET',
                dataType: 'json',
                data: {
                    query: query
                },
                error: function(e) {
                    callback();
                },
                success: function(res) {
                    callback(res);
                }
            });
        },
        onInitialize: function() {
            var elem = $($(this)[0].$input[0]);
            var objects = [];
            var _this = this;
            $.each(elem.data('values'), function (i, b) {
                objects[b.value] = { id: b.id, email: b.email};
                _this.addOption({ id: b.id, email: b.email})
                _this.addItem(b.id)
            });

        },
        preLoad: function(data) {
            var self = this;

            //  Add options to be able to insert the items
            this.options = data;

            // Add items
            Object.keys(data).forEach(function(key) {
                self.addOption(key);
                self.addItem(key);
            });

            // Clear Options
            self.options = self.sifter.items = {};
        }
    });

})