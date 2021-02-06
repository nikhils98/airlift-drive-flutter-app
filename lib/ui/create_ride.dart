import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'common/action_button.dart';

class CreateRide extends StatefulWidget {
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
                child: Form(
                  key: rideFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: 'Origin'
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: 'Destination'
                          ),
                        ),
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
                                    hintText: 'Start Date'
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
                                onSaved: (input) => this.startDate = DateTime.parse(input),
                              ),
                            ),
                            Container(
                              width: 160,
                              child: TextFormField(
                                controller: timeController,
                                readOnly: true,
                                decoration: InputDecoration(
                                    hintText: 'Start Time'
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
                                //onSaved: (input) => this.startDateTime = DateTime.parse(input),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: 'Estimated Reaching Time'
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'Max allowed passengers'
                          ),
                          onSaved: (input) => this.maxPassengers = int.parse(input),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
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
            Container(
              alignment: Alignment.bottomCenter,
              child: ActionButton(text: "Let's Go!", onPressed: () {
                var datetime = DateTime(startDate.year, startDate.month,
                    startDate.day, startTime.hour, startTime.minute);
                this.rideFormKey.currentState.save();

              },),
            )
          ],
        ),
      ),
    );
  }
}
