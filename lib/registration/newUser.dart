<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hubble_client/home/Home.dart';
// import 'package:dropdownfield/dropdownfield.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
=======
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hubble_client/home/Home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:dropdownfield/dropdownfield.dart';
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf

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
<<<<<<< HEAD
            'connections': [],
=======
            'connections': ['uHvnL2xiY1WSXu6YQqEc10kpP3q2'],
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
              MaterialPageRoute(builder: (context) => RegisterSchool(id: id)),
=======
              MaterialPageRoute(builder: (context) => RegisterAge(id: id)),
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addUser(context),
                }),
            child: Center(
=======
        body: Center(
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What's your name?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
<<<<<<< HEAD
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container(
                    // alignment: Alignment.center,
=======
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                  // ),
                  Container(
                    alignment: Alignment.center,
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
                    width: 280,
                    child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(), 
                            labelText: 'Enter your name',
                      )),
                  ),
<<<<<<< HEAD
                ],
              ),
            )));
=======
                  ElevatedButton(
                    onPressed: () {
                     addUser(context);
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ));
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
              MaterialPageRoute(builder: (context) => RegisterSchool(id: id)),
=======
              MaterialPageRoute(builder: (context) => RegisterHometown(id: id)),
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addAge(context),
                }),
            child: Center(
=======
        body: Center(
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "How old are you?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
<<<<<<< HEAD
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
=======
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                  // ),
                  Container (
                    alignment: Alignment.center,
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
                    width: 280,
                    child: TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your age'
                      )
                    ),
                  ),
<<<<<<< HEAD
                ],
              ),
            )));
=======
                  ElevatedButton(
                    onPressed: () {
                     addAge(context);
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ));
  }
}

//Register hometown
class RegisterHometown extends StatefulWidget {
  final String? id;
  RegisterHometown({Key? key, @required this.id});

  @override
  State<StatefulWidget> createState() {
    return RegisterHometownState(id: id);
  }
}

class RegisterHometownState extends State<RegisterHometown> {
  final String? id;
  RegisterHometownState({Key? key, @required this.id});

  @override
  Widget build(BuildContext context) {
    final hometownController = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    void addHometown(BuildContext context) {
      users
      .doc(id)
      .update({
            'hometown': hometownController.text
          })
      .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterSchool(id: id)),
            ),
          )
      .catchError((error) => print("Failed to update hometown: $error"));
    }

    return Scaffold(
        appBar: AppBar(
            title: Image.asset("assets/images/editName.png", scale: 1),
            bottomOpacity: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 100.0,
            elevation: 0.0),
        body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What is your hometown?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                  // ),
                  Container (
                    alignment: Alignment.center,
                    width: 280,
                    child: TextFormField(
                      controller: hometownController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your hometown'
                      )
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                     addHometown(context);
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ));
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addSchool(context),
                }),
            child: Center(
=======
        body: Center(
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What school do you go to?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
<<<<<<< HEAD
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
=======
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                  // ),
                  Container (
                    alignment: Alignment.center,
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
                    width: 280,
                    child: TextFormField(
                      controller: schoolController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your school'
                      )
                    ),
                  ),
<<<<<<< HEAD
                ],
              ),
            )));
=======
                  ElevatedButton(
                    onPressed: () {
                     addSchool(context);
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ));
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addMajor(context),
                }),
            child: Center(
=======
        body: Center(
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What's your major?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
<<<<<<< HEAD
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
=======
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                  // ),
                  Container (
                    alignment: Alignment.center,
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
                    width: 280,
                    child: TextFormField(
                      controller: majorController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your major'
                      )
                    ),
                  ),
<<<<<<< HEAD
                ],
              ),
            )));
=======
                  ElevatedButton(
                    onPressed: () {
                     addMajor(context);
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ));
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addYear(context),
                }),
            child: Center(
=======
        body: Center(
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What's your year level?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
<<<<<<< HEAD
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
=======
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                  // ),
                  Container (
                    alignment: Alignment.center,
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
                    width: 280,
                    child: TextFormField(
                      controller: yearController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
<<<<<<< HEAD
                        labelText: 'Enter your year level'
                      )
                    ),
                  ),
                ],
              ),
            )));
=======
                        labelText: 'Enter your year level (e.g. Freshman, Junior)'
                      )
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                     addYear(context);
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ));
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
              MaterialPageRoute(builder: (context) => RegisterLinks(id: id)),
