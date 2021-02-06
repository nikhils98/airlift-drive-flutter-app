import 'dart:convert';

import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:airlift_drive/models/location_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'common/action_button.dart';

class CreateRide extends StatefulWidget {
  CreateRide({
    Key key, 
    @required this.origin, 
    @required this.destination,
    @required this.distance,
    @required this.duration,
    @required this.route
  }): super(key: key);

  LocationDetails origin, destination;
  List<LatLng> route;
  num distance, duration;

  @override
  _CreateRideState createState() => _CreateRideState();
}

class _CreateRideState extends State<CreateRide> {

  final rideFormKey = GlobalKey<FormState>();
  String passengerPreference = "No preference";
  DateTime startDate;
  TimeOfDay startTime;
  int maxPassengers;

  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Confirm ride details", style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Form(
                  key: rideFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          initialValue: widget.origin.name,
                          maxLines: 2,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'From'
                          ),
                        ),
                        TextFormField(
                          initialValue: widget.destination.name,
                          maxLines: 2,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'To'
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 160,
                              child: TextFormField(
                                initialValue: '${widget.distance / 1000} KM',
                                readOnly: true,
                                decoration: InputDecoration(
                                    labelText: 'Distance'
                                ),
                              ),
                            ),
                            Container(
                              width: 160,
                              child: TextFormField(
                                initialValue: '${widget.duration / 60} Minutes',
                                readOnly: true,
                                decoration: InputDecoration(
                                    labelText: 'Duration'
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 160,
                                child: TextFormField(
                                  controller: dateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      labelText: 'Start Date'
                                  ),
                                  onTap: () async {
                                    var date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(Duration(days: 30)),

                                    );
                                    if(date != null) {
                                      var formatter = DateFormat.yMMMd();
                                      setState(() {
                                        dateController.text = formatter.format(date);
                                        this.startDate = date;
                                      });
                                    }
                                  },
                                ),
                              ),
                              Container(
                                width: 160,
                                child: TextFormField(
                                  controller: timeController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      labelText: 'Start Time'
                                  ),
                                  onTap: () async {
                                    var time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if(time != null) {
                                      setState(() {
                                        timeController.text = time.format(context);
                                        this.startTime = time;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Max number of passengers allowed'
                          ),
                          onSaved: (input) => this.maxPassengers = int.parse(input),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Passenger preference ", style: TextStyle(fontSize: 16)),
                              DropdownButton<String>(
                                value: this.passengerPreference,
                                underline: Container(
                                  height: 2,
                                  color: Colors.grey[350],
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    passengerPreference = newValue;
                                  });
                                },
                                items: <String>["No preference", "Male", "Female"]
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ActionButton(text: "Let's Go!", onPressed: () async {
                var datetime = DateTime(startDate.year, startDate.month,
                    startDate.day, startTime.hour, startTime.minute);
                this.rideFormKey.currentState.save();

                var coords = List<List<double>>();

                for(var e in widget.route){
                  var list = List<double>();
                  list.add(e.latitude);
                  list.add(e.longitude);
                  coords.add(list);
                }

                var json = jsonEncode({"userId": 1, "route": coords, "maxPassengers": maxPassengers, "startTime": datetime.toIso8601String()});
                print(json);
                var response = await post("$DRIVE_API_URL/ride", headers: HEADERS, body: json);
                print(response.statusCode);
              },),
            )
          ],
        ),
      ),
    );
  }
}
