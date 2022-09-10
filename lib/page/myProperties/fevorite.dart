
import 'package:badam/model/property.dart';
import 'package:badam/page/LoadingPage.dart';
import 'package:badam/page/home.dart';
import 'package:badam/provider/auth_provider.dart';
import 'package:badam/provider/property_provider.dart';
import 'package:flutter/material.dart';

class FevoritePage extends StatefulWidget {
  @override
  _FevoritePageState createState() => _FevoritePageState();
}

class _FevoritePageState extends State<FevoritePage> {
  List<Property> itemslist;
  Future items;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    items = PropertyProvider().fetchFavoritePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("لیست علاقه مندان"),
      ),
      body: FutureBuilder(
          future: items,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return LoadingPage();
              case ConnectionState.done:
                itemslist = snapshot.data;
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      itemslist.clear();
                    loadData();
                    });
                  },
                  child: ListView.builder(
                      itemCount: itemslist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ItemProperty(
                            property: itemslist[index],
                            favoriteFunction: () {
                              Auth()
                                  .addToFavorite(itemslist[index].id)
                                  .then((data) {
                                if (data) {
                                  setState(() => itemslist[index].isFavorite =
                                      !itemslist[index].isFavorite);
                                }
                              });
                            });
                        //       if (properties.length < 1) {
                        //         return Text("Favorite is Empty");
                        //       } else {
                        //         Property mylist = properties[index];
                      }),
                );

              default:
                return FlatButton(
                    onPressed: () async{
                      if (itemslist != null) {
                        itemslist.clear();
                      }
                       loadData();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.replay),
                        Text("مشکل پیش امد"),
                      ],
                    ));
            }
          }),
    );
  }
}
