import 'package:flutter/material.dart';

class RoundedCartIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.shopping_cart,
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
