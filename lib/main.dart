import 'package:flutter/material.dart';
import 'package:job_hive/config/routes/route.dart';
import 'package:job_hive/config/theme/app_theme.dart';
import 'package:job_hive/features/authentication/screens/login_screen.dart';
import 'package:job_hive/features/job_feed/screens/job_feed_screen.dart';
import 'package:job_hive/provider/user_provider.dart';
import 'package:job_hive/utils/services/user_api_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // making parent provider for all providers
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;
  bool isLoading = false;

  @override
  void initState() {
    checkToken();
    super.initState();
  }

  // checking token if user already logged in
  void checkToken() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      setState(() {
        token = prefs.getString('token');
      });
      if (mounted) {
        await UserAPIServices.getUser(token!, context);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Hive',
      theme: AppTheme.materialTheme,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: token != null
          ? isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const JobFeedScreen()
          : const LoginScreen(),
    );
  }
}
