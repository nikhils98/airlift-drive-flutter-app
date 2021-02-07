import 'dart:async';

import 'package:airlift_drive/common/google_map_constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverRideDetails extends StatefulWidget {
  @override
  _DriverRideDetailsState createState() => _DriverRideDetailsState();
}

class _DriverRideDetailsState extends State<DriverRideDetails> {

  Completer<GoogleMapController> mapController = Completer();
  Set<Marker> markers = {};


  onMapCreated(GoogleMapController controller) async {
    mapController.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Ride Details", style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: currentLocation ?? DEFAULT_LATLNG,
            zoom: 16
        ),
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        onMapCreated: onMapCreated,
        //polylines: _polylines,
        markers: markers,
        mapType: MapType.normal,

      ),
    );
  }

  LatLng currentLocation;
  setCurrentLocation() async {

    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var latLng = LatLng(position.latitude, position.longitude);
    //(await mapController.future).animateCamera(CameraUpdate.newLatLng(latLng));

    this.setState(() {
      currentLocation = latLng;

      //selectedOrigin.coordinates = LatLng(position.latitude, position.longitude);
      //selectedOrigin.name = geocode.results[0].formattedAddress;
      //originTextController.text = selectedOrigin.name;
      //this.setMarkers();
    });
  }
}
