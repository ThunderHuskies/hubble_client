import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../home/Home.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
String savedNumber = "";
String currentText = "";
String _verificationId;
bool isPhoneVerified = true;
bool verificationError = false;

void signIn(BuildContext context) async {
  try {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: currentText);
    User user = (await auth.signInWithCredential(credential)).user;
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    print("Success: ${user.uid}");
  } catch (e) {
    verificationError = true;
    print('failed' + e.toString());
    print(currentText);
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
        phoneNumber: savedNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  } catch (e) {
    print("Failed to Verify Phone Number: ${e}");
    print(savedNumber);
  }
}

//phone number ui
class EnterPhone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
          SizedBox(height: 50),
          Image.asset('assets/images/phoneVerification.png', scale: 1),
          RichText(
            text: TextSpan(
                text: "Welcome to ",
                children: [
                  TextSpan(
                    text: "hubble",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
                style: TextStyle(color: Colors.black, fontSize: 24)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50),
          PhoneNumberInput(),
        ])));
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
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
              spaceBetweenSelectorAndTextField: 5,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              initialValue: number,
              textFieldController: controller,
              formatInput: true,
              inputBorder: OutlineInputBorder(),
              onSaved: (PhoneNumber number) {
                savedNumber = number.phoneNumber;
                print(savedNumber);
                validatePhone(context);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Go back'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              onPressed: () {
                formKey.currentState.save();
              },
              child: Text('Register'),
            ),
          ],
        ),
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
      Image.asset('assets/images/mail.png', scale: 1.0),
      SizedBox(height: 50),
      Text(
        "Verification code",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      ConstrainedBox(
        child: PinCodeVerificationScreen(savedNumber),
        constraints: BoxConstraints(maxHeight: 400),
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

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;

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
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1),
                  child: RichText(
                    text: TextSpan(
                        text:
                            "Please type the 6 digit verification code sent to ",
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 6,
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
                          fieldHeight: 50,
                          fieldWidth: 40,
                          //For Cell Colors
                          inactiveColor: Colors.black26,
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
                  height: 5,
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
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 30),
                  child: ButtonTheme(
                    height: 50,
                    child: FlatButton(
                      onPressed: () {
                        signIn(context);
                        // conditions for validating
                        if (verificationError) {
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
                  height: 5,
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
      ),
    );
  }
}
