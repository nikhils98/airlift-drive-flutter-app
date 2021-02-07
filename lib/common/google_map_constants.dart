import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';

const GOOGLE_API_KEY = "AIzaSyBq8tTGKhsGePKqQon9m-ne0ly97JfyIt4";

final geocoding = GoogleMapsGeocoding(apiKey: GOOGLE_API_KEY);
final places = GoogleMapsPlaces(apiKey: GOOGLE_API_KEY);
final directions = GoogleMapsDirections(apiKey: GOOGLE_API_KEY);
final distance = GoogleDistanceMatrix(apiKey: GOOGLE_API_KEY);

const DEFAULT_LATLNG = LatLng(24.859698041385514, 67.04874334232731);