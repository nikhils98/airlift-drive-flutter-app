import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {

  const ActionButton({
    Key key,
    this.text,
    this.onPressed
  }): super(key: key);

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: width,
      child: ElevatedButton(
        onPressed: onPressed ?? (){},
        child: Text(text)
      ),
    );
  }
}
