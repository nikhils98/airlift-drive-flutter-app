import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDetails {

  LocationDetails({this.name, this.coordinates});
  
  String name;
  LatLng coordinates;

  LocationDetails.fromJson(Map<String, dynamic> json)
      : coordinates = LatLng(json['coordinates'][0] as double, json['coordinates'][1] as double),
        name = json['name'];
}