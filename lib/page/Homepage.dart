import 'package:badam/modul/bottom_nav/fancy_bottom_navigation.dart';
import 'package:badam/modul/draw.dart';
import 'package:badam/page/Maps/Maps.dart';
import 'package:badam/page/agency/agency_list.dart';
import 'package:badam/page/auth/profile.dart';
import 'package:badam/page/home.dart';
import 'package:badam/page/myProperties/addpropertise.dart';
import 'package:badam/page/myProperties/manager.dart';
import 'package:badam/page/posts/posts.dart';
import 'package:badam/page/propeties/properties.dart';
import 'package:badam/strings.dart';
import 'package:badam/util/httpRequest.dart';
import 'package:badam/util/sharedPreference.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  final Function() notifyParent;
  Dashboard({Key key, this.notifyParent}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 
  List imageUrl;
  @override
  void initState() {

    getMainSlider().then((data){
      print(data);
      imageUrl = data;
    });

    readPreferenceString("username").then((username) {
      readPreferenceString("password").then((password) {
        getToken(username, password).then((data) {});
      });
    });
    super.initState();
  }

  int _currentIndex = 3;
  final List<Widget> _children = [
    ManagerPage(),
    AddPropertise(),
    AgencyList(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
       
        body: _children[_currentIndex],
        bottomNavigationBar: FancyBottomNavigation(
          activeIconColor: Colors.white,
          circleColor: Theme.of(context).primaryColor,
          textColor: Theme.of(context).primaryColor,
          barBackgroundColor: Colors.white,
          inactiveIconColor: Theme.of(context).primaryColor,
          tabs: [
            TabData(iconData: FontAwesomeIcons.user,title: PROFILE),
            TabData(iconData: FontAwesomeIcons.plusSquare, title: SUBMIT_PROPERTY),
            TabData(iconData: FontAwesomeIcons.users ,title:AGENCIES),
            TabData(iconData: FontAwesomeIcons.searchLocation , title: SEARCH),
          ],
          onTabChangedListener: (position) {
            setState(() {
              _currentIndex = position;
            });
          },
        ),
        // drawer: AppDrawer()
        );
  }
}
