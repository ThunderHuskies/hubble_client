import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  File? imageFile;

  String year = '';
  String major = '';
  String clubs = '';
  String hobbies = '';
  String lookingFor = '';
  String pfp = '';

  @override
  void initState() {
    super.initState();
    year = "${snapshot!.data()!['year']}";
    major = "${snapshot!.data()!['major']}";
    clubs = "${snapshot!.data()!['clubs']}";
    hobbies = "${snapshot!.data()!['hobbies']}";
    lookingFor = "${snapshot!.data()!['lookingFor']}";
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('profileImages/$fileName');
    UploadTask uploadTask = reference.putFile(imageFile!);
    uploadTask.whenComplete(() {
      reference.getDownloadURL().then((String imageUrl) {
        pfp = imageUrl;
      });
    }).catchError((onError) {
      // setState(() {
      // });
      Fluttertoast.showToast(msg: "This file type is unsupported");
    });
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;
    try {
      pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
      imageFile = File(pickedFile!.path);
      // setState(() {
      //   // isLoading = true;
      // });
      uploadFile();
    } catch (e) {
      print(e);
    }
  }

  void updateProfile() {
    print(year);
    if (year != '' &&
        major != '' &&
        clubs != '' &&
        hobbies != '' &&
        lookingFor != '') {
      FirebaseFirestore.instance.collection('users').doc(snapshot!.id).update({
        'yearLevel': year,
        'major': major,
        'clubs': clubs,
        'hobbies': hobbies,
        'lookingFor': lookingFor,
        'image': pfp,
      });
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text("Edit Profile"),
          previousPageTitle: "Account Profile",
          trailing: TextButton(
            child: Text("DONE",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            onPressed: updateProfile,
          ),
        ),
        body: Column(children: [
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundImage:
                        CachedNetworkImageProvider(snapshot!.data()!['image']),
                  ),
                  TextButton(onPressed: getImage, child: Text("Change Photo")),
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
                padding: EdgeInsets.all(20.0),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  Text("Year"),
                  Padding(
                    padding: EdgeInsets.all(22.0),
                  ),
                  Container(
                    width: 280,
                    child: TextFormField(
                        onChanged: (value) => year = value,
                        controller: TextEditingController(
                            text: '${snapshot!.data()!['yearLevel']}'),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                        )),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  Text("Major"),
                  Padding(
                    padding: EdgeInsets.all(18.0),
                  ),
                  Container(
                    width: 280,
                    child: TextFormField(
                        onChanged: (value) => major = value,
                        controller: TextEditingController(
                            text: '${snapshot!.data()!['major']}'),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                        )),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  Text("Seeking"),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Container(
                    width: 280,
                    child: TextFormField(
                        onChanged: (value) => lookingFor = value,
                        controller: TextEditingController(
                            text: '${snapshot!.data()!['lookingFor']}'),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                        )),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  Text("Clubs"),
                  Padding(
                    padding: EdgeInsets.all(18.0),
                  ),
                  Container(
                      width: 280,
                      constraints: BoxConstraints(maxHeight: 100),
                      child: TextField(
                          decoration:
                              InputDecoration(border: UnderlineInputBorder()),
                          maxLines: null,
                          onChanged: (value) => clubs = value,
                          controller: TextEditingController(
                              text: '${snapshot!.data()!['clubs']}'))),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  Text("Hobbies"),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Container(
                      width: 280,
                      constraints: BoxConstraints(maxHeight: 100),
                      child: TextField(
                          decoration:
                              InputDecoration(border: UnderlineInputBorder()),
                          maxLines: null,
                          onChanged: (value) => hobbies = value,
                          controller: TextEditingController(
                              text: '${snapshot!.data()!['hobbies']}'))),
                ],
              ),
            ],
          ),
        ]));
  }
}
