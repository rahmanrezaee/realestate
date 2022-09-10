

import 'package:badam/apiReqeust/constants.dart';
import 'package:badam/model/Image.dart';
import 'package:badam/model/property.dart';
import 'package:badam/modul/SearchDialog.dart';

import 'package:badam/page/myProperties/myListProperties.dart';
import 'package:badam/provider/auth_provider.dart';
import 'package:badam/provider/property_provider.dart';
import 'package:badam/util/feature_property.dart';
import 'package:badam/util/utiles_functions.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:jiffy/jiffy.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  int page = 1;
  int totalProperties = 1;
  String taxt_label = "برای خرید";

  // ScrollController _sc = new ScrollController();
  // bool isLoading = false;

  static PostSortMetaBy meta = PostSortMetaBy.real_estate_property_price;
  StatusProperty status = StatusProperty.forsale;
  Map filterdSearch;

  String _selectedView = enumStringToName(meta.toString());

  List<Property> items;

  bool _loadingMore;
  bool _hasMoreItems;
  int _maxItems;
  Future _initialLoad;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();

    initLoad();
  }

  Future<void> initLoad() async {
    await Jiffy.locale("ar");
    _initialLoad = PropertyProvider()
        .fetchPosts(
            postParams: PropertyProvider().getParms(
      index: page,
      meta: meta,
      status: status,
      stateProperty:
          filterdSearch != null ? filterdSearch["place"]['term_slug'] : null,
      cityProperty: filterdSearch != null ? filterdSearch["city"] : null,
      lowerPrice:
          filterdSearch != null ? filterdSearch["price"]['lower'] : null,
      lowerSize: filterdSearch != null ? filterdSearch["size"]['upper'] : null,
      typesProperty: filterdSearch != null
          ? filterdSearch["type"] == null
              ? null
              : filterdSearch["type"]['slug']
          : null,
      upperPrice:
          filterdSearch != null ? filterdSearch["price"]['upper'] : null,
      upperSize: filterdSearch != null ? filterdSearch["size"]['lower'] : null,
    ))
        .then((data) {
      items = data[0];

      _maxItems = int.parse(data[1][0]);
      _hasMoreItems = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: FlatButton(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.arrow_drop_down),
                Text(
                  taxt_label,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            onPressed: () async {
              var statusResponse = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeatureProperty()),
              );
              if (statusResponse != "close") {
                setState(() {
                  status = statusResponse;
                  if (status == StatusProperty.forrent) {
                    taxt_label = "برای کرایه";
                  } else if (status == StatusProperty.forsale) {
                    taxt_label = "برای خرید";
                  } else if (status == StatusProperty.forexchange) {
                    taxt_label = "برای معاوضه";
                  } else if (status == StatusProperty.formortage) {
                    taxt_label = "برای رهن";
                  }

                  items.clear();
                  page = 1;
                  initLoad();
                });
              }
            },
          ),
          //  Navigator.pushNamed(widget.ctx, "/")),
        ),
        body: _buildList());
  }

  Future _loadMoreItems() async {
    ++page;
    await PropertyProvider()
        .fetchPosts(
            postParams: PropertyProvider().getParms(
      index: page,
      meta: meta,
      status: status,
      stateProperty:
          filterdSearch != null ? filterdSearch["place"]['term_slug'] : null,
      cityProperty: filterdSearch != null ? filterdSearch["city"] : null,
      lowerPrice:
          filterdSearch != null ? filterdSearch["price"]['lower'] : null,
      lowerSize: filterdSearch != null ? filterdSearch["size"]['upper'] : null,
      typesProperty: filterdSearch != null
          ? filterdSearch["type"] == null
              ? null
              : filterdSearch["type"]['slug']
          : null,
      upperPrice:
          filterdSearch != null ? filterdSearch["price"]['upper'] : null,
      upperSize: filterdSearch != null ? filterdSearch["size"]['lower'] : null,
    ))
        .then((data) {
      List<Property> temp = data[0];
      items.addAll(temp);
    });
    _hasMoreItems = items.length < _maxItems;
  }

  Widget _buildList() {
    return FutureBuilder(
      future: _initialLoad,
      builder: (context, snapshot) {
        return Column(
          children: <Widget>[
            new Card(
              elevation: 5,
              child: new ListTile(
                  contentPadding:
                      EdgeInsets.only(top: 0, left: 0, right: 10, bottom: 0),
                  onTap: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => FiltersScreen(this.filterdSearch)),
                    );
                    print(result);
                    if (result != null) {
                      setState(() {
                        filterdSearch = result;
                        items.clear();
                        page = 1;
                        initLoad();
                      });
                    }
                  },
                  leading: const Icon(Icons.search),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        'جستجو ولایت ، شهر ، محل ...',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )),
                    ],
                  ),
                  trailing: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.filter_list),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "فلتر",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  (snapshot.connectionState) == ConnectionState.done
                      ? Text("${_maxItems}  ملک",
                          style: TextStyle(fontSize: 20))
                      : Text("صبر کنید", style: TextStyle(fontSize: 20)),
                  new PopupMenuButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.filter_list),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "دسته بندی",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    onSelected: (value) {
                      setState(() {
                        if (value ==
                            enumStringToName(PostSortMetaBy
                                .real_estate_property_price
                                .toString())) {
                          meta = PostSortMetaBy.real_estate_property_price;
                        } else if (value ==
                            enumStringToName(PostSortMetaBy
                                .real_estate_property_land
                                .toString())) {
                          meta = PostSortMetaBy.real_estate_property_land;
                        }

                        setState(() {
                          items.clear();
                          page = 1;
                          initLoad();
                          
                        _selectedView = value;
                        });
                      });
                    },
                    itemBuilder: (_) => [
                      new CheckedPopupMenuItem(
                        checked: _selectedView ==
                            enumStringToName(PostSortMetaBy
                                .real_estate_property_price
                                .toString()),
                        value: enumStringToName(PostSortMetaBy
                            .real_estate_property_price
                            .toString()),
                        child: new Text('گران ترین'),
                      ),
                      new CheckedPopupMenuItem(
                        checked: _selectedView ==
                            enumStringToName(PostSortMetaBy
                                .real_estate_property_land
                                .toString()),
                        value: enumStringToName(PostSortMetaBy
                            .real_estate_property_land
                            .toString()),
                        child: new Text('پیشترین مساحت'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            (snapshot.connectionState) == ConnectionState.done
                ? items != null
                    ? Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              items.clear();
                              page = 1;
                              initLoad();
                            });
                          },
                          child: IncrementallyLoadingListView(
                            hasMore: () => _hasMoreItems,
                            itemCount: () => items.length,
                            loadMore: () async {
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
                                    ItemProperty(
                                        property: item,
                                        favoriteFunction: () {
                                          setState(() =>
                                              items[index].isFavorite =
                                                  !items[index].isFavorite);
                                          Auth()
                                              .addToFavorite(item.id)
                                              .then((data) {
                                            print(data);
                                            if (!data) {
                                              setState(() =>
                                                  items[index].isFavorite =
                                                      !items[index].isFavorite);
                                            }
                                          });
                                        }),
                                    PlaceholderItemCard(),
                                  ],
                                );
                              }
                              return ItemProperty(
                                  property: item,
                                  favoriteFunction: () {
                                    setState(() => items[index].isFavorite =
                                        !items[index].isFavorite);
                                    Auth().addToFavorite(item.id).then((data) {
                                      print(data);
                                      if (!data) {
                                        setState(() => items[index].isFavorite =
                                            !items[index].isFavorite);
                                      }
                                    });
                                  });
                            },
                          ),
                        ),
                      )
                    : Center(
                        child: Column(
                        children: <Widget>[
                          Text("مشکل پیش امده "),
                          FlatButton(
                            onPressed: initLoad,
                            child: Icon(Icons.replay),
                          ),
                        ],
                      ))
                : Center(child: CircularProgressIndicator())
          ],
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }
}

