import 'dart:convert';
import 'dart:io';

import 'package:airlift_drive/common/drive_api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'common/action_button.dart';
import 'home.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  
  final registerFormKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  String gender;
  DateTime dateOfBirth;
  var dateController = TextEditingController();
  File licenceImg, registrationImg;
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
                alignment: Alignment.center,
                child: Form(
                  key: registerFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 160,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'First Name'
                                ),
                                onSaved: (input) => json["firstName"] = input,
                              ),
                            ),
                            Container(
                              width: 160,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Last Name'
                                ),
                                onSaved: (input) => json["lastName"] = input
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'CNIC'
                          ),
                            onSaved: (input) => json["cnic"] = input
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Contact No.'
                          ),
                            onSaved: (input) => json["contact"] = input
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Email'
                          ),
                            onSaved: (input) => json["email"] = input
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'Password'
                          ),
                            onSaved: (input) => json["password"] = input
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 160,
                              child: TextFormField(
                                controller: dateController,
                                readOnly: true,
                                decoration: InputDecoration(
                                    labelText: 'Date of birth',
                                ),
                                onTap: () async {
                                  var date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),

                                  );
                                  if(date != null) {
                                    var formatter = DateFormat.yMMMd();
                                    setState(() {
                                      dateController.text = formatter.format(date);
                                      this.dateOfBirth = date;
                                    });
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: 160,
                              child: DropdownButtonFormField<String>(
                                value: this.gender,
                                decoration: InputDecoration(
                                  labelText: 'Gender',
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    this.gender = newValue;
                                  });
                                },
                                items: <String>["Male", "Female"]
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 220,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Car Model'
                                ),
                                  onSaved: (input) => json["carModel"] = input
                              ),
                            ),
                            Container(
                              width: 120,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: 'Registration No.'
                                ),
                                  onSaved: (input) => json["registrationNumber"] = input
                              ),
                            )
                          ],
                        ),
                        TextFormField(
                          initialValue: "",
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Licence",
                              prefixIcon: Icon(Icons.image_outlined)
                          ),
                          onTap: () async {
                            final pickedFile = await picker.getImage(source: ImageSource.gallery);
                            setState(() {
                              this.licenceImg = File(pickedFile.path);
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: "",
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Car registration proof",
                            prefixIcon: Icon(Icons.image_outlined)
                          ),
                          onTap: () async {
                            final pickedFile = await picker.getImage(source: ImageSource.gallery);
                            setState(() {
                              this.registrationImg = File(pickedFile.path);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ActionButton(text: 'Register', onPressed: () async {
                if(registerFormKey.currentState.validate()) {

                  /*var formData = dio.FormData.fromMap({
                    "name": "wendux",
                    "age": 25,
                    "file": dio.MultipartFile.fromBytes(await this.licenceImg.readAsBytes()),
                  });
                  dio.Dio d = dio.Dio();
                  d.options.headers['Content-Type'] = 'application/json';
                  var response = await d.post("https://regiser.free.beeceptor.com", data: formData);

                   */
                  registerFormKey.currentState.save();
                  this.json["dateOfBirth"] = this.dateOfBirth.toIso8601String();
                  this.json["gender"] = this.gender;

                  var body = jsonEncode(this.json);
                  var response = await post(
                      '$DRIVE_API_URL/auth/register', headers: HEADERS,
                      body: body);

                  print(response.statusCode);
                  print(response.body);

                  if (response.statusCode >= 200 && response.statusCode < 300) {
                    showDialog(context: context, child:
                    AlertDialog(
                      title: Text("Successfully registered"),
                      content: Icon(Icons.check_circle,
                        color: Colors.green[600], size: 30,),
                    )
                    );
                    await Future.delayed(Duration(seconds: 1));
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login())
                    );
                  }
                }
              },),
            )
          ],
        ),
      ),
    );
  }
}
