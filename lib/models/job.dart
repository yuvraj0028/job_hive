class Job {
  String title;
  String company;
  String location;
  String salary;
  String description;
  String id;
  String owner;
  bool closed;
  List<dynamic> skills;
  List<dynamic> applicants;

  Job({
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.description,
    required this.id,
    required this.skills,
    required this.applicants,
    required this.owner,
    this.closed = false,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      title: json['title'],
      company: json['company'],
      location: json['location'],
      salary: json['salary'],
      description: json['description'],
      id: json['_id'],
      skills: json['skills'],
      applicants: json['applicants'],
      owner: json['owner'],
      closed: json['closed'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'company': company,
        'location': location,
        'salary': salary,
        'description': description,
        'skills': skills,
        'applicants': applicants,
        'owner': owner,
        'closed': closed,
      };
}
