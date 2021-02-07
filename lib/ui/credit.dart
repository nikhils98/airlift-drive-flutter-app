import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:flutter/material.dart';

class Credit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Ride details", style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text("Remaining ALCs: ${myInfo.alcs}", style: TextStyle(
          fontSize: 20
        ),),
      ),
    );
  }
}
