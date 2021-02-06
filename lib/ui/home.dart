import 'package:airlift_drive/models/ride.dart';
import 'package:airlift_drive/ui/common/common_drawer.dart';
import 'package:airlift_drive/ui/common/elevated_text_field.dart';
import 'package:airlift_drive/ui/search_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

  List<Ride> rides;

  Home() {
    this.rides = List<Ride>();
    rides.add(Ride(id: 1, driverName: 'Uzair Ahmed', origin: 'Somehere a b c',
        destination: 'Someplace else duh', startTime: DateTime.now(), endTime: DateTime.now()));
    rides.add(Ride(id: 2, driverName: 'Uzair Ahmed', origin: 'Somehere a b c',
        destination: 'Someplace else duh', startTime: DateTime.now(), endTime: DateTime.now()));
    rides.add(Ride(id: 3, driverName: 'Uzair Ahmed', origin: 'Somehere a b c',
        destination: 'Someplace else duh', startTime: DateTime.now(), endTime: DateTime.now()));
    rides.add(Ride(id: 4, driverName: 'Uzair Ahmed', origin: 'Somehere a b c',
        destination: 'Someplace else duh', startTime: DateTime.now(), endTime: DateTime.now()));
    rides.add(Ride(id: 5, driverName: 'Uzair Ahmed', origin: 'Somehere a b c',
        destination: 'Someplace else duh', startTime: DateTime.now(), endTime: DateTime.now()));
  }
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home', style: TextStyle(color: Colors.white),),
      ),
      drawer: CommonDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black,),
        onPressed: () {},
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
            child: ElevatedTextField(
              hint: 'Search pick up location',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchLocation())
                );
              },
              readonly: true,
            )
          ),
          /*Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('Rides near you'),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: widget.rides.length,
              itemBuilder: (BuildContext context, int index) {
                var ride = widget.rides[index];
                return Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Container(padding: EdgeInsets.symmetric(vertical: 10), child: Text(ride.driverName)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Origin: ${ride.origin}'),
                          Text('Destination: ${ride.destination}'),
                          Text('Start Time: ${ride.startTime}'),
                          Text('End Time: ${ride.endTime}'),
                          Text('Max Passengers Limit: ${ride.maxPassengersLimit}'),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          )*/
        ],
      ),
    );
  }
}
