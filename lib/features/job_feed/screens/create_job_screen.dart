import 'package:flutter/material.dart';
import 'package:job_hive/utils/helpers/show_snackbar.dart';
import 'package:job_hive/utils/services/job_api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateJobScreen extends StatefulWidget {
  static const routeName = '/createJobScreen';
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  String _jobTitle = '';
  String _location = '';
  String _salary = '';
  String _description = '';
  String _company = '';
  List<String> _skills = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Job'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Job Title',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _jobTitle = value ?? '';
                        },
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Company',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _company = value ?? '';
                        },
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Location',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _location = value ?? '';
                        },
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Salary',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _salary = value ?? '';
                        },
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _description = value ?? '';
                        },
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Skills',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _skills = value?.split(',') ?? [];
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ElevatedButton(
          onPressed: _submit,
          child: const Text('Create Job'),
        ),
      ),
    );
  }

  void _submit() async {
    final prefs = SharedPreferences.getInstance();
    String token =
        await prefs.then((value) => value.getString('token')) as String;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final data = {
        'title': _jobTitle,
        'company': _company,
        'location': _location,
        'salary': _salary,
        'description': _description,
        'skills': _skills,
      };

      try {
        await JobAPIServices.createJob(data, token);

        if (mounted) {
          Navigator.of(context).pop();
          showSnackbar(context, 'Job created successfully');
        }
        setState(() {});
      } catch (e) {
        if (mounted) {
          showSnackbar(context, 'Something went wrong');
        }
      }
    }
  }
}
