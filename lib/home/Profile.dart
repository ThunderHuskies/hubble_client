import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatelessWidget {
  final DocumentSnapshot document;

  Profile({Key key, @required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          alignment: Alignment.center,
          child: Image(
            image: NetworkImage(document.data()['image']),
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
                  document.data()['name'],
                  style: TextStyle(fontSize: 30),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Text(
                  "Sophomore",
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        document.data()['courses'][0],
                      ),
                      Text(
                        document.data()['courses'][1],
                      ),
                      Text(
                        document.data()['courses'][2],
                      ),
                    ]),
                Text(
                  document.data()['hobbies'],
                ),
              ]),
        ),
      ]),
    );
  }
}
