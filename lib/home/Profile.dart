import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatelessWidget {
  final DocumentSnapshot document;

  Profile({Key key, @required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        SingleChildScrollView(
          child: Column(children: [
         Container(
          alignment: Alignment.center,
          child: 
          FittedBox(
            child: Image(
              image: NetworkImage(document.data()['image']),
              height: (MediaQuery.of(context).size.height)/2,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth
          )),
        ),
        Padding(
          padding: EdgeInsets.all(15.0),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 350),
          child: Container(
          alignment: Alignment.topLeft,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.data()['name'],
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                ),
                Text(
                  "University of British Columbia",
                   style: TextStyle(fontSize: 17)
                ),
                Text(
                  "Sophomore",
                   style: TextStyle(fontSize: 17)
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(child: Text(document.data()['courses'][0]))
                      ),
                      Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(child: Text(document.data()['courses'][1]))
                      ),
                      Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(child: Text(document.data()['courses'][2]))
                      ),
                    ]),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                Divider(
                  color: Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Text(
                  document.data()['hobbies'],
                ),
              ]),
        ))]),
      ),
      new Positioned(
                  top: 0.0,
                  left: 10.0,
                  right: 10.0,
                  child: AppBar(
                    leading: new IconButton(
                      icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    backgroundColor: Colors.transparent, 
                    elevation: 0.0
                  ),),
              ]),
      );
  }
}
