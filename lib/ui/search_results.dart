import 'dart:convert';

import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:airlift_drive/models/location_details.dart';
import 'package:airlift_drive/models/mock_response.dart';
import 'package:airlift_drive/models/ride.dart';
import 'package:airlift_drive/ui/common/common_drawer.dart';
import 'package:airlift_drive/ui/common/rides_list.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

import 'common/elevated_text_field.dart';

class SearchResults extends StatefulWidget {

  SearchResults({
    Key key,
    @required this.origin,
    @required this.destination,
    @required this.distance,
    @required this.duration,
    @required this.polyLineCoordinates
  }): super(key: key);

  final LocationDetails origin, destination;
  final num distance, duration;
  List<LatLng> polyLineCoordinates;

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  void initState() {
    super.initState();
    this.setRides();
  }

  List<Ride> rides;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Choose a ride', style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
            child: Column(
              children: [
                ElevatedTextField(
                  readonly: true,
                  hint: widget.origin.name,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: ElevatedTextField(
                      hint: widget.destination.name,
                      readonly: true,
                    )
                ),
              ],
            ),
          ),
          this.rides == null ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator()
          ): this.rides.isEmpty ?
              Container(
                alignment: Alignment.center,
                child: Text("No rides found near your locations"),
              ) :
          Container(
            padding: EdgeInsets.only(top: 130),
              child: RidesList(rides: this.rides, origin: widget.origin,
                destination: widget.destination, distance: widget.distance,
                duration: widget.duration, polyLineCoordinates: widget.polyLineCoordinates,))
      ])
    );
  }

  setRides() async {
    var rides = List<Ride>();
    var url = '$DRIVE_API_URL/ride/suggestions';

    var originArr = [widget.origin.coordinates.latitude, widget.origin.coordinates.longitude];
    var destinationArr = [widget.destination.coordinates.latitude, widget.destination.coordinates.longitude];

    var json = jsonEncode({"startLocation": originArr, "endLocation": destinationArr});
    print(json);
    var response = await post(url, headers: HEADERS, body: json);

    //var response = await get('${DRIVE_API_URL}/ride', headers: HEADERS);
    /*response.body = '['
        '{'
        '"id": 1, '
        '"driverName": "Nikhil", '
        '"currentPassengers": [{"id": 2, "name": "Hassan"}], '
        '"origin": "a", '
        '"destination": "b"'
        '}'
        ']';*/
    if(response.statusCode == 201 || response.statusCode == 200 ) {
      var body = jsonDecode(response.body);
      print(body);
      rides = (body as List).map((e) => Ride.fromJson(e)).toList();

      //rides = rides.where((element) => element.startTime?.difference(DateTime.now())?.inHours != null && element.startTime.difference(DateTime.now()).inHours > 50).toList();
    }
    setState(() {
      this.rides = rides;
    });
  }
}
