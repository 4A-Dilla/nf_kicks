import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nf_kicks/constants.dart';

class LandingMap extends StatefulWidget {
  @override
  _LandingMapState createState() => _LandingMapState();
}

class _LandingMapState extends State<LandingMap> {
  Completer<GoogleMapController> controller;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static LatLng _initialPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    _myMarkerFunc();
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _myMarkerFunc() {
    _firestore.collection('stores').get().then((docs) async {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; i++) {
          final File markerImageFile = await DefaultCacheManager()
              .getSingleFile(docs.docs[i]['image'].toString());
          final Uint8List markerImageBytes =
              await markerImageFile.readAsBytes();

          ui.Codec codec =
              await ui.instantiateImageCodec(markerImageBytes, targetWidth: 50);
          ui.FrameInfo fi = await codec.getNextFrame();

          final Uint8List markerImage =
              (await fi.image.toByteData(format: ui.ImageByteFormat.png))
                  .buffer
                  .asUint8List();

          final Marker marker = Marker(
            markerId: MarkerId(docs.docs[i].id),
            onTap: () {
              //Todo: You might want to add a delay to this
              showBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(docs.docs[i]['storeImage']),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                docs.docs[i]['name'],
                                style: GoogleFonts.josefinSans(
                                  textStyle: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                docs.docs[i]['address'],
                                style: GoogleFonts.josefinSans(
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                docs.docs[i]['description'],
                                style: GoogleFonts.josefinSans(
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "${docs.docs[i]['inStorePickup'] ? "✅️" : "❌"} - in store pickup",
                                  ),
                                  Text(
                                    "${docs.docs[i]['inStoreShopping'] ? "✅️" : "❌"} - in store shopping",
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: BitmapDescriptor.fromBytes(markerImage),
            position: LatLng(docs.docs[i]['latLong'].latitude as double,
                docs.docs[i]['latLong'].longitude as double),
            infoWindow: InfoWindow(
                title: docs.docs[i]['name'], snippet: docs.docs[i]['address']),
          );
          if (this.mounted) {
            setState(() {
              // adding a new marker to map
              markers[MarkerId(docs.docs[i].id)] = marker;
            });
          }
        }
      }
    });
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

  // _onMapCreated(GoogleMapController googleMapController) {
  //   setState(() {
  //     controller.complete(googleMapController);
  //   });
  // }

  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition == null
          ? kLoadingNoLogo
          : Container(
              child: Stack(children: <Widget>[
                GoogleMap(
                  markers: Set<Marker>.of(markers.values),
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
                ),
              ]),
            ),
    );
  }
}
