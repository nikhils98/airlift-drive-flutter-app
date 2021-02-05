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
}