import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDetails {

  LocationDetails({this.name, this.coordinates});
  
  String name;
  LatLng coordinates;
}