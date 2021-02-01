import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final TextEditingController phoneTextController = TextEditingController();
final TextEditingController smsVerificationController = TextEditingController();
String _verificationId;

void signIn() async {
  try {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsVerificationController.text);
    User user = (await auth.signInWithCredential(credential)).user;

    print("Success: ${user.uid}");
  } catch (e) {
    print('failed' + e.toString());
  }
}

void validatePhone() async {
  // user already verified on device
  PhoneVerificationCompleted verificationCompleted =
      (PhoneAuthCredential phoneAuthCredential) async {
    await auth.signInWithCredential(phoneAuthCredential);
    print(
        "Phone Number already verfied and signed in: ${auth.currentUser.uid}");
  };

  //Verification failed
  PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException authException) {
    print(
        'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
  };

  //Callback for when the code is sent
  PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
    print('Please check your phone for the verification code.');
    verificationId = verificationId;
  };

  PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    print("verification code: " + verificationId);
    _verificationId = verificationId;
  };

  try {
    await auth.verifyPhoneNumber(
        phoneNumber: phoneTextController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  } catch (e) {
    print("Failed to Verify Phone Number: ${e}");
    print(phoneTextController.text);
  }
}

//phone number ui
class EnterPhone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextField(
        controller: phoneTextController,
        decoration: new InputDecoration(
            labelText: "Enter your phone number (+x xxx xxx xxxx"),
        keyboardType: TextInputType.number,
        //   inputFormatters: <TextInputFormatter>[
        //     FilteringTextInputFormatter.digitsOnly
        //   ],
      ),
      ElevatedButton(
        child: Text('Go back'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      ElevatedButton(
        child: Text('Register'),
        onPressed: () {
          try {
            validatePhone();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ValidatePhone()));
          } catch (e) {}
        },
      ),
    ])));
  }
}

class ValidatePhone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextField(
        controller: smsVerificationController,
        decoration: new InputDecoration(labelText: "Enter your number"),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
      ElevatedButton(
        child: Text('Go back'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      ElevatedButton(
        child: Text('Validate'),
        onPressed: () {
          signIn();
        },
      ),
    ])));
  }
}
