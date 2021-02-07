import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:airlift_drive/ui/credit.dart';
import 'package:airlift_drive/ui/login.dart';
import 'package:airlift_drive/ui/rides_scheduled_by_me.dart';
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
              child: Text('Hi, ${myInfo.firstName} ${myInfo.lastName}', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
          FlatButton(
            minWidth: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.credit_card,),
                ),
                Text('Credits')
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Credit())
              );
            }
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
                  Text('Rides Scheduled By Me')
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RidesScheduledByMe())
                );
              }
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
                  Text('Rides Joined')
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Credit())
                );
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
