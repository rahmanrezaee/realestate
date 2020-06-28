import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:badam/model/city.dart';
import 'package:badam/model/model.dart';
import 'package:badam/model/property.dart';
import 'package:badam/page/myProperties/map_screen.dart';
import 'package:badam/style/style.dart';
import 'package:badam/util/sharedPreference.dart';
import 'package:badam/util/utiles_functions.dart';
import 'package:flutter/material.dart';
import 'package:badam/util/httpRequest.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:validators/validators.dart' as validator;

class AddPropertise extends StatefulWidget {
  @override
  _AddPropertiseState createState() => _AddPropertiseState();
}

enum AimCharacter { buy, run, graw }
enum TypeCharacter { land, home, unit, office, shop, apartment, vela }

class _AddPropertiseState extends State<AddPropertise> {
  GlobalKey _globleKey = GlobalKey();
  String selectedValue = "";
  bool crop = false;
  bool _isUploadingImage = false;
  bool _isLoading = false;
  String token;
  String featureId;

  LatLng _showMailk;

  Property addItem;
  File _imageFile;
  final List<DropdownMenuItem> items = [];

  AimCharacter _aim = AimCharacter.buy;
  TypeCharacter _typeProperty = TypeCharacter.land;

  final _formKey = GlobalKey<FormState>();
  Model model = Model();

  String username = "";
  String password = "";
  String userId = "";
  String locationSelected = "0,0";

  bool _locationSelected = false;

  Location location;
  LocationData currentLocation;
  PermissionStatus _permissionGranted;

  bool _serviceEnabled;

