import 'dart:convert';

import 'package:job_hive/constants/api_constants.dart';
import 'package:job_hive/models/job.dart';
import 'package:http/http.dart' as http;

class JobAPIServices {
  static Future<List<Job>> fetchJobs() async {
    final url = Uri.parse(fetchJobsAPI);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List jobs = jsonResponse.map((job) => Job.fromJson(job)).toList();

      List<Job> filtered = [];
      for (var i in jobs) {
        if (i.closed == true) {
          filtered.add(i);
        }
      }

      return filtered;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  static Future<void> postApplicant(String jobId, String userId) async {
    final url = Uri.parse('http://$ipV4:3000/jobs/$jobId');

    final response = await http.patch(
      url,
      body: jsonEncode(
        {
          'applicants': userId,
        },
      ),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to post applicant');
    }
  }

  // get my jobs
  static Future<List<Job>> fetchMyJobs(String token) async {
    final url = Uri.parse(fetchMyJobsAPI);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  static createJob(Map<String, dynamic> data, String token) async {
    final url = Uri.parse(createJobAPI);
    final response = await http.post(
      url,
      body: jsonEncode(data),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('Failed to create job');
    }
  }

  static deleteJob(String token, String id) async {
    final url = Uri.parse('$deleteJobAPI/$id');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete job');
    }
  }

  static updateJobStatus(String id, String token, bool value) async {
    final url = Uri.parse('$updateJobStatusAPI/$id');
    try {
      final response = await http.patch(
        url,
        body: jsonEncode(
          {
            'closed': value,
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to update job status');
      }
    } catch (e) {
      throw Exception('Failed to update job status');
    }
  }

  // find jobs by name
  static Future<List<Job>> findJobsByName(String name) async {
    final url = Uri.parse('$findJobsByNameAPI/$name');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Job> jobs = jsonResponse.map((job) => Job.fromJson(job)).toList();
      List<Job> filtered = [];

      for (var i in jobs) {
        if (i.closed == true) {
          filtered.add(i);
        }
      }

      return filtered;
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
}
