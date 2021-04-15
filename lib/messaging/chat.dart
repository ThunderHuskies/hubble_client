import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hubble_client/home/Profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';

class CustomMaterialPageRoute extends MaterialPageRoute {
  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }

  CustomMaterialPageRoute({
    required WidgetBuilder builder,
    required RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );
}

class Chat extends StatelessWidget {
  final User? user;
  final DocumentSnapshot? friend;

  Chat({Key? key, @required this.user, @required this.friend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        backwardsCompatibility: false,
        title: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profile(
                    document: friend,
                  ),
                ));
          },
          child: Container(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(friend!.data()!['image']),
                  // maxRadius: 18,
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "${friend!.data()!['name']}",
                ),
              ],
            ),
          ),
        ),
      ),
      body: ChatScreen(user: user, friend: friend),
    );
  }
}

class FullPhoto extends StatelessWidget {
  final String? url;

  FullPhoto({Key? key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FullPhotoScreen(url: url),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String? url;

  FullPhotoScreen({Key? key, @required this.url}) : super(key: key);

  @override
  State createState() => FullPhotoScreenState(url: url);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String? url;

  FullPhotoScreenState({Key? key, @required this.url});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(imageProvider: CachedNetworkImageProvider(url!)));
  }
}

class ChatScreen extends StatefulWidget {
  final User? user;
  final DocumentSnapshot? friend;

  ChatScreen({Key? key, @required this.user, @required this.friend})
      : super(key: key);

  @override
  State createState() => ChatScreenState(user: user, friend: friend);
}

class ChatScreenState extends State<ChatScreen> {
  final User? user;
  final DocumentSnapshot? friend;

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
    if (user!.uid.hashCode <= friend!.id.hashCode) {
      groupChatId = '${user!.uid}-${friend!.id}';
    } else {
      groupChatId = '${friend!.id}-${user!.uid}';
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'chattingWith': friend!.id});

    setState(() {});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;
    try {
      pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
      imageFile = File(pickedFile!.path);
      setState(() {
        isLoading = true;
      });
      uploadFile();
    } catch (e) {
      print(e);
    }
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
    Reference reference = storage.ref().child('messageImages/$fileName');
    UploadTask uploadTask = reference.putFile(imageFile!);
    uploadTask.whenComplete(() {
      reference.getDownloadURL().then((String imageUrl) {
        setState(() {
          isLoading = false;
          onSendMessage(imageUrl, 1);
        });
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "This file type is unsupported");
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() == '') return;
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
          'idTo': friend!.id,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'type': type
        },
      );
    });
    listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
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
                  constraints: BoxConstraints(maxWidth: 250),
                  child: Text(
                    document.data()!['content'],
                    style: TextStyle(color: Colors.black),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  decoration: BoxDecoration(
                      //chnage text box colours
                      color: Colors.cyan[200],
                      borderRadius: BorderRadius.circular(15.0)),
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
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'images/porter.png',
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
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullPhoto(
                                      url: document.data()!['content'])));
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
                          imageUrl: friend!.data()!['image'],
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
                        constraints: BoxConstraints(maxWidth: 250),
                        child: Text(
                          document.data()!['content'],
                          style: TextStyle(color: Colors.black),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        // width: (document.data()!['content'].length).round(),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15.0)),
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
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset(
                                      'images/porter.png',
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
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullPhoto(
                                            url: document.data()!['content'])));
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : Container(
                            child: Image.asset(
                              'images/${document.data()!['content']}.gif',
                              width: 100.0,
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
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'chattingWith': null});
    Navigator.pop(context);

    return Future.value(false);
  }

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
          Padding(
            padding: EdgeInsets.all(5),
          ),
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
          Padding(
            padding: EdgeInsets.all(2),
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
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  hintText: 'Aa',
                  hintStyle: TextStyle(color: Colors.grey),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () =>
                        onSendMessage(textEditingController.text, 0),
                    color: Colors.blue,
                  ),
                ),
                focusNode: focusNode,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
          )
          // Button send message
        ],
      ),
      width: double.infinity,
      height: 70.0,
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
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  listMessage.addAll(snapshot.data!.docs);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data!.docs[index]),
                    itemCount: snapshot.data!.docs.length,
                    reverse: true,
                    controller: listScrollController,
                  );
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

              // Input content
              buildInput(),
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
              ),
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