  Future<void> _checkService() async {
    final bool serviceEnabledResult = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = serviceEnabledResult;
    });
  }

  Future<void> _requestService() async {
    if (_serviceEnabled == null || !_serviceEnabled) {
      final bool serviceRequestedResult = await location.requestService();
      setState(() {
        _serviceEnabled = serviceRequestedResult;
      });
      if (!serviceRequestedResult) {
        return;
      }
    }
  }

  Future<void> _checkPermissions() async {
    final PermissionStatus permissionGrantedResult =
        await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
      if (permissionRequestedResult != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  void initState() {
    CityList.list.forEach((word) {
      items.add(DropdownMenuItem(
        child: Text(word.toString()),
        value: word.toString(),
      ));
    });

    _permissionGranted == PermissionStatus.granted ? null : _requestPermission;
    _serviceEnabled == true ? null : _requestService;

    super.initState();

    location = new Location();
    location.getLocation().then((data) {
      currentLocation = data;
    });
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

  Future getUsername() async {
    try {
      List responses = await Future.wait([
        readPreferenceString("username").then((dataUsername) {
          if (dataUsername != null) {
            this.username = dataUsername;
          }
        }),
        readPreferenceString("password").then((dataPassword) {
          if (dataPassword != null) {
            this.password = dataPassword;
          }
        }),
        readPreferenceString("userId").then((userId) {
          if (userId != null) {
            this.userId = userId;
          }
        })
      ]);

      return Future.value(responses);
    } catch (e) {
      print("error");
    }
  }

  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal Called');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  width: double.infinity,
                  child: Text(
                    'انتخاب تصویر',
                    style: titleMedum(context),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      textColor: flatButtonColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FaIcon(FontAwesomeIcons.camera),
                          Text('از دوربین'),
                        ],
                      ),
                      onPressed: () {
                        _getImage(context, ImageSource.camera);
                      },
                    ),
                    FlatButton(
                      textColor: flatButtonColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FaIcon(FontAwesomeIcons.images),
                          Text('از گالری'),
                        ],
                      ),
                      onPressed: () {
                        _getImage(context, ImageSource.gallery);
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = image;
    });

    Navigator.pop(context);

    if (_imageFile != null) {
      _cropImage(_imageFile).then((data) {
        setState(() {
          _imageFile = data;
        });
      });
    }

    if (_imageFile != null) {
      setState(() {
        _isUploadingImage = true;
      });

      print("username: " + this.username);
      print("username: " + this.password);
      getToken(getPhoneforuser(this.username), this.password).then((value) {
        Map<String, dynamic> tokens = json.decode(value.body);
        token = tokens['token'];

        uploadImageMedia(_imageFile, token).then((data) {
          Map<String, dynamic> d = json.decode(data);

          setState(() {
            _isUploadingImage = false;

            featureId = d['id'].toString();
          });
        });
      });
    }
  }

  Future<File> _cropImage(File file) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
              ]
            : [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'ویرایش عکس پروفایل',
            toolbarColor: Theme.of(context).primaryColor,
            cropFrameColor: Theme.of(context).primaryColor,
            statusBarColor: Theme.of(context).primaryColor,
            activeControlsWidgetColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'ویرایش عکس پروفایل',
        ));
    if (croppedFile != null) {
      return Future.value(croppedFile);
    }
  }

  void submitProperty() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });
      switch (_typeProperty) {
        case TypeCharacter.land:
          addItem.types = 65.toString();
          break;
        case TypeCharacter.home:
          addItem.types = 67.toString();
          break;
        case TypeCharacter.unit:
          addItem.types = 47.toString();
          break;
        case TypeCharacter.office:
          addItem.types = 40.toString();
          break;
        case TypeCharacter.shop:
          addItem.types = 43.toString();
          break;
        case TypeCharacter.apartment:
          addItem.types = 48.toString();
          break;
        case TypeCharacter.vela:
          addItem.types = 46.toString();
          break;
      }
      switch (_aim) {
        case AimCharacter.buy:
          addItem.status = 31.toString();
          break;
        case AimCharacter.run:
          addItem.status = 68.toString();
          break;
        case AimCharacter.graw:
          addItem.status = 30.toString();
          break;
      }
      addItem.cities = CityList.getKeylist(selectedValue).toString();
      addItem.featured = gallaryimagesId;
  
      submitPropertytoServer(token, addItem, featureId,locationSelected).then((data) {
        if (data != null) {
          Alert(
            context: context,
            type: AlertType.success,
            desc: "منتظر باشد تا ملک شما چک شود",
            buttons: [
              DialogButton(
                child: Text(
                  "انجام شود",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                color: Color.fromRGBO(0, 179, 134, 1.0),
                radius: BorderRadius.circular(0.0),
              ),
            ],
            title: "ملک تان ثبت شد",
          ).show();
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Widget _imageProfile() {
    return _imageFile == null
        ? Container(
            height: 150,
          )
        : Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            child: Image.file(
              _imageFile,
              fit: BoxFit.cover,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    addItem = new Property();
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("اضافیه کردن ملک جدید"),
      ),
      body: FutureBuilder(
          future: getUsername(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10.0, right: 10.0),
                              child: GestureDetector(
                                onTap: () => _openImagePickerModal(context),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      _imageProfile(),
                                      Positioned(
                                        child: _isUploadingImage
                                            ? CircularProgressIndicator()
                                            : Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 45,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            MyTextFormField(
                              hintText: 'عنوان ملک',
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'عنوان ملک را وارد کنید';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                addItem.title = value;
                              },
                            ),
                            MyTextFormField(
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
                                addItem.content = value;
                              },
                            ),
                            ListTile(
                              title: Text("هدف"),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('کرایی'),
                                    Radio(
                                      value: AimCharacter.run,
                                      groupValue: _aim,
                                      onChanged: (AimCharacter value) {
                                        setState(() {
                                          _aim = value;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('فروشی'),
                                    Radio(
                                      value: AimCharacter.buy,
                                      groupValue: _aim,
                                      onChanged: (AimCharacter value) {
                                        setState(() {
                                          _aim = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('گروه'),
                                    Radio(
                                      value: AimCharacter.graw,
                                      groupValue: _aim,
                                      onChanged: (AimCharacter value) {
                                        setState(() {
                                          _aim = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ListTile(
                              title: Text("مکان ملک"),
                            ),
                            SearchableDropdown.single(
                              items: items,
                              value: selectedValue,
                              hint: "شهر مورد نظر را انتخاب کنید",
                              searchHint: "لیست شهر ها",
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                              doneButton: "انتخاب",
                              displayItem: (item, selected) {
                                return (Row(children: [
                                  selected
                                      ? Icon(
                                          Icons.radio_button_checked,
                                          color: Colors.grey,
                                        )
                                      : Icon(
                                          Icons.radio_button_unchecked,
                                          color: Colors.grey,
                                        ),
                                  SizedBox(width: 7),
                                  Expanded(
                                    child: item,
                                  ),
                                ]));
                              },
                              isExpanded: true,
                            ),
                            ListTile(
                              title: Text("نوعیت ملک"),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('زمین'),
                                    Radio(
                                      value: TypeCharacter.land,
                                      groupValue: _typeProperty,
                                      onChanged: (TypeCharacter value) {
                                        setState(() {
                                          _typeProperty = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('خانه'),
                                    Radio(
                                      value: TypeCharacter.home,
                                      groupValue: _typeProperty,
                                      onChanged: (TypeCharacter value) {
                                        setState(() {
                                          _typeProperty = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('دفتر'),
                                    Radio(
                                      value: TypeCharacter.office,
                                      groupValue: _typeProperty,
                                      onChanged: (TypeCharacter value) {
                                        setState(() {
                                          _typeProperty = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('دوکان'),
                                    Radio(
                                      value: TypeCharacter.shop,
                                      groupValue: _typeProperty,
                                      onChanged: (TypeCharacter value) {
                                        setState(() {
                                          _typeProperty = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('واحد'),
                                    Radio(
                                      value: TypeCharacter.unit,
                                      groupValue: _typeProperty,
                                      onChanged: (TypeCharacter value) {
                                        setState(() {
                                          _typeProperty = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('اپارتمان'),
                                    Radio(
                                      value: TypeCharacter.apartment,
                                      groupValue: _typeProperty,
                                      onChanged: (TypeCharacter value) {
                                        setState(() {
                                          _typeProperty = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('ویلا'),
                                    Radio(
                                      value: TypeCharacter.vela,
                                      groupValue: _typeProperty,
                                      onChanged: (TypeCharacter value) {
                                        setState(() {
                                          _typeProperty = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            MyTextFormField(
                              hintText: 'قمیت فروش یا اجاره به افغانی',
                              isNumber: true,
                              validator: (String value) {
                                if (!validator.isNumeric(value)) {
                                  return 'قمیت فروش یا اجاره را وارد کنید';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                setState(() {
                                  addItem.price = value;
                                });
                              },
                            ),
                            MyTextFormField(
                              hintText: 'مساحت ملک',
                              isNumber: true,
                              validator: (String value) {
                                if (!validator.isNumeric(value)) {
                                  return 'مساحت ملک را وارد کنید';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                setState(() {
                                  addItem.area = value;
                                });
                              },
                            ),
                            MyTextFormField(
                              hintText: 'آدرس',
                              maxLines: 3,
                              validator: (String value) {
                                if (value.length < 7) {
                                  return 'آدرس تان را وارد کنید';
                                }
                                _formKey.currentState.save();
                                return null;
                              },
                              onSaved: (String value) {
                                setState(() {
                                  addItem.address = value;
                                });
                              },
                            ),
                            Divider(height: 12),
                            _locationSelected
                                ? SizedBox(
                                    width: double.infinity,
                                    height: 200.0,
                                    child: googleMapWidget())
                                : SizedBox(),
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
                                  onPressed: () {
                                    goToSecondScreen(
                                            context,
                                            currentLocation != null
                                                ? LatLng(
                                                    currentLocation.latitude,
                                                    currentLocation.longitude)
                                                : LatLng(34, 65))
                                        .then((data) {
                                      if (data != null) {
                                        print(data);
                                        setState(() {
                                          _showMailk = data;
                                          _locationSelected = true;
                                          locationSelected = 
                                              _showMailk.latitude.toString() + ","+
                                              _showMailk.longitude.toString();
                                        });
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      FaIcon(FontAwesomeIcons.map,
                                          color: Colors.white),
                                      Expanded(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "گرفتن موقعیت از نقشه",
                                            style:
                                                TextStyle(color: Colors.white),
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
                            Divider(height: 12),
                            // FlatButton(
                            //   onPressed: () {},
                            //   child: Text("انتخاب عکس های دیگر"),
                            // ),
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
                                      FaIcon(FontAwesomeIcons.images,
                                          color: Colors.white),
                                      Expanded(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "انتخاب عکس های دیگر",
                                            style:
                                                TextStyle(color: Colors.white),
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
    );
  }

  bool _addImageToGallary = true;
  List<File> gallaryimages = List<File>();
  List gallaryimagesId = List();

  Future<void> loadAssets() async {
    String error = 'No Error Dectected';

    try {
      if (gallaryimages.length < 5) {
        File imagesPick = await ImagePicker.pickImage(
          source: ImageSource.gallery,
        );

        _cropImage(imagesPick).then((data) {
          if (data != null) {
            setState(() {
              if (gallaryimages.length >= 4) {
                _addImageToGallary = false;
              }
              gallaryimages.add(data);
            });
          }
        }).whenComplete(() {
          if (gallaryimages.length > 0) {
            setState(() {
              indexLoadingImage = gallaryimages.length - 1;
            });
            int indexFile = gallaryimages.length;

            uploadImageMedia(gallaryimages[indexFile - 1], token).then((data) {
              if (data != null) {
                Map<String, dynamic> d = json.decode(data);
                setState(() {
                  _isUploadingImage = false;
                  gallaryimagesId.add(d['id']);
                  indexLoadingImage = null;
                });

                print(gallaryimagesId.toString());
              }
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
      height: gallaryimages.length < 3 ? width : width * 2,
      child: gallaryimages.length > 0
          ? GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.all(5),
              children: List.generate(gallaryimages.length, (index) {
                File asset = gallaryimages[index];
                return Stack(
                  children: <Widget>[
                    Image.file(
                      asset,
                      width: width,
                      height: width,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 30),
                      onPressed: () {
                        setState(() {
                          gallaryimages.removeAt(index);
                          gallaryimagesId.removeAt(index);
                        });
                        print(gallaryimagesId.toString());
                      },
                    ),
                    index == indexLoadingImage
                        ? Center(child: CircularProgressIndicator())
                        : Text(""),
                  ],
                );
              }),
            )
          : Center(
              child: Text("هیج تصویر انتخاب نشده"),
            ),
    );
  }

  int indexLoadingImage;
  Widget googleMapWidget() {
    return GoogleMap(
      myLocationButtonEnabled: true,
      buildingsEnabled: true,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: _showMailk != null ? _showMailk : LatLng(34.0, 62.0),
        zoom: 13.0,
      ),
      markers: {
        Marker(
            markerId: MarkerId("id"),
            position: _showMailk != null ? _showMailk : LatLng(34.0, 62.0)),
      },
    );
  }

  Future goToSecondScreen(context, LatLng location) async {
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
}

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final Function validator;
  final Function onSaved;
  final bool isPassword;
  final bool isNumber;
  final bool isMultiline;
  MyTextFormField({
    this.hintText,
    this.validator,
    this.onSaved,
    this.isPassword = false,
    this.isMultiline = false,
    this.isNumber = false,
    this.maxLines = 1,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        maxLines: this.maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
        ),
        obscureText: isPassword ? true : false,
        validator: validator,
        onSaved: onSaved,
        enableInteractiveSelection: true,
        keyboardType: isNumber
            ? TextInputType.number
            : isMultiline ? TextInputType.multiline : TextInputType.text,
      ),
    );
  }
}
