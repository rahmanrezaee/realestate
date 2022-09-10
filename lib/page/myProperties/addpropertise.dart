import 'dart:io';
import 'dart:async';

import 'package:badam/apiReqeust/constants.dart';
import 'package:badam/model/Image.dart';
import 'package:badam/model/property.dart';
import 'package:badam/page/Homepage.dart';
import 'package:badam/page/myProperties/map_screen.dart';
import 'package:badam/provider/auth_provider.dart';
import 'package:badam/provider/property_provider.dart';
import 'package:badam/util/utiles_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_tags/flutter_tags.dart';

class AddPropertise extends StatefulWidget {
  Auth auth;
  Property propertyEdit;
  AddPropertise({this.auth, this.propertyEdit});
  @override
  _AddPropertiseState createState() => _AddPropertiseState();
}

enum AimCharacter { forrent, forsale }
enum TypeCharacter { land, home, unit, office, shop, apartment, vela }

class _AddPropertiseState extends State<AddPropertise> {
  List<Map<String, String>> propertytypes = [
    {"display": 'اپارتمان', "value": 'apartment'},
    {"display": 'اداری', "value": 'office'},
    {"display": 'تجارتی', "value": 'commerce'},
    {"display": 'مستغلات', "value": 'working'},
    {"display": 'زمین', "value": 'land'},
    {"display": 'ویلا', "value": 'villa'},
    {"display": 'باغ و باغچه', "value": 'grabeg'},
    {"display": 'انبار و سوله', "value": 'store'},
  ];

  List<Map<String, String>> province = PROVINCES_LIST;

  List<Map<String, String>> typeRegister = [
    {"name": "اجاره", "slug": "forrent"},
    {"name": 'فروش', "slug": 'forsale'},
  ];

  GlobalKey _globleKey = GlobalKey();

  bool _isLoading = false;
  bool _googleMapLoaded = false;
  bool _isUploadingImage = false;
  Property property;

  File _imageFile;
  final List<DropdownMenuItem> items = [];

  int _groupValue = -1;

  final _formKey = GlobalKey<FormState>();

  Future<Map> allFeatureProperty;

  SuggestionsBoxController _sbc = new SuggestionsBoxController();
  var typeAheadController = TextEditingController();
  var locationTextController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool checkboxValueCity = false;
  List<Map> allCities = [];
  bool _addImageToGallary = true;
  List<ImageProperty> gallaryimages = List<ImageProperty>();
  int indexLoadingImage;
  FocusNode passwordFocusNode;

  @override
  void dispose() {
    this.passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    if (widget.propertyEdit != null) {
      property.propertyForm = PropertyForm.edit;

      Property edited = widget.propertyEdit;

      locationTextController.text =
          edited.city != null ? edited.city["term_name"] : "";
      property.city = edited.city != null ? edited.city : null;
      property.types = edited.types;
      property.pricePerfix = edited.pricePerfix;

      property.pcckageType =
          edited.pcckageType != null ? edited.pcckageType : PackageType.normal;

      print(edited.agentDisplayOption);
      property.agentDisplayOption = edited.agentDisplayOption;
      property.otherContactDescription = edited.otherContactDescription;
      property.otherContactMail = edited.otherContactMail;
      property.otherContactName = edited.otherContactName;
      property.otherContactPhone = edited.otherContactPhone;
      property.attribute = edited.attribute;

      property.location = edited.location;

      property.gallary = edited.gallary;
      switch (edited.statusProperty['term_slug']) {
        case "forrent":
          setState(() {
            _groupValue = 0;
            property.statusProperty = {"term_slug": "forrent"};
          });
          break;
        case "forsale":
          setState(() {
            _groupValue = 1;
            property.statusProperty = {"term_slug": "forsale"};
          });
          break;
      }
    } else {
      property.propertyForm = PropertyForm.submit;
      property.types = {'term_slug': "apartment"};
      property.agentDisplayOption = "author_info";
      property.pcckageType = PackageType.normal;
    }
  }

