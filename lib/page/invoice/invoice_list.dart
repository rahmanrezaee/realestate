import 'dart:async';
import 'package:badam/model/Invoice.dart';
import 'package:badam/provider/property_provider.dart';
import 'package:flutter/material.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:shimmer/shimmer.dart';
import 'package:validators/validators.dart';

class InvoiceList extends StatefulWidget {
  InvoiceList();
  @override
  _MyInvoiceListState createState() => new _MyInvoiceListState();
}

class _MyInvoiceListState extends State<InvoiceList> {
  List<Invoice> items;
  bool _loadingMore;
  bool _hasMoreItems;
  int _maxItems;
  Future _initialLoad;
  int page = 1;

  AppBar appBar = AppBar(
    title: Text("فاکتور های خرید"),
  );

  Future _loadMoreItems() async {
    print("this not work");
    ++page;
    await PropertyProvider().fetchInvoiceList(page).then((data) {
      List<Invoice> temp = data[0];
      items.addAll(temp);
    });
    _hasMoreItems = items.length < _maxItems;
  }

  @override
  void initState() {
    super.initState();

    initAndRefresh();
  }

  Future<Null> initAndRefresh() async {
    refreshKey.currentState?.show(atTop: false);

    _initialLoad = PropertyProvider().fetchInvoiceList(page).then((data) {
      items = data[0];

      _maxItems = int.parse(data[1][0]);
      _hasMoreItems = true;
      print(_maxItems);
      print(_hasMoreItems);

      return null;
    });
  }

  Future<Null> _refreshLocalGallery() async {
    print('refreshing stocks...');
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    double screenSize =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;
    return Scaffold(
      appBar: appBar,
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: initAndRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: FutureBuilder(
            future: _initialLoad,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container(
                      height: screenSize,
                      child: Center(child: CircularProgressIndicator()));
                case ConnectionState.done:
                  return _maxItems != null && _maxItems > 0
                      ? Container(
                          height: screenSize,
                          child: IncrementallyLoadingListView(
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
                              Invoice item = items[index];

                              if ((_loadingMore ?? false) &&
                                  index == items.length - 1) {
                                return Column(
                                  children: <Widget>[
                                    ItemCard(
                                      invoice: item,
                                    ),
                                    PlaceholderItemCard(),
                                  ],
                                );
                              }
                              return ItemCard(
                                invoice: item,
                              );
                            },
                          ),
                        )
                      : Container(
                          height: screenSize,
                          child: Center(child: Text("هیج ملک پیدا نشد")));
                default:
                  return Container(
                      height: screenSize,
                      child: Center(
                          child:
                              Text('مشکل در گرفتن ملک ها پیدا شده دوباره ')));
              }
            },
          ),
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  Invoice invoice;
  ItemCard({this.invoice});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: ListTile(
            
            subtitle: Text(invoice.invoicePurchaseDate),
            title:Text(invoice.title),
            trailing: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    
                      

                      Text("قمیت بسته :"),
                      SizedBox(width: 10,),
                      Text(isNumeric(invoice.invoiceItemPrice) ? "${invoice.invoiceItemPrice} افغانی": "رایگان"),
                    ],
                  ),
                   SizedBox(height: 5,),
                 Text(invoice.invoice_status),
                ],
              ),
            ),
          )
        ),
         Divider(), 
      ],
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
