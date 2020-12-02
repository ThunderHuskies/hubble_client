import 'dart:convert';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFunctions.instance
      .useFunctionsEmulator(origin: 'http://localhost:5001');
  runApp(MyApp());
}

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

Future<void> getUsersTest() async {
  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('findMatches');
  final results = await callable();
  List users = results.data;
  print(users);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Future<List<User>> futureUsers = getUsers();
    // print(futureUsers);

    return MaterialApp(
      title: 'Flutter Card Carousel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Center(child: Text("Hello!")),
    );
  }
}