  @override
  void initState() {
    this.passwordFocusNode = FocusNode();
    property = new Property();
    property.attribute = [];
    property.gallary = [];
    getData();
    allFeatureProperty = PropertyProvider().propertyFeature();
    super.initState();
  }

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

  void submitProperty() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });
      try {
        var result = await PropertyProvider().sumbitProperty(property);

        if (result != null) {
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.green,
            content: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  widget.propertyEdit != null
                      ? "موفقانه ملک شما ثبت شده"
                      : "موفقانه ملک شما ایدیت شده",
                  style: TextStyle(fontFamily: "Vazir"),
                ),
                FaIcon(Icons.check)
              ],
            ),
            duration: Duration(seconds: 2),
          ));

          Timer(Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => Dashboard(
                  auth: widget.auth,
                ),
                transitionDuration: Duration.zero,
              ),
            );
          });
        } else {
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
            backgroundColor: Colors.redAccent,
            content: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  "مشکل پیش امده در ثبت ملک تان دوباره چک کنید!",
                  style: TextStyle(fontFamily: "Vazir"),
                ),
                FaIcon(Icons.error)
              ],
            ),
            duration: Duration(seconds: 2),
          ));
        }
      } catch (e) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent,
          content: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                "مشکل پیش امده در ثبت ملک تان دوباره چک کنید!",
                style: TextStyle(fontFamily: "Vazir"),
              ),
              FaIcon(Icons.error)
            ],
          ),
          duration: Duration(seconds: 2),
        ));
      }

      setState(() {
        _isLoading = true;
      });
    }
  }

  Widget keyboardDismisser({BuildContext context, Widget child}) {
    final gesture = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        debugPrint("!!!");
      },
      child: child,
    );
    return gesture;
  }

  Future<List> getSuggestions(String query) async {
    List<Map<String, String>> matches = List();
    matches.addAll(PROVINCES_LIST);

    print(matches);

    matches.retainWhere((s) => s['display'].contains(query));
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    // if (!currentFocus.hasPrimaryFocus) {
    //   currentFocus.
    // }
    // addItem = new Property();
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.propertyEdit == null
              ? "اضافیه کردن ملک جدید"
              : "ویرایش کردن ملک ",
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: allFeatureProperty,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List feature = snapshot.data['term'];
                allCities.clear();
                for (Map item in feature) {
                  allCities.add(item);
                }
                // allCities = feature as List<Map>;

                return SingleChildScrollView(
                  // reverse: true,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Card(
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: Text(
                                  "مشخصات ملک",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 8),
                                title: Text("انتخاب ولایت ملک"),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    // padding: const EdgeInsets.only(
                                    //     bottom: 8.0, left:
                                    // 8, right: 8)
                                    child: TypeAheadFormField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        decoration: InputDecoration(
                                            suffixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: FaIcon(FontAwesomeIcons
                                                  .locationArrow),
                                            ),
                                            border: OutlineInputBorder(),
                                            hintText: 'مکان را بنویسید'),
                                        controller: this.locationTextController,
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return getSuggestions(pattern);
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          dense: true,
                                          title: Text(suggestion['display']),
                                        );
                                      },
                                      hideSuggestionsOnKeyboardHide: true,
                                      transitionBuilder: (context,
                                          suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        setState(() {
                                          locationTextController.text =
                                              suggestion['display'];
                                          // property.city = {
                                          //   'term_slug': suggestion['value']
                                          // };
                                          property.state = {
                                            'term_slug': suggestion['value']
                                          };
                                        });
                                        // this.locationTextController.text = suggestion['value'];
                                      },
                                      validator: (value) => value.isEmpty
                                          ? 'Please select a city'
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //   height:
                              //       MediaQuery.of(context).viewInsets.bottom,
                              // ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'شهر  ملک',
                                    ),
                                    Text("0/100")
                                  ],
                                ),
                              ),
                              MyTextFormField(
                                textEditingController:
                                    widget.propertyEdit != null
                                        ? (TextEditingController()
                                          ..text = widget.propertyEdit.title)
                                        : null,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'شهر ملک را وارد کنید';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  property.city = {
                                    'term_slug': value,
                                    "term_name": value
                                  };
                                },
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'عنوان ملک',
                                    ),
                                    Text("0/100")
                                  ],
                                ),
                              ),
                              MyTextFormField(
                                textEditingController:
                                    widget.propertyEdit != null
                                        ? (TextEditingController()
                                          ..text = widget.propertyEdit.title)
                                        : null,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'عنوان ملک را وارد کنید';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  property.title = value;
                                },
                              ),

                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                title: Text(
                                  "نوع اعلان ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 0,
                                          groupValue: _groupValue,
                                          onChanged: (newValue) => setState(() {
                                            setState(() {
                                              _groupValue = newValue;

                                              property.statusProperty = {
                                                "term_slug": "forrent"
                                              };
                                            });
                                          }),
                                        ),
                                        Text("کرایی"),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: _groupValue,
                                          onChanged: (newValue) => setState(() {
                                            setState(() {
                                              _groupValue = newValue;
                                              property.statusProperty = {
                                                "term_slug": "forsale"
                                              };
                                              //  = "forrent";
                                            });
                                          }),
                                        ),
                                        Text("فروشی"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       bottom: 8.0, left: 8, right: 8),
                              //   child: TypeAheadField(
                              //     loadingBuilder: (BuildContext con) {
                              //       return Row(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.center,
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         children: <Widget>[
                              //           Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             child: CircularProgressIndicator(),
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //     textFieldConfiguration:
                              //         TextFieldConfiguration(
                              //       controller: locationTextController,
                              //       decoration: InputDecoration(
                              //           suffixIcon: Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             child: FaIcon(
                              //                 FontAwesomeIcons.locationArrow),
                              //           ),
                              //           border: OutlineInputBorder(),
                              //           hintText: 'مکان را بنویسید'),
                              //     ),
                              //     suggestionsCallback: (pattern) async {
                              //       if (pattern != "") {
                              //         // return await BackendService
                              //         //     .getSuggestions(pattern);
                              //       }
                              //     },
                              //     itemBuilder: (context, suggestion) {
                              //       return ListTile(
                              //         leading: Icon(Icons.location_on),
                              //         title: Text(suggestion['display']),
                              //         subtitle: Text(suggestion['value']),
                              //       );
                              //     },
                              //     onSuggestionSelected: (suggestion) {
                              //       setState(() {
                              //         locationTextController.text =
                              //             suggestion['display'];
                              //         property.city = {
                              //           'term_slug': suggestion['value']
                              //         };
                              //       });
                              //     },
                              //   ),
                              // ),
                              Divider(),
                              ListTile(
                                contentPadding: const EdgeInsets.only(
                                    top: 8.0, left: 8, right: 8, bottom: 0),
                                title: Text(" آدرس دقیق ملک"),
                              ),
                              MyTextFormField(
                                hintText: 'آدرس',
                                textEditingController:
                                    widget.propertyEdit != null
                                        ? (TextEditingController()
                                          ..text = widget.propertyEdit.address)
                                        : null,
                                validator: (String value) {
                                  if (value.length < 7) {
                                    return 'آدرس تان را وارد کنید';
                                  }
                                  _formKey.currentState.save();
                                  return null;
                                },
                                onSaved: (String value) {
                                  setState(() {
                                    property.address = value;
                                  });
                                },
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.only(
                                    top: 8.0, left: 8, right: 8, bottom: 0),
                                title: Text("انتخاب موقعیت در نقشه "),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  child: FlatButton(
                                    onPressed: () async {
                                      var picklocation =
                                          await goToGoogleMapScreen(
                                              context: context,
                                              location: property.location);

                                      if (picklocation != null) {
                                        setState(() {
                                          property.location = picklocation;
                                          _googleMapLoaded = true;
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "گرفتن موقعیت از نقشه",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(),
                              Row(
                                children: <Widget>[
                                  propertyTypeWidget(),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 8),
                                          title: Text("مساحت ملک"),
                                        ),
                                        MyTextFormField(
                                          hintText: 'مساحت ملک',
                                          textEditingController:
                                              widget.propertyEdit != null
                                                  ? (TextEditingController()
                                                    ..text = widget
                                                        .propertyEdit.area)
                                                  : null,
                                          isNumber: true,
                                          validator: (String value) {
                                            // if (!validator.isNumeric(value)) {
                                            //   return 'مساحت ملک را وارد کنید';
                                            // }
                                            return null;
                                          },
                                          onSaved: (String value) {
                                            setState(() {
                                              property.area = value;
                                              // addItem.area = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 8),
                                          title: Text("قمیت فروش یا اجاره "),
                                        ),
                                        MyTextFormField(
                                          textEditingController:
                                              widget.propertyEdit != null
                                                  ? (TextEditingController()
                                                    ..text = widget
                                                        .propertyEdit.price)
                                                  : null,
                                          hintText: '',
                                          isNumber: true,
                                          validator: (String value) {
                                            // if (!validator.isNumeric(value)) {
                                            //   return 'قمیت فروش یا اجاره را وارد کنید';
                                            // }
                                            return null;
                                          },
                                          onSaved: (String value) {
                                            setState(() {
                                              property.price = value;
                                              // addItem.price = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  propertyTypeMoneyWidget(),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Visibility(
                                      visible: property.types != null &&
                                          property.types['term_slug'] != "land",
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0, horizontal: 8),
                                            title: Text("تعداد اتاق خواب"),
                                          ),
                                          MyTextFormField(
                                            textEditingController:
                                                widget.propertyEdit != null
                                                    ? (TextEditingController()
                                                      ..text = widget
                                                          .propertyEdit
                                                          .bedrooms)
                                                    : null,
                                            hintText: '',
                                            isNumber: true,
                                            validator: (String value) {
                                              // if (!validator.isNumeric(value)) {
                                              //   return 'قمیت فروش یا اجاره را وارد کنید';
                                              // }
                                              return null;
                                            },
                                            onSaved: (String value) {
                                              setState(() {
                                                property.rooms =
                                                    int.parse(value);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Visibility(
                                      visible: property.types != null &&
                                          property.types['term_slug'] != "land",
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0, horizontal: 8),
                                            title: Text("تعداد حمام"),
                                          ),
                                          MyTextFormField(
                                            textEditingController:
                                                widget.propertyEdit != null
                                                    ? (TextEditingController()
                                                      ..text = widget
                                                          .propertyEdit
                                                          .bathrooms)
                                                    : null,
                                            hintText: 'تعداد حمام',
                                            isNumber: true,
                                            validator: (String value) {
                                              return null;
                                            },
                                            onSaved: (String value) {
                                              setState(() {
                                                property.bathrooms = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Visibility(
                                      visible: property.types != null &&
                                          property.types['term_slug'] != "land",
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0, horizontal: 8),
                                            title: Text("سال ساخت"),
                                          ),
                                          MyTextFormField(
                                            textEditingController:
                                                widget.propertyEdit != null
                                                    ? (TextEditingController()
                                                      ..text = widget
                                                          .propertyEdit
                                                          .buildYear)
                                                    : null,
                                            hintText: '',
                                            isNumber: true,
                                            validator: (String value) {
                                              // if (!validator.isNumeric(value)) {
                                              //   return 'قمیت فروش یا اجاره را وارد کنید';
                                              // }
                                              return null;
                                            },
                                            onSaved: (String value) {
                                              setState(() {
                                                property.buildYear = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: Visibility(
                                  //     visible: property.types != null &&
                                  //         property.types['term_slug'] != "land",
                                  //     child: Column(
                                  //       children: <Widget>[
                                  //         ListTile(
                                  //           contentPadding:
                                  //               EdgeInsets.symmetric(
                                  //                   vertical: 0, horizontal: 8),
                                  //           title: Text("تعداد حمام"),
                                  //         ),
                                  //         MyTextFormField(
                                  //           textEditingController:
                                  //               widget.propertyEdit != null
                                  //                   ? (TextEditingController()
                                  //                     ..text = widget
                                  //                         .propertyEdit
                                  //                         .bathrooms)
                                  //                   : null,
                                  //           hintText: 'تعداد حمام',
                                  //           isNumber: true,
                                  //           validator: (String value) {
                                  //             return null;
                                  //           },
                                  //           onSaved: (String value) {
                                  //             setState(() {
                                  //               property.bathrooms = value;
                                  //             });
                                  //           },
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.only(
                                    top: 8.0, left: 8, right: 8, bottom: 0),
                                title: Text("توضیحات ملک"),
                              ),
                              MyTextFormField(
                                textEditingController:
                                    widget.propertyEdit != null
                                        ? (TextEditingController()
                                          ..text = widget.propertyEdit.content)
                                        : null,
                                maxLines: 5,
                                hintText: 'توضيحات ملک',
                                isMultiline: true,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'توضيحات ملک را وارد کنید';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  property.content = value;
                                },
                              ),
                              Divider(),
                              Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 8),
                                          title: Text("امکانات"),
                                        ),
                                      ),
                                      FlatButton(
                                          child: Icon(Icons.add),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return _MyDialog(
                                                      cities: allCities,
                                                      selectedCities:
                                                          property.attribute,
                                                      onSelectedCitiesListChanged:
                                                          (cities) {
                                                        setState(() {
                                                          property.attribute =
                                                              cities;
                                                        });
                                                      });
                                                });
                                          })
                                    ],
                                  ),
                                ],
                              ),
                              property.attribute != null
                                  ? Tags(
                                      itemCount: property.attribute.length,
                                      itemBuilder: (index) {
                                        final item = property.attribute[index];
                                        return ItemTags(
                                          key: Key(index.toString()),
                                          index: index,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          title: item['term_name'],
                                          pressEnabled: false,
                                          singleItem: false,
                                          splashColor: Colors.white,
                                          color: Colors.white10,
                                          combine:
                                              ItemTagsCombine.withTextBefore,
                                          removeButton: ItemTagsRemoveButton(
                                            onRemoved: () {
                                              setState(() {
                                                property.attribute
                                                    .removeAt(index);
                                              });
                                              return true;
                                            },
                                          ),
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox(),
                              Divider(),
                              ListTile(
                                contentPadding: const EdgeInsets.only(
                                    top: 8.0, left: 8, right: 8, bottom: 0),
                                title: Text("انتخاب عکس ها ملک "),
                              ),
                              buildGridView(halfMediaWidth),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  child: FlatButton(
                                    onPressed:
                                        _addImageToGallary ? loadAssets : null,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "انتخاب عکس های دیگر",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Divider(),
                              packagePropertywiget(snapshot.data['package']),
                              Divider(),
                              contactPropertywiget(),
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
                                    // onPressed: _isLoading ? null : submitProperty,
                                    onPressed: submitProperty,
                                    child: submitButton(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Future<void> loadAssets() async {
    String error = 'No Error Dectected';

    try {
      if (gallaryimages.length < 5) {
        File imagesPick = await ImagePicker.pickImage(
          source: ImageSource.gallery,
        );

        imagesPick = await UtilClass().cropImage(imagesPick, context);
        if (imagesPick != null) {
          setState(() {
            if (gallaryimages.length >= 4) {
              _addImageToGallary = false;
            }
            // gallaryimages.add(imagesPick);
          });
        }

        setState(() {
          _isUploadingImage = true;
        });

        // int indexFile = gallaryimages.length;

        PropertyProvider()
            .uploadImage(imagesPick, (int a, int b) {})
            .then((data) {
          if (data != null) {
            ImageProperty image = data;
            setState(() {
              _isUploadingImage = false;
              property.gallary.add(image);
              indexLoadingImage = null;
            });
          }
        });
      }
    } on Exception catch (e) {
      error = e.toString();
    }
  }

  Widget buildGridView(width) {
    return Container(
      child: property.gallary.length >= 0
          ? GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.all(5),
              children: List.generate(property.gallary.length + 1, (index) {
                if (property.gallary.length > index) {
                  ImageProperty fuk = property.gallary[index];
                  return Stack(
                    children: <Widget>[
                      Image.network(
                        fuk.sourceUrl,
                        width: width,
                        height: width,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, size: 30),
                        onPressed: () {
                          setState(() {
                            property.gallary.removeAt(index);
                          });
                        },
                      ),
                      index == indexLoadingImage
                          ? Center(child: CircularProgressIndicator())
                          : Text(""),
                    ],
                  );
                } else {
                  return _isUploadingImage
                      ? Opacity(
                          opacity: 0.8,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Center(
                          child: Text("مکان  اضافه کردن عکس"),
                        );
                }
              }),
            )
          : Center(
              child: Text("هیج تصویر انتخاب نشده"),
            ),
    );
  }

  Future goToGoogleMapScreen({context, LatLng location}) async {
    return await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new MapScreen(
            key: _globleKey,
            initialLocation: location,
          ),
          fullscreenDialog: true,
        ));
  }

  Widget checkbox(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title),
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {},
        )
      ],
    );
  }

  Widget propertyTypeWidget() {
    return Expanded(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            title: Text("نوعیت ملک"),
          ),
          DropDownFormField(
            value: property.types == null
                ? "apartment"
                : property.types['term_slug'],
            onSaved: (value) {
              setState(() {
                property.types = {'term_slug': value};
              });
            },
            onChanged: (value) {
              setState(() {
                property.types = {'term_slug': value};
              });
            },
            dataSource: propertytypes,
            textField: 'display',
            valueField: 'value',
          ),
        ],
      ),
    );
  }

  Widget propertyTypeMoneyWidget() {
    return Expanded(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            title: Text("واحد پولی"),
          ),
          DropDownFormField(
            value: property.pricePerfix,
            onSaved: (value) {
              setState(() {
                property.pricePerfix = value;
              });
            },
            onChanged: (value) {
              setState(() {
                property.pricePerfix = value;
              });
            },
            dataSource: [
              {
                "display": "آفغانی",
                "value": "آفغانی",
              },
              {
                "display": "دالر",
                "value": "دالر",
              },
            ],
            textField: 'display',
            valueField: 'value',
          ),
        ],
      ),
    );
  }

  // Widget _myRadioButton({String title, int value, Function onChanged}) {
  //   return
  // }

  Widget packagePropertywiget(Map package) {
    return package['packageName'] != null
        ? Column(
            children: <Widget>[
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                title: Text("نوعیت بسته ${package['packageName']} "),
              ),
              DropDownFormField(
                value: enumStringToName(property.pcckageType.toString()),
                onSaved: (value) {
                  if (value ==
                      enumStringToName(PackageType.featured.toString())) {
                    setState(() {
                      property.pcckageType = PackageType.featured;
                    });
                  } else if (value ==
                      enumStringToName(PackageType.gold.toString())) {
                    setState(() {
                      property.pcckageType = PackageType.gold;
                    });
                  } else {
                    setState(() {
                      property.pcckageType = PackageType.normal;
                    });
                  }
                },
                onChanged: (value) {
                  property.pcckageType = PackageType.gold;
                  if (value ==
                      enumStringToName(PackageType.featured.toString())) {
                    setState(() {
                      property.pcckageType = PackageType.featured;
                    });
                  } else if (value ==
                      enumStringToName(PackageType.gold.toString())) {
                    setState(() {
                      property.pcckageType = PackageType.gold;
                    });
                  } else {
                    setState(() {
                      property.pcckageType = PackageType.normal;
                    });
                  }
                },
                dataSource: [
                  {
                    "display": " عادی :  تعداد باقی مانده ${package['normal']}",
                    "value": "normal",
                  },
                  {
                    "display":
                        " ویژه :  تعداد باقی مانده ${package['feature']}",
                    "value": "featured",
                  },
                  {
                    "display": " طلایی :  تعداد باقی مانده ${package['gold']}",
                    "value": "gold",
                  },
                ],
                textField: 'display',
                valueField: 'value',
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: RaisedButton(
              color: Colors.redAccent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.warning),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        "شما هیج بسته فعال ندارید برای خرید بسته کلید کنید",
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () {},
            ),
          );
  }

  Widget contactPropertywiget() {
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          title: Text("اطلاعات تماس"),
          subtitle: Text("چه اطلاعات تماسی نمایش داده شود?"),
        ),
        DropDownFormField(
          value: property.agentDisplayOption,
          onSaved: (value) {
            setState(() {
              property.agentDisplayOption = value;
            });
          },
          onChanged: (value) {
            FocusScope.of(context).nextFocus();
            setState(() {
              property.agentDisplayOption = value;
            });
          },
          dataSource: [
            {
              "display": "معلومات پروفایل من",
              "value": "author_info",
            },
            {
              "display": "جزییات تماس دیگر",
              "value": "other_info",
            },
          ],
          textField: 'display',
          valueField: 'value',
        ),
        Visibility(
            visible: property.agentDisplayOption == "other_info",
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.only(
                      top: 8.0, left: 8, right: 8, bottom: 0),
                  title: Text(" نام و تخلص"),
                ),
                MyTextFormField(
                  hintText: 'نام و تخلص',
                  validator: (String value) {
                    if (value.length < 7) {
                      return 'نام و تخلص تان را وارد کنید';
                    }
                    _formKey.currentState.save();
                    return null;
                  },
                  onSaved: (String value) {
                    setState(() {
                      property.otherContactName = value;
                      // addItem.address = value;
                    });
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(
                      top: 8.0, left: 8, right: 8, bottom: 0),
                  title: Text(" شماره تماس "),
                ),
                MyTextFormField(
                  hintText: ' شماره تماس ',
                  validator: (String value) {
                    if (value.length < 7) {
                      return ' شماره تماس  تان را وارد کنید';
                    }
                    _formKey.currentState.save();
                    return null;
                  },
                  onSaved: (String value) {
                    setState(() {
                      property.otherContactPhone = value;
                    });
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(
                      top: 8.0, left: 8, right: 8, bottom: 0),
                  title: Text(" ایمیل "),
                ),
                MyTextFormField(
                  hintText: 'ایمیل',
                  isEmail: true,
                  validator: (String value) {
                    if (value.length < 7) {
                      return 'ایمیل تان را وارد کنید';
                    }
                    _formKey.currentState.save();
                    return null;
                  },
                  onSaved: (String value) {
                    setState(() {
                      property.otherContactMail = value;
                    });
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(
                      top: 8.0, left: 8, right: 8, bottom: 0),
                  title: Text(" درباره خودتان "),
                ),
                MyTextFormField(
                  hintText: 'درباره خودتان',
                  isEmail: true,
                  onSaved: (String value) {
                    setState(() {
                      property.otherContactDescription = value;
                    });
                  },
                ),
              ],
            ))
      ],
    );
  }

  Widget dialogForSearchLocation() {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'امکانات',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),

                    onPressed: () {
                      Navigator.pop(context);
                    },
                    // color: Theme.of(context).primaryColor,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'انجام شد',
                          textDirection: TextDirection.ltr,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.save, color: Theme.of(context).primaryColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final TextEditingController textEditingController;
  final bool isEmail;
  final Function validator;
  final Function onSaved;
  final bool isPassword;
  final bool isNumber;
  final bool isMultiline;
  final bool isRtl;
  final Function onChange;
  MyTextFormField(
      {this.hintText,
      this.validator,
      this.textEditingController = null,
      this.onSaved,
      this.isPassword = false,
      this.isMultiline = false,
      this.isNumber = false,
      this.maxLines = 1,
      this.isEmail = false,
      this.onChange,
      this.isRtl = true});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        maxLines: this.maxLines,
        onChanged: this.onChange,
        // textDirection: isRtl ? TextDirection.rtl:TextDirection.rtl,
        // textAlign:  isRtl ? TextAlign.right :  TextAlign.left,
        controller: this.textEditingController,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          contentPadding: EdgeInsets.all(15.0),
          // border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[100],
        ),
        obscureText: isPassword ? true : false,
        validator: validator,
        onSaved: onSaved,
        enableInteractiveSelection: true,
        keyboardType: isNumber
            ? TextInputType.number
            : isMultiline
                ? TextInputType.multiline
                : this.isEmail
                    ? TextInputType.emailAddress
                    : TextInputType.text,
      ),
    );
  }
}

class DropDownFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function onChanged;
  final bool filled;
  final bool enable;

  DropDownFormField(
      {FormFieldSetter<dynamic> onSaved,
      FormFieldValidator<dynamic> validator,
      bool autovalidate = false,
      this.titleText = 'Title',
      this.hintText = 'Select one option',
      this.required = false,
      this.errorText = 'Please select one option',
      this.value,
      this.dataSource,
      this.textField,
      this.valueField,
      this.onChanged,
      this.enable = true,
      this.filled = true})
      : super(
          onSaved: onSaved,
          validator: validator,
          autovalidate: autovalidate,
          initialValue: value == '' ? null : value,
          builder: (FormFieldState<dynamic> state) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              // padding: EdgeInsets.only(right: 5,left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InputDecorator(
                    decoration: InputDecoration(
                      // hintText: hintText,
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    // decoration: new InputDecoration(
                    //   filled: true,
                    //   fillColor: Colors.white,

                    //   border: new OutlineInputBorder(
                    //     borderRadius: new BorderRadius.circular(12.0),
                    //     borderSide: new BorderSide(),
                    //   ),
                    // ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                        // hint: Text(
                        //   // hintText,
                        //   style: TextStyle(color: Colors.grey.shade500),
                        // ),
                        value: value == '' ? dataSource[0][valueField] : value,
                        onChanged: enable
                            ? (dynamic newValue) {
                                state.didChange(newValue);

                                onChanged(newValue);
                              }
                            : null,

                        items: dataSource.map((item) {
                          return DropdownMenuItem<dynamic>(
                            value: item[valueField],
                            child: Text(item[textField]),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: state.hasError ? 5.0 : 0.0),
                  Text(
                    state.hasError ? state.errorText : '',
                    style: TextStyle(
                        color: Colors.redAccent.shade700,
                        fontSize: state.hasError ? 12.0 : 0.0),
                  ),
                ],
              ),
            );
          },
        );
}

