import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nf_kicks/models/order.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../constants.dart';

class OrdersPage extends StatelessWidget {
  final DatabaseApi dataStore;

  const OrdersPage({Key key, this.dataStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Store>>(
      stream: dataStore.storesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Errors: ${snapshot.error}");
          return kLoadingLogo;
        }

        if (!snapshot.hasData) {
          return kLoadingLogo;
        }

        return DefaultTabController(
          length: snapshot.data.length,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Orders",
                style: GoogleFonts.permanentMarker(),
              ),
              automaticallyImplyLeading: true,
              bottom: TabBar(
                indicatorColor: Colors.white,
                isScrollable: true,
                tabs: [
                  for (final tab in snapshot.data)
                    Tab(
                      child: Text(tab.name),
                    ),
                ],
              ),
              backgroundColor: Colors.deepOrangeAccent,
            ),
            body: TabBarView(
              children: [
                for (final tab in snapshot.data)
                  StreamBuilder<List<Order>>(
                    stream: dataStore.ordersStream(storeOrderName: tab.name),
                    builder:
                        (context, AsyncSnapshot<List<Order>> snapshotData) {
                      if (snapshotData.hasError) {
                        print("Errors: ${snapshotData.error}");
                        return kLoadingNoLogo;
                      }
                      if (!snapshotData.hasData) {
                        return kLoadingNoLogo;
                      }

                      return ListView.builder(
                        itemCount: snapshotData.data.length,
                        itemBuilder: (context, index) {
                          if (snapshotData.data.isNotEmpty) {
                            return ExpansionTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    new DateFormat('d MMM, HH:mm a').format(
                                        snapshotData.data[index].dateOpened
                                            .toDate()),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.card_travel),
                                    onPressed: () => print("Ready for pickup"),
                                  ),
                                ],
                              ),
                              children: [
                                QrImage(
                                  data: snapshotData.data[index].id,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                ),
                              ],
                            );
                          } else {
                            return kLoadingNoLogo;
                          }
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
