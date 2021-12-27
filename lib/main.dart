import 'package:flutter/material.dart';
import 'package:bus_tracker/Pages/Bus_Details.dart';
import 'package:bus_tracker/Pages/Bus_Location.dart';

void main() {
  runApp(
      MaterialApp(
        title: 'Bus Tracker',
        routes: {
          '/BusDetails': (context)=> const BusDetail(),
          '/BusLocation': (context)=> const BusLocation(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home(),
      )
  );
}


class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String dropdownValue='One';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> startingPlaces=['DSC', 'Dhanmondi', 'Uttora'];
  List<String> days=['Saturday', 'Sunday', 'Monday','Tuesday','Wednesday','Thursday','Friday'];
  List<String> destinationPlaces=['DSC', 'Dhanmondi', 'Uttora'];
  List entries=['surjomukhi-1','surjomukhi-2','surjomukhi-3','surjomukhi-4','surjomukhi-5','surjomukhi-6','surjomukhi-7','surjomukhi-8','surjomukhi-9','surjomukhi-10'];

  String _startingPlace='';
  String _day='';
  String _destinationPlace='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Center(
          child: Text(
            'Bus Tracker',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
              children: <Widget>[
                DropdownButtonFormField(
                  alignment: AlignmentDirectional.centerStart,
                  hint: const Text('Select Starting Place'),
                  icon: const Icon(
                      Icons.list,
                    color: Colors.blue,
                  ),
                  items: startingPlaces.map((place){
                      return DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                          value: place,
                          child: Text(
                              place,
                          ),
                      );
                    }).toList(),
                  onChanged: (val){
                    setState(() {
                      _startingPlace=val.toString();
                    });
                  },
                ),
                DropdownButtonFormField(
                  alignment: AlignmentDirectional.centerStart,
                  hint: const Text('Select Day'),
                  icon: const Icon(
                    Icons.list,
                    color: Colors.blue,
                  ),
                  items: days.map((day){
                    return DropdownMenuItem(
                      alignment: AlignmentDirectional.center,
                      value: day,
                      child: Text(day),
                    );
                  }).toList(),
                  onChanged: (val){
                    setState(() {
                      _day=val.toString();
                    });
                  },
                ),
                DropdownButtonFormField(
                  alignment: AlignmentDirectional.centerStart,
                  hint: const Text('Select Destination Place'),
                  icon: const Icon(
                    Icons.list,
                    color: Colors.blue,
                  ),
                  items: destinationPlaces.map((place){
                    return DropdownMenuItem(
                      alignment: AlignmentDirectional.center,
                      value: place,
                      child: Text(place),
                    );
                  }).toList(),
                  onChanged: (val){
                    setState(() {
                      _destinationPlace=val.toString();
                    });
                  },
                ),
                const SizedBox(height: 25,),
                ElevatedButton(
                    onPressed: (){
                      print(_startingPlace);
                      print(_day);
                      print(_destinationPlace);
                    },
                    child: const Text('Search',),
                ),
              ],
            ),
              const SizedBox(height: 20,),
              entries.isNotEmpty? const Card(
                child: Center(
                  child: Text(
                    'Bus List',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ):
              const SizedBox(height: 20,),
              ListView.builder(
                  itemCount: entries.length,
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  addAutomaticKeepAlives: true,
                  itemBuilder: (BuildContext context, int index){
                    return entries.isNotEmpty? Card(
                      color: Colors.grey[250],
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Row(
                          children: [
                            Expanded(
                                flex: 12,
                                child: Text(
                                    '${index+1}. ${entries[index]}',
                                )
                                ),
                            IconButton(
                                onPressed: (){
                                  Navigator.pushNamed(context, '/BusDetails');
                                },
                                icon: const Icon(
                                Icons.info_rounded,
                                color: Colors.blue,
                                ),
                            ),
                            IconButton(
                                onPressed: (){
                                  Navigator.pushNamed(context, '/BusLocation');
                                },
                                icon: const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                ),
                                )
                          ]
                    ),
                        )
                    ): const Center(
                      child: Text('No Bus Found',),
                    );
                  }
              )
          ]
          ),

        ),

        ),
      ),

       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
