import 'package:flutter/material.dart';
import 'package:job_hive/constants/colors.dart';
import 'package:job_hive/utils/helpers/show_delete_alert.dart';

class CustomChip extends StatelessWidget {
  final String text;
  final String chipCategory;
  const CustomChip(this.text, this.chipCategory, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () {
          showDeleteAlert(chipCategory, '', text, context);
        },
        child: Container(
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primaryColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ));
  }
}
