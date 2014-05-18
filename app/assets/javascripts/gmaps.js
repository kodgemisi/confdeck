function initialize() {

    var markers = [];
    if(document.getElementById('map-canvas')){

        if($('#map_lat').val() != "" && $('#map_lon').val() != ""){
            var center_coord = new google.maps.LatLng($('#map_lat').val(), $('#map_lon').val());
            var zoom = 8;
        }else{
            var center_coord = new google.maps.LatLng(41.005811774870615, 28.96820068359375);
            var zoom = 3;
        }


        window.map = new google.maps.Map(document.getElementById('map-canvas'), {
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            center: center_coord ,
            zoom: zoom
        });


        window.markermap = new google.maps.Marker({
            position: center_coord,
            map: map,
            title: ""
        });

        google.maps.event.addListener(map, "click", function (event) {
            if (markermap) {
                markermap.setMap(null);
            }

            markermap = new google.maps.Marker({
                position: event.latLng,
                map: map,
                title: ""
            });
        });


        // Create the search box and link it to the UI element.
        var input = document.getElementById('target');
        var searchBox = new google.maps.places.SearchBox(input);

        google.maps.event.addListener(map, 'click', function (event) {
            var myLatLng = event.latLng;
            var lat = myLatLng.lat();
            var lng = myLatLng.lng();

            $('#map_lat').val(lat);
            $('#map_lon').val(lng);
        })


        // [START region_getplaces]
        // Listen for the event fired when the user selects an item from the
        // pick list. Retrieve the matching places for that item.
        google.maps.event.addListener(searchBox, 'places_changed', function () {
            var places = searchBox.getPlaces();

            for (var i = 0, marker; marker = markers[i]; i++) {
                marker.setMap(null);
            }

            // For each place, get the icon, place name, and location.
            markers = [];
            var bounds = new google.maps.LatLngBounds();
            for (var i = 0, place; place = places[i]; i++) {
                var image = {
                    url: place.icon,
                    size: new google.maps.Size(71, 71),
                    origin: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(17, 34),
                    scaledSize: new google.maps.Size(25, 25)
                };


                bounds.extend(place.geometry.location);
            }

            map.fitBounds(bounds);
        });
        // [END region_getplaces]

        // Bias the SearchBox results towards places that are within the bounds of the
        // current map's viewport.
        google.maps.event.addListener(map, 'bounds_changed', function () {
            var bounds = map.getBounds();
            searchBox.setBounds(bounds);
        });
    }
}

google.maps.event.addDomListener(window, 'load', initialize);