import 'package:badam/modul/loaderProperties.dart';
import 'package:badam/style/style.dart';
import 'package:badam/util/httpRequest.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

class PropertiesList extends StatefulWidget {
  String type;
  PropertiesList({this.type = ""});
  @override
  _PropertiesListState createState() => _PropertiesListState(typeIn: this.type);
}

class _PropertiesListState extends State<PropertiesList> {
  String typeIn;

  _PropertiesListState({this.typeIn});

  int paginate = 1;
  String getPara() {
    if (typeIn != null && typeIn != "") {
      return typeIn + "&per_page=5&page=" + paginate.toString();
    } else {
      return "?per_page=5&page=" + paginate.toString();
    }
  }

  bool _isLoading = false;

  List listdata = new List();

  Future<bool> _loadMore() async {
    if (_isLoading == false) {
      _isLoading = true;
      paginate++;
      getListPropertiesHttp(getPara()).then((datain) {
        print(getPara());
        setState(() {
          listdata.addAll(datain);
          _isLoading = false;
        });
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: getListPropertiesHttp(
            getPara()), // you should put here your method that call your web service
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            listdata.addAll(snapshot.data);

            if (snapshot.data.length > 0) {
              return LoadMore(
                onLoadMore: _loadMore,
                child: ListView.builder(
                  // shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: listdata.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map wp = listdata[index];

                    return GestureDetector(
                      onTap: () {
                        print(wp['id']);
                        Navigator.pushNamed(context, '/singleProperty',
                            arguments: wp);
                      },
                      child: Container(
                        width: double.infinity,
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Hero(
                                    tag: wp['id'],
                                    child: FadeInImage.assetNetwork(
                                      placeholder: "assets/img/placehoder.png",
                                      image: wp["better_featured_image"]
                                                  ["source_url"] !=
                                              null
                                          ? wp["better_featured_image"]
                                              ["source_url"]
                                          : null,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      height: 150,
                                    ),
                                  ),
                                  Positioned(
                                    left: 10,
                                    bottom: 10,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          wp["property_meta"][
                                                      "REAL_HOMES_property_price"]
                                                  [0] +
                                              " افغانی",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                  Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: IconButton(
                                        icon: Icon(Icons.favorite),
                                        onPressed: () => {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8, right: 8),
                                    child: Text(
                                      wp["title"]["rendered"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 3, right: 8),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                        size: 19,
                                      ),
                                      Text(
                                        "Herat Afghanistan",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey),
                                      ),
                                    ]),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 5),
                                height: 1,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.border_all,
                                          color: Colors.black87,
                                        ),
                                        Text(
                                          "4 Bet",
                                          style:
                                              TextStyle(color: Colors.black87),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.border_all,
                                          color: Colors.black87,
                                        ),
                                        Text(
                                          "4 Bet",
                                          style:
                                              TextStyle(color: Colors.black87),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.border_all,
                                          color: Colors.black87,
                                        ),
                                        Text(
                                          "4 Bet",
                                          style:
                                              TextStyle(color: Colors.black87),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    "assets/img/logo-med.png",
                    width: 200,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  Text(
                    "هیج ملک ثبت نیست",
                    style: titleMedum(context),
                  ),
                ],
              ));
            }
          }
          return loaderProperties();
        },
      ),
    );
  }
}
