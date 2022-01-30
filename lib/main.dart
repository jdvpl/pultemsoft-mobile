import 'package:flutter/material.dart';
import 'package:internediowidget/pages/info_page.dart';
import 'package:internediowidget/pages/map_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pultemsoft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "home",
      routes: {
        "home": (context) => MapPage(),
        "info": (context) => InfoPage(),
      },
    );
  }
}
