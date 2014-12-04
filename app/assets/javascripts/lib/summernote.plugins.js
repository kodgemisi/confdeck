(function (factory) {
    /* global define */
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['jquery'], factory);
    } else {
        // Browser globals: jQuery
        factory(window.jQuery);
    }
}(function ($) {
    // template, editor
    var tmpl = $.summernote.renderer.getTemplate();
    var editor = $.summernote.eventHandler.getEditor();

    // add plugin
    $.summernote.addPlugin({
        name: 'confdeck', // name of plugin
        buttons: {
            conferenceDropdown: function () {
                var templates =[
                    {
                        title: "Title",
                        value: "{{conference.title}}"
                    },
                    {
                        title: "Summary",
                        value: "{{conference.summary}}"
                    },
                    {
                        title: "Description",
                        value: "{{conference.description}}"
                    },
                    {
                        title: "Website Link",
                        value: "<a href='{{conference.website}}'>{{conference.title}}</a>",
                        html: true
                    },
                    {
                        title: "Twitter",
                        value: "{{conference.twitter}}"
                    },
                    {
                        title: "Facebook",
                        value: "{{conference.facebook}}"
                    },
                    {
                        title: "Logo",
                        value: "<img src='{{conference.logo_url}}'/>"
                    },
                ]
                var list = "";
                for(i = 0; i < templates.length; i++){
                    var t = templates[i];
                    if(t.html){
                        list += '<li><a data-event="insertHtml" href="#" data-value="'+ t.value +'">'+ t.title +'</a></li>';
                    }else{
                        list += '<li><a data-event="insertText" href="#" data-value="'+ t.value +'">'+ t.title +'</a></li>';
                    }                }

                var dropdown = '<ul class="dropdown-menu">' + list + '</ul>';

                return tmpl.button('Conference', {
                    title: 'Conference',
                    hide: true,
                    dropdown : dropdown
                });
            },
            topicDropdown: function () {
                var templates =[
                    {
                        title: "Subject",
                        value: "{{topic.title}}"
                    },
                    {
                        title: "Detail",
                        value: "{{topic.detail}}"
                    },
                    {
                        title: "Abstract",
                        value: "{{topic.abstract}}"
                    },
                    {
                        title: "Additional Info",
                        value: "{{topic.additional_info}}"
                    },
                    {
                        title: "Speakers List",
                        value: " <ul>\n                 {% for speaker in appeal.speakers %}\n\n                      <li> {{ speaker.name }}</li>\n                 {% endfor %}\n                </ul>\n",
                        html: true
                    },
                ]
                var list = "";
                for(i = 0; i < templates.length; i++){
                    var t = templates[i];
                    if(t.html){
                        list += '<li><a data-event="insertHtml" href="#" data-value="'+ t.value +'">'+ t.title +'</a></li>';
                    }else{
                        list += '<li><a data-event="insertText" href="#" data-value="'+ t.value +'">'+ t.title +'</a></li>';
                    }
                }

                var dropdown = '<ul class="dropdown-menu">' + list + '</ul>';

                return tmpl.button('Topic', {
                    title: 'Topic',
                    hide: true,
                    dropdown : dropdown
                });
            }

        },

        events: {
            insertText: function (layoutInfo, value) {
                // Get current editable node
                var $editable = layoutInfo.editable();
                // restore range
                editor.insertText($editable, value);
            },
            insertHtml: function (layoutInfo, value) {
                // Get current editable node
                var $editable = layoutInfo.editable();

                editor.insertNode($editable, $(value)[0]);
            }
        }
    });
}));