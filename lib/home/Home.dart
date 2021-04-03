import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_tindercard/flutter_tindercard.dart';

class Home extends StatelessWidget {
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
              elevation: 0.0
            ),
        body: Padding(
            padding: EdgeInsets.only(bottom: 90.0), 
            child: UserCards()
        ),
      ));
  }
}

class UserCards extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserCardsState();
  }
}

final List<Image> imgList = [
  Image.asset('assets/images/welcome0.png'),
  Image.asset('assets/images/welcome1.png'),
  Image.asset('assets/images/welcome2.png'),
  Image.asset('assets/images/welcome3.png'),
];

class UserCardsState extends State<UserCards> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        CarouselSlider(
            options: CarouselOptions(
                height: 690,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: imgList),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.map((url) {
            int index = imgList.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        )
      ]),
    );
  }
}

//For future use: card swiping in different directions
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with TickerProviderStateMixin {
//   List<String> welcomeImages = [
//     "assets/images/welcome0.png",
//     "assets/images/welcome1.png",
//     "assets/images/welcome2.png",
//     "assets/images/welcome3.png",
//     "assets/images/welcome0.png",
//     "assets/images/welcome1.png",
//     "assets/images/welcome2.png",
//     "assets/images/welcome3.png"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     CardController controller; //Use this to trigger swap.

//     return new Scaffold(
//       body: new Center(
//           child: Container(
//               height: MediaQuery.of(context).size.height * 0.7,
//               width: MediaQuery.of(context).size.height * 0.6,
//               child: new TinderSwapCard(
//                   swipeUp: true,
//                   swipeDown: true,
//                   orientation: AmassOrientation.BOTTOM,
//                   totalNum: welcomeImages.length,
//                   stackNum: 3,
//                   swipeEdge: 3.0,
//                   maxWidth: MediaQuery.of(context).size.width * 0.9,
//                   maxHeight: MediaQuery.of(context).size.width * 1.6,
//                   minWidth: MediaQuery.of(context).size.width * 0.8,
//                   minHeight: MediaQuery.of(context).size.width * 1.0,
//                   cardBuilder: (context, index) => Card(
//                         child: Image.asset('${welcomeImages[index]}'),
//                       ),
//                   cardController: controller = CardController(),
//                   swipeUpdateCallback:
//                       (DragUpdateDetails details, Alignment align) {
//                     /// Get swiping card's alignment
//                     if (align.x < 0) {
//                       //Card is LEFT swiping
//                     } else if (align.x > 0) {
//                       //Card is RIGHT swiping
//                     }
//                   },
//                   swipeCompleteCallback:
//                       (CardSwipeOrientation orientation, int index) {
//                     /// Get orientation & index of swiped card!
//                   },
//               ),
//           ),
//       ),
//     );
//   }
// }