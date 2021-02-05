import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import 'common/common_drawer.dart';

class SearchLocation extends StatefulWidget {
  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {

  @override
  void initState() {
    super.initState();
    this.setCurrentLocation();
  }

  Position currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Search', style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: CommonDrawer(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      hintText: this.currentLocation == null ? 'Search pick up location' : 'My location'
                  ),
                  autofocus: true,
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Search destination'
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  setCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('${position.latitude}, ${position.longitude}, ${position.accuracy}');
    this.setState(() {
      this.currentLocation = position;
    });
  }
}