=======
              MaterialPageRoute(builder: (context) => RegisterHobbies(id: id)),
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addClubs(context),
                }),
            child: Center(
=======
        body: Center(
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What clubs are you in?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
<<<<<<< HEAD
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
=======
                  Container (
                    alignment: Alignment.center,
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
                    width: 280,
                    child: TextFormField(
                      controller: clubsController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Enter some clubs you're involved in"
                      )
                    ),
                  ),
<<<<<<< HEAD
                ],
              ),
            )));
=======
                  ElevatedButton(
                    onPressed: () {
                     addClubs(context);
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ));
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
  }
}

//Register Hobbies
class RegisterHobbies extends StatefulWidget {
  final String? id;
  RegisterHobbies({Key? key, @required this.id});

  @override
  State<StatefulWidget> createState() {
<<<<<<< HEAD
    return RegisterLinksState(id: id);
=======
    return RegisterHobbiesState(id: id);
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
              MaterialPageRoute(builder: (context) => RegisterLinks(id: id)),
=======
              MaterialPageRoute(builder: (context) => RegisterLookingFor(id: id)),
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addHobbies(context),
                }),
            child: Center(
=======
        body: Center(
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What are your hobbies?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
<<<<<<< HEAD
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
=======
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                  // ),
                  Container (
                    alignment: Alignment.center,
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
                    width: 280,
                    child:
                      TextFormField(
                        controller: hobbiesController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'List some of your hobbies'
                      )),
                  ),
<<<<<<< HEAD
                ])),
      ));
=======
                  ElevatedButton(
                    onPressed: () {
                     addHobbies(context);
                    },
                    child: Text('Next'),
                  ),
                ])),
      );
  }
}

//Register LookingFor
class RegisterLookingFor extends StatefulWidget {
  final String? id;
  RegisterLookingFor({Key? key, @required this.id});

  @override
  State<StatefulWidget> createState() {
    return RegisterLookingForState(id: id);
  }
}

class RegisterLookingForState extends State<RegisterLookingFor> {
  final String? id;
  RegisterLookingForState({Key? key, @required this.id});

  @override
  Widget build(BuildContext context) {
    final lookingForController = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    void addLookingFor(BuildContext context) {
     users
      .doc(id)
      .update({
            'lookingFor': lookingForController.text
          })
      .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterLinks(id: id)),
            ),
          )
      .catchError((error) => print("Failed to update looking for: $error"));
    }

    return Scaffold(
        appBar: AppBar(
            title: Image.asset("assets/images/editLinks.png", scale: 1),
            bottomOpacity: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 100.0,
            elevation: 0.0),
        body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "What type of connection are you looking for?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  Container (
                    alignment: Alignment.center,
                    width: 280,
                    child:
                      TextFormField(
                        controller: lookingForController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'E.g. friend, study buddy, project partner, etc'
                      )),
                  ),
                  ElevatedButton(
                    onPressed: () {
                     addLookingFor(context);
                    },
                    child: Text('Next'),
                  ),
                ])),
      );
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
      User? user = FirebaseAuth.instance.currentUser;
=======
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
      users
      .doc(id)
      .update({
            'instagramHandle': 'https://www.instagram.com/' + igController.text,
            'email': emailController.text,
            'linkedinURL': linkedinController.text
          })
      .then((value) => Navigator.push(
              context,
<<<<<<< HEAD
              MaterialPageRoute(builder: (context) => Home(user: user)),
=======
              MaterialPageRoute(builder: (context) => RegisterCourses(id: id)),
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ({
                  addLinks(context),
                }),
            child: Center(
=======
        resizeToAvoidBottomInset: false,
        body: Center(
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Where else can we reach you?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
<<<<<<< HEAD
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  Container (
                    // alignment: Alignment.center,
=======
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                  // ),
                  Container (
                    alignment: Alignment.center,
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
                    width: 280,
                    child: Column( 
                      children: [
                        TextFormField(
                          controller: igController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
<<<<<<< HEAD
                            labelText: 'instagram'
=======
                            labelText: 'Enter your instagram handle'
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
                          )),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
<<<<<<< HEAD
                            labelText: 'email'
=======
                            labelText: 'Enter your email address'
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
                        )),
                        TextFormField(
                          controller: linkedinController,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
<<<<<<< HEAD
                            labelText: 'linkedin'
                        )),
                ],
              )),
            ]
      ))));
=======
                            labelText: 'Enter your linkedIn url'
                        )),
                ],
              )),
              ElevatedButton(
                    onPressed: () {
                     addLinks(context);
                    },
                    child: Text('Next'),
                  ),
            ]
      )));
  }
}

