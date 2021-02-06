import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';

const GOOGLE_API_KEY = "AIzaSyBq8tTGKhsGePKqQon9m-ne0ly97JfyIt4";

final geocoding = GoogleMapsGeocoding(apiKey: GOOGLE_API_KEY);
final places = GoogleMapsPlaces(apiKey: GOOGLE_API_KEY);
final directions = GoogleMapsDirections(apiKey: GOOGLE_API_KEY);
final distance = GoogleDistanceMatrix(apiKey: GOOGLE_API_KEY);