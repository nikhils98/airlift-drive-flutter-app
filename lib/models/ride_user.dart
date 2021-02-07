import 'package:airlift_drive/models/location_details.dart';
import 'package:airlift_drive/models/user.dart';
import 'package:geodesy/geodesy.dart';

class RideUser {
  int id, userId, rideId, fare;
  String status;
  bool isDriver;
  User user;
  DateTime startTime, endTime;
  LocationDetails lastLocation, pickUpLocation, dropOffLocation;

  RideUser.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        rideId = json['rideId'],
        fare = json['fare'],
        status = json["status"],
        isDriver = json['isDriver'],
        user = json['user'] == null ? null : User.fromJson(json['user']),
        lastLocation = LocationDetails.fromJson(json['lastLocation']),
        pickUpLocation = LocationDetails.fromJson(json['pickupLocation']),
        dropOffLocation = LocationDetails.fromJson(json['dropoffLocation']);
}