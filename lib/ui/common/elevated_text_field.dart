import 'package:flutter/material.dart';

class ElevatedTextField extends StatelessWidget {

  const ElevatedTextField({
    Key key,
    this.hint = '',
    this.autoFocus = false,
    this.readonly = false,
    this.onTap,
    this.onChanged,
    this.focusNode
  }): super(key: key);

  final String hint;
  final bool autoFocus, readonly;
  final Function onTap, onChanged;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none
        ),
        focusNode: this.focusNode,
        onTap: this.onTap,
        onChanged: this.onChanged,
        readOnly: this.readonly,
        autofocus: this.autoFocus,

      ),
    );
  }
}
