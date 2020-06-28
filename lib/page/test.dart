

import 'package:flutter/material.dart';
import 'dart:collection';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BuildContext _c1;
  BuildContext _c2;

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Home Page"),
        ),
        body: new Center(
          child: new Text("Home Page"),
        ),
      ),
    );
  }
}

class ChildA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Child A'),
    );
  }
}
class ChildB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Child B'),
    );
  }
}
class ChildC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Child C'),
    );
  }
}


// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'package:flutter_paginator/flutter_paginator.dart';
// import 'package:flutter_paginator/enums.dart';



// class HomePagePage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return HomeState();
//   }
// }

// class HomeState extends State<HomePagePage> {
//   GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Paginator'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.format_list_bulleted),
//             onPressed: () {
//               paginatorGlobalKey.currentState
//                   .changeState(listType: ListType.LIST_VIEW);
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.grid_on),
//             onPressed: () {
//               paginatorGlobalKey.currentState.changeState(
//                 listType: ListType.GRID_VIEW,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2),
//               );
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.library_books),
//             onPressed: () {
//               paginatorGlobalKey.currentState
//                   .changeState(listType: ListType.PAGE_VIEW);
//             },
//           ),
//         ],
//       ),
//       body: Paginator.listView(
//         key: paginatorGlobalKey,
//         pageLoadFuture: sendCountriesDataRequest,
//         pageItemsGetter: listItemsGetter,
//         listItemBuilder: listItemBuilder,
//         loadingWidgetBuilder: loadingWidgetMaker,
//         errorWidgetBuilder: errorWidgetMaker,
//         emptyListWidgetBuilder: emptyListWidgetMaker,
//         totalItemsGetter: totalPagesGetter,
//         pageErrorChecker: pageErrorChecker,
//         scrollPhysics: BouncingScrollPhysics(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           paginatorGlobalKey.currentState.changeState(
//               pageLoadFuture: sendCountriesDataRequest, resetState: true);
//         },
//         child: Icon(Icons.refresh),
//       ),
//     );
//   }

//   Future<CountriesData> sendCountriesDataRequest(int page) async {
//     //  '');
//     try {
//       String url = Uri.encodeFull(
//           'https://badam.af/wp-json/wp/v2/properties?&per_page=5&page=$page');
//       http.Response response = await http.get(url,headers: {
//         "Access-Control-Expose-Headers":" X-WP-Total",
//         "Access-Control-Expose-Headers":" X-WP-TotalPages",
//       });
//       return CountriesData.fromResponse(response);
//     } catch (e) {
//       if (e is IOException) {
//         return CountriesData.withError(
//             'Please check your internet connection.');
//       } else {
//         print(e.toString());
//         return CountriesData.withError('Something went wrong.');
//       }
//     }
//   }

//   List<dynamic> listItemsGetter(CountriesData countriesData) {
//     List<String> list = [];
//     countriesData.countries.forEach((value) {
//       list.add(value['name']);
//     });
//     return list;
//   }

//   Widget listItemBuilder(value, int index) {
//     return ListTile(
//       leading: Text(index.toString()),
//       title: Text(value),
//     );
//   }

//   Widget loadingWidgetMaker() {
//     return Container(
//       alignment: Alignment.center,
//       height: 160.0,
//       child: CircularProgressIndicator(),
//     );
//   }

//   Widget errorWidgetMaker(CountriesData countriesData, retryListener) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(countriesData.errorMessage),
//         ),
//         FlatButton(
//           onPressed: retryListener,
//           child: Text('Retry'),
//         )
//       ],
//     );
//   }

//   Widget emptyListWidgetMaker(CountriesData countriesData) {
//     return Center(
//       child: Text('No countries in the list'),
//     );
//   }

//   int totalPagesGetter(CountriesData countriesData) {
//     return countriesData.total;
//   }

//   bool pageErrorChecker(CountriesData countriesData) {
//     return countriesData.statusCode != 200;
//   }
// }

// class CountriesData {
//   List<dynamic> countries;
//   int statusCode;
//   String errorMessage;
//   int total;
//   int nItems;

//   CountriesData.fromResponse(http.Response response) {
//     this.statusCode = response.statusCode;
//     List countries = json.decode(response.body);
    
//     total = countries.length+1;
//     nItems = countries.length;
//   }

//   CountriesData.withError(String errorMessage) {
//     this.errorMessage = errorMessage;
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:hive/hive.dart';
// // import 'package:hive_flutter/hive_flutter.dart';

// // final String boxName = 'favourite_list';

// // class HomePage extends StatefulWidget {
// //   HomePage({Key key}) : super(key: key);

// //   List<String> images = [
// //     '1',
// //     '2',
// //     '3',
// //     '4',
// //     '5',
// //     '6',
// //     '7',
// //   ];

// //   @override
// //   _HomePageState createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {
// //   Box<String> box;

// //   @override
// //   void initState() {
// //     super.initState();
// //     box = Hive.box<String>(boxName);
// //   }

// //   void favouritePressed(id) {
// //     if (box.containsKey(id)) {
// //       box.delete(id);
// //     } else {
// //       box.put(id, id);
// //     }
// //   }

// //   Widget _getIcon(id) {
// //     bool isFavourite = box.containsKey(id);
// //     return Icon(
// //       isFavourite ? Icons.favorite : Icons.favorite_border,
// //       color: isFavourite ? Colors.red : Colors.grey,
// //     );
// //   }

// //   Widget _listItemBuilder(_context, index) {
// //     String id = widget.images[index];
// //     return ListTile(
// //       title: Text(id),
// //       trailing: GestureDetector(
// //         onTap: () {
// //           favouritePressed(id);
// //         },
// //         child: _getIcon(id),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Hive DB Saved List Sample"),
// //       ),
// //       body: ValueListenableBuilder(
// //         valueListenable: box.listenable(),
// //         builder: (_, __, ___) {
// //           return ListView.builder(
// //             itemCount: widget.images.length,
// //             itemBuilder: _listItemBuilder,
// //           );
// //         },
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         child: Text(
// //           'Saved List',
// //           textAlign: TextAlign.center,
// //         ),
// //         onPressed: () {
// //           Navigator.push(context, MaterialPageRoute(builder: (_) => SavedItemsPage()));
// //         },
// //       ),
// //     );
// //   }
// // }



// // class SavedItemsPage extends StatefulWidget {
// //   @override
// //   _SavedItemsPageState createState() => _SavedItemsPageState();
// // }

// // class _SavedItemsPageState extends State<SavedItemsPage> {
// //   List<String> favouriteList;

// //   @override
// //   void initState() {
// //     super.initState();
// //     var box = Hive.box<String>(boxName);
// //     setState(() {
// //       favouriteList = box.values.toList();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Saved"),
// //       ),
// //       body: ListView.builder(
// //         itemBuilder: (_cc, index) {
// //           return ListTile(
// //             title: Text(favouriteList[index]),
// //           );
// //         },
// //         itemCount: favouriteList.length,
// //       ),
// //     );
// //   }
// // }