import 'package:flutter/material.dart';
import 'package:job_hive/constants/colors.dart';
import 'package:job_hive/utils/helpers/show_delete_alert.dart';

class ExperienceDetails extends StatelessWidget {
  final String company;
  final String position;
  final String description;
  final String experienceId;

  const ExperienceDetails(
      {required this.company,
      required this.experienceId,
      required this.position,
      required this.description,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () {
          showDeleteAlert('experience', experienceId, '', context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Company - $company',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Divider(
                    color: primaryColor,
                  ),
                  Text(
                    'Position - $position',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Description - $description',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
