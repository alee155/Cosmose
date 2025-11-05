import 'package:flutter/material.dart';

class ReusableTextField extends StatefulWidget {
  const ReusableTextField(
      {super.key,
      required this.title,
      required this.hint,
      this.isNumber,
      required this.controller,
      required this.formkey});
  final String title, hint;
  final bool? isNumber;
  final TextEditingController controller;
  final Key formkey;

  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formkey,
      child: TextFormField(
        keyboardType:
            widget.isNumber == null ? TextInputType.text : TextInputType.number,
        decoration: InputDecoration(
          label: Text(widget.title),
          hintText: widget.hint,
          filled: true, // This makes the background color white
          fillColor: Colors.white, // Set the background color to white
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded border
            borderSide: BorderSide(color: Colors.grey), // Border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded border
            borderSide: BorderSide(color: Colors.grey), // Border color
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded border
            borderSide:
                BorderSide(color: Colors.blue), // Border color when focused
          ),
        ),
        validator: (value) => value!.isEmpty ? "Cannot be empty" : null,
        controller: widget.controller,
      ),
    );
  }
}
