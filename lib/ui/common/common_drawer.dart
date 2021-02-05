import 'package:airlift_drive/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CommonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 250,
            alignment: Alignment.bottomLeft,
            color: Colors.red,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              child: Text('Hi, Nikhil Satiani', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
          FlatButton(
            minWidth: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.directions_car,),
                ),
                Text('My Rides')
              ],
            ),
            textColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            onPressed: () {

            }
          ),
          FlatButton(
            minWidth: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,),
                  child: Icon(Icons.logout,),
                ),
                Text('Logout')
              ],
            ),
            textColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false
              );
            }
          ),
        ],
      ),
    );
  }
}
