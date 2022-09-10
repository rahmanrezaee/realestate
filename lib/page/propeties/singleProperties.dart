import 'package:badam/model/property.dart';
import 'package:badam/modul/html_converter.dart';
import 'package:badam/page/propeties/showOnMap.dart';
import 'package:badam/provider/auth_provider.dart';
import 'package:badam/style/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleProperties extends StatefulWidget {
  Property mylist;

  SingleProperties({this.mylist});

  @override
  _SinglePropertiesState createState() => _SinglePropertiesState();
}

class _SinglePropertiesState extends State<SingleProperties> {
  int _currentSlider = 0;
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    print("is null " + widget.mylist.agentName);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.mylist.propertyId.toString()),
        actions: <Widget>[
          IconButton(
              icon: widget.mylist.isFavorite
                  ? FaIcon(FontAwesomeIcons.solidHeart)
                  : FaIcon(FontAwesomeIcons.heart),
              onPressed: () {
                setState(
                    () => widget.mylist.isFavorite = !widget.mylist.isFavorite);

                Auth().addToFavorite(widget.mylist.id).then((data) {
                  if (!data) {
                    setState(() =>
                        widget.mylist.isFavorite = !widget.mylist.isFavorite);
                  }
                });
              }),
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                final RenderBox box = context.findRenderObject();
                Share.share("pro['link']",
                    subject: "pro['title']['rendered']",
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Carousel(
                images: widget.mylist.gallary
                    .map((m) => GestureDetector(
                          onTap: () {
                            int index = 0;
                            int selectindex = 0;
                            widget.mylist.gallary.map((f) {
                              m.id == f.id ? selectindex = index : index++;
                            }).toList();

                            Navigator.pushNamed(context, "/ImageViewPage",
                                arguments: {
                                  "images": widget.mylist.gallary,
                                  "selected": selectindex,
                                });
                          },
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/img/placehoder.png",
                            image: m.sourceUrl,
                            fit: BoxFit.fitHeight,
                          ),
                        ))
                    .toList(),
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotColor: Theme.of(context).accentColor,
                indicatorBgPadding: 5.0,
                dotBgColor: Theme.of(context).primaryColor.withOpacity(0.4),
                borderRadius: true,
                moveIndicatorFromBottom: 180.0,
                noRadiusForIndicator: true,
              ),
            ),
            Container(
              child: Column(children: <Widget>[
                Card(
                  elevation: 5,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, right: 10, left: 10),
                                    child: Text(
                                      widget.mylist.title,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 3, right: 10, left: 10),
                                    child: Text(
                                      "${widget.mylist.pricePerfix != '' ? widget.mylist.pricePerfix : "تماس بگیرید"}" +
                                          "${widget.mylist.pricePerfix != null ? widget.mylist.pricePerfix : ""}",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 15, right: 15, top: 5, bottom: 5),
                          color: Colors.grey.withOpacity(0.3),
                          height: 1.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: getHtmlFile(widget.mylist.content),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, right: 8),
                              child: Text(
                                "مشخصات ملک",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // cityWidget('${widget.mylist.city} ${widget.mylist.statusProperty}' ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "کد ملک:",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  " ${widget.mylist.propertyId}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "نوع ملک",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  " ${widget.mylist.types['term_name']}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Visibility(
                          visible: widget.mylist.bathrooms != "",
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "اتاق خواب:",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    " ${widget.mylist.bathrooms}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.mylist.bedrooms != "",
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "تعداد حمام:",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    " ${widget.mylist.bedrooms}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "متراژ",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  " ${widget.mylist.area} ${widget.mylist.areaPrefix}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mylist.buildYear != "",
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "سال ساخت",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    " ${widget.mylist.buildYear}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "شهر",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  " ${widget.mylist.state != null ? widget.mylist.state['term_name'] : 'نامعلوم'}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "منطقه",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  " ${widget.mylist.city['term_name']}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "آدرس دقیق",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  " ${widget.mylist.address}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Visibility(
                          visible: widget.mylist.attribute.length > 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, right: 15),
                                child: Text(
                                  "امکانات ملک",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        attrWidget(widget.mylist.attribute),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            child: FlatButton(
                              onPressed: () {
                                print(widget.mylist.location.latitude);
                                LatLng currentLocation =
                                    (widget.mylist.location);
                                goToSecondScreen(
                                    context,
                                    currentLocation != null
                                        ? LatLng(currentLocation.latitude,
                                            currentLocation.longitude)
                                        : LatLng(34, 65));
                              },
                              child: Row(
                                children: <Widget>[
                                  FaIcon(FontAwesomeIcons.map,
                                      color: Colors.white),
                                  Expanded(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        " موقعیت در نقشه",
                                        style: TextStyle(color: Colors.white),
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
                        Visibility(
                          visible: widget.mylist.agentName != "",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, right: 15),
                                child: Text(
                                  "ارتباط با صاحب ملک",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.mylist.agentName != null,
                          child: Column(children: <Widget>[
                            Container(
                              height: 105,
                              width: 105,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(52.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      spreadRadius: 2,
                                    )
                                  ]),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                radius: 50,
                                child: widget.mylist.prfileUri != ""
                                    ? widget.mylist.prfileUri
                                    : FaIcon(
                                        FontAwesomeIcons.userAlt,
                                        size: 33,
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: widget.mylist.agentName != "",
                              child: Text(
                                widget.mylist.agentName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Visibility(
                              visible: widget.mylist.phone != "",
                              child: Text(
                                widget.mylist.phone,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Visibility(
                              visible: widget.mylist.email != "",
                              child: Text(
                                widget.mylist.email,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Visibility(
                              visible: widget.mylist.agentDescription != "",
                              child: Text(
                                widget.mylist.agentDescription,
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Card(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Row(
            children: <Widget>[
              Visibility(
                visible: widget.mylist.otherContactPhone != null,
                child: Expanded(
                  child: FlatButton(
                    onPressed: () {
                      _launchURL("tel:${widget.mylist.otherContactPhone}");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.phone,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "تماس",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.mylist.otherContactPhone != null,
                child: Expanded(
                  child: FlatButton(
                    onPressed: () {
                      _launchURL("sms: ${widget.mylist.otherContactPhone}");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.facebookMessenger,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "ارسال پیام",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.mylist.otherContactMail != null,
                child: Expanded(
                  child: FlatButton(
                    onPressed: () {
                      _launchURL('mailto:${widget.mylist.otherContactMail}');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.envelope,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "ارسال ایمیل",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget attrWidget(data) {
    List<Map> dataIn = data;

    return Column(
      children: <Widget>[
        Container(
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: dataIn.length,
              itemBuilder: (BuildContext context, int index) {
                Map ite = dataIn[index];

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(ite["term_name"]),
                      Icon(Icons.check, color: Colors.green, size: 25),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget statusWidget(pro) {
    List dataIn = pro;
    return Column(
      children: <Widget>[
        Container(
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: dataIn.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(dataIn[index]),
                      Icon(Icons.home, size: 25),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget cityWidget(pro) {
    String dataIn = pro;
    return Column(
      children: <Widget>[
        textMedim("موقعیت", context),
        Container(
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: dataIn.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(dataIn[index]),
                      Icon(Icons.location_city, size: 25),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  LatLng getCurrentLocation(String location) {
    List d = location.split(",");

    return LatLng(double.parse(d[0]), double.parse(d[1]));
  }

  Future goToSecondScreen(context, LatLng location) async {
    return await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new ShowLocation(
            initialLocation: location,
          ),
          fullscreenDialog: true,
        ));
  }
}
