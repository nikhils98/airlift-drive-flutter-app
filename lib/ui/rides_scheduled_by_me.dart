import 'dart:convert';

import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:airlift_drive/models/ride.dart';
import 'package:airlift_drive/ui/common/rides_list.dart';
import 'package:airlift_drive/ui/driver_ride_details.dart';
import 'package:airlift_drive/ui/ride_details.dart';
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

  List<Ride> rides;

  getMyRides(String status, bool isDriver) async {
    var response = await get('${DRIVE_API_URL}/ride/user/${myInfo.id}?rideStatus=${status}&driver=${isDriver}',
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
      body: this.rides == null ? Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator()
      ): ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: rides.length,
          itemBuilder: (BuildContext context, int index) {
            var ride = rides[index];
            var rideUsers = ride.rideUsers;
            var passengersCount = rideUsers.where((element) => !element.isDriver && element.status != "CANCELLED").length;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
              child: Card(
                elevation: 2,
                child: ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => DriverRideDetails(ride: ride,)));
                  },
                  title: Container(padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text('${myInfo.firstName} ${myInfo.lastName}')),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Origin: ${ride.origin.name}'),
                        SizedBox(height: 5,),
                        Text('Destination: ${ride.destination.name}'),
                        SizedBox(height: 5,),
                        Text('Start Time: ${dateTimeFormatter.format(ride.startTime)}'),
                        SizedBox(height: 5,),
                        Text('End Time: ${dateTimeFormatter.format(ride.endTime)}'),
                        SizedBox(height: 5,),
                        Text('Available capacity: ${ride.maxPassengers - passengersCount} / ${ride.maxPassengers}'),
                        SizedBox(height: 5,),
                        Text("Fare: ${ride.fare}"),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
