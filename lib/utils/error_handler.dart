import 'package:flutter/material.dart';
import 'package:here2there_kids/main.dart';

class ErrorHandler {
  static void show(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
