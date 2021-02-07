import 'dart:convert';

import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:airlift_drive/models/ride.dart';
import 'package:airlift_drive/ui/common/rides_list.dart';
import 'package:airlift_drive/ui/ride_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RidesJoinedByMe extends StatefulWidget {
  @override
  _RidesJoinedByMeState createState() => _RidesJoinedByMeState();
}

class _RidesJoinedByMeState extends State<RidesJoinedByMe> {

  @override
  void initState() {
    super.initState();
    this.getMyRides("ACCEPTED", false);
  }

  List<Ride> rides;

  getMyRides(String status, bool isDriver) async {
    //print()
    var response = await get('${DRIVE_API_URL}/ride/user/${myInfo.id}',
        headers: HEADERS);
    print(response.statusCode);
    if(response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var rides = (json as List).map((e) => Ride.fromJson(e)).toList();
      setState(() {
        this.rides = rides;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(rides != null) {
      for (var ride in rides) {
        ride.driver = ride.rideUsers
            .firstWhere((element) => element.isDriver)
            .user;
        ride.passengerCount = ride.rideUsers.where((element) => !element.isDriver).length.toString();
      }
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Rides Joined By Me", style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: this.rides == null ?
      Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator()
      ):
      RidesList(rides: this.rides,)
    );
  }
}
