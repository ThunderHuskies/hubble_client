import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;
import 'dart:async';

import '../home/Profile.dart';

class Home extends StatefulWidget {
  final User user;
  Home({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      UserCard(user: widget.user),
      Connections(user: widget.user),
      AccountPage(user: widget.user),
    ];
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              label: 'Connections',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onNavTapped,
        ));
  }
}

class UserCard extends StatelessWidget {
  final User user;
  UserCard({this.user});
  // Home page
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Home',
        home: Scaffold(
          appBar: AppBar(
              title: Image.asset("assets/images/plane.png", scale: 1.0),
              bottomOpacity: 0,
              backgroundColor: Colors.white,
              toolbarHeight: 75.0,
              elevation: 0.0),
          body: UserCards(user: user),
        ));
  }
}

class UserCards extends StatefulWidget {
  final User user;
  UserCards({this.user});

  @override
  State<StatefulWidget> createState() {
    return UserCardsState();
  }
}

class UserCardsState extends State<UserCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Center(child: Text('${snapshot.error}'));
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Center(child: new CircularProgressIndicator());
                default:
                  if (!snapshot.hasData) {
                    return new Center(child: Text('No one...yet...'));
                  }
                  List<Widget> widgetList =
                      snapshot.data.docs.map((DocumentSnapshot document) {
                    return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context2) => Profile(
                                      document: document,
                                    ),
                                  ));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            document.data()['image']),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                Container(
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: <Color>[
                                          Colors.black.withAlpha(10),
                                          Colors.black12,
                                          Colors.black54
                                        ],
                                      ),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  document.data()['name'],
                                                  style: TextStyle(
                                                      fontFamily: 'Open Sans',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25.0),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(2.5),
                                                ),
                                                Text("Sophomore",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    )),
                                                Padding(
                                                  padding: EdgeInsets.all(1.0),
                                                ),
                                                Text(document.data()['major'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    )),
                                                Padding(
                                                  padding: EdgeInsets.all(20.0),
                                                ),
                                              ]),
                                          Padding(
                                            padding: EdgeInsets.all(15.0),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: CircleBorder(),
                                                  ),
                                                  child: Transform.rotate(
                                                    angle: -(math.pi / 5.0),
                                                    child: IconButton(
                                                        iconSize: 30.0,
                                                        icon: const Icon(Icons
                                                            .insert_link_rounded),
                                                        onPressed: () {
                                                          var listid = [
                                                            document.id
                                                          ];
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "users")
                                                              .doc(widget
                                                                  .user.uid)
                                                              .update({
                                                                'connections':
                                                                    FieldValue
                                                                        .arrayUnion(
                                                                            listid)
                                                              })
                                                              .then((value) =>
                                                                  print(
                                                                      "User Updated"))
                                                              .catchError(
                                                                  (error) => print(
                                                                      "Failed to update user: $error"));
                                                        }),
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                              ),
                                            ],
                                          )
                                        ])),
                              ],
                            )));
                  }).toList();
                  return Column(children: [
                    CarouselSlider(
                        options: CarouselOptions(
                          height: 690,
                          enlargeCenterPage: true,
                        ),
                        items: widgetList)
                  ]);
              }
            }));
  }
}

class Connections extends StatefulWidget {
  final User user;

  Connections({this.user});
  @override
  _ConnectionsState createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  @override
  Widget build(BuildContext context) {
    getConnectionsList() {
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.uid)
          .get()
          .then((DocumentSnapshot document) {
        print(document.data()['connections']);
        return document.data()['connections'];
      });
    }

    return CupertinoPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                CupertinoSliverNavigationBar(
                  automaticallyImplyLeading: false,
                  largeTitle: Text("Connections"),
                ),
              ];
            },
            body: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where(FieldPath.documentId, whereIn: getConnectionsList())
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Center(child: Text('${snapshot.error}'));
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return new Center(child: new CircularProgressIndicator());
                    default:
                      if (!snapshot.hasData) {
                        return new Center(child: Text('No matches!'));
                      }
                      return ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return Card(
                              child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Profile(
                                            document: document,
                                          ),
                                        ));
                                  },
                                  child: Column(children: <Widget>[
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            document.data()['image']),
                                      ),
                                      title: Text(document.data()['name']),
                                      subtitle: Text(document.data()['major']),
                                      trailing:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                    )
                                  ])));
                        }).toList(),
                      );
                  }
                })));
  }
}

class AccountPage extends StatelessWidget {
  final User user;

  AccountPage({this.user});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                CupertinoSliverNavigationBar(
                  automaticallyImplyLeading: false,
                  largeTitle: Text("My Account"),
                ),
              ];
            },
            body: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Center(child: Text('${snapshot.error}'));
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return new Center(child: new CircularProgressIndicator());
                    default:
                      if (!snapshot.hasData) {
                        return new Center(child: Text('No account?'));
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(15.0),
                              ),
                              CircleAvatar(
                                //change here to be backgroundImage
                                radius: 75,
                                backgroundImage:
                                    AssetImage('assets/images/porter.png'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                              ),
                              Text(
                                snapshot.data['name'],
                                style: TextStyle(fontSize: 30),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                              ),
                              Text("Sophomore"),
                              Padding(
                                padding: EdgeInsets.all(2.0),
                              ),
                              Text("University of British Columbia"),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(50.0),
                          ),
                          Row(children: [
                            Flexible(
                                child: Card(
                              child: ListTile(
                                  title: Text("Edit Profile"),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                  )),
                            )),
                          ]),
                          Flexible(
                            child: Card(
                                child: ListTile(
                              title: Text("Change Password"),
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                            )),
                          ),
                          Flexible(
                            child: Card(
                                child: ListTile(
                              title: Text("Change Schools"),
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                            )),
                          ),
                          Flexible(
                              child: Card(
                            child: ListTile(
                                title: Text("Sign Out"),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                )),
                          )),
                        ],
                      );
                  }
                })));
  }
}
