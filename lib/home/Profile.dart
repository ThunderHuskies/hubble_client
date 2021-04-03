import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/rachel.jpg',
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15.0),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rachel Chiu",
                  style: TextStyle(fontSize: 30),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Text(
                  "Sophomore",
                ),
                Text(
                  "According to all known laws of aviation, there is no way a bee should be able to fly",
                ),
              ]),
        ),
      ]),
    );
  }
}
