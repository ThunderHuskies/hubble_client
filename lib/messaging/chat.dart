import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatelessWidget {
  final User? user;
  final User? friend;

  Chat({Key? key, @required this.user, @required this.friend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHAT',
          // style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(user: user, friend: friend),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final User? user;
  final User? friend;

  ChatScreen({Key? key, @required this.user, @required this.friend})
      : super(key: key);

  @override
  State createState() => ChatScreenState(user: user, friend: friend);
}

class ChatScreenState extends State<ChatScreen> {
  final User? user;
  final User? friend;

  ChatScreenState({Key? key, @required this.user, @required this.friend});

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  int _limitIncrement = 20;
  String? groupChatId;
  SharedPreferences? prefs;

  File? imageFile;
  bool isLoading = false;
  bool? isShowSticker;
  String? imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    if (user!.uid.hashCode <= friend!.uid.hashCode) {
      groupChatId = '${user!.uid}-${friend!.uid}';
    } else {
      groupChatId = '${friend!.uid}-${user!.uid}';
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'chattingWith': friend!.uid});

    setState(() {});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile!.path);

    setState(() {
      isLoading = true;
    });
    uploadFile();
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = false;
    });
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile!);
    uploadTask.whenComplete(() {
      imageUrl = reference.getDownloadURL() as String?;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl!, 1);
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId.toString())
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': user!.uid,
            'idTo': friend!.uid,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      print('error');
      //   Fluttertoast.showToast(
      //       msg: 'Nothing to send',
      //       backgroundColor: Colors.black,
      //       textColor: Colors.red);
      // }
    }
  }

  bool isLastMessageLeft(int index) {
    return ((index > 0 &&
            listMessage[index - 1].data()['idFrom'] == user!.uid) ||
        index == 0);
  }

  bool isLastMessageRight(int index) {
    return ((index > 0 &&
            listMessage[index - 1].data()['idFrom'] != user!.uid) ||
        index == 0);
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document.data()!['idFrom'] == user!.uid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document.data()!['type'] == 0
              // Text
              ? Container(
                  child: Text(
                    document.data()!['content'],
                    style: TextStyle(color: Colors.black),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              : document.data()!['type'] == 1
                  // Image
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'images/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document.data()!['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          print('cheese');
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => FullPhoto(
                          //             url: document.data()!['content'])));
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  // Sticker
                  : Container(
                      child: Image.asset(
                        'images/${document.data()!['content']}.gif',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: document.data()!['image'],
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                document.data()!['type'] == 0
                    ? Container(
                        child: Text(
                          document.data()!['content'],
                          style: TextStyle(color: Colors.black),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document.data()!['type'] == 1
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset(
                                      'images/img_not_available.jpeg',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document.data()!['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                print('cheese2');
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => FullPhoto(
                                //             url: document.data()!['content'])));
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : Container(
                            child: Image.asset(
                              'images/${document.data()!['content']}.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document.data()!['timestamp']))),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  Future<bool> onBackPress() {
    // if (isShowSticker) {
    //   setState(() {
    //     isShowSticker = false;
    //   });
    // } else {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'chattingWith': null});
    Navigator.pop(context);
    // }

    return Future.value(false);
  }

  // Widget buildSticker() {
  //   return Container(
  //     child: Column(
  //       children: <Widget>[
  //         Row(
  //           children: <Widget>[
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi1', 2),
  //               child: Image.asset(
  //                 'images/mimi1.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi2', 2),
  //               child: Image.asset(
  //                 'images/mimi2.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi3', 2),
  //               child: Image.asset(
  //                 'images/mimi3.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             )
  //           ],
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         ),
  //         Row(
  //           children: <Widget>[
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi4', 2),
  //               child: Image.asset(
  //                 'images/mimi4.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi5', 2),
  //               child: Image.asset(
  //                 'images/mimi5.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi6', 2),
  //               child: Image.asset(
  //                 'images/mimi6.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             )
  //           ],
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         ),
  //         Row(
  //           children: <Widget>[
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi7', 2),
  //               child: Image.asset(
  //                 'images/mimi7.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi8', 2),
  //               child: Image.asset(
  //                 'images/mimi8.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             FlatButton(
  //               onPressed: () => onSendMessage('mimi9', 2),
  //               child: Image.asset(
  //                 'images/mimi9.gif',
  //                 width: 50.0,
  //                 height: 50.0,
  //                 fit: BoxFit.cover,
  //               ),
  //             )
  //           ],
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         )
  //       ],
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     ),
  //     decoration: BoxDecoration(
  //         border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
  //         color: Colors.white),
  //     padding: EdgeInsets.all(5.0),
  //     height: 180.0,
  //   );
  // }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: CircularProgressIndicator(),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, 0);
                },
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.blue,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId.toString())
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(child: CircularProgressIndicator());
                  // listMessage.addAll(snapshot.data!);
                  // return ListView.builder(
                  //   padding: EdgeInsets.all(10.0),
                  //   itemBuilder: (context, index) =>
                  //       buildItem(index, snapshot.data!.doc[index]),
                  //   itemCount: snapshot.data!.doc.length,
                  //   reverse: true,
                  //   controller: listScrollController,
                  // );
                }
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Sticker
              // (isShowSticker ? buildSticker() : Container()),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }
}
