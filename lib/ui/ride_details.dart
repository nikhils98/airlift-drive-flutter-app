import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:airlift_drive/common/google_map_constants.dart';
import 'package:airlift_drive/common/util.dart';
import 'package:airlift_drive/models/location_details.dart';
import 'package:airlift_drive/models/ride.dart';
import 'package:airlift_drive/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geodesy/geodesy.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' hide Polyline;
import 'package:google_maps_webservice/src/core.dart' as GoogleMapsWebservice;
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'common/action_button.dart';

class RideDetails extends StatefulWidget {
  RideDetails({Key key, @required this.ride,
    @required this.origin,
    @required this.destination,
    this.distance,
    this.duration,
    this.passengerCoordinates,
    this.isRideRegistered = false
  }): super(key: key);

  final Ride ride;
  final LocationDetails origin, destination;
  final num distance, duration;
  List<LatLng> passengerCoordinates;
  bool isRideRegistered;

  @override
  _RideDetailsState createState() => _RideDetailsState();
}

class _RideDetailsState extends State<RideDetails> {

  @override
  void initState() {
    super.initState();
    this.setCurrentLocation();
    this.setPolyLines();
  }

  var geodesy = geo.Geodesy();

  Completer<GoogleMapController> mapController = Completer();
  Set<Marker> markers = {};
  Set<Polyline> _polylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> driverPolylineCoordinates = [];
  List<LatLng> passengerPolylineCoordinates = [];

  onMapCreated(GoogleMapController controller) async {
    mapController.complete(controller);
  }



  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

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
      floatingActionButton: Container(
          padding: EdgeInsets.only(right: 15, left: 50),
          alignment: Alignment.bottomCenter,
          child: !widget.isRideRegistered ? ActionButton(text: "Register In Ride", onPressed: () async {
            //var json = jsonEncode({"status": "REQUESTED"});

            if(myInfo.alcs >= widget.ride.fare) {
              var json = jsonEncode({"pickupLocation": [closestStartPoint.latitude, closestStartPoint.longitude],
                "dropoffLocation": [closestEndPoint.latitude, closestEndPoint.longitude]});
              var response = await post(
                  '${DRIVE_API_URL}/ride/${widget.ride.id}/${myInfo.id}/request',
                  headers: HEADERS, body: json);
              print(response.statusCode);
              if (response.statusCode == 201) {
                var response = await get('${DRIVE_API_URL}/user/${myInfo.id}', headers: HEADERS);
                myInfo = User.fromJson(jsonDecode(response.body));
                Fluttertoast.showToast(msg: "Registered in ride");
                setState(() {
                  widget.isRideRegistered = true;
                });
              }
            } else {
              showDialog(context: context, child:
              AlertDialog(
                  title: Text("You don't have enough credits"),
                  content: Icon(Icons.info, color: Colors.red, size: 30,)
              )
              );
            }
          },) :
          ActionButton(text: "Cancel", onPressed: () async {
            var json = jsonEncode({"status": "CANCELLED"});
            var response = await put('${DRIVE_API_URL}/${widget.ride.id}/${myInfo.id}/status',
                headers: HEADERS, body: json);
            print(response.statusCode);
            if(response.statusCode == 201) {
              Fluttertoast.showToast(msg: "Cancelled");
              setState(() {
                widget.isRideRegistered = false;
              });
            }
          },)
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

  LatLng closestStartPoint, closestEndPoint;
  setPolyLines() async {
    var driverCoordinates = List<LatLng>();
    for(var coordinates in widget.ride.route) {
      print('route ' + coordinates.coordinates.toString());
      driverCoordinates.add(LatLng(coordinates.coordinates.latitude, coordinates.coordinates.longitude));
    }

    closestStartPoint = getClosestLatLng(driverCoordinates, widget.origin.coordinates);
    closestEndPoint = getClosestLatLng(driverCoordinates, widget.destination.coordinates);
    var passengerCoordinatesInRide = List<LatLng>();
    int startIndex = driverCoordinates.indexOf(closestStartPoint);
    int endIndex = driverCoordinates.indexOf(closestEndPoint);
    for(int i = startIndex; i <= endIndex; i++) {
      passengerCoordinatesInRide.add(driverCoordinates[i]);
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

      this.driverPolylineCoordinates = driverCoordinates;
      this.passengerPolylineCoordinates = passengerCoordinatesInRide;
      var driverPolyline = Polyline(
          polylineId: PolylineId("driverPoly"),
          color: Colors.grey,
          width: 5,
          points: driverCoordinates
      );

      var passengerPolyLineInRide = Polyline(
          polylineId: PolylineId("passengerPolyInRide"),
          color: Colors.red[600],
          width: 5,
          points: passengerCoordinatesInRide
      );

      if(widget.passengerCoordinates?.isNotEmpty) {
        var passengerPolyLine = Polyline(
            polylineId: PolylineId("passengerPoly"),
            color: Colors.red[200],
            width: 5,
            points: widget.passengerCoordinates
        );
        _polylines.add(passengerPolyLine);
      }

      _polylines.add(driverPolyline);
      _polylines.add(passengerPolyLineInRide);
      this.setMarkers();
      this.setStartMarker(closestStartPoint, bd);
    });
  }

  setStartMarker(LatLng startPoint, BitmapDescriptor bd) {
    this.markers.add(Marker(
      markerId: MarkerId("startMarkerId"),
      position: startPoint,
      icon: bd
    ));
  }

  setMarkers() {
    var markers = Set<Marker>();
    markers.add(Marker(
      markerId: MarkerId("destMarkerId"),
      position: passengerPolylineCoordinates.last,
      //icon: bd
    ));
      this.markers = markers;
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

  LatLng getClosestLatLng(List<LatLng> route, LatLng point) {

    double min = double.maxFinite;
    LatLng closest = route[0];

    for(var coodinates in route) {
      var dist = geodesy.distanceBetweenTwoGeoPoints(
          geo.LatLng(coodinates.latitude, coodinates.longitude),
          geo.LatLng(point.latitude, point.longitude)
      );
      if(dist < min) {
        closest = coodinates;
        min = dist;
      }
    }

    return closest;
  }
}
