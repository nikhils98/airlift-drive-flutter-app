import 'package:airlift_drive/models/user.dart';
import 'package:intl/intl.dart';

const DRIVE_API_URL = "http://0338bf383bf7.ngrok.io/api";

const HEADERS = {
  "Content-type": "application/json"
};

bool sendLocation = false;
String authToken;
User myInfo;

final dateTimeFormatter = DateFormat.yMd().add_jm();