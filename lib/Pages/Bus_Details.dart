import 'package:flutter/material.dart';
import '../Pages/BusDetail.dart';
class BusDetail extends StatelessWidget {
  const BusDetail({Key? key, required this.bus}) : super(key: key);
   final Bus bus;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bus.bus_name),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                child: Text(
                  'Starting: ${bus.source}'
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                child: Text(
                    'Destination: ${bus.destination}'
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                child: Text(
                    'Departure Time: ${int.parse(bus.departureTime.substring(0,2))<12?'${bus.departureTime.substring(0,5)} AM':'${int.parse(bus.departureTime.substring(0,2))-12}:${bus.departureTime.substring(3,5)} PM'}'
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                child: Text(
                    'Bus Type: ${bus.bus_type=='ST'?'Student':'Stuff'}'
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                child: Text(
                    'Routes: ${bus.routes.split(',').join(' -> ')}'
                ),
              ),
            ),
          ],
        ),

    );
  }
}
