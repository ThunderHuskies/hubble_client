import 'dart:convert';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() => runApp(MyApp());
// Future<void> main() async {
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp();
//   // FirebaseFunctions.instance
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
  void getStarted() {
    print("pressed");
  }

  @override
  Widget build(BuildContext context) {
    // Future<List<User>> futureUsers = getUsers();
    // print(futureUsers);

    return MaterialApp(
      title: 'Flutter Card Carousel App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('hubble'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ConstrainedBox(
                child: ImageSlider(),
                constraints: BoxConstraints(maxHeight: 500)),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text("Get started"),
                  onPressed: () {
                    getStarted();
                  },
                  color: Colors.blue,
                ),
                Image.asset('assets/images/orlogin.png', scale: 3.5),
                CupertinoButton(
                  child: Text("Sign in"),
                  onPressed: () {
                    getStarted();
                  },
                  color: Colors.blue,
                ),
              ],
            )
          ],
        )),
      ),
    );
  }
}

class ImageSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImageSliderState();
  }
}

final List<Image> imgList = [
  Image.asset('assets/images/studybuddylogin.png'),
  Image.asset('assets/images/meetppllogin.png'),
  Image.asset('assets/images/gethelplogin.png'),
  Image.asset('assets/images/givehelplogin.png'),
];

class ImageSliderState extends State<ImageSlider> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        CarouselSlider(
            options: CarouselOptions(
                autoPlay: true,
                height: 450,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: imgList),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.map((url) {
            int index = imgList.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        )
      ]),
    );
  }
}
