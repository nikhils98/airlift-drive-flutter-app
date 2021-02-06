import 'dart:convert';

import 'package:airlift_drive/common/server_constants.dart';
import 'package:airlift_drive/models/mock_response.dart';
import 'package:airlift_drive/models/ride.dart';
import 'package:airlift_drive/ui/common/common_drawer.dart';
import 'package:airlift_drive/ui/common/rides_list.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'common/elevated_text_field.dart';

class SearchResults extends StatefulWidget {

  SearchResults({Key key, @required this.origin, @required this.destination}): super(key: key);

  final LatLng origin;
  final LatLng destination;

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
                  hint: widget.origin.toString(),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: ElevatedTextField(
                      hint: widget.destination.toString(),
                      readonly: true,
                    )
                ),
              ],
            ),
          ),
          this.rides == null ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator()
          ): Container(
            padding: EdgeInsets.only(top: 130),
              child: RidesList(rides: this.rides))
      ])
    );
  }

  setRides() async {
    var rides = List<Ride>();
    var url = '$DRIVE_API_URL/rides?origin=destination=';
    url = "https://reqres.in/api/users?page=2";
    var response = MockResponse(); //await http.get(url);
    await Future.delayed(Duration(seconds: 3));
    response.body = '['
        '{'
        '"id": 1, '
        '"driverName": "Nikhil", '
        '"currentPassengers": [{"id": 2, "name": "Hassan"}], '
        '"origin": "a", '
        '"destination": "b"'
        '}'
        ']';
    if(response.statusCode == 200 ) {
      var body = jsonDecode(response.body);
      print(body);
      var test = (body as List).map((e) => Ride.fromJson(e)).toList();
      for(int i = 0; i < 10; i++) {
        rides.add(test[0]);
      }
    }
    setState(() {
      this.rides = rides;
    });
  }
}
