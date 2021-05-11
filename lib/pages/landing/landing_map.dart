// Dart imports:
import 'dart:async';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/pages/store/store_page.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/constants.dart';
import 'package:nf_kicks/widgets/product_card.dart';

class LandingMap extends StatefulWidget {
  @override
  _LandingMapState createState() => _LandingMapState();
}

class _LandingMapState extends State<LandingMap> {
  final Completer<GoogleMapController> _controller = Completer();

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

  Future<void> _getUserLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    if (mounted) {
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    }
  }

  Future<void> _recenterCamera() async {
    final GoogleMapController controller = await _controller.future;
    final LatLng currentLocation = _initialPosition;

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 14.4746,
      ),
    ));
  }

  final MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return _initialPosition == null
        ? kLoadingNoLogo
        : _buildGoogleMapsWithMarkers();
  }

  GoogleMap _buildGoogleMaps(Set<Marker> markers) {
    return GoogleMap(
      markers: markers,
      mapType: _currentMapType,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: 14.4746,
      ),
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      myLocationEnabled: true,
      compassEnabled: false,
      myLocationButtonEnabled: false,
    );
  }

  Widget _buildGoogleMapsWithMarkers() {
    final database = Provider.of<DatabaseApi>(context, listen: false);

    return Stack(
      children: [
        StreamBuilder<List<Store>>(
          stream: database.storesStream(),
          builder: (context, snapshot) {
            Set<Marker> _markers = <Marker>{};

            if (snapshot.hasError) {
              return kLoadingLogo;
            }

            if (!snapshot.hasData) {
              return kLoadingNoLogo;
            }

            for (final element in snapshot.data) {
              _markers.add(
                Marker(
                  markerId: MarkerId(element.id) ?? MarkerId(''),
                  icon: BitmapDescriptor.defaultMarkerWithHue(20.00),
                  position: LatLng(element.latLong.latitude,
                          element.latLong.longitude) ??
                      const LatLng(0, 0),
                  infoWindow: InfoWindow(
                          title: element.name, snippet: element.address) ??
                      const InfoWindow(title: '', snippet: ''),
                  onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return storeBottomDrawer(
                            StorePage(storeId: element.id, dataStore: database),
                            element.storeImage,
                            element.inStoreShopping,
                            element.inStorePickup);
                      }),
                ),
              );
            }

            return _buildGoogleMaps(_markers);
          },
        ),
        Column(
          children: [
            recenterButton(),
            Expanded(
              flex: 9,
              child: Container(),
            ),
          ],
        ),
      ],
    );
  }

  GestureDetector storeBottomDrawer(
      Widget storePage, String storeImage, bool shopping, bool pickup) {
    bool _isStoreClosed;
    if (!shopping && !pickup) {
      _isStoreClosed = true;
    } else {
      _isStoreClosed = false;
    }
    return GestureDetector(
      onTap: () => !_isStoreClosed
          ? Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => storePage),
            )
          : showToast(context, "Store is closed!"),
      child: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)), //here
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: const Alignment(-1.0, -1),
                image: NetworkImage(storeImage),
              ),
            ),
            child: Center(
              child: ButtonTheme(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      !_isStoreClosed ? Colors.deepOrangeAccent : Colors.grey,
                    ),
                  ),
                  onPressed: () => !_isStoreClosed
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => storePage),
                        )
                      : showToast(context, "Store is closed!"),
                  child: Text(
                    !_isStoreClosed ? "Go to store" : "Store Closed",
                    style: GoogleFonts.permanentMarker(
                        color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded recenterButton() {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ButtonTheme(
            child: ElevatedButton.icon(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(
                        color: Colors.deepOrangeAccent, width: 2),
                  ),
                ),
                minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: _recenterCamera,
              label: Text("Recenter".toUpperCase(),
                  style: const TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              icon: const Icon(
                Icons.navigation_outlined,
                color: Colors.deepOrangeAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
