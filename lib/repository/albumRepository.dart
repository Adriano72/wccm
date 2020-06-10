import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wccm/models/album.dart';

class AlbumRepository {
  final Query collection = Firestore.instance
      .collection('meditatiotalks')
      .orderBy('release_date', descending: true);

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
}
