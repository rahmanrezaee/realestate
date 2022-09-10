import 'package:badam/model/User.dart';
import 'package:badam/page/Homepage.dart';
import 'package:badam/page/PackageManage/packageManagement.dart';
import 'package:badam/page/PackageManage/payment_invoice.dart';
import 'package:badam/page/auth/PhoneAuthVerify.dart';
import 'package:badam/page/auth/Register.dart';
import 'package:badam/page/auth/phoneVarify.dart';
import 'package:badam/page/auth/profile.dart';
import 'package:badam/page/auth/welcome.dart';
import 'package:badam/page/contact_us.dart';
import 'package:badam/page/invoice/invoice_list.dart';
import 'package:badam/page/myProperties/addpropertise.dart';
import 'package:badam/page/myProperties/fevorite.dart';
import 'package:badam/page/myProperties/myListProperties.dart';
import 'package:badam/page/propeties/imageView.dart';
import 'package:badam/page/propeties/singleProperties.dart';
import 'package:badam/provider/auth_provider.dart';
import 'package:badam/provider/property_provider.dart';
import 'package:badam/themes/custom_theme.dart';
import 'package:badam/themes/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'strings.dart';

final String boxName = 'favourite_list';

Future<void> main() async {
  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  User currentUser = User();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: Consumer<Auth>(
        builder: (BuildContext context, Auth value, Widget child) =>
            MaterialApp(
          debugShowCheckedModeBanner: false,
          title: APP_NAME,
          theme: CustomTheme.of(context),
        initialRoute: "/",
          routes: <String, WidgetBuilder>{
            // '/': (BuildContext context) => MyHomePage(),
            // '/': (BuildContext context) => SplashScreen(),
            // '/': (BuildContext context) => AddPropertise(),
            // '/': (BuildContext context) => Dashboard(auth: value,),
            '/': (BuildContext context) => Dashboard(auth: value,),
            // '/': (BuildContext context) => CacheScreen(),
            '/welcome': (BuildContext context) => Welcome(),
            // '/register': (BuildContext context) => RegisterUser(
            //       userAuthData: ModalRoute.of(context).settings.arguments,
            //     ),
            '/codephoneVarify': (BuildContext context) => PhoneVarify(),
            '/PhoneAuthVerify': (BuildContext context) =>
                PhoneAuthVerify(ModalRoute.of(context).settings.arguments),
            '/Dashboard': (BuildContext context) => Dashboard(),
            // '/singleAgent': (BuildContext context) =>
            //     SingleAgence(ModalRoute.of(context).settings.arguments),
            '/singleProperty': (BuildContext context) => SingleProperties(
                  mylist: ModalRoute.of(context).settings.arguments,
                ),
            // '/singlePost': (BuildContext context) =>
            //     SinglePost(ModalRoute.of(context).settings.arguments),
            '/ImageViewPage': (BuildContext context) =>
                ImageViewPage(ModalRoute.of(context).settings.arguments),
            '/myPropertyList': (BuildContext context) =>
                MyListProperties(ModalRoute.of(context).settings.arguments),
            '/addProperty': (BuildContext context) => AddPropertise(auth: value,propertyEdit:ModalRoute.of(context).settings.arguments),
            // '/agencyPropertiesList': (BuildContext context) =>
            //     ShowPropertyAgency(ModalRoute.of(context).settings.arguments),
            // '/SearchDialog': (BuildContext context) => FiltersScreen(),
            // '/searchPage': (BuildContext context) => SearchPage(),
            '/profile': (BuildContext context) => ProfilePage(),
            '/favoritePage': (BuildContext context) => FevoritePage(),
            '/PackageManagement': (BuildContext context) => PackageManagement(),
            '/ContactUs': (BuildContext context) => ContactUs(),
            '/invoiceList': (BuildContext context) => InvoiceList(),
            '/PaymentIvoice': (BuildContext context) => PaymentIvoice(packageId: ModalRoute.of(context).settings.arguments,),

            //test
          },
        ),
      ),
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: PropertyProvider()),
      ],
    );
  }

  //  @override
  // Widget build(BuildContext context) {
  //   return ChangeNotifierProvider<MyBottomSheetModel>(
  //     create: (_) => MyBottomSheetModel(),
  //     child: MaterialApp(
  //       debugShowCheckedModeBanner: false,
  //       title: 'Flutter Demo',
  //       theme: ThemeData(
  //         primarySwatch: Colors.blue,
  //         fontFamily: 'OpenSans',
  //       ),
  //       home: HomeScreen(),
  //     ),
  //   );
  // }
}
