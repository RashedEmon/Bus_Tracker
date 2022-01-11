
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class BusLocation extends StatefulWidget {
  const BusLocation({Key? key}) : super(key: key);

  @override
  _BusLocationState createState() => _BusLocationState();
}

class _BusLocationState extends State<BusLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Location'),
      ),
      body: MyApp()
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  //final Completer<GoogleMapController> _controller = Completer();
  dynamic _locationSubscription;
  Location _locationTracker = Location();
  late Marker marker=Marker(markerId: MarkerId('bus'));
  late Circle circle = Circle(circleId: CircleId('buscircle'));
  late GoogleMapController _controller;

  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.777176, 90.399452),
    zoom: 18,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load('assets/bus.png');
    return byteData.buffer.asUint8List();
  }

  void UpdateMarkerAndCircle(LocationData newLocalData, Uint8List imageData){

      LatLng latLng = LatLng(newLocalData.latitude!,newLocalData.longitude!);
      setState(() {
        marker=Marker(
          markerId: MarkerId('Bus'),
          draggable: false,
          flat: true,
          position: latLng,
          zIndex: 2,
          rotation: newLocalData.heading!,
          anchor: Offset(0.5,0.5),
          icon: BitmapDescriptor.fromBytes(imageData)

        );

            circle=Circle(
              circleId: CircleId('buscircle'),
              radius: newLocalData.accuracy!,
              center: latLng,
              zIndex: 1,
              strokeColor: Colors.blue,
              fillColor: Colors.blue.withAlpha(70)
            );
      });
  }
void permissiion() async{
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
}
  void getCurrentLocation() async {
    try {
      permissiion();
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      UpdateMarkerAndCircle(location, imageData);
        if(_locationSubscription != null){
          _locationSubscription.cancel();
        }
      _locationSubscription=_locationTracker.onLocationChanged.listen((LocationData newLocalData){
        if(_controller != null){
          _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            bearing: 192.83349,
            target: LatLng(newLocalData.latitude!,newLocalData.longitude!),
            tilt: 0,
            zoom: 19.000
          )));

        }
        UpdateMarkerAndCircle(newLocalData,imageData);
      });
    } on PlatformException catch (e){
      debugPrint(e.message);
    }
}
void dispose(){
    if(_locationSubscription != null){
      _locationSubscription.cancel();
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller=controller;
         // getCurrentLocation();
        },
        markers: Set.of((marker != null)? [marker]:[]),
        circles: Set.of((circle != null)? [circle]:[]),

      ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            getCurrentLocation();
          },
          label: Text('To the lake!'),
          icon: Icon(Icons.directions_boat),
        )
    );
  }
}