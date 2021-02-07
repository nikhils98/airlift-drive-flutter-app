import 'dart:convert';

import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:airlift_drive/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class Credit extends StatefulWidget {
  @override
  _CreditState createState() => _CreditState();
}

class _CreditState extends State<Credit> {

  var alcs = myInfo.alcs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Credit", style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.grey[800],),
        onPressed: () async {
          var json = jsonEncode({"alcs": 500});
          var response = await put('${DRIVE_API_URL}/user/${myInfo.id}', headers: HEADERS, body: json);
          print (response.statusCode);
          if(response.statusCode == 200 || response.statusCode == 201) {
            response = await get('${DRIVE_API_URL}/user/${myInfo.id}', headers: HEADERS);
            myInfo = User.fromJson(jsonDecode(response.body));
            Fluttertoast.showToast(msg: "500 ALCs added");
            setState(() {
              this.alcs = myInfo.alcs;
            });
          }
        },
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text("Remaining ALCs: ${this.alcs}", style: TextStyle(
            fontSize: 20
        ),),
      ),
    );
  }
}
