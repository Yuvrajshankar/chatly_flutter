import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final Widget content;

  const MyButton({
    super.key,
    required this.onTap,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: onTap,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.secondary),
            foregroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.tertiary),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.2);
                }
                return null;
              },
            ),
          ),
          child: content,
        ),
      ),
    );
  }
}
