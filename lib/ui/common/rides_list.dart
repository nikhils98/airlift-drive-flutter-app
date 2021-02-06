import 'dart:convert';

import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:airlift_drive/models/mock_response.dart';
import 'package:airlift_drive/models/ride.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RidesList extends StatelessWidget {

  RidesList({Key key, @required this.rides}): super(key: key);

  final List<Ride> rides;

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
                  title: Container(padding: EdgeInsets.symmetric(vertical: 10), child: Text(ride.driverName)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Origin: ${ride.origin}'),
                        Text('Destination: ${ride.destination}'),
                        Text('Start Time: ${ride.startTime}'),
                        Text('End Time: ${ride.endTime}'),
                        Text('Max Passengers Limit: ${ride.maxPassengersLimit}'),
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

