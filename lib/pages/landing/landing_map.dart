import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nf_kicks/constants.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/pages/store/store_page.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/product_card.dart';
import 'package:provider/provider.dart';

class LandingMap extends StatefulWidget {
  @override
  _LandingMapState createState() => _LandingMapState();
}

class _LandingMapState extends State<LandingMap> {
  Completer<GoogleMapController> _controller = Completer();

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

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    if (this.mounted) {
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    }
  }

  void _recenterCamera() async {
    final GoogleMapController controller = await _controller.future;
    LatLng currentLocation = _initialPosition;

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 14.4746,
      ),
    ));
  }

  MapType _currentMapType = MapType.normal;

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
            Set<Marker> _markers = Set<Marker>();

            if (snapshot.hasError) {
              print("Errors: ${snapshot.error}");
              return kLoadingLogo;
            }

            if (!snapshot.hasData) {
              return kLoadingNoLogo;
            }

            snapshot.data.forEach((element) async {
              _markers.add(
                Marker(
                  markerId: MarkerId(element.id) ?? MarkerId(''),
                  icon: BitmapDescriptor.defaultMarkerWithHue(20.00),
                  position: LatLng(element.latLong.latitude,
                          element.latLong.longitude) ??
                      LatLng(0, 0),
                  infoWindow: InfoWindow(
                          title: element.name, snippet: element.address) ??
                      InfoWindow(title: '', snippet: ''),
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
            });

            return _buildGoogleMaps(_markers);
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
      child: Container(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Center(
              child: RaisedButton(
                onPressed: () => !_isStoreClosed
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => storePage),
                      )
                    : showToast(context, "Store is closed!"),
                color: !_isStoreClosed ? Colors.deepOrangeAccent : Colors.grey,
                child: Text(
                  !_isStoreClosed ? "Go to store" : "Store Closed",
                  style: GoogleFonts.permanentMarker(
                      color: Colors.white, fontSize: 30),
                ),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)), //here
              image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment(-1.0, -1),
                  image: NetworkImage(storeImage)),
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
          Container(
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.deepOrangeAccent, width: 2),
              ),
              onPressed: _recenterCamera,
              color: Colors.white,
              textColor: Colors.deepOrangeAccent,
              icon: Icon(Icons.navigation_outlined),
              label: Text("Recenter".toUpperCase(),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
