import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internediowidget/models/user.dart';

class UserProvider {
  CollectionReference _ref;
  userProvider() {
    _ref = FirebaseFirestore.instance.collection("users");
  }

  Future<User> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();

    if (document.exists) {
      User user = User.fromJson(document.data());
      return user;
    }

    return null;
  }

  // obtiene la data de los usuarios
  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  // metodo para actualizar campos en la base de datos
  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }
}
