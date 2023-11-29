class User {
  final String id;
  final String name;
  final String email;
  final int age;
  final String? about;
  final String? profession;
  final List<dynamic>? skills;
  final List<dynamic>? languages;
  final List<dynamic>? experience;
  final List<dynamic>? education;
  final List<dynamic>? achievement;
  final List<dynamic>? project;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.about,
    required this.profession,
    required this.skills,
    required this.languages,
    required this.experience,
    required this.education,
    required this.achievement,
    required this.project,
  });

  // creating user from json
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
      about: json['about'],
      profession: json['profession'],
      skills: json['skills'],
      languages: json['languages'],
      experience: json['experience'],
      education: json['education'],
      achievement: json['achievement'],
      project: json['project'],
    );
  }

  // creating json from user
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'age': age,
        'about': about,
        'profession': profession,
        'skills': skills,
        'languages': languages,
        'experience': experience,
        'education': education,
        'achievement': achievement,
        'project': project,
      };
}
