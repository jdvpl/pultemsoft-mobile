import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internediowidget/controllers/map_controller.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  MapController _con = new MapController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('¿Estas seguro?'),
            content: new Text('Realmente quieres salir de la aplicacion'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Si'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: key,
        body: Stack(
          children: [
            _googleMapsWidget(),
            SafeArea(
              child: Column(
                children: [
                  _cardGooglePlaceS(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _btnCenterPosition(),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: _iconMyLocation(),
            )
          ],
        ),
      ),
    );
  }

  Widget _btnCenterPosition() {
    return GestureDetector(
      onTap: _con.centerPosition,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 18),
        child: Card(
          shape: CircleBorder(),
          elevation: 5.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: Colors.black,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      onCameraMove: (position) {
        _con.initialPosition = position;
      },
      onCameraIdle: () async {
        await _con.setLocationDraggableInfo();
      },
    );
  }

  // icono
  Widget _iconMyLocation() {
    return Image.asset("assets/marker.png", width: 55, height: 55);
  }

  // carview
  Widget _cardGooglePlaceS() {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoCardLocation(
                  "Origen",
                  _con.from ?? "Lugar de Recogida",
                  () async {
                    await _con.showGoogleAutoComplete(true);
                  },
                  _buscarAutocomplete(
                    () async {
                      await _con.showGoogleAutoComplete(true);
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _infoCardLocation(
      String title, String value, Function function, Widget widget) {
    return GestureDetector(
      onTap: function,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                ),
              ),
              widget,
            ],
          ),
          GestureDetector(
            onTap: function,
            child: Text(
              value.toUpperCase(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  // boton para grabar audio del destino
  Widget _buscarAutocomplete(Function function) {
    return GestureDetector(
      onTap: function,
      child: Container(
        alignment: Alignment.centerRight,
        child: Card(
          shape: CircleBorder(),
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.search,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
