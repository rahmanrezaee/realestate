
import 'package:badam/modul/bottom_nav/fancy_bottom_navigation.dart';
import 'package:badam/page/LoadingPage.dart';
import 'package:badam/page/LoginMain.dart';
import 'package:badam/page/home.dart';
import 'package:badam/page/myProperties/addpropertise.dart';
import 'package:badam/page/myProperties/fevorite.dart';
import 'package:badam/page/myProperties/manager.dart';
import 'package:badam/provider/auth_provider.dart';
import 'package:badam/strings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  Auth auth;
  Dashboard({this.auth});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BottomNavigationBarProvider>(
      child: BottomNavigationBarCustome(this.auth),
      create: (BuildContext context) => BottomNavigationBarProvider(),
    );
  }
}

class BottomNavigationBarCustome extends StatefulWidget {
  Auth auth;
  BottomNavigationBarCustome(this.auth);
  @override
  _BottomNavigationBarCustomeState createState() =>
      _BottomNavigationBarCustomeState();
}

class _BottomNavigationBarCustomeState
    extends State<BottomNavigationBarCustome> {
  @override
  Widget build(BuildContext context) {

    var currentTab = [
      widget.auth.token != null
          ? ManagerPage()
          : FutureBuilder(
              future: Provider.of<Auth>(context, listen: false).tryAutoLogin(),
              builder: (ctx, authResultSnapshot) =>
                  authResultSnapshot.connectionState == ConnectionState.waiting
                      ? LoadingPage()
                      : LoginScreen()),
      widget.auth.token != null
          ? AddPropertise(
              auth: widget.auth,
            )
          : FutureBuilder(
              future: Provider.of<Auth>(context, listen: false).tryAutoLogin(),
              builder: (ctx, authResultSnapshot) =>
                  authResultSnapshot.connectionState == ConnectionState.waiting
                      ? LoadingPage()
                      : LoginScreen(),
            ),
      widget.auth.token != null
          ? FevoritePage()
          : FutureBuilder(
              future: Provider.of<Auth>(context, listen: false).tryAutoLogin(),
              builder: (ctx, authResultSnapshot) =>
                  authResultSnapshot.connectionState == ConnectionState.waiting
                      ? LoadingPage()
                      : LoginScreen(),
            ),
      HomePage(),
    ];

    var provider = Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          new Offstage(
            offstage: provider.currentIndex != 0,
            child: currentTab[0],
          ),
          new Offstage(
            offstage: provider.currentIndex != 1,
            child: currentTab[1],
          ),
          new Offstage(
            offstage: provider.currentIndex != 2,
            child: currentTab[2],
          ),
          new Offstage(
            offstage: provider.currentIndex != 3,
            child: currentTab[3],
          ),
        ],
      ),
      // body: currentTab[provider.currentIndex],
      bottomNavigationBar: FancyBottomNavigation(
        activeIconColor: Colors.white,
        circleColor: Theme.of(context).primaryColor,
        textColor: Theme.of(context).primaryColor,
        barBackgroundColor: Colors.white,
        initialSelection: provider.currentIndex,
        inactiveIconColor: Theme.of(context).primaryColor,
        tabs: [
          TabData(iconData: FontAwesomeIcons.user, title: PROFILE),
          TabData(
              iconData: FontAwesomeIcons.plusSquare, title: SUBMIT_PROPERTY),
          TabData(iconData: FontAwesomeIcons.heart, title: FAVORITE),
          TabData(iconData: FontAwesomeIcons.searchLocation, title: SEARCH),
        ],
        onTabChangedListener: (position) {
          setState(() {
            provider.currentIndex = position;
          });
        },
      ),
    );
  }
}

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 3;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
