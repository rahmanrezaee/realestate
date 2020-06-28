import 'package:badam/modul/SearchDialog.dart';
import 'package:badam/modul/properties.dart';
import 'package:badam/page/Maps/MapLocation.dart';
import 'package:badam/page/Maps/Maps.dart';
import 'package:badam/page/propeties/search.dart';
import 'package:badam/strings.dart';
import 'package:badam/style/style.dart';
import 'package:badam/util/feature_property.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Location location;
  LocationData currentLocation;
  PermissionStatus _permissionGranted;
  bool _is_Maps = false;

  bool _serviceEnabled;
  String _TEXT_FEATURE_PROPERTY = 'خرید';

  Future<void> _checkService() async {
    final bool serviceEnabledResult = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = serviceEnabledResult;
    });
  }

  Future<void> _requestService() async {
    if (_serviceEnabled == null || !_serviceEnabled) {
      final bool serviceRequestedResult = await location.requestService();
      setState(() {
        _serviceEnabled = serviceRequestedResult;
      });
      if (!serviceRequestedResult) {
        return;
      }
    }
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
      if (permissionRequestedResult != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  void initState() {
    _permissionGranted == PermissionStatus.granted ? null : _requestPermission;
  
    _serviceEnabled == true ? null : _requestService;
   
    super.initState();

    location = new Location();
    location.getLocation().then((data) {
      currentLocation = data;
    });
  }

  Future goToFeatureProperty(context) async {
    return await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.upToDown,
        child: new FeatureProperty(),
      ),
    );
  }

  Future goToSecondScreen(context) async {
    return await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new SearchDialog(),
          fullscreenDialog: true,
        ));
  }

  String searchQuerySecond, searchQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          // appBar: AppBar(
          //   elevation: 0,
          //   centerTitle: true,
          //   backgroundColor: Colors.white,
          //   title: ),
          body: Column(
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColorDark,
                height: MediaQuery.of(context).padding.top,
              ),
              FlatButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.arrow_drop_down),
                    Text(
                      _TEXT_FEATURE_PROPERTY,
                      style: style_title_appbar(context),
                    ),
                  ],
                ),
                onPressed: () {
                  goToFeatureProperty(context).then((value) {
                    setState(() {
                      print(value);
                      if (value != null && value != "close") {
                        _TEXT_FEATURE_PROPERTY = value;
                      }
                    });
                  });
                },
              ),
              new Card(
                elevation: 5,
                child: new ListTile(
                    onTap: () {
                      setState(() {
                        searchQuerySecond = searchQuery;
                        searchQuery = null;
                      });
                      goToSecondScreen(context).then((data) {
                        if (data != null) {
                          setState(() {
                            searchQuery = data;
                          });
                        } else {
                          setState(() {
                            searchQuery = searchQuerySecond;
                          });
                        }
                      });
                    },
                    leading: const Icon(Icons.search),
                    title: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          SEARCH_LABEL_MAIN,
                          style: feature_style(context),
                        )),
                        FaIcon(Icons.filter_list, color: Colors.grey, size: 24),
                      ],
                    )),
              ),
              _is_Maps ? 
              MapsLocationPage() :
              PropertiesList(type: searchQuery) ,
            ],
            
          ),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () => setState(() { _is_Maps = true; }),
              backgroundColor: Theme.of(context).primaryColor,
              splashColor: Colors.white,
              icon: Icon(Icons.map,color: Colors.white,),
              label: Text('نقشه',style: TextStyle(color: Colors.white),))),
    );
  }

  Widget googleMapWidget() {
    // print(currentLocation.latitude.toString()+" , "+currentLocation.longitude.toString());
    return GoogleMap(
      myLocationButtonEnabled: true,
      buildingsEnabled: true,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: currentLocation != null ? currentLocation : LatLng(34.0, 62.0),
        zoom: 10.0,
      ),
    );
  }
}
