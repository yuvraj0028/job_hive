import 'package:flutter/material.dart';
import 'package:job_hive/core/auth/auth_methods.dart';
import 'package:job_hive/features/authentication/widgets/auth_text_field.dart';
import 'package:job_hive/utils/helpers/show_snackbar.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/loginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // loading state
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // login using email and password
  void handleAuth() async {
    setState(() {
      isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // login user
        String res = await AuthMethods.loginUser(email, password, context);

        if (res == 'success') {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/jobFeedScreen');
          }
        } else {
          if (mounted) {
            showSnackbar(context, res);
          }
        }
      } else {
        showSnackbar(context, 'Please fill all the fields');
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(context, e.toString());
      }
      return;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // media query
    final mediaQuery = MediaQuery.of(context);
    final double w = mediaQuery.size.width;
    bool isPortrait = mediaQuery.orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Your Account',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // scroll view
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Job Hive',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // custom text field
                    AuthTextField(
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                      controller: _emailController,
                      isPassword: false,
                      width: isPortrait ? w * 1.3 : w * 0.6,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthTextField(
                      hintText: 'Password',
                      prefixIcon: Icons.lock,
                      controller: _passwordController,
                      isPassword: true,
                      width: isPortrait ? w * 1.3 : w * 0.6,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    // login button
                    Container(
                      margin: const EdgeInsets.all(10),
                      alignment: Alignment.bottomCenter,
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              onPressed: handleAuth,
                              child: const Text('Login'),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      // register button
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('New to Job Hive?'),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/registerScreen'),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
