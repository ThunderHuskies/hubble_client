import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hubble_client/home/Home.dart';
// import 'package:dropdownfield/dropdownfield.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class Registration extends StatelessWidget {
  final String? id;

  Registration({Key? key, @required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterName(id: id),
    );
  }
}

//Register name
class RegisterName extends StatefulWidget {
  final String? id;

  RegisterName({Key? key, @required this.id});

  @override
  State<StatefulWidget> createState() {
    return RegisterNameState(id: id);
  }
}

class RegisterNameState extends State<RegisterName> {
  final String? id;

  RegisterNameState({Key? key, @required this.id});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    void addUser(BuildContext context) {
      // Call the user's CollectionReference to add a new user
      users
          .doc(id)
          .set({
            'name': nameController.text,
            'chattingWith:': '',
            'clubs': '',
            'connections': [],
            'courses': [],
            'email': '',
            'hobbies': '',
            'hometown': '',
            'image': '',
            'instagramHandle': null,
            'linkedinURL': null,
            'lookingFor': '',
            'major': '',
            'age': 0,
            'phone': '',
            'school': '',
            'yearLevel': ''
            })
          .then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterSchool(id: id)),
            ),
          )
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
        appBar: AppBar(
            title: Image.asset("assets/images/editName.png", scale: 1),
            bottomOpacity: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 100.0,
            elevation: 0.0),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addUser(context),
                }),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What's your name?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container(
                    // alignment: Alignment.center,
                    width: 280,
                    child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(), 
                            labelText: 'Enter your name',
                      )),
                  ),
                ],
              ),
            )));
  }
}

//Register age
class RegisterAge extends StatefulWidget {
  final String? id;
  RegisterAge({Key? key, @required this.id});

  @override
  State<StatefulWidget> createState() {
    return RegisterAgeState(id: id);
  }
}

class RegisterAgeState extends State<RegisterAge> {
  final String? id;
  RegisterAgeState({Key? key, @required this.id});

  @override
  Widget build(BuildContext context) {
    final ageController = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    void addAge(BuildContext context) {
      users
      .doc(id)
      .update({
            'age': int.parse(ageController.text)
          })
      .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterSchool(id: id)),
            ),
          )
      .catchError((error) => print("Failed to update age: $error"));
    }

    return Scaffold(
        appBar: AppBar(
            title: Image.asset("assets/images/editName.png", scale: 1),
            bottomOpacity: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 100.0,
            elevation: 0.0),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addAge(context),
                }),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "How old are you?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
                    width: 280,
                    child: TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your age'
                      )
                    ),
                  ),
                ],
              ),
            )));
  }
}

//Register school
class RegisterSchool extends StatefulWidget {
  final String? id;
  RegisterSchool({Key? key, @required this.id});

  @override
  State<StatefulWidget> createState() {
    return RegisterSchoolState(id: id);
  }
}

class RegisterSchoolState extends State<RegisterSchool> {
  final String? id;
  RegisterSchoolState({Key? key, @required this.id});

  @override
  Widget build(BuildContext context) {
    final schoolController = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    void addSchool(BuildContext context) {
      users
      .doc(id)
      .update({
            'school': schoolController.text
          })
      .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterMajor(id: id)),
            ),
          )
      .catchError((error) => print("Failed to update school: $error"));
    }

    return Scaffold(
        appBar: AppBar(
            title: Image.asset("assets/images/editSchool.png", scale: 1),
            bottomOpacity: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 100.0,
            elevation: 0.0),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addSchool(context),
                }),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What school do you go to?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
                    width: 280,
                    child: TextFormField(
                      controller: schoolController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your school'
                      )
                    ),
                  ),
                ],
              ),
            )));
  }
}

//Register Major
class RegisterMajor extends StatefulWidget {
  final String? id;
  RegisterMajor({Key? key, @required this.id});

  @override
  State<StatefulWidget> createState() {
    return RegisterMajorState(id: id);
  }
}

class RegisterMajorState extends State<RegisterMajor> {
  final String? id;
  RegisterMajorState({Key? key, @required this.id});

  @override
  Widget build(BuildContext context) {
    final majorController = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    void addMajor(BuildContext context) {
     users
      .doc(id)
      .update({
            'major': majorController.text
          })
      .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterYear(id: id)),
            ),
          )
      .catchError((error) => print("Failed to update major: $error"));
    }

    return Scaffold(
        appBar: AppBar(
            title: Image.asset("assets/images/editMajor.png", scale: 1),
            bottomOpacity: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 100.0,
            elevation: 0.0),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addMajor(context),
                }),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What's your major?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
                    width: 280,
                    child: TextFormField(
                      controller: majorController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your major'
                      )
                    ),
                  ),
                ],
              ),
            )));
  }
}

//Register year level
class RegisterYear extends StatefulWidget {
  final String? id;
  RegisterYear({Key? key, @required this.id});

  @override
  State<StatefulWidget> createState() {
    return RegisterYearState(id: id);
  }
}

class RegisterYearState extends State<RegisterYear> {
  final String? id;
  RegisterYearState({Key? key, @required this.id});

  @override
  Widget build(BuildContext context) {
    final yearController = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    void addYear(BuildContext context) {
     users
      .doc(id)
      .update({
            'yearLevel': yearController.text
          })
      .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterClubs(id: id)),
            ),
          )
      .catchError((error) => print("Failed to update year: $error"));
    }

    return Scaffold(
        appBar: AppBar(
            title: Image.asset("assets/images/editMajor.png", scale: 1),
            bottomOpacity: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 100.0,
            elevation: 0.0),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addYear(context),
                }),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What's your year level?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
                    width: 280,
                    child: TextFormField(
                      controller: yearController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your year level'
                      )
                    ),
                  ),
                ],
              ),
            )));
  }
}

