import 'package:airlift_drive/models/user.dart';

class Ride {
  Ride({
    this.id, this.driverName, this.origin, this.destination,
    this.startTime, this.endTime, this.maxPassengersLimit, this.currentPassengers
  });

  int id;
  String driverName;
  String origin;
  String destination;
  DateTime startTime;
  DateTime endTime;
  int maxPassengersLimit;
  List<User> currentPassengers;

  Ride.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        driverName = json['driverName'],
        origin = json['origin'],
        destination = json['destination'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        maxPassengersLimit = json['maxPassengersLimit'],
        currentPassengers = (json['currentPassengers'] as List).map((e) => User.fromJson(e)).toList();
}