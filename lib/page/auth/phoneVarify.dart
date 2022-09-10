import 'dart:async';

import 'package:badam/modul/html_converter.dart';
import 'package:badam/provider/auth_provider.dart';
import 'package:badam/util/AuthServiceFirebase.dart';
import 'package:badam/util/auth_service.dart';
import 'package:badam/util/countdown_base.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PhoneVarify extends StatefulWidget {
  @override
  _PhoneVarifyState createState() => _PhoneVarifyState();
}

class _PhoneVarifyState extends State<PhoneVarify> {
  TextEditingController phoneNo = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  TextEditingController codeVarify = TextEditingController();

  bool _isLoading = false;

  Widget innerButton() {
    return _isLoading
        ? Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(backgroundColor: Colors.white))
        : Text(
            "وارد شدن",
            style: TextStyle(color: Colors.white, fontSize: 16),
          );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  AuthServiceFirebase ?insta;
  bool _toggleVistibal = true;
  String ?varifiedUserId;

  bool _showPasswordField = false;
  bool _showVarifyField = false;

  Future<void> obbcode() async {
    startTimer();
    try {
      insta!.getCurrentUser().then((user) async {
        if (user.uid != null) {
          print("before ${phoneNo.text}");
          String phoneEdit = phoneNo.text.contains("+")
              ? phoneNo.text
              : "+93${phoneNo.text.substring(1)}";

          print("phone edit $phoneEdit");
          Navigator.pushReplacementNamed(context, "/register",
              arguments: UserAuthData(uid: user.uid, phoneNr: phoneEdit));
        } else {
          var response =
              await insta!.submitPhoneNumber(phoneNumber: phoneNo.text);
          if (response is UserAuthData) {
            Navigator.pushReplacementNamed(context, "/register",
                arguments: response);
          }
          varifiedUserId = response;
          setState(() {
            _showVarifyField = true;
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      if (e.code == "quotaExceeded") {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent,
          content: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                "به دلیل درخواست زیاد کد این شماره موقعا بسته میباشد.",
                style: TextStyle(fontFamily: "Vazir"),
              ),
              FaIcon(Icons.error)
            ],
          ),
          duration: Duration(seconds: 2),
        ));
      } else if (e.code == "verifyPhoneNumberError") {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent,
          content: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                "اتصال انترنت تان را چک کنید!",
                style: TextStyle(fontFamily: "Vazir"),
              ),
              FaIcon(Icons.error)
            ],
          ),
          duration: Duration(seconds: 2),
        ));
      } else {
        print("hello");
        print(e);
      }
      setState(() {
        _isLoading = false;
      });
      print("no Internet");
      print(e.code);
    }
  }

  submitNumber() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      if (phoneNo.text != "" && codeVarify.text != "") {
        try {
          var confirmcode = await insta.confirmSMSCode(
              smsCode: codeVarify.text, verificationId: this.varifiedUserId);
          Navigator.pushReplacementNamed(context, "/register",
              arguments: confirmcode);
        } catch (e) {
          if (e.code == "ERROR_SESSION_EXPIRED") {
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
              backgroundColor: Colors.redAccent,
              content: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    "کد تان منقضا شده . دکمه ارسال مجدد را بفشارید.",
                    style: TextStyle(fontFamily: "Vazir"),
                  ),
                  FaIcon(Icons.error)
                ],
              ),
              duration: Duration(seconds: 2),
            ));
          } else if (e.code == "ERROR_INVALID_VERIFICATION_CODE") {
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
              backgroundColor: Colors.redAccent,
              content: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    "کد وارده اشتباه میباشد لطفا کد درست را وارد کنید.",
                    style: TextStyle(fontFamily: "Vazir"),
                  ),
                  FaIcon(Icons.error)
                ],
              ),
              duration: Duration(seconds: 2),
            ));
          } else {
            print(e.code);
          }

          setState(() {
            _isLoading = false;
          });
          print(e.code);
        }
      } else if (phoneNo.text != "" && passwordInput.text != "") {
        try {
          await Provider.of<Auth>(context, listen: false)
              .loginWithPhoneNumber(
                  phone: phoneNo.text, password: passwordInput.text)
              .then((data) {
            if (data[0]) {
              Navigator.pushReplacementNamed(context, "/");
            } else {
              setState(() {
                _isLoading = false;
              });
              _scaffoldKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.redAccent,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(child: getHtmlFile(data[1])),
                        FaIcon(Icons.error)
                      ],
                    ),
                  ],
                ),
                duration: Duration(seconds: 2),
              ));
            }
          });
        } catch (e) {
          print(e);
        }
      } else {
        bool alreadyexit = await Auth().userAlreadyExits(this.phoneNo.text);

        if (alreadyexit) {
          setState(() {
            _showPasswordField = true;
            _isLoading = false;
          });
        } else {
          obbcode();
        }
      }
    }
  }

  @override
  void initState() {
    insta = AuthServiceFirebase(context: context);

    super.initState();
  }

  bool otpWaitTimeLabelResend = false;
  String otpWaitTimeLabel = null;
  StreamSubscription<Duration> sub;
  void startTimer() {
    if (sub != null) {
      sub.cancel();
    }
    otpWaitTimeLabelResend = false;
    sub = new CountDown(new Duration(seconds: 100)).stream.listen(null);

    sub.onData((Duration d) {
      int sec = d.inSeconds % 60;
      d.inSeconds == 0 ? otpWaitTimeLabelResend = true : null;
      setState(() {
        otpWaitTimeLabel = d.inMinutes.toString() + ":" + sec.toString();
      });
    });
  }

  @override
  void dispose() {
    if (sub != null) {
      sub.cancel();
    }

    super.dispose();
  }

  List<Widget> loginItem = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('ثبت و وارد شدن')),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: phoneNo,
                                    autofocus: true,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.left,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'شماره تلفون را وارد کنید';
                                      }
                                      if (value.length < 10) {
                                        return 'شماره تلفون معتبر وارد کنید';
                                      }
                                      return null;
                                    },
                                    decoration: new InputDecoration(
                                        labelText: ' شماره تلفون تان وارد کنند',
                                        hintText: "0785185336",
                                        suffixStyle: const TextStyle(
                                            color: Colors.green)),
                                  ),
                                  _showPasswordField
                                      ? TextFormField(
                                          controller: passwordInput,
                                          autofocus: true,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                          keyboardType: TextInputType.text,
                                          obscureText: true,
                                          maxLength: 10,
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.left,
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return 'رمز عبورتان را وارد کنید';
                                            }

                                            return null;
                                          },
                                          decoration: new InputDecoration(
                                              labelText:
                                                  'رمز عبورتان را وارد کنید',
                                              suffixStyle: const TextStyle(
                                                  color: Colors.green)),
                                        )
                                      : SizedBox(),
                                  _showVarifyField
                                      ? Column(
                                          children: <Widget>[
                                            TextFormField(
                                              autofocus: true,
                                              controller: codeVarify,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 10,
                                              textDirection: TextDirection.ltr,
                                              textAlign: TextAlign.left,
                                              validator: (String value) {
                                                if (value.isEmpty) {
                                                  return 'کد پیامک را وارد کنید';
                                                }

                                                return null;
                                              },
                                              decoration: new InputDecoration(
                                                  labelText:
                                                      'کد پیامک را وارد کنید',
                                                  suffixStyle: const TextStyle(
                                                      color: Colors.green)),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                otpWaitTimeLabelResend
                                                    ? FlatButton(
                                                        onPressed: () =>
                                                            obbcode(),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Icon(Icons.message),
                                                            SizedBox(
                                                              width: 3,
                                                            ),
                                                            Text("ارسال مجدد"),
                                                          ],
                                                        ))
                                                    : Text(otpWaitTimeLabel),
                                                FlatButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        varifiedUserId = "";
                                                        _showVarifyField =
                                                            false;
                                                        codeVarify.text = "";
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text("تغیر شماره "),
                                                        Icon(Icons.phone),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            )
                                          ],
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 0.0),
                    Container(
                      width: 200,
                      padding: EdgeInsets.all(10),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: FlatButton(
                          onPressed: submitNumber,
                          child: innerButton(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
