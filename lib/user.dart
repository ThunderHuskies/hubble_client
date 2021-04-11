class User {
  String uid;
  String major;
  String hometown;
  String image;
  String instagramHandle;
  String school;
  String linkedinURL;
  String phone;
  String email;
  String hobbies;
  String clubs;
  int age;
  String name;
  List<String> courses;
  double rating;

  User(
      {required this.uid,
      required this.major,
      required this.hometown,
      required this.image,
      required this.instagramHandle,
      required this.school,
      required this.linkedinURL,
      required this.phone,
      required this.email,
      required this.hobbies,
      required this.clubs,
      required this.age,
      required this.name,
      required this.courses,
      required this.rating});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        uid: json['uid'],
        major: json['major'],
        image: json['image'],
        instagramHandle: json['instagramHandle'],
        school: json['school'],
        linkedinURL: json['linkedinURL'],
        phone: json['phone'],
        email: json['email'],
        hobbies: json['hobbies'],
        clubs: json['clubs'],
        age: json['age'],
        name: json['name'],
        courses: json['courses'],
        rating: json['rating'], hometown: '');
  }
}
