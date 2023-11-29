import 'package:flutter/material.dart';
import 'package:job_hive/constants/colors.dart';
import 'package:job_hive/models/job.dart';
import 'package:job_hive/provider/user_provider.dart';
import 'package:job_hive/utils/services/job_api_services.dart';
import 'package:provider/provider.dart';

class JobDetail extends StatefulWidget {
  final Job job;
  const JobDetail({required this.job, super.key});

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  bool _isExpanded = false;

  bool checkIfApplied(String id) {
    for (var i in widget.job.applicants) {
      if (i == id) {
        return true;
      }
    }

    return false;
  }

  Future<String> applyForJob(String uid, String jobId) async {
    String res = 'Some error occurred';
    try {
      await JobAPIServices.postApplicant(jobId, uid);
      res = 'Applied';
    } catch (e) {
      res = 'Some error occurred';
    }
    return res;
  }

  void postApplicant(uid, jobId, jobOwnerId, context) async {
    if (jobOwnerId == uid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cannot Apply'),
            content: const Text('You cannot apply for your own job'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (checkIfApplied(uid)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Already Applied'),
            content: const Text('You have already applied for this job'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      return;
    }
    String str = await applyForJob(uid, jobId);
    if (str == 'Applied' && context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Applied'),
            content: const Text('You have successfully applied for this job'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    } else {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Some error occurred'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      shadowColor: primaryColor,
      child: GestureDetector(
        onTap: () => setState(() {
          _isExpanded = !_isExpanded;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: _isExpanded ? null : 100, //
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.job.title,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    icon: _isExpanded
                        ? const Icon(Icons.arrow_upward_rounded)
                        : const Icon(Icons.arrow_downward_rounded)),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Company - ${widget.job.company}'),
                ),
                if (_isExpanded)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Description - ${widget.job.description}'),
                  ),
                if (_isExpanded)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Salary - ${widget.job.salary}'),
                  ),
                if (_isExpanded)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Location - ${widget.job.location}'),
                  ),
                if (_isExpanded)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Skills Required',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (_isExpanded)
                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      for (var skill in widget.job.skills)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Chip(
                            label: Text(skill),
                          ),
                        ),
                    ],
                  ),
                if (_isExpanded)
                  Center(
                    child: TextButton(
                      onPressed: () => postApplicant(
                          user!.id, widget.job.id, widget.job.owner, context),
                      child: const Text('Apply'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
