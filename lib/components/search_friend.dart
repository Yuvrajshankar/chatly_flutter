import 'package:flutter/material.dart';

class SearchFriend extends StatelessWidget {
  final Function()? onTap;
  final bool? enable;

  const SearchFriend({
    super.key,
    this.onTap,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Add friend by search...',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
            prefixIcon: const Icon(Icons.search),
            prefixIconColor: Theme.of(context).colorScheme.secondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.primary,
          ),
          onChanged: (value) {
            debugPrint('Search query: $value');
          },
          enabled: enable,
        ),
      ),
    );
  }
}
