import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:airlift_drive/models/ride.dart';
import 'package:airlift_drive/ui/common/common_drawer.dart';
import 'package:airlift_drive/ui/common/elevated_text_field.dart';
import 'package:airlift_drive/ui/search_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

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
        child: Icon(Icons.add,),
        onPressed: () {
          if(myInfo.carModel == null) {
            showDialog(context: context, child:
              AlertDialog(
                title: Text("Please Enter Your Car Details"),
                content: Icon(Icons.info, color: Colors.red, size: 30,)
              )
            );
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    SearchLocation(
                      title: "Create a ride",
                      originTextFieldHint: "Search starting point",
                      isCreateRide: true,
                    ))
            );
          }
        },
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
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Text("Rides scheduled by me"),
                ),

                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Text("Rides joined by me"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
