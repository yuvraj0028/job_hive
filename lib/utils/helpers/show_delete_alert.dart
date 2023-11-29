import 'package:flutter/material.dart';
import 'package:job_hive/utils/helpers/show_snackbar.dart';
import 'package:job_hive/utils/services/user_api_services.dart';

void showDeleteAlert(
    String toDelete, String id, String name, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete'),
      content: const Text('Are you sure you want to delete this?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String res = await UserAPIServices.deleteUserDetails(
                toDelete, context, id, name);
            if (res == 'success' && context.mounted) {
              Navigator.pop(context);
              showSnackbar(context, 'Deleted successfully');
            } else {
              if (context.mounted) {
                showSnackbar(context, res);
              }
            }
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