//Register Courses
class RegisterCourses extends StatefulWidget {
  final String? id;
  RegisterCourses({Key? key, @required this.id});

  @override
  State<StatefulWidget> createState() {
    return RegisterCoursesState(id: id);
  }
}

class RegisterCoursesState extends State<RegisterCourses> {
  final String? id;
  RegisterCoursesState({Key? key, @required this.id});

  @override
  Widget build(BuildContext context) {
    final c1 = TextEditingController();
    final c2 = TextEditingController();
    final c3 = TextEditingController();
    var coursesList = [];
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    void addCourses(BuildContext context) {
      coursesList = [c1.text, c2.text, c3.text];
      users
      .doc(id)
      .update({
            'courses': coursesList
          })
      .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterImage(id: id)),
            ),
          )
      .catchError((error) => print("Failed to update courses: $error"));
    }

    return Scaffold(
        appBar: AppBar(
            title: Image.asset("assets/images/editPhoto.png", scale: 1),
            bottomOpacity: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 100.0,
            elevation: 0.0),
        resizeToAvoidBottomInset: false,
        body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Enter the courses you are taking",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                  // ),
                  Container (
                    alignment: Alignment.center,
                    width: 280,
                    child: Column( 
                      children: [
                        TextFormField(
                          controller: c1,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter a course'
                          )),
                        TextFormField(
                          controller: c2,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter a course'
                        )),
                        TextFormField(
                          controller: c3,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter a course'
                        )),
                ],
              )),
              ElevatedButton(
                    onPressed: () {
                     addCourses(context);
                    },
                    child: Text('Next'),
                  ),
            ]
      )));
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
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
<<<<<<< HEAD
=======

//Register image
class RegisterImage extends StatefulWidget {
  final String? id;
  RegisterImage({Key? key, @required this.id});

  @override
  State<StatefulWidget> createState() {
    return RegisterImageState(id: id);
  }
}

class RegisterImageState extends State<RegisterImage> {
  final String? id;
  RegisterImageState({Key? key, @required this.id});
  // User? user = FirebaseAuth.instance.currentUser;
  File? imageFile;    
  String? uploadedFileURL;
  bool isLoading = false;
  String? pfp;

//   Future chooseFile() async {    
//    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {    
//      setState(() {    
//        _image = image;    
//      });    
//    });    
//  }

//  // upload the chosen file to the Google Firebase Firestore in the chats folder and return the uploaded file URL. 
//  Future uploadFile() async {    
//    StorageReference storageReference = FirebaseStorage.instance    
//        .ref()    
//        .child('chats/${Path.basename(_image.path)}}');    
//    StorageUploadTask uploadTask = storageReference.putFile(_image);    
//    await uploadTask.onComplete;    
//    print('File Uploaded');    
//    storageReference.getDownloadURL().then((fileURL) {    
//      setState(() {    
//        _uploadedFileURL = fileURL;    
//      });    
//    });    
//  }
    Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('profileImages/$fileName');
    UploadTask uploadTask = reference.putFile(imageFile!);
    uploadTask.whenComplete(() {
      reference.getDownloadURL().then((String imageUrl) {
        setState(() {
          isLoading = false;
          pfp = imageUrl;
          // onSendMessage(imageUrl, 1);
        });
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "This file type is unsupported");
    });
  }

    Future getImage() async {
      ImagePicker imagePicker = ImagePicker();
      PickedFile? pickedFile;
      try {
        pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
        imageFile = File(pickedFile!.path);
        setState(() {
          isLoading = true;
        });
        uploadFile();
      } catch (e) {
        print(e);
      }
    }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    
    void addImage(BuildContext context) {
      users
      .doc(id)
      .update({
            'image': uploadedFileURL
          })
      .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterName(id: id)),
            ),
          )
      .catchError((error) => print("Failed to update image: $error"));
    }

    return Scaffold(
        appBar: AppBar(
            title: Image.asset("assets/images/editPhoto.png", scale: 1),
            bottomOpacity: 0,
            backgroundColor: Colors.white,
            toolbarHeight: 100.0,
            elevation: 0.0),
        body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Select a profile picture",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  ElevatedButton(
                    onPressed: getImage,
                    child: Text('Upload photo'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                     addImage(context);
                    },
                    child: Text('Create account'),
                  ),
                ],
              ),
            ));
  }
}
>>>>>>> 6ab2c8989ca088aab49220282ea2af81c09a6cbf
