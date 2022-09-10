import 'package:badam/modul/customRadioButton/CustomButtons/CustomRadioButton.dart';
import 'package:badam/page/myProperties/addpropertise.dart';
import 'package:badam/provider/auth_provider.dart';
import 'package:badam/util/AuthServiceFirebase.dart';
import 'package:badam/util/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RegisterUser extends StatefulWidget {
  UserAuthData userAuthData;

  RegisterUser({this.userAuthData});
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  AuthServiceFirebase authCurrent;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Map typeRegisterSelected;
  @override
  void initState() {
    typeRegisterSelected = typeRegister[0];
    super.initState();
  }

  var nameInput, lastnameInput;
  List<Map<String, String>> typeRegister = [
    {"name": "شخص", "slug": "person"},
    {"name": 'مشاور املاک', "slug": 'agent'},
    {"name": 'رهنمایی معاملات', "slug": 'agency'},
  ];

  bool _isLoading = false;

  var fullName = TextEditingController();
  var agencyName = TextEditingController();
  var agencyAddress = TextEditingController();
  var idCard = TextEditingController();
  var lysinceId = TextEditingController();

  var fullname = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();

  Widget submitButton() {
    return _isLoading
        ? Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(backgroundColor: Colors.white))
        : Text(
            "ارسال کردن",
            style: TextStyle(color: Colors.white, fontSize: 16),
          );
  }

  LoginUserDB() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        String phoneEdit = widget.userAuthData.phoneNr;
        print(widget.userAuthData.phoneNr);

        Map response = await Auth().registerUser(
          email: email.text,
          fullname: fullName.text,
          password: password.text,
          phoneNumber: phoneEdit,
          registerType: typeRegisterSelected['slug'],
          agencyAddress: agencyAddress.text,
          agencyName: agencyName.text,
          idCard: idCard.text,
          lyciseId: lysinceId.text,
        );

        if (response["success"]) {
          await Provider.of<Auth>(context, listen: false)
              .loginWithPhoneNumber(password: password.text, phone: phoneEdit);
          Navigator.pushReplacementNamed(context, "/");
        } else {
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent,
            content: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  response["message"],
                  style: TextStyle(fontFamily: "Vazir"),
                ),
                FaIcon(Icons.error)
              ],
            ),
            duration: Duration(seconds: 2),
          ));
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print("this place");
        print(e);
      }
      // _scaffoldKey.currentState.showSnackBar(
      //   new SnackBar(
      //     backgroundColor: Colors.redAccent,
      //     content: Row(
      //       mainAxisSize: MainAxisSize.max,
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         new Text(
      //           "انترنت تان را چک کنید",
      //           style: TextStyle(fontFamily: "Vazir"),
      //         ),
      //       ],
      //     ),
      //   );

    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("فورم ثبت نام"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        reverse: true,
              child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.only(right: 10, top: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomRadioButton(
                      elevation: 0,
                      unSelectedColor: Theme.of(context).canvasColor,
                      height: 40,
                      autoWidth: true,
                      width: double.infinity,
                      enableShape: false,
                      spacing: 0,
                      padding: 0,
                      defaultSelected: typeRegisterSelected['slug'],
                      buttonLables: typeRegister.map((m) => m['name']).toList(),
                      buttonValues: typeRegister.map((m) => m['slug']).toList(),
                      // buttonTextStyle: ButtonTextStyle(
                      //     selectedColor: Colors.white,
                      //     unSelectedColor: Colors.black,
                      //     textStyle: TextStyle(fontSize: 16)),
                      radioButtonValue: (value) {
                        setState(() {
                          typeRegister.map((data) {
                            if (data['slug'] == value) {
                              this.typeRegisterSelected = data;
                            }
                          }).toList();

                          // _propertyTpe = value;
                        });
                      },
                      selectedColor: Theme.of(context).primaryColor,
                    ),
                    Divider(),
                    MyTextFormField(
                      hintText: "نام و تخلص",
                      textEditingController: fullName,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'تخلص تان را وارد کنید';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        // addItem.title = value;
                      },
                    ),
                    typeRegisterSelected['slug'] == "agency" ||
                            typeRegisterSelected['slug'] == "agent"
                        ? MyTextFormField(
                            textEditingController: agencyName,
                            hintText: 'نام رهنمایی معاملات',
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'نام رهنمایی معاملات را وارد کنید';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              // addItem.title = value;
                            },
                          )
                        : SizedBox(),
                    typeRegisterSelected['slug'] == "agency"
                        ? MyTextFormField(
                            textEditingController: agencyAddress,
                            hintText: 'آدرس رهنمایی معاملات',
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'آدرس رهنمایی معاملات را وارد کنید';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              // addItem.title = value;
                            },
                          )
                        : SizedBox(),
                    typeRegisterSelected['slug'] == "agency"
                        ? MyTextFormField(
                            isNumber: true,
                            textEditingController: idCard,
                            hintText: 'شماره تذکره',
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'شماره تذکره را وارد کنید';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              // addItem.title = value;
                            },
                          )
                        : SizedBox(),
                    typeRegisterSelected['slug'] == "agency"
                        ? MyTextFormField(
                            isNumber: true,
                            textEditingController: lysinceId,
                            hintText: 'نمبر جواز',
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'نمبر جواز  را وارد کنید';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              // addItem.title = value;
                            },
                          )
                        : SizedBox(),
                    MyTextFormField(
                      textEditingController: email,
                      hintText: 'ایمیل ادرس',
                      isEmail: true,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return ' ایمیل ادرس را وارد کنید';
                        }
                        if (!value.contains("@")) {
                          return ' ایمیل ادرس معتبر نیست';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        // addItem.title = value;
                      },
                    ),
                    MyTextFormField(
                      textEditingController: password,
                      hintText: 'رمز عبور ',
                      isPassword: true,
                      isRtl: false,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'رمز عبور را وارد کنید';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        // addItem.title = value;
                      },
                    ),
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
                          onPressed: LoginUserDB,
                          child: submitButton(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
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

//  var displayName = user.displayName;
//             var email = user.email;
//             var emailVerified = user.emailVerified;
//             var photoURL = user.photoURL;
//             var uid = user.uid;
//             var phoneNumber = user.phoneNumber;
//             var providerData = user.providerData;
