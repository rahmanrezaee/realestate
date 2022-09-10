import 'dart:async';
import 'dart:io';
import 'package:badam/page/myProperties/addpropertise.dart';
import 'package:badam/provider/property_provider.dart';
import 'package:badam/util/utiles_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class PaymentIvoice extends StatefulWidget {
  int packageId;

  PaymentIvoice({this.packageId});
  @override
  _PaymentIvoiceState createState() => _PaymentIvoiceState();
}

class _PaymentIvoiceState extends State<PaymentIvoice> {
  Future getInvoiceData;

  @override
  void initState() {
    getInvoiceData = PropertyProvider().getPaymentInvoice(widget.packageId);
    super.initState();
  }

  bool _isUploadingImage = false;
  File imagesPick;
  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("پرداخت بسته"),
      ),
      body: FutureBuilder(
        future: getInvoiceData,
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              Map data = snapshot.data;
              return SingleChildScrollView(
                reverse: true,
                child: _isdoneAll
                    ? Container(
                        height: MediaQuery.of(context).size.height - 50,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("تشکر از فعال سازی بسته",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        height: 1.4,
                                        fontSize: 25)),
                                FaIcon(
                                  FontAwesomeIcons.solidCheckCircle,
                                  color: Colors.green,
                                  size: 25,
                                ),
                              ],
                            ),
                            Text(
                                "خرید شما از طریق ادمین سایت چک شده و درست تصدیق آن بسته شما فعال میگردد.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    height: 1.4,
                                    fontSize: 18)),
                                    SizedBox(height: 30),
                            Text("درحال برکشت به صفحه اصلی....",  style: TextStyle(
                                    color: Colors.grey[500],
                                  
                                    fontSize: 15),)
                          ],
                        ),
                      )
                    : Column(
                        children: <Widget>[
                          (data["package_id"] == data['user_package_id']) &&
                                  data["check_package"] == 1
                              ? Center(
                                  child: Text(
                                      "شما فعلا این پکیج را استفاده میکنید  پگیج دیگری را انتخاب کنید"),
                                )
                              : data['package_price'] > 0
                                  ? Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            "روش پرداخت پول",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        ],
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                          "حساب عزیزی بانک",
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        ),
                                                        trailing: Text(
                                                          "102233141566",
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        ),
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                          "حساب کابل بانک",
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        ),
                                                        trailing: Text(
                                                          "102233141566",
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        ),
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                          "شماره تماس",
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        ),
                                                        trailing: Text(
                                                          "0780088163 , 0780088163",
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Divider(),
                                                          Text(
                                                            "لطفا اول شرایط و مقررات بادام را بخوانید.",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "برای خرید بسته به یکی از حساب های بانکی فوق پول واریز کرده و عکس رسید آن را در فورم زیر درج نمایید.",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: _isSubmitDetail
                                              ? Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    children: <Widget>[
                                                      MyTextFormField(
                                                        hintText: "نام و تخلص",
                                                        textEditingController:
                                                            name,
                                                        validator:
                                                            (String value) {
                                                          if (value.isEmpty) {
                                                            return 'تخلص تان را وارد کنید';
                                                          }
                                                          return null;
                                                        },
                                                        // onChange: (value) {
                                                        //   name.text = value;
                                                        // },
                                                        onSaved:
                                                            (String value) {
                                                          name.text = value;
                                                        },
                                                      ),
                                                      MyTextFormField(
                                                        hintText: "شماره تلفون",
                                                        isNumber: true,
                                                        textEditingController:
                                                            phone,
                                                        validator:
                                                            (String value) {
                                                          if (value.isEmpty) {
                                                            return 'شماره تلفون تان را وارد کنید';
                                                          }
                                                          return null;
                                                        },
                                                        // onChange: (value) {
                                                        //   phone.text = value;
                                                        // },
                                                        onSaved:
                                                            (String value) {
                                                          phone.text = value;
                                                        },
                                                      ),
                                                      DottedBorder(
                                                        borderType:
                                                            BorderType.RRect,
                                                        strokeWidth: 2,
                                                        dashPattern: [
                                                          6,
                                                          6,
                                                          6,
                                                          6
                                                        ],
                                                        radius:
                                                            Radius.circular(15),
                                                        padding:
                                                            EdgeInsets.all(6),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          1)),
                                                          child: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                6,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.5,
                                                            decoration:
                                                                BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                              style: BorderStyle
                                                                  .none,
                                                            )),
                                                            child: imagesPick ==
                                                                    null
                                                                ? IconButton(
                                                                    icon:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Icon(Icons
                                                                            .add_a_photo),
                                                                        Text(
                                                                            "عکس رسید بانکی")
                                                                      ],
                                                                    ),
                                                                    onPressed:
                                                                        pickImage)
                                                                : Stack(
                                                                    fit: StackFit
                                                                        .expand,
                                                                    children: <
                                                                        Widget>[
                                                                      Image
                                                                          .file(
                                                                        imagesPick,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      IconButton(
                                                                        icon: Icon(
                                                                            Icons
                                                                                .delete,
                                                                            size:
                                                                                30),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            imagesPick =
                                                                                null;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 200,
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  30),
                                                            ),
                                                          ),
                                                          child: FlatButton(
                                                            // onPressed: _isLoading ? null : submitProperty,
                                                            onPressed:
                                                                _isUploadingImage
                                                                    ? null
                                                                    : submitDetailImage,
                                                            child: pickButton(),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  width: 200,
                                                  padding: EdgeInsets.all(10),
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(30),
                                                      ),
                                                    ),
                                                    child: FlatButton(
                                                      // onPressed: _isLoading ? null : submitProperty,
                                                      onPressed:
                                                          _isUploadingImage
                                                              ? null
                                                              : buyPackage,
                                                      child: _isUploadingImage
                                                          ? Container(
                                                              width: 20,
                                                              height: 20,
                                                              child: CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white))
                                                          : Text("انجام شد",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      16)),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              100,
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      child: data["user_free_package"] == "yes"
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                  Text(
                                                      " شما قبلا از این پکیج رایگان استفاده نمودید لطفا بسته دیگر انتخاب کنید تشکر.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          height: 1.4,
                                                          fontSize: 18)),
                                                ])
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                    "بسته رایگان می یاشد .\n شما نیاز به هیچ گونه پرداخت نمیباشد.",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18)),
                                                Container(
                                                  width: 200,
                                                  padding: EdgeInsets.all(10),
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(30),
                                                      ),
                                                    ),
                                                    child: FlatButton(
                                                      // onPressed: _isLoading ? null : submitProperty,
                                                      onPressed:
                                                          _isUploadingImage
                                                              ? null
                                                              : buyPackage,
                                                      child: _isUploadingImage
                                                          ? Container(
                                                              width: 20,
                                                              height: 20,
                                                              child: CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white))
                                                          : Text("انجام شد",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      16)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                        ],
                      ),
              );
            default:
              return Text('مشکل در گرفتن ملک ها پیدا شده دوباره ');
          }
        },
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  Future submitDetailImage() async {
    if (_formKey.currentState.validate() && imagesPick != null) {
      _formKey.currentState.save();
      setState(() {
        _isUploadingImage = true;
      });

      PropertyProvider()
          .sumbitDetailPayment(imagesPick, name.text, phone.text)
          .then((data) {
        // if (data['status'] != "mail_failed") {
          setState(() {
            _isSubmitDetail = false;
          });

        
        
        // } else {
        //   _scaffoldKey.currentState.showSnackBar(new SnackBar(
        //     backgroundColor: Colors.redAccent,
        //     content: Row(
        //       mainAxisSize: MainAxisSize.max,
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: <Widget>[
        //         new Text(
        //           data['message'],
        //           style: TextStyle(fontFamily: "Vazir"),
        //         ),
        //         FaIcon(Icons.error)
        //       ],
        //     ),
        //     duration: Duration(seconds: 2),
        //   ));
        // }
        setState(() {
          _isUploadingImage = false;
        });
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.redAccent,
        content: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              "جزییات کامل نیست",
              style: TextStyle(fontFamily: "Vazir"),
            ),
            FaIcon(Icons.error)
          ],
        ),
        duration: Duration(seconds: 2),
      ));
    }
  }

  bool _isdoneAll = false;

  Future buyPackage() async {
    setState(() {
      _isUploadingImage = true;
    });

    PropertyProvider().addPackageUser(widget.packageId).then((data) {
      setState(() {
        _isUploadingImage = false;
      });

      if (data["message"] == "done") {
        setState(() {
          _isdoneAll = true;
        });

        Timer(Duration(seconds: 2), () {
          Navigator.of(context).pushReplacementNamed("/");
        });
      }
    });
  }

  bool _isSubmitDetail = true;

  Widget pickButton() {
    return _isUploadingImage
        ? Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(backgroundColor: Colors.white))
        : Text(
            "ارسال جزییات",
            style: TextStyle(color: Colors.white, fontSize: 16),
          );
  }

  Future pickImage() async {
    imagesPick = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    imagesPick = await UtilClass().cropImage(imagesPick, context);
    setState(() {});
  }
}