class ItemProperty extends StatelessWidget {
  Property property;
  VoidCallback favoriteFunction;
  ItemProperty({this.property, this.favoriteFunction});
  @override
  Widget build(BuildContext context) {
    List<ImageProperty> image = property.gallary;

    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed("/singleProperty", arguments: property),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
              margin: EdgeInsets.only(top: 10),
              child: new Center(
                child: new Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: (MediaQuery.of(context).size.width / 2) - 30,
                            height: 115,
                            child: Carousel(
                              boxFit: BoxFit.cover,
                              images: property.gallary
                                  .map((m) => GestureDetector(
                                        onTap: () {
                                          int index = 0;
                                          int selectindex = 0;
                                          property.gallary.map((f) {
                                            m.id == f.id
                                                ? selectindex = index
                                                : index++;
                                          }).toList();

                                          Navigator.pushNamed(
                                              context, "/ImageViewPage",
                                              arguments: {
                                                "images": property.gallary,
                                                "selected": selectindex,
                                              });
                                        },
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              "assets/img/placehoder.png",
                                          image: m.sourceUrl,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ))
                                  .toList(),
                              dotSize: 2.0,
                              dotSpacing: 5.0,
                              autoplay: false,
                              dotColor: Theme.of(context).accentColor,
                              indicatorBgPadding: 5.0,
                              dotBgColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.4),
                              borderRadius: true,
                              moveIndicatorFromBottom: 180.0,
                              noRadiusForIndicator: true,
                            ),
                          ),
                          // FadeInImage.assetNetwork(
                          //   placeholder: "assets/img/placehoder.png",
                          //   image: image.length > 0 ? image[0].sourceUrl : "",

                          //   alignment: Alignment.bottomLeft,
                          //   fit: BoxFit.fitHeight,
                          // ),
                          Positioned(
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.yellow[700],
                              width: 40,
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
                                  child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Text(
                                                    property.title,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    // set some style to text
                                                    style: new TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  new Text(
                                                    "${property.types != null ? property.types['term_name'] : ""} ",
                                                    //
                                                    // set some style to text
                                                    style: new TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  new Text(
                                                    "${property.state != null ? property.state['term_name'] : ""} " +
                                                        "${property.city['term_name']} ",
                                                    // set some style to text
                                                    style: new TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                IconButton(
                                  icon: property.isFavorite
                                      ? FaIcon(FontAwesomeIcons.solidHeart)
                                      : FaIcon(FontAwesomeIcons.heart),
                                  onPressed: favoriteFunction,
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "${property.area + property.areaPrefix} ",
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                property.buildYear != null
                                    ? Text(
                                        "ساخت " + property.buildYear.toString())
                                    : SizedBox(
                                        width: 10,
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              Jiffy(property.date).fromNow(),
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
