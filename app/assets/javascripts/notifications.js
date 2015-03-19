// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

ConfDeck.Notifications = {

    // Configuration
    container: '#header-dd-notification',
    indicator: '.indicator',
    app: ConfDeck,
    route: null,

    init: function(){
        this.app.log('Notifications Initializated')
        this.route = this.app.routes.notifications;
        _this = this;
        $(this.container).click(function(){
            _this.loadNotifications();
        })
    },

    loadNotifications: function(){
        _this = this;
        $.ajax({
            url: _this.route,
            cache: false,
            type: "GET",
            beforeSend: function(){
                _this.showIndicator();
            }
        }).done(function (data) {
            $(_this.container).find('.notifications-content').html(data);
            _this.hideIndicator();
            _this.UpdateTimeago()
        })
    },

    hideIndicator: function(){
        $(this.indicator).hide();
    },

    showIndicator: function(){
        $(this.indicator).show();
    },

    UpdateTimeago: function(){
        $('time[datetime]').timeago();
    }
}

$(document).ready(function(){
    ConfDeck.Notifications.init();
})