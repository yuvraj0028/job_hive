import 'package:flutter/material.dart';

class BasicDetails extends StatelessWidget {
  final IconData iconData;
  final String content;
  const BasicDetails(
      {required this.iconData, required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconData),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
