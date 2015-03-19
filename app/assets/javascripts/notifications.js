// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

ConfDeck.Notifications = {

    // Configuration
    container: '#header-dd-notification',
    indicator: '.indicator',
    app: ConfDeck,
    routes: null,

    init: function(){
        this.app.log('Notifications Initializated')
        this.routes = this.app.routes.notifications;
        _this = this;
        $(this.container).click(function(){
            _this.loadNotifications();
        })

        $('#readNotifications').click(function(e){
            e.stopPropagation();

            _this.readAllNotifications();
        })
    },

    loadNotifications: function(){
        _this = this;
        $.ajax({
            url: _this.routes.index,
            cache: false,
            type: "GET",
            beforeSend: function(){
                _this.showIndicator();
            }
        }).done(function (data) {
            $(_this.container).find('.notifications-content').html(data);
            _this.hideIndicator();
            _this.updateTimeago()
        })
    },

    readAllNotifications: function(){
        _this = this;
        $.ajax({
            url: _this.routes.read_all,
            cache: false,
            type: "GET",
            beforeSend: function(){
                _this.showIndicator();
            }
        }).done(function (data) {
            _this.hideIndicator();
            _this.markAsRead()
        })
    },

    hideIndicator: function(){
        $(this.indicator).hide();
    },

    showIndicator: function(){
        $(this.indicator).show();
    },

    updateTimeago: function(){
        $('time[datetime]').timeago();
    },

    markAsRead: function(){
        $(this.container).find('.notifications-content .media').removeClass('unread')
        $(this.container).find('.notifications-content .media').addClass('read')
    }
}

$(document).ready(function(){
    ConfDeck.Notifications.init();
})