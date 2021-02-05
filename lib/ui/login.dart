import 'package:airlift_drive/ui/common/action_button.dart';
import 'package:airlift_drive/ui/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*Expanded(
              child: Text(
                'Airlift Drive',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 50),
              ),
            ),*/
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
                          hintText: 'Username'
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password'
                        ),
                      ),
                      ActionButton(
                        text: 'Login',
                        onPressed: () {
                          if(loginFormKey.currentState.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home())
                            );
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
              child: ActionButton(text: 'Register'),
            )
          ],
        ),
      ),
    );
  }
}

