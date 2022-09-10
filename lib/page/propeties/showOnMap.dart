import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowLocation extends StatefulWidget {
  final LatLng initialLocation;

  ShowLocation({this.initialLocation = const LatLng(0, 0), Key key})
      : super(key: key);

  @override
  _ShowLocationState createState() => _ShowLocationState();
}

class _ShowLocationState extends State<ShowLocation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("lat "+widget.initialLocation.latitude.toString());
    print("log "+widget.initialLocation.longitude.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("نمایش در نقشه"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: MarkerId('Location'),
            position: widget.initialLocation,
          ),
        },
      ),
    );
  }
}
