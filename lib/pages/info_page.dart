import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:internediowidget/constants/constants.dart';
import 'package:internediowidget/controllers/info_controller.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class InfoPage extends StatefulWidget {
  InfoPage({Key key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  InfoController _con = new InfoController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle del usuario"),
        backgroundColor: black,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _bannerInfoCLient(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerInfoCLient() {
    return ClipPath(
      clipper: DiagonalPathClipperTwo(),
      child: Container(
        height: MediaQuery.of(context).size.height * .25,
        width: double.infinity,
        color: black,
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/enfermo.png'),
              radius: 50,
              backgroundColor: black,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                _con.user?.name ?? "",
                style: TextStyle(
                  color: white,
                  fontSize: 19,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