//Register Clubs
class RegisterClubs extends StatefulWidget {
  final String? id;
  RegisterClubs({Key? key, @required this.id});

  @override
  State<StatefulWidget> createState() {
    return RegisterClubsState(id: id);
  }
}

class RegisterClubsState extends State<RegisterClubs> {
  final String? id;
  RegisterClubsState({Key? key, @required this.id});

  @override
  Widget build(BuildContext context) {
    final clubsController = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    void addClubs(BuildContext context) {
     users
      .doc(id)
      .update({
            'clubs': clubsController.text
          })
      .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterLinks(id: id)),
            ),
          )
      .catchError((error) => print("Failed to update clubs: $error"));
    }

    return Scaffold(
        appBar: AppBar(
            title: Image.asset("assets/images/editMajor.png", scale: 1),
            bottomOpacity: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 100.0,
            elevation: 0.0),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addClubs(context),
                }),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What clubs are you in?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
                    width: 280,
                    child: TextFormField(
                      controller: clubsController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Enter some clubs you're involved in"
                      )
                    ),
                  ),
                ],
              ),
            )));
  }
}

//Register Hobbies
class RegisterHobbies extends StatefulWidget {
  final String? id;
  RegisterHobbies({Key? key, @required this.id});

  @override
  State<StatefulWidget> createState() {
    return RegisterLinksState(id: id);
  }
}

class RegisterHobbiesState extends State<RegisterHobbies> {
  final String? id;
  RegisterHobbiesState({Key? key, @required this.id});

  @override
  Widget build(BuildContext context) {
    final hobbiesController = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    void addHobbies(BuildContext context) {
     users
      .doc(id)
      .update({
            'hobbies': hobbiesController.text
          })
      .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterLinks(id: id)),
            ),
          )
      .catchError((error) => print("Failed to update hobbies: $error"));
    }

    return Scaffold(
        appBar: AppBar(
            title: Image.asset("assets/images/editLinks.png", scale: 1),
            bottomOpacity: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 100.0,
            elevation: 0.0),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addHobbies(context),
                }),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What are your hobbies?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
                    width: 280,
                    child:
                      TextFormField(
                        controller: hobbiesController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'List some of your hobbies'
                      )),
                  ),
                ])),
      ));
  }
}

//Register Links
class RegisterLinks extends StatefulWidget {
  final String? id;
  RegisterLinks({Key? key, @required this.id});

  @override
  State<StatefulWidget> createState() {
    return RegisterLinksState(id: id);
  }
}

class RegisterLinksState extends State<RegisterLinks> {
  final String? id;
  RegisterLinksState({Key? key, @required this.id});

  @override
  Widget build(BuildContext context) {
    final igController = TextEditingController();
    final emailController = TextEditingController();
    final linkedinController = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    void addLinks(BuildContext context) {
      User? user = FirebaseAuth.instance.currentUser;
      users
      .doc(id)
      .update({
            'instagramHandle': 'https://www.instagram.com/' + igController.text,
            'email': emailController.text,
            'linkedinURL': linkedinController.text
          })
      .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home(user: user)),
            ),
          )
      .catchError((error) => print("Failed to update links: $error"));
    }

    return Scaffold(
        appBar: AppBar(
            title: Image.asset("assets/images/editLinks.png", scale: 1),
            bottomOpacity: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 100.0,
            elevation: 0.0),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addLinks(context),
                }),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Where else can we reach you?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
                    width: 280,
                    child: Column( 
                      children: [
                        TextFormField(
                          controller: igController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'instagram'
                          )),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'email'
                        )),
                        TextFormField(
                          controller: linkedinController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'linkedin'
                        )),
                ],
              )),
            ]
      ))));
  }
}

//Register Courses
// class RegisterCourses extends StatefulWidget {
//   final String? id;
//   RegisterCourses({Key? key, @required this.id});

//   @override
//   State<StatefulWidget> createState() {
//     return RegisterCoursesState(id: id);
//   }
// }

// class RegisterCoursesState extends State<RegisterCourses> {
//   final String? id;
//   RegisterCoursesState({Key? key, @required this.id});

//   final List<String> courses = [
//     'ENGL 112',
//     'ENGL 110',
//     'BIOL 112',
//     'CPSC 110',
//     'CPSC 210',
//     'CPSC 213',
//     'MATH 200',
//     'CHEM 210',
//     'HIST 221',
//     'MATH 221',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     var course;
//     User? user = FirebaseAuth.instance.currentUser;
//     CollectionReference users = FirebaseFirestore.instance.collection('users');

//     void addCourses(BuildContext context) {
//      users
//       .doc(id)
//       .update({
//             'courses': course.toList()
//           })
//       .then((value) => print('course list updated'))
//       .catchError((error) => print("Failed to update courses: $error"));
//     }

//     return Scaffold(
//         appBar: AppBar(
//             title: Image.asset("assets/images/editLinks.png", scale: 1),
//             bottomOpacity: 0,
//             backgroundColor: Colors.white,
//             toolbarHeight: 100.0,
//             elevation: 0.0),
//         body: GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () => ({
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => Home(user: user)),
//                   ),
//                 }),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text(
//                     "What courses are you taking?",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 30),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                   ),
//                   Container (
//                     // alignment: Alignment.center,
//                     width: 280,
//                     child:
//                       DropDownField(
//                         value: 'Select a course',
//                         required: true,
//                         hintText: 'Choose a course',
//                         labelText: 'Courses',
//                         items: courses,
//                         strict: false,
//                         setter: (dynamic newValue) {
//                           course = newValue;
//                           addCourses(context);
//                         }),
//                   ),
//                 ])),
//       ));
//   }
// }
