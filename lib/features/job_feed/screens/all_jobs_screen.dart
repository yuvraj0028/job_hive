import 'package:flutter/material.dart';
import 'package:job_hive/features/job_feed/widgets/job_detail.dart';
import 'package:job_hive/models/job.dart';
import 'package:job_hive/utils/services/job_api_services.dart';

class AllJobScreen extends StatefulWidget {
  const AllJobScreen({super.key});

  @override
  State<AllJobScreen> createState() => _AllJobScreenState();
}

class _AllJobScreenState extends State<AllJobScreen> {
  late List<Job> jobs;

  @override
  void initState() {
    fetchJobs();
    super.initState();
  }

  void fetchJobs() async {
    final jobs = await JobAPIServices.fetchJobs();
    setState(() {
      this.jobs = jobs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: JobAPIServices.fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              fetchJobs();
            },
            child: jobs.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.work_off_outlined,
                          size: 100,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No Jobs',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  )
                : CustomScrollView(
                    slivers: <Widget>[
                      SliverList.builder(
                        itemBuilder: (context, jobIndex) {
                          if (jobs.isEmpty) {
                            return const Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.work_off_outlined,
                                    size: 100,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'No Jobs',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: JobDetail(job: jobs[jobIndex]),
                          );
                        },
                        itemCount: jobs.length,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
