import 'package:flutter/material.dart';
import 'package:job_hive/constants/colors.dart';
import 'package:job_hive/utils/helpers/show_delete_alert.dart';

class EducationDetails extends StatelessWidget {
  final String institute;
  final String degree;
  final String educationId;
  const EducationDetails(this.institute, this.degree, this.educationId,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () {
          showDeleteAlert('education', educationId, '', context);
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
                    'Institute - $institute',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Degree - $degree',
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
