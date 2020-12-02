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
      {this.uid,
      this.major,
      this.hometown,
      this.image,
      this.instagramHandle,
      this.school,
      this.linkedinURL,
      this.phone,
      this.email,
      this.hobbies,
      this.clubs,
      this.age,
      this.name,
      this.courses,
      this.rating});

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
        rating: json['rating']);
  }
}
