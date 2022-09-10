import 'dart:async';
import 'package:badam/model/Image.dart';
import 'package:badam/model/property.dart';
import 'package:badam/provider/property_provider.dart';
import 'package:badam/util/utiles_functions.dart';
import 'package:flutter/material.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';

class MyListProperties extends StatefulWidget {
  final state;
  MyListProperties(this.state);
  @override
  _MyListPropertiesState createState() => new _MyListPropertiesState();
}

class _MyListPropertiesState extends State<MyListProperties> {
  List<Property> items;
  bool _loadingMore;
  bool _hasMoreItems;
  int _maxItems;
  Future _initialLoad;
  int page = 1;

  Future _loadMoreItems() async {
 
    ++page;
    await PropertyProvider().fetchMyProperty(page, widget.state).then((data) {
      List<Property> temp = data[0];
      items.addAll(temp);
    });
    _hasMoreItems = items.length < _maxItems;
  }

  Widget titleBartext() {
    switch (widget.state) {
      case "publish":
        return Text("منتشر شده ها");

      case "trash":
        return Text("تایید نشده ها");

      case "pending":
        return Text("در دست برسی ها");
    }
  }

  @override
  void initState() {
    super.initState();

    _initialLoad =
        PropertyProvider().fetchMyProperty(page, widget.state).then((data) {
      items = data[0];

      _maxItems = int.parse(data[1][0]);
      _hasMoreItems = true;
      print(_maxItems);
      print(_hasMoreItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleBartext(),
      ),
      body: FutureBuilder(
        future: _initialLoad,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return _maxItems!= null && _maxItems > 0
                  ? IncrementallyLoadingListView(
                      hasMore: () => _hasMoreItems,
                      itemCount: () => items.length,
                      loadMore: () async {
                        print("loading again");
                        await _loadMoreItems();
                      },
                      onLoadMore: () {
                        setState(() {
                          _loadingMore = true;
                        });
                      },
                      onLoadMoreFinished: () {
                        setState(() {
                          _loadingMore = false;
                        });
                      },
                      loadMoreOffsetFromBottom: 2,
                      itemBuilder: (context, index) {
                        Property item = items[index];

                        if ((_loadingMore ?? false) &&
                            index == items.length - 1) {
                          return Column(
                            children: <Widget>[
                              MyItemCard(
                                property: item,
                              ),
                              PlaceholderItemCard(),
                            ],
                          );
                        }
                        return MyItemCard(
                          property: item,
                        );
                      },
                    )
                  : Center(child: Text("هیج ملک پیدا نشد"));
            default:
              return Text('مشکل در گرفتن ملک ها پیدا شده دوباره ');
          }
        },
      ),
    );
  }
}

