

import 'package:badam/util/AuthServiceFirebase.dart';
import 'package:flutter/material.dart';

import 'package:badam/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ManagerPage extends StatelessWidget {
  TabController tabController;

   _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'حساب کاربری',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          Container(
            width: 90,
            child: IconButton(
              icon: Row(
                children: <Widget>[
                  Icon(
                    Icons.exit_to_app,
                    size: 24,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "خروج",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              onPressed: ()  {
                Provider.of<Auth>(context, listen: false).logout().then((_) async {
                  await AuthServiceFirebase(context: context).signOut();
                  Navigator.pushReplacementNamed(context, "/");
                });
              },
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: Auth().userData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height / 4 - 20,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.7),
                              blurRadius: 20,
                              spreadRadius: 10,
                            )
                          ],
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          )),
                      child: Column(
                        children: <Widget>[
                          // Container(
                          //   height: 105,
                          //   width: 105,
                          //   decoration: BoxDecoration(
                          //       color: Theme.of(context).primaryColor,
                          //       borderRadius: BorderRadius.circular(52.5),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Theme.of(context).primaryColorLight,
                          //           spreadRadius: 2,
                          //         )
                          //       ]),
                          //   child: CircleAvatar(
                          //     backgroundColor: Colors.black45,
                          //     radius: 50,
                          //     child: FaIcon(
                          //       FontAwesomeIcons.userAlt,
                          //       size: 33,
                          //     ),
                          //   ),
                          // ),
                         
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  snapshot.data['user_nicename'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data['phoneNumber'],
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                       SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, right: 34, left: 34),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "مدیرت املاک",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              dense: true,
                              onTap: () => Navigator.pushNamed(
                                  context, "/myPropertyList",
                                  arguments: "publish"),
                              leading: Icon(
                                Icons.list,
                                size: 20,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                              title: Text(
                                'منتشر شده ها',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              dense: true,
                              onTap: () => Navigator.pushNamed(
                                  context, "/myPropertyList",
                                  arguments: "pending"),
                              leading: Icon(
                                Icons.list,
                                size: 20,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                              title: Text(
                                'در دست برسی ها',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              dense: true,
                              onTap: () => Navigator.pushNamed(
                                  context, "/myPropertyList",
                                  arguments: "trash"),
                              leading: Icon(
                                Icons.list,
                                size: 20,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                              title: Text(
                                'تایید نشده ها',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(bottom: 3),
                          //   child: ListTile(
                          //     contentPadding: EdgeInsets.symmetric(
                          //         vertical: 0.0, horizontal: 0.0),
                          //     dense: true,
                          //     onTap: () => Navigator.pushNamed(
                          //         context, "/myPropertyList",
                          //         arguments: "noScore"),
                          //     leading: Icon(
                          //       Icons.list,
                          //       size: 20,
                          //     ),
                          //     trailing: Icon(
                          //       Icons.arrow_forward_ios,
                          //       size: 20,
                          //     ),
                          //     title: Text(
                          //       'منقضی شده ها',
                          //       style: TextStyle(
                          //         fontSize: 15,
                          //         fontWeight: FontWeight.w500,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Divider(
                            color: Colors.black,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "مدیریت حساب کاربری",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              dense: true,
                              onTap: () => Navigator.pushNamed(
                                  context, "/PackageManagement",
                                  arguments: 1.toString()),
                              leading: Icon(
                                Icons.list,
                                size: 20,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                              title: Text(
                                'مدیریت بسته ها',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              dense: true,
                              onTap: () => Navigator.pushNamed(
                                  context, "/invoiceList",
                                  arguments: 1.toString()),
                              leading: Icon(
                                Icons.list,
                                size: 20,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                              title: Text(
                                'فاکتورهای خرید من',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              dense: true,
                              onTap: () => Navigator.pushNamed(
                                  context, "/profile",
                                  arguments: 1.toString()),
                              leading: Icon(
                                Icons.list,
                                size: 20,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                              title: Text(
                                'ویرایش پروفایل',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "تماس",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              dense: true,
                              onTap: () => Navigator.pushNamed(
                                  context, "/ContactUs",
                                  arguments: 1.toString()),
                              leading: Icon(
                                Icons.list,
                                size: 20,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                              title: Text(
                                'درباره و ارتباط باما',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              dense: true,
                              onTap: () => _launchURL("https://www.badam.af/terms-condition"),
                                 
                              leading: Icon(
                                Icons.list,
                                size: 20,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                              title: Text(
                                'شرایط و ضوابط',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        
                          Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              dense: true,
                              onTap: () => _launchURL("https://www.badam.af/advertising/"),
                              leading: Icon(
                                Icons.list,
                                size: 20,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                              title: Text(
                                'تبلیغات در بادام',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
  Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              dense: true,
                              onTap: () => _launchURL("https://www.badam.af/"),
                              leading: Icon(
                                Icons.list,
                                size: 20,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                              title: Text(
                                'به روزرسانی',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 3),
                              alignment: Alignment.center,
                              child: Text("تسخه ۱.۱.۱")),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
