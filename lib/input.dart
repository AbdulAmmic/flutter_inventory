import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
   final String hintText;
  const InputText({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: 
Center(
  child: SizedBox(
    width: 700,
    child: TextField(
           decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hintText,
          
      ),
    ),
  ),
),
    );
  }
}