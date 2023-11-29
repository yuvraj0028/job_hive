import 'package:flutter/material.dart';
import 'package:job_hive/utils/helpers/show_snackbar.dart';
import 'package:job_hive/utils/services/user_api_services.dart';

Future<String> _saveData(String field1, String field2, String field3,
    String info, BuildContext context) async {
  String res = 'some error occurred';
  if (info == 'Skill') {
    final data = {
      'skills': field1,
    };
    res = await UserAPIServices.updateUser(data, context);
  } else if (info == 'Experience') {
    final data = {
      'experience': {
        'company': field1,
        'position': field3,
        'description': field2,
      }
    };
    res = await UserAPIServices.updateUser(data, context);
  } else if (info == 'Education') {
    final data = {
      'education': {
        'institute': field1,
        'degree': field2,
      }
    };

    res = await UserAPIServices.updateUser(data, context);
  } else if (info == 'Project') {
    final data = {
      'project': {
        'title': field1,
        'description': field2,
      }
    };
    res = await UserAPIServices.updateUser(data, context);
  } else if (info == 'Achievement') {
    final data = {
      'achievement': {
        'title': field1,
        'description': field2,
      }
    };
    res = await UserAPIServices.updateUser(data, context);
  } else if (info == 'Language') {
    final data = {
      'languages': field1,
    };
    res = await UserAPIServices.updateUser(data, context);
  } else if (info == 'Name') {
    final data = {
      'name': field1,
      'profession': field2,
      'about': field3,
    };

    if (field1.isNotEmpty && field2.isEmpty && field3.isEmpty) {
      data.remove('profession');
      data.remove('about');
    }

    if (field1.isEmpty && field2.isNotEmpty && field3.isEmpty) {
      data.remove('name');
      data.remove('about');
    }

    if (field1.isEmpty && field2.isEmpty && field3.isNotEmpty) {
      data.remove('name');
      data.remove('profession');
    }

    if (field1.isNotEmpty && field2.isNotEmpty && field3.isEmpty) {
      data.remove('about');
    }

    if (field1.isNotEmpty && field2.isEmpty && field3.isNotEmpty) {
      data.remove('profession');
    }

    if (field1.isEmpty && field2.isNotEmpty && field3.isNotEmpty) {
      data.remove('name');
    }

    res = await UserAPIServices.updateUser(data, context);
  }

  return res;
}

void showCustomBottomSheet(String title, String description, String position,
    String info, BuildContext context) {
  String field1 = '';
  String field2 = '';
  String field3 = '';
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: title,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) => field1 = value,
                ),
              ),
              if (description != '')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: description,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) => field2 = value,
                  ),
                ),
              if (position != '')
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: position,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) => field3 = value,
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  String str =
                      await _saveData(field1, field2, field3, info, context);
                  if (str == 'success' && context.mounted) {
                    showSnackbar(context, 'Updated Successfully');
                    Navigator.pop(context);
                  } else {
                    if (context.mounted) {
                      showSnackbar(context, str);
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
