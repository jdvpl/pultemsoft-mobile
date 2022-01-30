import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internediowidget/models/user.dart';
import 'package:internediowidget/providers/client_provider.dart';

class InfoController {
  BuildContext context;
  Function refresh;
  String id;
  UserProvider _userprovider;
  User user;

  StreamSubscription<DocumentSnapshot> _clientInfoSubscription;
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    Map<String, dynamic> arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    id = await arguments["id"];
    print("id user ${id}");
    _userprovider = new UserProvider();

    setInfo(id);
    refresh();
  }

  // obtiene la informacion del usuario
  void getUserInfo() {
    Stream<DocumentSnapshot> particularStream =
        _userprovider.getByIdStream(id ?? "");
    _clientInfoSubscription =
        particularStream.listen((DocumentSnapshot document) {
      // aca trae la info de la base de datos
      user = User.fromJson(document.data());
      print(user);
      print(user.Ir);
      print(user.distance);
      refresh();
    });
  }

  void setInfo(idU) async {
    if (idU != null) {
      getUserInfo();
    }
  }
}
