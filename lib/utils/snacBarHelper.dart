import 'package:flutter/material.dart';

//! SnacBar -> Failure
void showErrorMessage(
  BuildContext context, {
  required String message,
}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
    ),
    duration: const Duration(seconds: 5),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

//SnacBar -> Success
void showSuccessMessage(
  BuildContext context, {
  required String message,
}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
    ),
    duration: const Duration(seconds: 5),
    backgroundColor: Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
