import 'package:flutter/material.dart';
import 'package:job_hive/features/job_feed/widgets/job_detail.dart';
import 'package:job_hive/models/job.dart';
import 'package:job_hive/utils/services/job_api_services.dart';

class JobSearchScreen extends StatefulWidget {
  static const routeName = '/jobSearchScreen';
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  late List<Job> jobs;

  @override
  void initState() {
    fetchJobs('-1');
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchJobs(String str) async {
    final job = await JobAPIServices.findJobsByName(str);
    setState(() {
      jobs = job;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
          controller: _searchController,
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_searchController.text.isEmpty) {
                return;
              }
              fetchJobs(_searchController.text);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder(
        future: JobAPIServices.fetchJobs(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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
          return RefreshIndicator(
            onRefresh: () async {
              if (_searchController.text.isNotEmpty) {
                fetchJobs(_searchController.text);
                return;
              }
              fetchJobs('-1');
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
                          'No Jobs Found',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: JobDetail(
                          job: jobs[index],
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
