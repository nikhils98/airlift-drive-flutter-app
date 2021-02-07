import 'package:airlift_drive/models/location_details.dart';
import 'package:airlift_drive/models/ride_user.dart';
import 'package:airlift_drive/models/user.dart';

class Ride {
  Ride({
    this.id, this.origin, this.destination,
    this.startTime, this.endTime, this.maxPassengers, this.currentPassengers
  });

  int id;
  LocationDetails origin;
  LocationDetails destination;
  List<LocationDetails> route;
  DateTime startTime;
  DateTime endTime;
  int maxPassengers;
  User driver;
  double distanceFromStart, distanceFromEnd, totalDistance;
  int fare;
  String status;
  List<User> currentPassengers;
  num distance;
  String passengerCount;
  List<RideUser> rideUsers;

  Ride.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        origin = LocationDetails.fromJson({"coordinates": json['startLocation']["coordinates"], "name": json["startLocationName"]}),
        destination = LocationDetails.fromJson({"coordinates": json['endLocation']["coordinates"], "name": json["endLocationName"]}),
        route = (json['route']['coordinates'] as List).map((e) => LocationDetails.fromJson({"coordinates": e})).toList(),
        startTime = DateTime.parse(json['startTime']),
        endTime = DateTime.parse(json['startTime']).add(Duration(seconds: int.parse(json['estimatedDuration']))),
        distance = int.parse(json['distance']),
        maxPassengers = json['maxPassengers'],
        fare = json['perPassengerFare'],
        status = json['status'],
        driver = json["driver"] == null ? null : User.fromJson(json['driver']),
        passengerCount = json['passengerCount'].toString(),
        rideUsers = json['rideUsers'] != null ? (json['rideUsers'] as List).map((e) => RideUser.fromJson(e)).toList() : null;
}