class _MyDialog extends StatefulWidget {
  _MyDialog({
    this.cities,
    this.selectedCities,
    this.onSelectedCitiesListChanged,
  });

  final List<Map> cities;
  final List<Map> selectedCities;
  final ValueChanged<List<Map>> onSelectedCitiesListChanged;

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<_MyDialog> {
  List<Map> _tempSelectedCities = [];

  @override
  void initState() {
    _tempSelectedCities = widget.selectedCities;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      child: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'امکانات',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),

                    onPressed: () {
                      Navigator.pop(context);
                    },
                    // color: Theme.of(context).primaryColor,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'انجام شد',
                          textDirection: TextDirection.ltr,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.save, color: Theme.of(context).primaryColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.cities.length,
                itemBuilder: (BuildContext context, int index) {
                  final cityName = widget.cities[index];
                  return Container(
                    child: CheckboxListTile(
                        title: Text(cityName['term_name']),
                        value: _tempSelectedCities.contains(cityName),
                        onChanged: (bool value) {
                          if (value) {
                            if (!_tempSelectedCities.contains(cityName)) {
                              setState(() {
                                _tempSelectedCities.add(cityName);
                              });
                            }
                          } else {
                            if (_tempSelectedCities.contains(cityName)) {
                              setState(() {
                                _tempSelectedCities.removeWhere(
                                    (Map city) => city == cityName);
                              });
                            }
                          }
                          widget
                              .onSelectedCitiesListChanged(_tempSelectedCities);
                        }),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
