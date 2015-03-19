window.ConfDeck = {
    logger: console,
    routes: {},
    
    init: function(){
        this.log('ConfDeck Init')
    },

    log: function(data){
        this.logger.log(data);
    }
}

$(document).ready(function(){
    ConfDeck.init();
})