import 'package:flutter/material.dart';
import 'package:flutter_app/components/TextFieldContainer.dart';
import 'package:flutter_app/constants.dart';

class RoundedPasswordField extends StatefulWidget{
  final String hintText;
  final ValueChanged<String> onChanged;

  const RoundedPasswordField({
    Key key,
    this.hintText,
    this.onChanged,
  }): super(key: key);

  //get _hintText => hintText;
  //get _onChanged => onChanged;

  @override 
  RoundedPasswordFieldState createState() => RoundedPasswordFieldState();
}

class RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    
    return TextFieldContainer(
      child: TextField(
        onChanged: widget.onChanged,
        obscureText: _isHidden,
        cursorColor: appPrimaryColor,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: Icon(
            Icons.lock,
            color: appPrimaryColor,
          ),
          suffix: InkWell(
            onTap: (){
              setState(() {
                _isHidden = !_isHidden;
              });
            },
            child: Icon(
              _isHidden 
              ? Icons.visibility 
              : Icons.visibility_off,
              color: appPrimaryColor,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}