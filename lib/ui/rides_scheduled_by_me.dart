import 'dart:convert';

import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:airlift_drive/models/ride.dart';
import 'package:airlift_drive/ui/common/rides_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RidesScheduledByMe extends StatefulWidget {
  @override
  _RidesScheduledByMeState createState() => _RidesScheduledByMeState();
}

class _RidesScheduledByMeState extends State<RidesScheduledByMe> {

  @override
  void initState() {
    super.initState();
    this.getMyRides("SCHEDULED", true);
  }

  var ridesScheduledByMe = List<Ride>();

  getMyRides(String status, bool isDriver) async {
    var response = await get('${DRIVE_API_URL}/ride/user/${myInfo.id}',
        headers: HEADERS);
    print(response.statusCode);
    if(response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var rides = (json as List).map((e) => Ride.fromJson(e)).toList();
      setState(() {
        this.ridesScheduledByMe = rides;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Rides Scheduled By Me", style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RidesList(rides: this.ridesScheduledByMe, scheduledByMe: true,),
    );
  }
}
