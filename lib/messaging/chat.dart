import 'dart:async';
import 'dart:convert';
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
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../messaging/spotify.dart';

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
  String? spotifyAuthToken;
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
    initializeSpotifyAPI();
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
        print(imageFile);
        isLoading = true;
      });
      uploadFile();
    } catch (e) {
      print("err");
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

  // Future getSpotifySecret() async {
  //   final RemoteConfig remoteConfig = RemoteConfig.instance;
  //   await remoteConfig.fetch();
  //   await remoteConfig.activate();
  //   String clientSecret = remoteConfig.getValue('client_secret').asString();
  //   String clientId = remoteConfig.getValue('client_id').asString();

  //   initializeSpotifyAPI(clientId, clientSecret);
  // }

  Future initializeSpotifyAPI() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization":
            'Basic OTIyMDVhODRmYWQwNDA2YTk1Njk4MDA2YjAyOWIyMzk6MmQyODJmOGU5MzM5NGQ2M2EwNzRmZjg1ODkyY2U4YjQ='
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      spotifyAuthToken = jsonList['access_token'];
      print('authSaved');
    } else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('failed');
    }
  }

  Future<Song> renderSpotifySongObject(String spotifyURL) async {
    print(spotifyURL);
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/tracks/$spotifyURL'),
      headers: {"Authorization": 'Bearer $spotifyAuthToken'},
    );

    if (response.statusCode == 200) {
      return Song.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception("failed");
    }
  }

  Future<Playlist> renderSpotifyPlaylistObject(String spotifyURL) async {
    print(spotifyURL);
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/playlists/$spotifyURL'),
      headers: {"Authorization": 'Bearer $spotifyAuthToken'},
    );

    if (response.statusCode == 200) {
      return Playlist.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      print(response.body.toString());
      throw Exception("failed");
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('messageImages/$fileName');
    UploadTask uploadTask = reference.putFile(imageFile!);
    uploadTask.whenComplete(() {
      print(imageUrl);
      reference.getDownloadURL().then((String imageUrl) {
        print(imageUrl);
        setState(() {
          print('imageUrl');
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

  void onSendSpotifyMessage(Song content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
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
          'name': content.name,
          'imageURL': content.imageUrl,
          'songURL': content.spotifyUrl,
          'songType': content.type,
          'songArtist': content.artistName,
          'songPreview': content.preview,
          'releaseDate': content.date,
          'type': type
        },
      );
    });
    listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void onSendSpotifyPlaylistMessage(Playlist content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
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
          'name': content.name,
          'description': content.description,
          'imageURL': content.imageUrl,
          'songURL': content.spotifyUrl,
          'playlistArtist': content.playlistArtist,
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
                  // Spotify
                  : document.data()!['type'] == 2
                      ? InkWell(
                          onTap: () {
                            launch("${document.data()!['songURL']}");
                          },
                          child: Container(
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  child: Image.network(
                                    "${document.data()!['imageURL']}",
                                    width: 250.0,
                                    height: 250.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 250),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      )),
                                  width: 250,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                      ),
                                      Text(
                                        "${document.data()!['name']}",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${document.data()!['songArtist']}",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(2),
                                          ),
                                          Text(
                                            "•",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(2),
                                          ),
                                          Text(
                                            "${document.data()!['releaseDate'].toString().substring(0, 4)}",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "open.spotify.com",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 0.0, 15.0, 20.0),
                                )
                              ],
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            launch("${document.data()!['songURL']}");
                          },
                          child: Container(
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  child: Image.network(
                                    "${document.data()!['imageURL']}",
                                    width: 250.0,
                                    height: 250.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 250),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      )),
                                  width: 250,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                      ),
                                      Text(
                                        "${document.data()!['name']}",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${document.data()!['description']}",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${document.data()!['playlistArtist']}",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        "open.spotify.com",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                      20.0, 0.0, 15.0, 20.0),
                                )
                              ],
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ),
                        )
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
                        : document.data()!['type'] == 2
                            ? InkWell(
                                onTap: () {
                                  print('cheese');
                                  launch("${document.data()!['songURL']}");
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    child: Column(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          topRight: Radius.circular(15.0),
                                        ),
                                        child: Image.network(
                                          "${document.data()!['imageURL']}",
                                          width: 250.0,
                                          height: 250.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 250),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15.0),
                                              bottomRight:
                                                  Radius.circular(15.0),
                                            )),
                                        width: 250,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                            ),
                                            Text(
                                              "${document.data()!['name']}",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(5),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${document.data()!['songArtist']}",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(2),
                                                ),
                                                Text(
                                                  "•",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(2),
                                                ),
                                                Text(
                                                  "Song",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  "${document.data()!['releaseDate'].toString().substring(0, 4)}",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "open.spotify.com",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.fromLTRB(
                                            20.0, 0.0, 15.0, 20.0),
                                      )
                                    ])))
                            : InkWell(
                                onTap: () {
                                  launch("${document.data()!['songURL']}");
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          topRight: Radius.circular(15.0),
                                        ),
                                        child: Image.network(
                                          "${document.data()!['imageURL']}",
                                          width: 250.0,
                                          height: 250.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 250),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15.0),
                                              bottomRight:
                                                  Radius.circular(15.0),
                                            )),
                                        width: 250,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                            ),
                                            Text(
                                              "${document.data()!['name']}",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(5),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${document.data()!['description']}",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "${document.data()!['playlistArtist']}",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            Text(
                                              "open.spotify.com",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.fromLTRB(
                                            20.0, 0.0, 15.0, 20.0),
                                      )
                                    ],
                                  ),
                                  margin: EdgeInsets.only(
                                      left: 10.0,
                                      bottom: isLastMessageRight(index)
                                          ? 5.0
                                          : 10.0,
                                      right: 0.0),
                                ),
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
                    onPressed: () async {
                      if (textEditingController.text.length > 24 &&
                          textEditingController.text.substring(0, 24) ==
                              "https://open.spotify.com") {
                        print(textEditingController.text.substring(24, 34));
                        if (textEditingController.text.substring(24, 34) ==
                            "/playlist/") {
                          var playlist = await renderSpotifyPlaylistObject(
                              textEditingController.text.substring(34));
                          onSendSpotifyPlaylistMessage(playlist, 2);
                        } else {
                          var song = await renderSpotifySongObject(
                              textEditingController.text.substring(31));
                          onSendSpotifyMessage(song, 2);
                        }
                      }
                      onSendMessage(textEditingController.text, 0);
                    },
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
