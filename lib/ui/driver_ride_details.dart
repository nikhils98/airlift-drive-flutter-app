import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:airlift_drive/common/google_map_constants.dart';
import 'package:airlift_drive/common/util.dart';
import 'package:airlift_drive/models/ride.dart';
import 'package:airlift_drive/ui/common/action_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class DriverRideDetails extends StatefulWidget {

  DriverRideDetails({Key key, this.ride}): super(key: key);

  Ride ride;

  @override
  _DriverRideDetailsState createState() => _DriverRideDetailsState();
}

class _DriverRideDetailsState extends State<DriverRideDetails> {

  @override
  void initState() {
    super.initState();
    this.setCurrentLocation();
    this.setPolyLines();
    status = widget.ride.status;
  }

  Completer<GoogleMapController> mapController = Completer();
  Set<Marker> markers = {};

  onMapCreated(GoogleMapController controller) async {
    mapController.complete(controller);
  }

  String status;

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
      floatingActionButton: status == "COMPLETED" ? Container() : Container(
          padding: EdgeInsets.only(right: 15, left: 50),
          alignment: Alignment.bottomCenter,
        child: status == "ACTIVE" ?
        ActionButton(
          text: "End ride",
          onPressed: () async {
            var json = jsonEncode({"status": "COMPLETED"});
            var response = await put('${DRIVE_API_URL}/ride/${widget.ride.id}/status', headers: HEADERS, body: json);
            print(response.statusCode);
            setState(() {
              this.status = "COMPLETED";
            });
          },
        ) :
        ActionButton(
          text: "Start ride",
          onPressed: () async {
            var json = jsonEncode({"status": "ACTIVE"});
            var response = await put('${DRIVE_API_URL}/ride/${widget.ride.id}/status', headers: HEADERS, body: json);
            print(response.statusCode);
            setState(() {
              this.status = "ACTIVE";
            });
          },
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: currentLocation ?? DEFAULT_LATLNG,
            zoom: 16
        ),
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        onMapCreated: onMapCreated,
        polylines: _polylines,
        markers: markers,
        mapType: MapType.normal,

      ),
    );
  }

  Set<Polyline> _polylines = {};
  List<LatLng> driverCoordinates;

  setPolyLines() async{
    var driverCoordinates = List<LatLng>();
    for(var coordinates in widget.ride.route) {
      print('route ' + coordinates.coordinates.toString());
      driverCoordinates.add(LatLng(coordinates.coordinates.latitude, coordinates.coordinates.longitude));
    }

    LatLng southWest = LatLng(
        min(driverCoordinates[0].latitude, driverCoordinates.last.latitude),
        min(driverCoordinates[0].longitude, driverCoordinates.last.longitude)
    );

    LatLng northEast = LatLng(
        max(driverCoordinates[0].latitude, driverCoordinates.last.latitude),
        max(driverCoordinates[0].longitude, driverCoordinates.last.longitude)
    );

    (await mapController.future).animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: southWest, northeast: northEast), 115
    ));

    var bd = await Util.getBitmapDescriptorFromIconData(Icons.accessibility);

    setState(() {
      this.driverCoordinates = driverCoordinates;
      var driverPolyline = Polyline(
          polylineId: PolylineId("driverPoly"),
          color: Colors.red,
          width: 5,
          points: driverCoordinates
      );

      _polylines.add(driverPolyline);
      this.setMarkers(bd);
    });
  }

  setMarkers(BitmapDescriptor bd) {
    if(this.driverCoordinates != null) {
      markers.add(Marker(
          markerId: MarkerId("origin"),
          position: this.driverCoordinates[0],
          icon: bd
      ));
      markers.add(Marker(
          markerId: MarkerId("dest"),
          position: this.driverCoordinates.last
      ));

      for(var rideUser in widget.ride.rideUsers) {
        if(rideUser.pickUpLocation?.coordinates != null) {
          markers.add(Marker(
              markerId: MarkerId("origin" + rideUser.id.toString()),
              position: LatLng(rideUser.pickUpLocation.coordinates.latitude, rideUser.pickUpLocation.coordinates.longitude)
          ));
        }
        if(rideUser.dropOffLocation?.coordinates != null) {
          markers.add(Marker(
              markerId: MarkerId("dest" + rideUser.id.toString()),
              position: LatLng(rideUser.dropOffLocation.coordinates.latitude, rideUser.dropOffLocation.coordinates.longitude)
          ));
        }
      }
    }
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
