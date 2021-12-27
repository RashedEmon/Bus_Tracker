import 'package:flutter/material.dart';

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
      body: const Center(
        child: Text(
          'Google Map',
        ),
      ),
    );
  }
}
