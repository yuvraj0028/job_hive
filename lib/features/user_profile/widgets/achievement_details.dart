import 'package:flutter/material.dart';
import 'package:job_hive/constants/colors.dart';
import 'package:job_hive/utils/helpers/show_delete_alert.dart';

class AchievementDetails extends StatelessWidget {
  final String achievementId;
  final String title;
  final String description;
  const AchievementDetails(
      {required this.achievementId,
      required this.title,
      required this.description,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        showDeleteAlert('achievement', achievementId, '', context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
