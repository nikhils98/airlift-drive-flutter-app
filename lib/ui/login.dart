import 'dart:convert';

import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:airlift_drive/ui/common/action_button.dart';
import 'package:airlift_drive/ui/home.dart';
import 'package:airlift_drive/ui/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final loginFormKey = GlobalKey<FormState>();
  var json = {};

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Form(
                  key: loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email'
                        ),
                        onSaved: (input) => json["email"] = input,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password'
                        ),
                        onSaved: (input) => json["password"] = input,
                      ),
                      ActionButton(
                        text: 'Login',
                        onPressed: () async {
                          loginFormKey.currentState.save();

                          var body = jsonEncode(this.json);
                          print(body);

                          var response = await post('$DRIVE_API_URL/auth/login', headers: HEADERS, body: body);
                          print(response.statusCode);
                          print(response.body);

                          var responseBody = jsonDecode(response.body);
                          authToken = responseBody['accessToken'];

                          if(response.statusCode == 201) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home())
                            );
                          }
                          else {
                            Fluttertoast.showToast(msg: "Invalid email or password");
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ActionButton(text: 'Register', onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register())
                );
              },),
            )
          ],
        ),
      ),
    );
  }
}

