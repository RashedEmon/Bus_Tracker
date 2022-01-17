
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bus_tracker/Pages/LocationInformation.dart';
import 'dart:io';
import '../Pages/BusDetail.dart';


class BusLocation extends StatefulWidget {
  final Bus bus;
  const BusLocation({Key? key,required this.bus}) : super(key: key);

  @override
  _BusLocationState createState() => _BusLocationState();
}

class _BusLocationState extends State<BusLocation> {
  late Bus bus;
  // _BusLocationState(this.bus);
  //final Completer<GoogleMapController> _controller = Completer();
  dynamic _locationSubscription;
  // Location _locationTracker = Location();
  late Marker marker= Marker(markerId: MarkerId(bus.bus_name));
  late Circle circle = Circle(circleId: CircleId('${bus.bus_name}-circle'));
  late GoogleMapController _controller;

  dynamic _subscription;
  dynamic channel;
  bool socketOpen=true;
  //var channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.1.120:8000/ws/location/bus'));
//make socket connection
  Future<dynamic> createSocketConnection() async{
    //channel=WebSocketChannel.connect(Uri.parse('ws://192.168.1.120:8000/ws/location/bus1'));
    try{
      if(channel!=null){
        channel.close();
      }
      channel=await WebSocket.connect('ws://192.168.1.120:8000/ws/location/bus1',protocols: ['ws:']);
    }on SocketException catch(e){
      print('exception here');
      return 1;

    }
    return channel;
    //print(channel.closeReason);
  }

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.876150128, 90.320401691),
    zoom: 14,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load('assets/bus.png');
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationInfo newLocalData, Uint8List imageData){
    double lat=newLocalData.latitude!=''?double.parse(newLocalData.latitude):0.0;
    double lon=newLocalData.longitude!=''?double.parse(newLocalData.longitude):0.0;
    double bear=newLocalData.bearing!=''?double.parse(newLocalData.bearing): 192.0;
    double accu=newLocalData.accuracy!=''?double.parse(newLocalData.accuracy): 192.0;
      LatLng latLng = LatLng(lat,lon);
      setState(() {
        marker=Marker(
          markerId: const MarkerId('Bus'),
          draggable: false,
          flat: true,
          position: latLng,
          zIndex: 2,
          rotation: bear,
          anchor: const Offset(0.5,0.5),
          icon: BitmapDescriptor.fromBytes(imageData)

        );

            circle=Circle(
              circleId: const CircleId('bus-circle'),
              radius: accu,
              center: latLng,
              zIndex: 1,
              strokeColor: Colors.blue,
              fillColor: Colors.blue.withAlpha(70)
            );
      });
  }
// void permission() async{
//   _serviceEnabled = await location.serviceEnabled();
//   if (!_serviceEnabled) {
//     _serviceEnabled = await location.requestService();
//     if (!_serviceEnabled) {
//       return;
//     }
//   }
//
//   _permissionGranted = await location.hasPermission();
//   if (_permissionGranted == PermissionStatus.denied) {
//     _permissionGranted = await location.requestPermission();
//     if (_permissionGranted != PermissionStatus.granted) {
//       return;
//     }
//   }
// }
  void getCurrentLocation() async {

    LocationInfo locationInfo;
    dynamic socket;
    socket!=null? socket.close():'';
    try {
      //permission();
      Uint8List imageData = await getMarker();
      // var location = await _locationTracker.getLocation();
      // UpdateMarkerAndCircle(locationInfo, imageData);
      //   if(_locationSubscription != null){
      //     _locationSubscription.cancel();
      //   }
      socket=await createSocketConnection();
      if(socket is int){
            print('i am here');
      }
      _subscription!=null?_subscription.cancel():'';
      _subscription=socket.listen((message) async {

        locationInfo=LocationInfo.fromJson(jsonDecode(message));
        updateMarkerAndCircle(locationInfo,imageData);
        double lat=locationInfo.latitude!=''?double.parse(locationInfo.latitude):0.0;
        double lon=locationInfo.longitude!=''?double.parse(locationInfo.longitude):0.0;
        double bear=locationInfo.bearing!=''?double.parse(locationInfo.bearing): 192.0;

        _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: bear,
          target: LatLng(lat,lon),
          tilt: 0,
          zoom: await _controller.getZoomLevel()
        )));


      },
          onError: (e){
            socket.close();
            setState(() {
              socketOpen=!socketOpen;
            });

      },
          onDone: (){
            socket.close();
            _controller.dispose();
          }
      );
    } on Exception catch (e){
      debugPrint('Exception');
    }finally{

    }
}
@override
  void dispose(){
    super.dispose();
    // if(_locationSubscription != null){
    //   _locationSubscription.cancel();
    // }
  _subscription!=null?_subscription.cancel():"";
  channel!=null?channel.close():'';


}
// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getCurrentLocation();
//   }

  @override
  Widget build(BuildContext context) {
    setState(() {
      bus=widget.bus;
    });
    return WillPopScope(
      onWillPop: () {
        _subscription.cancel();
        channel.close();

          dispose();
          print('press on back');
          return Future<bool>.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.bus.bus_name),
        ),
        body: Stack(
          children:[
            GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller=controller;
              getCurrentLocation();
            },
            markers: Set.of((marker != null)? [marker]:[]),
            circles: Set.of((circle != null)? [circle]:[]),
          ),
          Positioned(
            bottom: 5,
              right: MediaQuery.of(context).size.width/3,
              left: MediaQuery.of(context).size.width/3,

              child: Visibility(
                visible: !socketOpen,
                child: ElevatedButton(
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.refresh_sharp),
                       Text('Retry'),
                    ],
                  ),
                  onPressed: (){

                  },
                ),
              )
          ),
          ]
        ),

      ),
    );
  }
}