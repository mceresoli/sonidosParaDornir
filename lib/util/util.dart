import 'dart:io';
import 'package:flutter/material.dart';
  Container backgroundGradient() {
    return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
  }

  BoxDecoration buttonBackgroundGradientDecoration() {
    return  const BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey
              ],
            )
        );
  }





