import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'RegisterPage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'home/Home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// Future<void> main() async {
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp();
//   // FirebaseFunctions.instanl
//   //     .useFunctionsEmulator(origin: 'http://localhost:5001');
//   runApp(MyApp());
// }

// Future<List<User>> getUsers() async {
//   final queryParameters = {'uid': 'oqSwvDZdqJeR5pRztMLlSPI6FxE3'};
//   final findMatchEndpoint = 'localhost:5001/c-students-b7a3d/us-central1/';
//   print(findMatchEndpoint);
//   final uri = Uri.http(findMatchEndpoint, '/findMatches', queryParameters);
//   final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
//   final response = await http.get(uri, headers: headers);
//   print(response.body);

//   if (response.statusCode == 200) {
//     final decodedUsers = jsonDecode(response.body) as Map;
//     decodedUsers.forEach((key, value) {
//       return User.fromJson(value);
//     });

//     return decodedUsers.values;
//   } else {
//     throw Exception('Failed to load users');
//   }
// }

// Future<void> getUsersTest() async {
//   HttpsCallable callable =
//       FirebaseFunctions.instance.httpsCallable('findMatches');
//   final results = await callable();
//   List users = results.data;
//   print(users);
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Future<List<User>> futureUsers = getUsers();
    // print(futureUsers);

    return FutureBuilder(
      future: Authentication.initializeFirebase(context: context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('returning to register page');
            return MaterialApp(
              title: 'hubble',
              home: RegisterPage(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
              User? user = FirebaseAuth.instance.currentUser;
              print('returning to home page');
              return MaterialApp(
                title: 'hubble-home',
                home: Home(user: user),
            );
          }
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.blue,
            ),);
        });
      }
    }
      
class Authentication {
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
  
    User? user = FirebaseAuth.instance.currentUser;
  
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Home(
            user: user,
          ),
        ),
      );
    }
  
    return firebaseApp;
  }
}