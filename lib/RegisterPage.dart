// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import './registration/phone.dart';
import './home/Home.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatelessWidget {
  // FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signIn() async {
    // await auth.signInWithCredential(credential);
    // print(
    //     "Phone Number already verfied and signed in: ${auth.currentUser.uid}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Future<List<User>> futureUsers = getUsers();
    // print(futureUsers);

    return Scaffold(
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EnterPhone()));
                },
                color: Colors.blue,
              ),
              Image.asset('assets/images/orlogin.png', scale: 3.5),
              CupertinoButton(
                //linda remember to change this and actually add styling LOL
                child: Text("    Sign in    "),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                color: Colors.blue,
              ),
            ],
          )
        ],
      )),
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
