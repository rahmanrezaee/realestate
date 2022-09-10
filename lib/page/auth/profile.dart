import 'dart:async';
import 'package:badam/model/Image.dart';
import 'package:badam/page/LoadingPage.dart';
import 'package:badam/page/myProperties/addpropertise.dart';
import 'package:badam/provider/auth_provider.dart';
import 'package:badam/provider/property_provider.dart';
import 'package:badam/style/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  File _imageFile;
  bool _isUploadingImage = false;
  var fullName = TextEditingController();
  var agencyName = TextEditingController();
  var agencyAddress = TextEditingController();
  var idCard = TextEditingController();
  var lysinceId = TextEditingController();
  var fullname = TextEditingController();
  var email = TextEditingController();
  String userType = "normal";
  ImageProperty prof = null;
  bool _isLoading = false;

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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(
      source: source,
      imageQuality: 85,
    );

    setState(() {
      _imageFile = image;
    });

    Navigator.pop(context);

    if (_imageFile != null) {
      await _cropImage();
    }

    setState(() {
      _isUploadingImage = true;
    });
    prof = await PropertyProvider().uploadImage(
      _imageFile,
      (int sent, int total) {
        final progress = sent / total;
        print('progress: $progress ($sent/$total)');
      },
    );
    setState(() {
      _isUploadingImage = false;
    });
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
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
      setState(() {
        _imageFile = croppedFile;
      });
    }
  }

  void _startUploading() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      var result = await Auth().updateUser(
          email: email.text,
          fullname: fullName.text,
          registerType: userType,
          agencyAddress: agencyAddress.text,
          agencyName: agencyName.text,
          idCard: idCard.text,
          lyciseId: lysinceId.text,
          profileId: prof != null ? prof.id : null);
      
      if (!result['success']) {
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
            backgroundColor: Colors.redAccent,
            content: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  "انترنت تان را چک کنید",
                  style: TextStyle(fontFamily: "Vazir"),
                ),
              ],
            ),
          ),
        );
        return null;
      } else {
        setState(() {
          _isLoading = false;
        });
      }
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

  Widget _ImageProfile(profileUrl) {
    return _imageFile == null
        ? profileUrl == ""
            ? Text(
                "",
                // displayName.substring(0, 1) + displayLast.substring(1, 2),
                style: TextStyle(fontSize: 30),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FadeInImage.assetNetwork(
                    placeholder: "",
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                    height: 150.0,
                    width: 150,
                    image: (profileUrl)))
        : ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.file(
              _imageFile,
              fit: BoxFit.cover,
              height: 150.0,
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('تنظیمات پروفایل'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Auth().infoMe(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            userType = snapshot.data['userType'];
            String author_picture_src = snapshot.data['author_picture_src'];

            fullName.text = snapshot.data['nickname'];
            agencyName.text = snapshot.data['author_company'];
            email.text = snapshot.data['email'];
            idCard.text = snapshot.data['idCard'];
            lysinceId.text = snapshot.data['lysinceId'];
            agencyAddress.text = snapshot.data['agencyAddress'];

            return SingleChildScrollView(
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
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            child: GestureDetector(
                              onTap: () => !_isUploadingImage
                                  ? _openImagePickerModal(context)
                                  : null,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    _ImageProfile(author_picture_src),
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
                          userType == "agency" || userType == "agent"
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
                          userType == "agency"
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
                          userType == "agency"
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
                          userType == "agency"
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
                                onPressed: _startUploading,
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
            );
          } else {
            return LoadingPage();
          }
        },
      ),
    );
  }
}

//   return SingleChildScrollView(
//     child: Form(
//       key: _formKey,
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Card(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Padding(

//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20),
//                   child: TextFormField(
//                       textDirection: TextDirection.rtl,
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'نام تان را وارد کنید';
//                         }
//                         return null;
//                       },

//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         labelText: 'نام تان را وارد کنید ',
//                       ),
//                       obscureText: false),
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 20),
//                   child: TextFormField(
//                       textDirection: TextDirection.rtl,

//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'تخلص تان را وارد کنید';
//                         }
//                         return null;
//                       },

//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         labelText: 'تخلص تان را وارد کنید ',
//                       ),
//                       obscureText: false),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   width: 200,
//                   padding: EdgeInsets.all(10),
//                   child: DecoratedBox(
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).primaryColor,
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(30),
//                       ),
//                     ),
//                     child: FlatButton(
//                       onPressed: () {
//                         _startUploading();
//                       },
//                       child: submitButton(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// } else {
//   return Center(child: CircularProgressIndicator());
