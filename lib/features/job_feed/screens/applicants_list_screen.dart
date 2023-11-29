import 'package:flutter/material.dart';
import 'package:job_hive/features/job_feed/widgets/user_card.dart';

class ApplicantsListScreen extends StatelessWidget {
  final List<dynamic> applicants;

  const ApplicantsListScreen({required this.applicants, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicants'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              applicants.length.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: applicants.length,
        itemBuilder: (context, index) {
          return UserCard(userId: applicants[index].toString());
        },
      ),
    );
  }
}
