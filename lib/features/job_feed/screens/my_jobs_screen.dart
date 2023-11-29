import 'package:flutter/material.dart';
import 'package:job_hive/constants/colors.dart';
import 'package:job_hive/features/job_feed/screens/applicants_list_screen.dart';
import 'package:job_hive/models/job.dart';
import 'package:job_hive/utils/helpers/show_snackbar.dart';
import 'package:job_hive/utils/services/job_api_services.dart';

class MyJobsScreen extends StatefulWidget {
  final String token;
  const MyJobsScreen({required this.token, super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  late List<Job> job;
  bool isLoading = false;

  @override
  void initState() {
    fetchJobs();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    fetchJobs();
    super.didChangeDependencies();
  }

  void fetchJobs() async {
    setState(() {
      isLoading = true;
    });

    final jobs = await JobAPIServices.fetchMyJobs(widget.token);
    setState(() {
      job = jobs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : FutureBuilder(
            future: JobAPIServices.fetchMyJobs(widget.token),
            builder: (context, snapshot) {
              return Scaffold(
                body: RefreshIndicator(
                  onRefresh: () {
                    fetchJobs();
                    return Future.value();
                  },
                  child: job.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 100,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'click on the add button to create a job',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : CustomScrollView(
                          slivers: <Widget>[
                            SliverList.builder(
                              itemBuilder: (context, jobIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ApplicantsListScreen(
                                          applicants: job[jobIndex].applicants,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 5,
                                      shadowColor: primaryColor,
                                      child: ListTile(
                                        title: Text(
                                          job[jobIndex].title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          job[jobIndex].description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        trailing: Wrap(
                                          spacing: 2,
                                          children: [
                                            Switch(
                                                value: job[jobIndex].closed,
                                                onChanged: (value) async {
                                                  setState(() {
                                                    job[jobIndex].closed =
                                                        value;
                                                  });

                                                  try {
                                                    await JobAPIServices
                                                        .updateJobStatus(
                                                            job[jobIndex].id,
                                                            widget.token,
                                                            value);
                                                    fetchJobs();
                                                    if (mounted) {
                                                      showSnackbar(context,
                                                          'Job status updated successfully');
                                                    }
                                                  } catch (e) {
                                                    if (mounted) {
                                                      showSnackbar(context,
                                                          'Failed to update job status');
                                                    }
                                                  }
                                                }),
                                            IconButton(
                                              onPressed: () async {
                                                try {
                                                  await JobAPIServices
                                                      .deleteJob(widget.token,
                                                          job[jobIndex].id);
                                                  fetchJobs();
                                                  if (mounted) {
                                                    showSnackbar(context,
                                                        'Job deleted successfully');
                                                  }
                                                } catch (e) {
                                                  if (mounted) {
                                                    showSnackbar(context,
                                                        'Failed to delete job');
                                                  }
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: job.length,
                            ),
                          ],
                        ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/createJobScreen');
                  },
                  child: const Icon(
                    Icons.add,
                    color: backgroundColor,
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
              );
            },
          );
  }
}