class MyItemCard extends StatelessWidget {
  Property property;
  MyItemCard({this.property});
  @override
  Widget build(BuildContext context) {
    print(property.address);
    List<ImageProperty> image = property.gallary;

    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed("/singleProperty", arguments: property),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
              child: new Center(
                child: new Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: <Widget>[
                          FadeInImage.assetNetwork(
                            placeholder: "assets/img/placehoder.png",
                            image: image != null && image.length > 0
                                ? image[0].sourceUrl
                                : "",
                            width: (MediaQuery.of(context).size.width / 2) - 30,
                            height: 115,
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.yellow[700],
                              width: 35,
                              height: 20,
                              child: Text(
                                 UtilClass.getTextLabel(property.propertyLabel),
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    new Expanded(
                      child: new Padding(
                        padding: EdgeInsets.all(10.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        "${property.title}",
                                        overflow: TextOverflow.ellipsis,
                                        // set some style to text
                                        style: new TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      new Text(
                                        "${property.types != null ? property.types['term_name'] + " " : ""}${property.statusProperty != null ? property.statusProperty['term_name'] + " " : ""}",
                                        overflow: TextOverflow.ellipsis,
                                        // set some style to text
                                        style: new TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5,),
                                      new Text(
                                        "${property.city != null ? property.city['term_name'] + " " : ""}${property.state != null ? property.state['term_name'] + " " : ""}",
                                        style: new TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                     
                                      SizedBox(height: 5,),
                                    ],
                                  ),
                                ),
                                PopUpMenu((value) {
                                  switch (value) {
                                    case "edit":
                                      Navigator.pushNamed(
                                          context, "/addProperty",
                                          arguments: property);
                                      break;
                                    case "delete":
                                      break;
                                  }
                                }),
                                // IconButton(
                                //     icon: FaIcon(Icons.more_vert),
                                //     onPressed: () => PopUpMenu() )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                property.buildYear != null
                                    ? Text(property.area + " متر")
                                    : SizedBox(),
                                SizedBox(
                                  width: 10,
                                ),
                                property.buildYear != null
                                    ? Text(
                                        "ساخت " + property.buildYear.toString())
                                    : SizedBox(),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            
                                      SizedBox(height: 5,),
                            Text(
                              "امتیاز : ${property.score}"
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
          Divider(),
        ],
      ),
    );
  }
}

class PlaceholderItemCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 60.0,
                    height: 60.0,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                    child: Container(
                      color: Colors.white,
                      child: Text(
                        "item.name",
                        style: TextStyle(color: Colors.transparent),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Container(
                  color: Colors.white,
                  child: Text(
                    "item.message",
                    style: TextStyle(color: Colors.transparent),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemDetailsPage extends StatelessWidget {
  final Item item;
  const ItemDetailsPage(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow,
        appBar: AppBar(
          title: Text(item.name),
        ),
        body: Container(
          child: Text(item.message),
        ));
  }

  Widget MyListPropertiesWidget(List data) {
    return data.length > 0
        ? new ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {
              Map mylist = data[index];

              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/singleProperty',
                    arguments: mylist),
                child: new Card(
                  child: new Container(
                      child: new Center(
                        child: new Row(
                          children: <Widget>[
                            new CircleAvatar(
                              radius: 30.0,
                              child: Hero(
                                tag: mylist['id'],
                                child: FadeInImage.assetNetwork(
                                  placeholder: "assets/img/placehoder.png",
                                  image: mylist["better_featured_image"] != null
                                      ? mylist["better_featured_image"]
                                              ["media_details"]["sizes"]
                                          ["medium"]["source_url"]
                                      : "",
                                  width: 150,
                                  alignment: Alignment.bottomLeft,
                                  fit: BoxFit.fitHeight,
                                  height: 150,
                                ),
                              ),
                              backgroundColor: const Color(0xFF20283e),
                            ),
                            new Expanded(
                              child: new Padding(
                                padding: EdgeInsets.all(10.0),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                      mylist['title']['rendered'],
                                      // set some style to text
                                      style: new TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    new Text(
                                      mylist['property_meta']
                                          ['REAL_HOMES_property_id'][0],
                                      // set some style to text
                                      style: new TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new IconButton(
                                  padding: EdgeInsets.all(3),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: const Color(0xFF167F67),
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    Alert(
                                      context: context,
                                      type: AlertType.warning,
                                      title: "حذف کردن !",
                                      desc: "آیا مطمین استن که ملک را حذف شود.",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "بله",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            // deleteProperty(mylist['id'])
                                            //     .then((data) {
                                            //   // if (data != null) {
                                            //   //   _isLoading = false;
                                            //   //   refreshlist();
                                            //   // }
                                            // });
                                          },
                                          color:
                                              Color.fromRGBO(0, 179, 134, 1.0),
                                        ),
                                        DialogButton(
                                          child: Text(
                                            "نخیر",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: Colors.redAccent,
                                        )
                                      ],
                                    ).show();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
                ),
              );
            })
        : Center(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "assets/img/logo-med.png",
                width: 200,
                color: Colors.grey.withOpacity(0.2),
              ),
              Text(
                "هیج ملک از شما ثبت نیست",
                // style: titleMedum(context),
              ),
            ],
          ));
  }

  // Future deleteProperty(id) {
  //   readPreferenceString("username").then((username) {
  //     readPreferenceString("password").then((password) {
  //       getToken(getPhoneforuser(username), password).then((value) {
  //         Map<String, dynamic> tokens = json.decode(value.body);
  //         String token = tokens['token'];
  //         return Future.value(deletePropertyServer(token, id));
  //       });
  //     });
  //   });
  // }
}

class Item {
  final String name;
  final String avatarUrl = 'http://via.placeholder.com/60x60';
  final String message =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

  Item(this.name);
}

class PopUpMenu extends StatelessWidget {
  var callback;
  PopUpMenu(this.callback);
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Icon(Icons.more_vert),
      onSelected: callback,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'edit',
          child: Text('ویرایش'),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('حذف'),
        ),
      ],
    );
    // <String>(
    //   onSelected: (String value) {

    //   },
    //   child: ListTile(
    //     leading: IconButton(
    //       icon: Icon(Icons.add_alarm),
    //       onPressed: () {
    //         print('Hello world');
    //       },
    //     ),
    //     title: Text('Title'),
    //     subtitle: Column(
    //       children: <Widget>[
    //         Text('Sub title'),

    //       ],
    //     ),
    //     trailing: Icon(Icons.account_circle),
    //   ),
    //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
    //     const PopupMenuItem<String>(
    //       value: 'Value1',
    //       child: Text('Choose value 1'),
    //     ),
    //     const PopupMenuItem<String>(
    //       value: 'Value2',
    //       child: Text('Choose value 2'),
    //     ),
    //     const PopupMenuItem<String>(
    //       value: 'Value3',
    //       child: Text('Choose value 3'),
    //     ),
    //   ],
    // );
  }
}
