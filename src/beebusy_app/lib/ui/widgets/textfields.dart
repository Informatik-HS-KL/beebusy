import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  const MyTextFormField({
    @required this.controller,
    @required this.labelText,
    this.icon,
    this.validator,
    this.maxLines,
    this.keyboardType,
    this.textInputAction,
    this.minLines,
    this.maxLength,
  });

  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final FormFieldValidator<String> validator;
  final int maxLines;
  final int minLines;
  final int maxLength;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      child: TextFormField(
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        focusNode: focusNode,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        decoration: InputDecoration(
          icon: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: Theme.of(context).primaryColor,
                )
              : null,
          labelText: widget.labelText,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          // TODO(dakr): label color on error not set correctly, see: https://github.com/flutter/flutter/issues/28075
          labelStyle: focusNode.hasFocus
              ? TextStyle(color: Theme.of(context).primaryColor)
              : null,
        ),
      ),
    );
  }
}
