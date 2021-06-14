import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hubble_client/home/Home.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:dropdownfield/dropdownfield.dart';

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
            'connections': ['uHvnL2xiY1WSXu6YQqEc10kpP3q2'],
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
              MaterialPageRoute(builder: (context) => RegisterAge(id: id)),
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "What's your name?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              Container(
                alignment: Alignment.center,
                width: 280,
                child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter your name',
                    )),
              ),
              ElevatedButton(
                onPressed: () {
                  addUser(context);
                },
                child: Text('Tap to continue'),
              ),
            ],
          ),
        ));
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
          .update({'age': int.parse(ageController.text)})
          .then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterHometown(id: id)),
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "How old are you?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              Container(
                alignment: Alignment.center,
                width: 280,
                child: TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your age')),
              ),
              ElevatedButton(
                onPressed: () {
                  addAge(context);
                },
                child: Text('Tap to continue'),
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
          .update({'hometown': hometownController.text})
          .then(
            (value) => Navigator.push(
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
              Container(
                alignment: Alignment.center,
                width: 280,
                child: TextFormField(
                    controller: hometownController,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your hometown')),
              ),
              ElevatedButton(
                onPressed: () {
                  addHometown(context);
                },
                child: Text('Tap to continue'),
              ),
            ],
          ),
        ));
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
          .update({'school': schoolController.text})
          .then(
            (value) => Navigator.push(
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "What school do you go to?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              Container(
                alignment: Alignment.center,
                width: 280,
                child: TextFormField(
                    controller: schoolController,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your school')),
              ),
              ElevatedButton(
                onPressed: () {
                  addSchool(context);
                },
                child: Text('Tap to continue'),
              ),
            ],
          ),
        ));
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
          .update({'major': majorController.text})
          .then(
            (value) => Navigator.push(
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "What's your major?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              Container(
                alignment: Alignment.center,
                width: 280,
                child: TextFormField(
                    controller: majorController,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your major')),
              ),
              ElevatedButton(
                onPressed: () {
                  addMajor(context);
                },
                child: Text('Tap to continue'),
              ),
            ],
          ),
        ));
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
          .update({'yearLevel': yearController.text})
          .then(
            (value) => Navigator.push(
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "What's your year level?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              Container(
                alignment: Alignment.center,
                width: 280,
                child: TextFormField(
                    controller: yearController,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText:
                            'Enter your year level (e.g. Freshman, Junior)')),
              ),
              ElevatedButton(
                onPressed: () {
                  addYear(context);
                },
                child: Text('Tap to continue'),
              ),
            ],
          ),
        ));
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
          .update({'clubs': clubsController.text})
          .then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterHobbies(id: id)),
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
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "What clubs are you in?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              Container(
                alignment: Alignment.center,
                width: 280,
                child: TextFormField(
                    controller: clubsController,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Enter some clubs you're involved in")),
              ),
              ElevatedButton(
                onPressed: () {
                  addClubs(context);
                },
                child: Text('Tap to continue'),
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
    return RegisterHobbiesState(id: id);
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
          .update({'hobbies': hobbiesController.text})
          .then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterLookingFor(id: id)),
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
      body: Center(
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
            Text(
              "Tell us a little about yourself",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            Container(
              alignment: Alignment.center,
              width: 280,
              child: TextFormField(
                  controller: hobbiesController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'List some of your hobbies')),
            ),
            ElevatedButton(
              onPressed: () {
                addHobbies(context);
              },
              child: Text('Tap to continue'),
            ),
          ]))),
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
          .update({'lookingFor': lookingForController.text})
          .then(
            (value) => Navigator.push(
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
            Container(
              alignment: Alignment.center,
              width: 280,
              child: TextFormField(
                  controller: lookingForController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText:
                          'E.g. friend, study buddy, project partner, etc')),
            ),
            ElevatedButton(
              onPressed: () {
                addLookingFor(context);
              },
              child: Text('Tap to continue'),
            ),
          ])),
    );
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
      users
          .doc(id)
          .update({
            'instagramHandle': 'https://www.instagram.com/' + igController.text,
            'email': emailController.text,
            'linkedinURL': linkedinController.text
          })
          .then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterCourses(id: id)),
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
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              Text(
                "Where else can we reach you?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              Container(
                  alignment: Alignment.center,
                  width: 280,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: igController,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter your instagram handle')),
                      TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter your email address')),
                      TextFormField(
                          controller: linkedinController,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter your linkedIn url')),
                    ],
                  )),
              ElevatedButton(
                onPressed: () {
                  addLinks(context);
                },
                child: Text('Tap to continue'),
              ),
            ])));
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
          .update({'courses': coursesList})
          .then(
            (value) => Navigator.push(
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
                "What courses are you taking?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              Container(
                  alignment: Alignment.center,
                  width: 280,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: c1,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter a course')),
                      TextFormField(
                          controller: c2,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter a course')),
                      TextFormField(
                          controller: c3,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter a course')),
                    ],
                  )),
              ElevatedButton(
                onPressed: () {
                  addCourses(context);
                },
                child: Text('Tap to continue'),
              ),
            ])));
  }
}

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
  User? user = FirebaseAuth.instance.currentUser;
  File? imageFile;
  bool isLoading = false;
  String? pfp;

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
          .update({'image': pfp})
          .then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home(user: user)),
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
