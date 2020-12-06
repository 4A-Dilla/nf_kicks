import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nf_kicks/constants.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/pages/something_went_wrong_page.dart';
import 'package:nf_kicks/pages/store/store_page.dart';
import 'package:nf_kicks/services/database/database.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:provider/provider.dart';

class LandingMap extends StatefulWidget {
  @override
  _LandingMapState createState() => _LandingMapState();
}

class _LandingMapState extends State<LandingMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();

  static LatLng _initialPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<BitmapDescriptor> _makeMarkerIcon(String image) async {
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(image);
    final Uint8List markerImageBytes = await markerImageFile.readAsBytes();

    ui.Codec codec =
        await ui.instantiateImageCodec(markerImageBytes, targetWidth: 50);
    ui.FrameInfo fi = await codec.getNextFrame();

    final Uint8List markerImage =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))
            .buffer
            .asUint8List();

    return BitmapDescriptor.fromBytes(markerImage);
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    if (this.mounted) {
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    }
  }

  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    // print("my markers: $markers");
    return Scaffold(
      body: _initialPosition == null
          ? kLoadingNoLogo
          : _buildGoogleMapsWithMarkers(),
    );
  }

  // Future<void> initMarker(Store storeMarker) async {
  //   var markerIdVal = storeMarker.id;
  //   final MarkerId markerId = MarkerId(markerIdVal);
  //   BitmapDescriptor markerImage = await _makeMarkerIcon(storeMarker.image);
  //
  //   final Marker marker = Marker(
  //     markerId: markerId ?? '',
  //     icon: markerImage ?? BitmapDescriptor.defaultMarker,
  //     position:
  //         LatLng(storeMarker.latLong.latitude, storeMarker.latLong.longitude) ??
  //             LatLng(0, 0),
  //     infoWindow:
  //         InfoWindow(title: storeMarker.name, snippet: storeMarker.address) ??
  //             InfoWindow(title: '', snippet: ''),
  //   );
  //
  //   setState(() {
  //     markers[markerId] = marker;
  //   });
  // }

  GoogleMap _buildGoogleMaps(Set<Marker> markers) {
    return GoogleMap(
      markers: markers,
      mapType: _currentMapType,
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: 14.4746,
      ),
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      compassEnabled: true,
      myLocationButtonEnabled: true,
    );
  }

  Widget _buildGoogleMapsWithMarkers() {
    final database = Provider.of<DatabaseApi>(context, listen: false);

    return StreamBuilder<List<Store>>(
      stream: database.storesStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return kLoadingNoLogo;
        }

        snapshot.data.forEach((element) async {
          // initMarker(element);
          BitmapDescriptor markerImage = await _makeMarkerIcon(element.image);
          _markers.add(
            Marker(
              markerId: MarkerId(element.id) ?? MarkerId(''),
              icon: markerImage ?? BitmapDescriptor.defaultMarker,
              position:
                  LatLng(element.latLong.latitude, element.latLong.longitude) ??
                      LatLng(0, 0),
              infoWindow:
                  InfoWindow(title: element.name, snippet: element.address) ??
                      InfoWindow(title: '', snippet: ''),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StorePage(
                    storeId: element.id,
                    dataStore: database,
                  ),
                ),
              ),
            ),
          );
          return _buildGoogleMaps(_markers);
        });
        return _buildGoogleMaps(_markers);
      },
    );
  }
}
