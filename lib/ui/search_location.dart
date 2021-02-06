import 'dart:async';
import 'dart:math';

import 'package:airlift_drive/common/google_map_constants.dart';
import 'package:airlift_drive/models/location_details.dart';
import 'package:airlift_drive/ui/common/elevated_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_polyline_points/src/utils/request_enums.dart' as PolyLinePointsEnum;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'common/common_drawer.dart';

class SearchLocation extends StatefulWidget {
  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {

  Position currentLocation;
  Completer<GoogleMapController> mapController = Completer();
  Set<Marker> markers = {};

  List<Prediction> predictions;
  List<String> suggestions = List<String>();

  var originFocusNode = FocusNode();
  var destinationFocusNode = FocusNode();

  var selectedOrigin = LocationDetails();
  var selectedDestination = LocationDetails();

  var originTextController = TextEditingController();
  var destTextController = TextEditingController();

  Set<Polyline> _polylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    this.setCurrentLocation();
  }

  onMapCreated(GoogleMapController controller) async {
    mapController.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentLocationNull = this.currentLocation == null;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Search', style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.my_location_outlined, color: Colors.black,),
        onPressed: () async {
          (await mapController.future).animateCamera(CameraUpdate.newLatLng(
            LatLng(this.currentLocation.latitude, this.currentLocation.longitude)
          ));
        },
      ),
      drawer: CommonDrawer(),
      body: Stack(
        overflow: Overflow.clip,
        children: [
          if (isCurrentLocationNull) Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator()
          )
          else GoogleMap(
            onMapCreated: this.onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(this.currentLocation.latitude, this.currentLocation.longitude),
              zoom: 16,
            ),
            zoomControlsEnabled: false,
            markers: this.markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            polylines: _polylines,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
            child: Column(
              children: [
                ElevatedTextField(
                  controller: this.originTextController,
                  autoFocus: true,
                  hint: 'Search pick up location',
                  focusNode: this.originFocusNode,
                  onChanged: (value) {
                    suggestions.clear();
                    places.autocomplete(value, region: "pk").then((value) => {
                      this.setState(() {
                        predictions = value.predictions;
                        suggestions.addAll(predictions.map((e) => e.description));
                      })
                    });
                  },
                ),
                Container(
                  height: this.originFocusNode.hasFocus && this.suggestions.length > 0 ? 200 : 0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: this.suggestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(suggestions[index]),
                          onTap: () async {
                            this.selectedOrigin.name = suggestions[index];
                            var response = await geocoding.searchByPlaceId(predictions.firstWhere((element) =>
                              element.description == suggestions[index]
                            ).placeId
                            );
                            var location = response.results[0].geometry.location;
                            this.selectedOrigin.coordinates = LatLng(location.lat, location.lng);
                            this.setPolylines();

                            this.setState(() {
                              this.setMarkers();
                              this.originTextController.text = suggestions[index];
                              this.originFocusNode.unfocus();
                              this.suggestions.clear();
                            });
                          },
                        ),
                      );
                  }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: ElevatedTextField(
                    controller: this.destTextController,
                    hint: 'Search destination',
                    focusNode: this.destinationFocusNode,
                    onChanged: (value) {
                      suggestions.clear();
                      places.autocomplete(value, region: "pk").then((value) => {
                        this.setState(() {
                          predictions = value.predictions;
                          suggestions.addAll(predictions.map((e) => e.description));
                        })
                      });
                    },
                  )
                ),
                Container(
                  height: this.destinationFocusNode.hasFocus && this.suggestions.length > 0 ? 200 : 0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: this.suggestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(suggestions[index]),
                          onTap: () async {
                            this.selectedDestination.name = suggestions[index];
                            var response = await geocoding.searchByPlaceId(predictions.firstWhere((element) =>
                              element.description == suggestions[index]
                            ).placeId
                            );
                            var location = response.results[0].geometry.location;
                            this.selectedDestination.coordinates = LatLng(location.lat, location.lng);
                            this.setPolylines();
                            this.setState(() {
                              this.setMarkers();
                              this.destTextController.text = suggestions[index];
                              this.destinationFocusNode.unfocus();
                              this.suggestions.clear();
                            });
                          },
                        ),
                      );
                    }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  setCurrentLocation() async {
    //var position = await Geolocator.getLastKnownPosition();
    //if(position == null)
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var geocode = await geocoding.searchByLocation(Location(position.latitude, position.longitude));
    //print('${position.latitude}, ${position.longitude}, ${position.accuracy}');
    this.setState(() {
      /*this.markers.add(Marker(
        markerId: MarkerId('${position.latitude}, ${position.longitude}'),
        position: LatLng(position.latitude, position.longitude),
      ));*/
      currentLocation = position;
      selectedOrigin.coordinates = LatLng(position.latitude, position.longitude);
      selectedOrigin.name = geocode.results[0].formattedAddress;
      originTextController.text = selectedOrigin.name;
      this.setMarkers();
    });
  }

  final sourceMarkerId = MarkerId("sourceMarkerId");
  final destMarkerId = MarkerId("destMarkerId");

  setMarkers() {
    var markers = Set<Marker>();
    if(this.selectedOrigin.coordinates != null) {
      markers.add(Marker(
        markerId: sourceMarkerId,
        position: this.selectedOrigin.coordinates
      ));
    }
    if(this.selectedDestination.coordinates != null) {
      markers.add(Marker(
          markerId: destMarkerId,
          position: this.selectedDestination.coordinates
      ));
    }
    this.markers = markers;
  }

  setPolylines() async {
    if(this.selectedOrigin.coordinates != null && this.selectedDestination.coordinates != null) {
      var result = await polylinePoints.getRouteBetweenCoordinates(
          GOOGLE_API_KEY,
          PointLatLng(
              selectedOrigin.coordinates.latitude,
              selectedOrigin.coordinates.longitude
          ),
          PointLatLng(
              selectedDestination.coordinates.latitude,
              selectedDestination.coordinates.longitude
          ),
        travelMode: PolyLinePointsEnum.TravelMode.driving
      );
      if (result.points.length > 0) {

        result.points.forEach((element) {
          print(element.toString());
        });
        print("length: ${result.points.length}");

        LatLng southWest = LatLng(
          min(selectedOrigin.coordinates.latitude, selectedDestination.coordinates.latitude),
          min(selectedOrigin.coordinates.longitude, selectedDestination.coordinates.longitude)
        );

        LatLng northEast = LatLng(
            max(selectedOrigin.coordinates.latitude, selectedDestination.coordinates.latitude),
            max(selectedOrigin.coordinates.longitude, selectedDestination.coordinates.longitude)
        );

        (await mapController.future).animateCamera(CameraUpdate.newLatLngBounds(
            LatLngBounds(southwest: southWest, northeast: northEast), 115
        ));

        setState(() {
          polylineCoordinates.clear();
          polylineCoordinates.addAll(result.points.map((e) => LatLng(e.latitude, e.longitude)));
          // create a Polyline instance
          // with an id, an RGB color and the list of LatLng pairs
          Polyline polyline = Polyline(
              polylineId: PolylineId("poly"),
              color: Colors.red,
              width: 5,
              points: polylineCoordinates
          );

          // add the constructed polyline as a set of points
          // to the polyline set, which will eventually
          // end up showing up on the map
          _polylines.clear();
          _polylines.add(polyline);
        });
      }
    }
  }
}
