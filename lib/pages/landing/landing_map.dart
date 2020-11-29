import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nf_kicks/constants.dart';

class LandingMap extends StatefulWidget {
  @override
  _LandingMapState createState() => _LandingMapState();
}

class _LandingMapState extends State<LandingMap> {
  Completer<GoogleMapController> controller;

  static LatLng _initialPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  _onMapCreated(GoogleMapController googleMapController) {
    setState(() {
      controller.complete(googleMapController);
    });
  }

  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition == null
          ? kLoadingLogo
          : Container(
              child: Stack(children: <Widget>[
                GoogleMap(
                  markers: _markers,
                  mapType: _currentMapType,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 14.4746,
                  ),
                  onMapCreated: _onMapCreated,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ]),
            ),
    );
  }
}
