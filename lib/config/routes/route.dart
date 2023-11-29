import 'package:flutter/material.dart';
import 'package:job_hive/features/authentication/screens/login_screen.dart';
import 'package:job_hive/features/authentication/screens/register_screen.dart';
import 'package:job_hive/features/job_feed/screens/create_job_screen.dart';
import 'package:job_hive/features/job_feed/screens/job_feed_screen.dart';
import 'package:job_hive/features/job_feed/screens/search_job_screen.dart';
import 'package:job_hive/features/user_profile/screens/user_profile_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case RegisterScreen.routeName:
      return MaterialPageRoute(builder: (context) => const RegisterScreen());
    case UserProfileScreen.routeName:
      return MaterialPageRoute(builder: (context) => const UserProfileScreen());
    case JobFeedScreen.routeName:
      return MaterialPageRoute(builder: (context) => const JobFeedScreen());
    case CreateJobScreen.routeName:
      return MaterialPageRoute(builder: (context) => const CreateJobScreen());
    case JobSearchScreen.routeName:
      return MaterialPageRoute(builder: (context) => const JobSearchScreen());
    default:
      return MaterialPageRoute(
        builder: (context) => const Center(
          child: Text('Screen does not exist'),
        ),
      );
  }
}
