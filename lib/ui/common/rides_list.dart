import 'dart:convert';

import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:airlift_drive/common/util.dart';
import 'package:airlift_drive/models/location_details.dart';
import 'package:airlift_drive/models/mock_response.dart';
import 'package:airlift_drive/models/ride.dart';
import 'package:airlift_drive/ui/ride_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../create_ride.dart';

class RidesList extends StatelessWidget {

  RidesList({Key key, @required this.rides,
    @required this.origin,
    @required this.destination,
    @required this.distance,
    @required this.duration,
    @required this.polyLineCoordinates
  }): super(key: key);

  final List<Ride> rides;
  final LocationDetails origin, destination;
  final num distance, duration;
  List<LatLng> polyLineCoordinates;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
          itemCount: rides.length,
          itemBuilder: (BuildContext context, int index) {
            var ride = rides[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
              child: Card(
                elevation: 2,
                child: ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => RideDetails(ride: ride,
                          origin: origin, destination: destination, distance: distance,
                          duration: duration, passengerCoordinates: this.polyLineCoordinates,)));
                  },
                  title: Container(padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('${ride.driver.firstName} ${ride.driver.lastName}')),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Origin: ${ride.origin.name}'),
                        SizedBox(height: 5,),
                        Text('Destination: ${ride.destination.name}'),
                        SizedBox(height: 5,),
                        Text('Contact: ${ride.driver.contact}'),
                        SizedBox(height: 5,),
                        Text('Start Time: ${dateTimeFormatter.format(ride.startTime)}'),
                        SizedBox(height: 5,),
                        Text('End Time: ${dateTimeFormatter.format(ride.endTime)}'),
                        SizedBox(height: 5,),
                        Text('Available capacity: ${ride.maxPassengers - ride.passengerCount} / ${ride.maxPassengers}'),
                        SizedBox(height: 5,),
                        Text("Fare: ${ride.fare}"),
                        SizedBox(height: 5,),
                        Text("Car Model: ${ride.driver.carModel}")
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

