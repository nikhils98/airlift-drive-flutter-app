import 'dart:async';
import 'dart:math';

import 'package:airlift_drive/common/google_map_constants.dart';
import 'package:airlift_drive/ui/common/elevated_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'common/common_drawer.dart';

class SearchLocation extends StatefulWidget {
  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {

  Position currentLocation;
  Completer<GoogleMapController> mapController = Completer();
  final Set<Marker> markers = {};
  List<String> suggestions = List<String>();
  FocusNode originFocusNode = FocusNode();
  FocusNode destinationFocusNode = FocusNode();

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

          ),
          Container(
            padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
            child: Column(
              children: [
                ElevatedTextField(
                  autoFocus: true,
                  hint: isCurrentLocationNull ?
                  'Search pick up location' : 'My location',
                  focusNode: this.originFocusNode,
                  onChanged: (value) {
                    suggestions.clear();
                    places.autocomplete(value, region: "pk").then((value) => {
                      this.setState(() {
                        suggestions.addAll(value.predictions.map((e) => e.description));
                      })
                    });
                  },
                ),
                Container(
                  height: this.originFocusNode.hasFocus ? 200 : 0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: this.suggestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(suggestions[index])),
                      );
                  }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: ElevatedTextField(
                    hint: 'Search destination',
                    focusNode: this.destinationFocusNode,
                    onChanged: (value) {
                      suggestions.clear();
                      places.autocomplete(value, region: "pk").then((value) => {
                        this.setState(() {
                          suggestions.addAll(value.predictions.map((e) => e.description));
                        })
                      });
                    },
                  )
                ),
                Container(
                  height: this.destinationFocusNode.hasFocus ? 200 : 0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: this.suggestions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.white,
                          child: ListTile(
                              title: Text(suggestions[index])),
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
    print('${position.latitude}, ${position.longitude}, ${position.accuracy}');
    this.setState(() {
      /*this.markers.add(Marker(
        markerId: MarkerId('${position.latitude}, ${position.longitude}'),
        position: LatLng(position.latitude, position.longitude),
      ));*/
      this.currentLocation = position;
    });
  }
}
