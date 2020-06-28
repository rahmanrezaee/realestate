import 'package:badam/model/User.dart';
import 'package:badam/modul/SearchDialog.dart';
import 'package:badam/page/Homepage.dart';
import 'package:badam/page/SplashScreen.dart';
import 'package:badam/page/agency/showAgencyProperties.dart';
import 'package:badam/page/agency/singleAgence.dart';
import 'package:badam/page/auth/Login.dart';
import 'package:badam/page/auth/PhoneAuthVerify.dart';
import 'package:badam/page/auth/Register.dart';
import 'package:badam/page/auth/phoneVarify.dart';
import 'package:badam/page/auth/profile.dart';
import 'package:badam/page/auth/welcome.dart';
import 'package:badam/page/myProperties/addpropertise.dart';
import 'package:badam/page/myProperties/fevorite.dart';
import 'package:badam/page/myProperties/myListProperties.dart';
import 'package:badam/page/posts/singlePosts.dart';
import 'package:badam/page/propeties/search.dart';
import 'package:badam/page/propeties/singleProperties.dart';
import 'package:badam/page/test.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:badam/themes/my_themes.dart';
import 'package:badam/themes/custom_theme.dart';
import 'package:hive/hive.dart';

import 'strings.dart';


final String boxName = 'favourite_list';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>(boxName);
  runApp(CustomTheme(initialThemeKey: MyThemeKeys.LIGHT, child: MyApp()));
}


class MyApp extends StatelessWidget {
  User currentUser = User();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      theme: CustomTheme.of(context),
      builder: (BuildContext context, Widget child) {
        return new Directionality(
          textDirection: TextDirection.rtl,
          child: new Builder(
            builder: (BuildContext context) {
              return new MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                ),
                child: child,
              );
            },
          ),
        );
      },
      routes: <String, WidgetBuilder>{
        // '/': (BuildContext context) => MyHomePage(),
        '/': (BuildContext context) => SplashScreen(),
        '/welcome': (BuildContext context) => Welcome(),
        '/register': (BuildContext context) => RegisterUser(),
        '/codephoneVarify': (BuildContext context) => PhoneVarify(),
        '/PhoneAuthVerify': (BuildContext context) =>
            PhoneAuthVerify(ModalRoute.of(context).settings.arguments),
        '/LoginUser': (BuildContext context) => LoginUser(),
        '/Dashboard': (BuildContext context) => Dashboard(),
        '/singleAgent': (BuildContext context) =>
            SingleAgence(ModalRoute.of(context).settings.arguments),
        '/singleProperty': (BuildContext context) =>
            SingleProperties(ModalRoute.of(context).settings.arguments),
        '/singlePost': (BuildContext context) =>
            SinglePost(ModalRoute.of(context).settings.arguments),
        '/myPropertyList': (BuildContext context) =>
            MyListProperties(ModalRoute.of(context).settings.arguments),
        '/addPropery': (BuildContext context) => AddPropertise(),
        '/agencyPropertiesList': (BuildContext context) =>
            ShowPropertyAgency(ModalRoute.of(context).settings.arguments),
        '/SearchDialog': (BuildContext context) => SearchDialog(),
        '/searchPage': (BuildContext context) => SearchPage(),
        '/profile': (BuildContext context) => ProfilePage(),
        '/favoritePage': (BuildContext context) => FevoritePage(),

        //test
      }
    );
  }
}
