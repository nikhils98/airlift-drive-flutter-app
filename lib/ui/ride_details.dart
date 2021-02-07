import 'dart:async';

import 'package:airlift_drive/common/google_map_constants.dart';
import 'package:airlift_drive/models/location_details.dart';
import 'package:airlift_drive/models/ride.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails extends StatefulWidget {
  RideDetails({Key key, @required this.ride,
    @required this.origin,
    @required this.destination,
    @required this.distance,
    @required this.duration
  }): super(key: key);

  final Ride ride;
  final LocationDetails origin, destination;
  final num distance, duration;

  @override
  _RideDetailsState createState() => _RideDetailsState();
}

class _RideDetailsState extends State<RideDetails> {

  @override
  void initState() {
    super.initState();
    this.setCurrentLocation();
  }

  Completer<GoogleMapController> mapController = Completer();
  Set<Marker> markers = {};

  onMapCreated(GoogleMapController controller) async {
    mapController.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    print(height);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Ride details", style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            height: height * 0.5,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: currentLocation ?? DEFAULT_LATLNG,
                  zoom: 16
              ),
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: onMapCreated,
            ),
          ),

        ],
      ),
    );
  }

  LatLng currentLocation;

  setCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var latLng = LatLng(position.latitude, position.longitude);
    (await mapController.future).animateCamera(CameraUpdate.newLatLng(latLng));

    this.setState(() {
      currentLocation = latLng;

      //selectedOrigin.coordinates = LatLng(position.latitude, position.longitude);
      //selectedOrigin.name = geocode.results[0].formattedAddress;
      //originTextController.text = selectedOrigin.name;
      //this.setMarkers();
    });
  }
}
