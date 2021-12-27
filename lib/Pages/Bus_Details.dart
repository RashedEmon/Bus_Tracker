import 'package:flutter/material.dart';

class BusDetail extends StatefulWidget {
  const BusDetail({Key? key}) : super(key: key);

  @override
  _BusDetailState createState() => _BusDetailState();
}

class _BusDetailState extends State<BusDetail> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: const Center(
            child: Text(
              'Bus Details',
            ),
          ),
      ),
      body: const Text('Bus Details'),
      );
  }
}
