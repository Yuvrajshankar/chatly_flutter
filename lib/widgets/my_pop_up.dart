import 'package:flutter/material.dart';

void MyPopUp({
  required BuildContext context,
  required Widget content,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: content,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      );
    },
  );
}
