import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Function() onPressed;

  const TitleWidget({required this.title, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(onPressed: onPressed, icon: const Icon(Icons.add))
          ],
        ),
      ),
    );
  }
}
