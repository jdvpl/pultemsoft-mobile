import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internediowidget/environment/environment.dart';
import 'package:internediowidget/providers/geofire_provider.dart';
import 'package:internediowidget/utils/map_style.dart';
import 'package:internediowidget/utils/snackbar.dart' as utils;
import 'package:location/location.dart' as location;
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:flutter_google_places/flutter_google_places.dart';

class MapController {
  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition =
      CameraPosition(target: LatLng(4.60971, -74.08175), zoom: 10.0);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position _position;
  StreamSubscription<Position> _positionStream;

  BitmapDescriptor markerDriver;
  // instanciar el geofireprovider
  GeofireProvider _geofireProvider;
  // auth provider desde la base de datos
  // stado del eschador
  // stado del eschador de la info del usuario
  StreamSubscription<DocumentSnapshot> _clientInfoSubscription;
  StreamSubscription<DocumentSnapshot> _driverInfoSubscription;
  // instanciar el client provider

  // string para almacenar el origen
  String from;
  // para almacenar la latitude y longitude que estamos seleccionando en el mapa origen
  LatLng fromLatlng;
  // string para almacenar el origen
  String to;
  // para almacenar la latitude y longitude que estamos seleccionando en el mapa
  LatLng toLatlng;

  // para saber si esta en el select de origen o destino
  bool isFromSelected = true;
  // variable para instanciar lo de google places
  places.GoogleMapsPlaces _places =
      places.GoogleMapsPlaces(apiKey: Environment.API_KEY_MAPS);

  String ciudad;
  String departmento;
  String typeUser = "Particulares";
  List<String> idsDriver = new List();

// metodo init
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    // instanciar los providers
    _geofireProvider = new GeofireProvider();

    markerDriver = await createMarkerImageFromAsset("assets/usuario1.png");

    checkGPS();
  }

  // coloca los parametros para el mapa
  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(jsonEncode(mapsStyle));
    _mapController.complete(controller);
  }

// actualiza la ubicacion
  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      // centrar pantalla
      // obtiene los conducores
      getNearbyDrivers();
      refresh();
      centerPosition();

// cada vez que el usuario se mueve

      _positionStream = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.best, distanceFilter: 30)
          .listen((Position position) {
        _position = position;

        // animacion de la camara a la ubicacion actual
        animateCameraToPosition(_position.latitude, _position.longitude);
        // guarda la ubicacion
        // refresca la pantalla
        refresh();
      });
    } catch (error) {
      print('Error en la localizacion: $error');
    }
  }
  // la camara se ubicaca en la posicion actual del conductor

  void centerPosition() {
    if (_position != null) {
      animateCameraToPosition(_position.latitude, _position.longitude);
    } else {
      utils.Snackbar.showSnackbar(context, key, 'Activa el GPS para continuar');
      Geolocator.openAppSettings();
    }
  }

// verifica si el gps esta activado
  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      updateLocation();
    } else {
      // booleano para activar el gps
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }

// determina la posicion actual del dispositivo
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Gps desactivado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Los permisos fueron negados.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
  // metodo para la animacion de la camara

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: _position.heading,
          target: LatLng(latitude, longitude),
          zoom: 17)));
    }
  }
  // metodo para colocar la imagen

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }
  // metodo para agregar un marcador personalizado

  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        rotation: _position.heading);

    markers[id] = marker;
  }

  // eliminanddo los escuchadores
  void dispose() {
    _positionStream?.cancel();
    _clientInfoSubscription?.cancel();
    _driverInfoSubscription?.cancel();
  }

  // obitne los conductores cercanos
  void getNearbyDrivers() {
    Stream<List<DocumentSnapshot>> stream = _geofireProvider.getNearbyDrivers(
        // aca es donde busca los conductores a la distancia que le indiquemos
        _position.latitude,
        _position.longitude,
        15);
    stream.listen((List<DocumentSnapshot> documentList) {
      for (MarkerId m in markers.keys) {
        bool remove = true;
        for (DocumentSnapshot d in documentList) {
          if (m.value == d.id) {
            remove = false;
          }
        }
        if (remove) {
          markers.remove(m);
          refresh();
        }
      }

      // aca acede a la referencia de la base de datos
      for (DocumentSnapshot d in documentList) {
        GeoPoint point = d.data()['position']['geopoint'];
        String id = d.id;
        String name = d.data()['name'];
        double rating = d.data()['rating'];

        if (!idsDriver.contains(id)) {
          idsDriver.add(id);
        }
        print("conductores lista $idsDriver");

        addMarker(d.id, point.latitude, point.longitude, name,
            rating.toStringAsFixed(2), markerDriver);
      }

      refresh();
    });
  }

// metodo para obtener la ubicacion del icono
  Future<Null> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;
      List<Placemark> address = await placemarkFromCoordinates(lat, lng);
      if (address != null) {
        if (address.length > 0) {
          // retorna el nombre de la direccion
          String direction = address[0].thoroughfare;
          String street = address[0].subThoroughfare;
          String city = address[0].locality;
          String department = address[0].administrativeArea;

          ciudad = city;
          departmento = department;

          if (isFromSelected) {
            from = '$direction #$street';
            fromLatlng = new LatLng(lat, lng);
          } else {
            to = '$direction #$street';
            toLatlng = new LatLng(lat, lng);
          }

          refresh();
        }
      }
    }
  }

  // metodo para el autocomplete
  Future<Null> showGoogleAutoComplete(bool idFrom) async {
    places.Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: Environment.API_KEY_MAPS,
        language: 'es',
        strictbounds: true,
        radius: 50000,
        // aca coloca la latitud y longitud refrenciales a la ciudad
        location: places.Location(_position.latitude, _position.longitude));
    if (p != null) {
      places.PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId, language: 'es');
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      List<Address> address =
          await Geocoder.local.findAddressesFromQuery(p.description);
      if (address != null) {
        if (address.length > 0) {
          if (detail != null) {
            String direction = detail.result.name;
            String city = address[0].locality;
            String department = address[0].adminArea;

            ciudad = city;
            departmento = department;

            // para fijar el texto si es en el autocompletado del origen o destino
            if (idFrom) {
              from = '$direction';
              fromLatlng = new LatLng(lat, lng);
            } else {
              to = '$direction';
              toLatlng = new LatLng(lat, lng);
            }
            refresh();
          }
        }
      }
    }
  }
}
