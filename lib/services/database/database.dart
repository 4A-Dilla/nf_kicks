import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/services/api/store_api_path.dart';
import 'package:nf_kicks/services/database/database_api.dart';

class Database implements DatabaseApi {
  @override
  Stream<Store> storeStream({String storeId}) {
    final path = StoreAPIPath.store(storeId);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => Store.fromMap(
        snapshot.data(),
        snapshot.id,
      ),
    );
  }

  @override
  Stream<List<Store>> storesStream() {
    final path = StoreAPIPath.stores();
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map(
      (snapshot) => snapshot.docs
          .map(
            (snapshot) => Store.fromMap(
              snapshot.data(),
              snapshot.id,
            ),
          )
          .toList(),
    );
  }
}
