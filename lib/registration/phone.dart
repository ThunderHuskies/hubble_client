import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../home/Home.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final TextEditingController phoneTextController = TextEditingController();
final TextEditingController smsVerificationController = TextEditingController();
String _verificationId;
bool isPhoneVerified = true;

void signIn(BuildContext context) async {
  try {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsVerificationController.text);
    User user = (await auth.signInWithCredential(credential)).user;
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    print("Success: ${user.uid}");
  } catch (e) {
    print('failed' + e.toString());
  }
}

Future<void> validatePhone(BuildContext context) async {
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
    _verificationId = verificationId;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ValidatePhone()));
  };

  PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    print("verification code: " + verificationId);
    _verificationId = verificationId;
  };

  try {
    await auth.verifyPhoneNumber(
        phoneNumber: phoneTextController.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  } catch (e) {
    print("Failed to Verify Phone Number: ${e}");
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
      Text("Welcome to hubble"),
      // TextField(
      //   controller: phoneTextController,
      //   decoration: new InputDecoration(
      //       labelText: "Enter your phone number (+x xxx xxx xxxx"),
      //   keyboardType: TextInputType.number,
      //     inputFormatters: <TextInputFormatter>[
      //       FilteringTextInputFormatter.digitsOnly
      //     ],
      // ),
      PhoneNumberInput(),
    ]))
    );
  }
}

class PhoneNumberInput extends StatefulWidget {
  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'CA';
  PhoneNumber number = PhoneNumber(isoCode: 'CA');
  String savedNumber = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              onInputValidated: (bool value) {
                print(value);
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: Colors.black),
              //customs
              maxLength: 12,
              hintText: '(xxx) xxx-xxxx',
              spaceBetweenSelectorAndTextField: 0,
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              // keyboardType: TextInputType.number,
              initialValue: number,
              textFieldController: controller,
              formatInput: true,
              inputBorder: OutlineInputBorder(),
              onSaved: (PhoneNumber number) {
                print('Saved: $number');
                savedNumber = number.parseNumber();
              },
            ),
            // RaisedButton(
            //   onPressed: () {
            //     formKey.currentState.validate();
            //   },
            //   child: Text('Validate'),
            // ),
            ElevatedButton(
              child: Text('Go back'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              onPressed: () {
                formKey.currentState.save();
                pushSaved();
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
  
  void pushSaved() {
    // PinCodeVerificationScreen("+12348882222");
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
              body: Center(
                  child:
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Verification code"),
                  ConstrainedBox(
                    child: PinCodeVerificationScreen("+15872845788"),
                    constraints: BoxConstraints(maxHeight: 500),
                  ),
                ])));
        },
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
        decoration: new InputDecoration(
            labelText: "Enter the 4-digit verification code"),
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
          signIn(context);
        },
      ),
    ])));

    
  }
}

class PinCodeVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  PinCodeVerificationScreen(this.phoneNumber);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Please type the verification code sent to ",
                      children: [
                        TextSpan(
                            text: widget.phoneNumber,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 4,
                      // obscureText: true,
                      // obscuringCharacter: '*',
                      // blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      // validator: (v) {
                      //   if (v.length < 3) {
                      //     return "I'm from validator";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 80,
                        fieldWidth: 60,
                        //For Cell Colors
                        inactiveFillColor: Colors.white,
                        activeFillColor:
                            hasError ? Colors.lightBlue[100] : Colors.white,
                        selectedFillColor: Colors.lightBlue[100],
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Colors.white60,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        print("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please Enter The Correct Code" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                    children: [
                      TextSpan(
                          text: " RESEND",
                          recognizer: onTapRecognizer,
                          style: TextStyle(
                              color: Color.fromRGBO(0, 171, 240, 1.0),
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ]),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      formKey.currentState.validate();
                      // conditions for validating
                      if (currentText.length != 4 || currentText != "1234") {
                        errorController.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() {
                          hasError = true;
                        });
                      } else {
                        setState(() {
                          hasError = false;
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Validated"),
                            duration: Duration(seconds: 2),
                          ));
                        });
                      }
                    },
                    child: Center(
                        child: Text(
                      "VERIFY".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.blue.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: FlatButton(
                    child: Text("Clear"),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
      // body: Center(
      //   child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      //     SizedBox(
      //       // width: 10.0,
      //       // height: 10.0,
      //       child: 
      //       PinCodeTextField(
      //           length: 4,
      //           obscureText: false,
      //           animationType: AnimationType.fade,
      //           pinTheme: PinTheme(
      //             shape: PinCodeFieldShape.box,
      //             borderRadius: BorderRadius.circular(0.5),
      //             fieldHeight: 80,
      //             fieldWidth: 60,
      //             activeFillColor: Colors.blueGrey,
      //           ),
      //           animationDuration: Duration(milliseconds: 300),
      //           enableActiveFill: true,
      //           errorAnimationController: errorController,
      //           controller: textEditingController,
      //           onCompleted: (v) {
      //             print("Completed");
      //           },
      //           onChanged: (value) {
      //             print(value);
      //             setState(() {
      //               currentText = value;
      //             });
      //           },
      //           beforeTextPaste: (text) {
      //             print("Allowing to paste $text");
      //             //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
      //             //but you can show anything you want here, like your pop up saying wrong paste format or etc
      //             return true;
      //           }, appContext: null,
      //         )
      //     )
      //   ])
    //)
//     );
//   }
// }
