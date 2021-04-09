import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final DocumentSnapshot? snapshot;

  EditProfile({this.snapshot});

  @override
  _EditProfileScreenState createState() =>
      _EditProfileScreenState(snapshot: snapshot!);
}

class _EditProfileScreenState extends State<EditProfile> {
  final DocumentSnapshot? snapshot;

  _EditProfileScreenState({this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text("Edit Profile"),
          previousPageTitle: "Account Profile",
          leading: GestureDetector(
            onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                            child: const Text("Save Profile"),
                            onPressed: () => Navigator.of(context).pop()),
                        CupertinoActionSheetAction(
                            child: const Text("Don't Save"),
                            onPressed: () => Navigator.pop(context)),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )),
            child: Row(
              children: <Widget>[
                Icon(CupertinoIcons.left_chevron),
              ],
            ),
          ),
        ),
        body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(snapshot!.data()!['image']),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Text(
                    snapshot!.data()!['name'],
                    style: TextStyle(fontSize: 30),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                  ),
                  Text("University of British Columbia"),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Year"),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Container(
                    width: 200,
                    child: TextFormField(
                        controller: TextEditingController(
                            text: '${snapshot!.data()!['yearLevel']}'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        )),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Major"),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Container(
                    width: 200,
                    child: TextFormField(
                        controller: TextEditingController(
                            text: '${snapshot!.data()!['major']}'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        )),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Clubs"),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Container(
                      width: 200,
                      constraints: BoxConstraints(maxHeight: 100),
                      child: TextField(
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                          maxLines: null,
                          controller: TextEditingController(
                              text: '${snapshot!.data()!['clubs']}'))),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hobbies"),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Container(
                      width: 200,
                      constraints: BoxConstraints(maxHeight: 100),
                      child: TextField(
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                          maxLines: null,
                          controller: TextEditingController(
                              text: '${snapshot!.data()!['hobbies']}'))),
                ],
              ),
              OutlinedButton(
                child: Text("Save Profile"),
                onPressed: () => {},
              ),
              TextButton(
                child: Text("delete account"),
                style: TextButton.styleFrom(primary: Colors.redAccent),
                onPressed: () => {},
              )
            ],
          ),
        ]));
  }
}
