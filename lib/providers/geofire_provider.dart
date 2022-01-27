import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeofireProvider {
  CollectionReference _ref;
  Geoflutterfire _geo;

  GeofireProvider() {
    _ref = FirebaseFirestore.instance.collection('users');
    _geo = Geoflutterfire();
  }
  // creando el metodo para almacenar en la base de datos

  Future<void> create(String id, double lat, double lng, String typeUser) {
    // esto es lo que se guarda en la base de datos
    GeoFirePoint myLocation = _geo.point(latitude: lat, longitude: lng);
    return _ref
        .doc(id)
        .set({'status': '${typeUser}_available', 'position': myLocation.data});
  }
  // borra la posicion actual del conductor

  Future<void> delete(String id) {
    return _ref.doc(id).delete();
  }

  // verifica si esta en la base de datos
  Stream<DocumentSnapshot> getLocationByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  // para obtener la lista de los Conductores,
  Stream<List<DocumentSnapshot>> getNearbyDrivers(
      double lat, double lng, double radius) {
    GeoFirePoint center = _geo.point(latitude: lat, longitude: lng);
    return _geo
        .collection(collectionRef: _ref.where('status', isEqualTo: 'available'))
        .within(center: center, radius: radius, field: 'position');
  }
}
