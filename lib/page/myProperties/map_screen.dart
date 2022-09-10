import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialLocation;
  bool isSelecting;

  MapScreen({this.initialLocation, this.isSelecting = false, Key key})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('انتخاب موقعیت'),
        actions: <Widget>[
           widget.isSelecting
            ? FlatButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.check,
                    color: Colors.white,
                  ),
                ],
              ),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ):SizedBox(),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              markers: _lastMapPosition == null
                  ? null
                  : {
                      Marker(
                        markerId: MarkerId('m1'),
                        position: _lastMapPosition,
                      ),
                    },
              onTap: (data) {
                setState(() {
                  print(data);
                  widget.isSelecting = true;
                  _pickedLocation = data;
                });
              },
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _lastMapPosition,
                zoom: 14.4746,
              ),
              onMapCreated: _onMapCreated,
              zoomGesturesEnabled: true,
              onCameraMove: _onCameraMove,
              myLocationEnabled: true,
              compassEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
        ],
      ),
    );
  }

  Completer<GoogleMapController> controller1;

  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  static LatLng _lastMapPosition = _initialPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    setState(() {
      if (widget.initialLocation != null){
         _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
              title: "Pizza Parlour",
              snippet: "This is a snippet",
              onTap: () {}),
          onTap: () {},
          icon: BitmapDescriptor.defaultMarker));
      }
      else
        _initialPosition = LatLng(34.38106760813841, 62.14080657809973);
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
    });
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
              title: "Pizza Parlour",
              snippet: "This is a snippet",
              onTap: () {}),
          onTap: () {},
          icon: BitmapDescriptor.defaultMarker));
    });
  }

 
}

class ListenLocationWidget extends StatefulWidget {
  const ListenLocationWidget({Key key}) : super(key: key);

  @override
  _ListenLocationState createState() => _ListenLocationState();
}

class _ListenLocationState extends State<ListenLocationWidget> {
  final Location location = Location();

  LocationData _location;
  StreamSubscription<LocationData> _locationSubscription;
  String _error;

  Future<void> _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      setState(() {
        _error = err.code;
      });
      _locationSubscription.cancel();
    }).listen((LocationData currentLocation) {
      setState(() {
        _error = null;

        _location = currentLocation;
      });
    });
  }

  Future<void> _stopListen() async {
    _locationSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Listen location: ' + (_error ?? '${_location ?? "unknown"}'),
          style: Theme.of(context).textTheme.body2,
        ),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 42),
              child: RaisedButton(
                child: const Text('Listen'),
                onPressed: _listenLocation,
              ),
            ),
            RaisedButton(
              child: const Text('Stop'),
              onPressed: _stopListen,
            )
          ],
        ),
      ],
    );
  }
}

class GetLocationWidget extends StatefulWidget {
  const GetLocationWidget({Key key}) : super(key: key);

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocationWidget> {
  final Location location = Location();

  LocationData _location;
  String _error;

  Future<void> _getLocation() async {
    setState(() {
      _error = null;
    });
    try {
      final LocationData _locationResult = await location.getLocation();
      setState(() {
        _location = _locationResult;
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Location: ' + (_error ?? '${_location ?? "unknown"}'),
          style: Theme.of(context).textTheme.body2,
        ),
        Row(
          children: <Widget>[
            RaisedButton(
              child: const Text('Get'),
              onPressed: _getLocation,
            )
          ],
        ),
      ],
    );
  }
}

class ServiceEnabledWidget extends StatefulWidget {
  const ServiceEnabledWidget({Key key}) : super(key: key);

  @override
  _ServiceEnabledState createState() => _ServiceEnabledState();
}

class _ServiceEnabledState extends State<ServiceEnabledWidget> {
  final Location location = Location();

  bool _serviceEnabled;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Service enabled: ${_serviceEnabled ?? "unknown"}',
            style: Theme.of(context).textTheme.body2),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 42),
              child: RaisedButton(
                child: const Text('Check'),
                onPressed: _checkService,
              ),
            ),
            RaisedButton(
              child: const Text('Request'),
              onPressed: _serviceEnabled == true ? null : _requestService,
            )
          ],
        )
      ],
    );
  }
}

class PermissionStatusWidget extends StatefulWidget {
  const PermissionStatusWidget({Key key}) : super(key: key);

  @override
  _PermissionStatusState createState() => _PermissionStatusState();
}

class _PermissionStatusState extends State<PermissionStatusWidget> {
  final Location location = Location();

  PermissionStatus _permissionGranted;

  Future<void> _checkPermissions() async {
    final PermissionStatus permissionGrantedResult =
        await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Permission status: ${_permissionGranted ?? "unknown"}',
          style: Theme.of(context).textTheme.body2,
        ),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 42),
              child: RaisedButton(
                child: const Text('Check'),
                onPressed: _checkPermissions,
              ),
            ),
            RaisedButton(
              child: const Text('Request'),
              onPressed: _permissionGranted == PermissionStatus.granted
                  ? null
                  : _requestPermission,
            )
          ],
        )
      ],
    );
  }
}
