import 'package:badam/model/package.dart';
import 'package:badam/provider/property_provider.dart';
import 'package:flutter/material.dart';

class PackageManagement extends StatefulWidget {
  @override
  _PackageManagementState createState() => _PackageManagementState();
}

class _PackageManagementState extends State<PackageManagement> {
  Widget textField() {
    return TextField(
      scrollPadding: EdgeInsets.all(4),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(128, 128, 128, 0.1),
        // isCollapsed: true,
        contentPadding: EdgeInsets.all(8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget text(String textInput) {
    return Text(
      textInput,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Future _initialLoad;

  @override
  void initState() {
    _initialLoad = PropertyProvider().getPackages();
    super.initState();
  }

  bool isExpand = false;

    // void buyPackage() {

    //   Navigator.
    //   // showDialog(
    //   //   context: context,
    //   //   builder: (ctx) => AlertDialog(
    //   //     content: Container(
    //   //       child: Column(
    //   //         crossAxisAlignment: CrossAxisAlignment.end,
    //   //         children: [
    //   //           text('نام'),
    //   //           textField(),
    //   //           SizedBox(
    //   //             height: 10,
    //   //           ),
    //   //           text('نام خانواده گی'),
    //   //           textField(),
    //   //           SizedBox(
    //   //             height: 10,
    //   //           ),
    //   //           text('نام آژانس'),
    //   //           textField(),
    //   //           SizedBox(
    //   //             height: 10,
    //   //           ),
    //   //           text('پست الکترونیک'),
    //   //           textField(),
    //   //           SizedBox(
    //   //             height: 10,
    //   //           ),
    //   //           text('شماره تلفن'),
    //   //           textField(),
    //   //           SizedBox(
    //   //             height: 10,
    //   //           ),
    //   //           text('شماره موبایل'),
    //   //           textField(),
    //   //           SizedBox(
    //   //             height: 10,
    //   //           ),
    //   //           Container(
    //   //             width: double.infinity,
    //   //             child: FlatButton(
    //   //               color: Colors.cyan,
    //   //               textColor: Colors.white,
    //   //               onPressed: () {},
    //   //               child: Text(
    //   //                 'ثبت',
    //   //                 style: TextStyle(fontWeight: FontWeight.bold),
    //   //               ),
    //   //             ),
    //   //           ),
    //   //         ],
    //   //       ),
    //   //     ),
    //   //   ),
    //   // );
    // }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('مدیریت بسته'),
      ),
      body: FutureBuilder(
        future: _initialLoad,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              List<Package> pack = snapshot.data;

              return ListView.builder(
                  itemCount: pack.length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                        padding: (isExpand == true)
                            ? const EdgeInsets.all(8.0)
                            : const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: (isExpand != true)
                                  ? BorderRadius.all(Radius.circular(8))
                                  : BorderRadius.all(Radius.circular(22)),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor)),
                          child: ExpansionTile(
                            key: PageStorageKey(pack[index].id),
                            title: Container(
                                width: double.infinity,
                                child: Text(
                                  pack[index].title,
                                  style: TextStyle(
                                      fontSize: (isExpand != true) ? 18 : 22),
                                )),
                            trailing: (isExpand == true)
                                ? Icon(
                                    Icons.arrow_drop_down,
                                    size: 32,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : Icon(Icons.arrow_drop_up,
                                    size: 32,
                                    color: Theme.of(context).primaryColor),
                            onExpansionChanged: (value) {
                              setState(() {
                                isExpand = value;
                              });
                            },
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  child: Container(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Text("قمیت :"),
                                          trailing: Text(pack[index].price),
                                        ),
                                         ListTile(
                                          title: Text("ملک ساده"),
                                          trailing: Text(pack[index]
                                              .normalProperties
                                              .toString()),
                                        ),
                                        ListTile(
                                          title: Text("ملک ویژه"),
                                          trailing: Text(pack[index]
                                              .vipProperties
                                              .toString()),
                                        ),
                                        ListTile(
                                          title: Text("ملک طلایی"),
                                          trailing: Text(pack[index]
                                              .goldProperties
                                              .toString()),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ),
                                              color:Theme.of(context).primaryColor,
                                              textColor: Colors.white,
                                              onPressed: ()=> Navigator.pushNamed(context, "/PaymentIvoice",arguments: pack[index].id),
                                              child: Text(
                                                'درخواست خرید بسته',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ));
            default:
              return Text('مشکل در گرفتن ملک ها پیدا شده دوباره ');
          }
        },
      ),
    );
  }
}

// class ListItemState extends State
// {
//   bool isExpand=false;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     isExpand=false;
//   }
//   @override
//   Widget build(BuildContext context) {
//     List listItem=this.widget.listItems;
//     return  ;
//   }
// }
