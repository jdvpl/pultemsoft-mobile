import 'package:internediowidget/utils/responsive.dart';
import 'package:internediowidget/widgets/circle.dart';
import 'package:internediowidget/widgets/icon_container.dart';
import 'package:internediowidget/widgets/login_form.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // clase responsive
    final Responsive responsive = Responsive.of(context);
    final double pinkSize = responsive.wp(80);
    final double orangeSize = responsive.wp(57);

    return Scaffold(
      key: key,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: responsive.height,
            color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: -pinkSize * .4,
                  right: -pinkSize * .2,
                  child: Circle(
                    size: pinkSize,
                    colors: [
                      Colors.black,
                      Colors.black87,
                    ],
                  ),
                ),
                Positioned(
                  top: -orangeSize * .55,
                  left: -orangeSize * .15,
                  child: Circle(
                    size: orangeSize,
                    colors: [
                      Colors.black54,
                      Colors.black26,
                    ],
                  ),
                ),
                Positioned(
                  top: pinkSize * 0.37,
                  child: Column(
                    children: [
                      IconContainer(size: responsive.wp(17)),
                      SizedBox(
                        height: responsive.hp(3),
                      ),
                      Text(
                        "Hola\nBienvenido!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: responsive.dp(2)),
                      )
                    ],
                  ),
                ),
                LoginForm(),
                _btnMenuDrawer(responsive.hp(5)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnMenuDrawer(double top) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: top),
      child: IconButton(
        onPressed: () {
          key.currentState.openDrawer();
        },
        icon: Icon(
          Icons.menu,
          size: 30.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
