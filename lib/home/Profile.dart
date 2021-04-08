import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatelessWidget {
  final DocumentSnapshot document;

  Profile({Key key, @required this.document}) : super(key: key);

  void _launchSocial(String url, String fallbackUrl) async {
    // Don't use canLaunch because of fbProtocolUrl (fb://)
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        SingleChildScrollView(
          child: Column(children: [
            Container(
              alignment: Alignment.center,
              child: FittedBox(
                  child: Image(
                      image: NetworkImage(document.data()['image']),
                      height: (MediaQuery.of(context).size.height) / 2,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover)),
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
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.0),
                        ),
                        Text(document.data()['major'],
                            style: TextStyle(fontSize: 17)),
                        Padding(
                          padding: EdgeInsets.all(1.0),
                        ),
                        Row(
                          children: [
                            Text(document.data()['yearLevel'],
                                style: TextStyle(fontSize: 17)),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                            ),
                            Text("|", style: TextStyle(fontSize: 17)),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                            ),
                            Text(
                                "Looking for: ${document.data()['lookingFor']}",
                                style: TextStyle(fontSize: 17)),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
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
                                  child: Center(
                                      child:
                                          Text(document.data()['courses'][0]))),
                              Container(
                                  height: 30,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(
                                      child:
                                          Text(document.data()['courses'][1]))),
                              Container(
                                  height: 30,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(
                                      child:
                                          Text(document.data()['courses'][2]))),
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
                        Text("Clubs", style: TextStyle(fontSize: 17)),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                        ),
                        Text(
                          document.data()['clubs'],
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                        ),
                        Text("About me", style: TextStyle(fontSize: 17)),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                        ),
                        Text(
                          document.data()['hobbies'],
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //replace with urls from firestore
                              GestureDetector(
                                  onTap: () {
                                    _launchSocial(
                                        'fb://profile/408834569303957',
                                        'https://www.facebook.com/dorockxl');
                                  },
                                  child: Container(
                                      child: Image.asset("assets/images/fb.png",
                                          scale: 10))),
                              GestureDetector(
                                  onTap: () {
                                    _launchSocial(
                                        'https://mail.google.com/mail/?view=cm&fs=1&tf=1&to=lindama200@gmail.com',
                                        '');
                                  },
                                  child: Container(
                                      child: Image.asset(
                                          "assets/images/email.png",
                                          scale: 10))),
                              GestureDetector(
                                  onTap: () {
                                    _launchSocial(
                                        'https://www.linkedin.com/in/linda--ma/',
                                        '');
                                  },
                                  child: Container(
                                      child: Image.asset(
                                          "assets/images/linkedin.png",
                                          scale: 10))),
                            ]),
                      ]),
                ))
          ]),
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
              elevation: 0.0),
        ),
      ]),
    );
  }
}
