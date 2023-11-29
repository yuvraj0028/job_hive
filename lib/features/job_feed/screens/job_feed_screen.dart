import 'package:flutter/material.dart';
import 'package:job_hive/features/job_feed/screens/all_jobs_screen.dart';
import 'package:job_hive/features/job_feed/screens/my_jobs_screen.dart';
import 'package:job_hive/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobFeedScreen extends StatefulWidget {
  static const routeName = '/jobFeedScreen';
  const JobFeedScreen({super.key});

  @override
  State<JobFeedScreen> createState() => _JobFeedScreenState();
}

class _JobFeedScreenState extends State<JobFeedScreen> {
  String token = '';

  @override
  void initState() {
    fetchToken();
    super.initState();
  }

  void fetchToken() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('token') ?? '';
    setState(() {
      token = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Hello, ${user!.name}',
            style: const TextStyle(
              fontSize: 21,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/jobSearchScreen');
              },
              icon: const Icon(
                Icons.search,
                size: 30,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.person,
                size: 30,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, '/userProfileScreen'),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Jobs',
              ),
              Tab(
                text: 'My Jobs',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const AllJobScreen(),
            MyJobsScreen(
              token: token,
            ),
          ],
        ),
      ),
    );
  }
}
