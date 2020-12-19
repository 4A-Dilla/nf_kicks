import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nf_kicks/models/order.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/product_card.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:toast/toast.dart';

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
                tabs: <Tab>[
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
                        // print("Errors: ${snapshotData.error}");
                        return kLoadingNoLogo;
                      }
                      if (!snapshotData.hasData) {
                        return Column(
                          children: [
                            kLoadingNoLogo,
                          ],
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshotData.data.length,
                        itemBuilder: (context, index) {
                          if (snapshotData.data.isNotEmpty) {
                            return orderInfo(
                                context,
                                snapshotData.data[index].dateOpened.toDate(),
                                snapshotData.data[index].readyForPickup,
                                snapshotData.data[index].isComplete,
                                snapshotData.data[index].id);
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

ExpansionTile orderInfo(BuildContext context, DateTime dateOpened,
    bool readyForPickup, bool completed, String id) {
  Color _color;
  IconData _buttonIcon;
  String _toastMsg;

  if (readyForPickup == true && completed == true) {
    _color = Colors.green;
    _buttonIcon = Icons.check;
    _toastMsg = "Order completed!";
  } else if (readyForPickup == true && completed == false) {
    _color = Colors.blue;
    _buttonIcon = Icons.card_travel;
    _toastMsg = "Order is ready for pickup!";
  } else {
    _color = Colors.black;
    _buttonIcon = Icons.history;
    _toastMsg = "Order is being processed!";
  }

  return ExpansionTile(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          DateFormat('d MMM, HH:mm a').format(dateOpened),
          style: TextStyle(
            color: _color,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          color: _color,
          icon: Icon(_buttonIcon),
          onPressed: () => showToast(context, _toastMsg, gravity: Toast.CENTER),
        ),
      ],
    ),
    children: <QrImage>[
      QrImage(
        data: id,
        version: QrVersions.auto,
        size: 200.0,
      ),
    ],
  );
}
