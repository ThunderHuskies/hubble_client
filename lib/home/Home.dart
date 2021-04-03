import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../home/Profile.dart';

class Home extends StatefulWidget {
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

  static List<Widget> _widgetOptions = <Widget>[
    Scaffold(
        body: Center(
            // paste inside here ur card code
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        child: Text('WE DID IT HOME'),
        onPressed: () {
          print('chee');
        },
      ),
    ]))),
    // page 2
    Connections(),
    //page 3
    CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              automaticallyImplyLeading: false,
              largeTitle: Text("My Account"),
            ),
          ];
        },
        body: Column(
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
                  backgroundImage: AssetImage('assets/images/porter.png'),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Text(
                  "Martin Au-yeung",
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
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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

class Connections extends StatefulWidget {
  @override
  _ConnectionsState createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  @override
  Widget build(BuildContext context) {
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
                stream:
                    FirebaseFirestore.instance.collection("users").snapshots(),
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
                                          builder: (context) => Profile(),
                                        ));
                                  },
                                  child: Column(children: <Widget>[
                                    ListTile(
                                      leading: CircleAvatar(),
                                      title: Text(document.data()['name']),
                                      subtitle: Text("chicken"),
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
