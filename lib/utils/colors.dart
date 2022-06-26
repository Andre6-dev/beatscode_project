import 'package:flutter/material.dart';

const mobileBackgroundColor = Color.fromRGBO(1, 3, 25, 1);
const webBackgroundColor = Color.fromRGBO(18, 18, 18, 1);
const mobileSearchColor = Color.fromRGBO(38, 38, 38, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;

const gradient1 = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [
      0.1,
      0.4,
      0.6,
      0.9,
    ],
    colors: [
      Colors.yellow,
      Colors.red,
      Colors.indigo,
      Colors.teal,
    ],
  ),
);
