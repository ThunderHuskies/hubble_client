import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import  'package:flutter_form_builder/flutter_form_builder.dart';
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
          .set({'name': nameController.text})
          .then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterSchool()),
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
                            border: UnderlineInputBorder(), labelText: 'name')),
                  ),
                ],
              ),
            )));
  }
}

//Register school
class RegisterSchool extends StatefulWidget {
  // final String documentId;
  // RegisterSchool(this.documentId);

  @override
  State<StatefulWidget> createState() {
    return RegisterSchoolState();
  }
}

class RegisterSchoolState extends State<RegisterSchool> {
  @override
  Widget build(BuildContext context) {
    // String? documentId;
    // final schoolController = TextEditingController();
    // CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Future<void> addSchool() {
    //   return users
    //   .doc(documentId)
    //   .update({
    //         'name': schoolController.text
    //       })
    //   .then((value) => print("School Updated"))
    //   .catchError((error) => print("Failed to update school: $error"));
    // }

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
                  // addSchool(),
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterMajor()),
                  ),
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
                  // Container (
                  //   // alignment: Alignment.center,
                  //   width: 280,
                  //   child: TextFormField(
                  //     controller: schoolController,
                  //     // onChanged: (value) => userName = value,
                  //     decoration: InputDecoration(
                  //       border: UnderlineInputBorder(),
                  //       labelText: 'school'
                  //     )
                  //   ),
                  // ),
                ],
              ),
            )));
  }
}

//Register Major
class RegisterMajor extends StatefulWidget {
  // final String documentId;
  // RegisterMajor(this.documentId);

  @override
  State<StatefulWidget> createState() {
    return RegisterMajorState();
  }
}

class RegisterMajorState extends State<RegisterMajor> {
  @override
  Widget build(BuildContext context) {
    // String? documentId;
    // final majorController = TextEditingController();
    // CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Future<void> addMajor() {
    //   return users
    //   .doc(documentId)
    //   .update({
    //         'major': majorController.text
    //       })
    //   .then((value) => print("Major Updated"))
    //   .catchError((error) => print("Failed to update school: $error"));
    // }

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
                  // addMajor(),
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterClubs()),
                  ),
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
                  // Container (
                  //   // alignment: Alignment.center,
                  //   width: 280,
                  //   child: TextFormField(
                  //     controller: majorController,
                  //     // onChanged: (value) => userName = value,
                  //     decoration: InputDecoration(
                  //       border: UnderlineInputBorder(),
                  //       labelText: 'major'
                  //     )
                  //   ),
                  // ),
                ],
              ),
            )));
  }
}

//Register Clubs
class RegisterClubs extends StatefulWidget {
  // final String documentId;
  // RegisterClubs(this.documentId);

  @override
  State<StatefulWidget> createState() {
    return RegisterClubsState();
  }
}

class RegisterClubsState extends State<RegisterClubs> {
  @override
  Widget build(BuildContext context) {
    // String? documentId;
    final clubsController = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Future<void> addClubs() {
    //   return users
    //   .doc(documentId)
    //   .update({
    //         'clubs': clubsController.text
    //       })
    //   .then((value) => print("School Updated"))
    //   .catchError((error) => print("Failed to update school: $error"));
    // }

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
                  // addClubs(),
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterName()),
                  ),
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
                  // Container (
                  //   // alignment: Alignment.center,
                  //   width: 280,
                  //   child: TextFormField(
                  //     controller: clubsController,
                  //     // onChanged: (value) => userName = value,
                  //     decoration: InputDecoration(
                  //       border: UnderlineInputBorder(),
                  //       labelText: 'list your clubs here'
                  //     )
                  //   ),
                  // ),
                ],
              ),
            )));
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
