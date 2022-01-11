import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bus_tracker/Pages/Bus_Details.dart';
import 'package:bus_tracker/Pages/Bus_Location.dart';
import 'package:http/http.dart' as http;
import '../Pages/BusDetail.dart';

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
        home: const Home(),
      )
  );
}


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String dropdownValue='One';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> startingPlaces=['DSC', 'Dhanmondi', 'Uttora'];
  List<String> days=['Saturday', 'Sunday', 'Monday','Tuesday','Wednesday','Thursday','Friday'];
  List<String> destinationPlaces=['DSC', 'Dhanmondi', 'Uttora'];
  List entries=[];

  String _startingPlace='';
  String _day='';
  String _destinationPlace='';
  var client = http.Client();
  search() async{
    var uri=Uri(scheme: 'http',host: '192.168.1.120',port: 8000,path: 'api/search/$_startingPlace/$_destinationPlace',);
    print(uri.toString());
    http.Response response;
    try {
      response = await client.get(uri);
      //print(jsonDecode(response.body).runtimeType);
      var ls;
      if(response.statusCode<400 && response.statusCode>=200){
        ls=jsonDecode(response.body) as List;
      }


        setState(() {
          if(response.statusCode<400 && response.statusCode>=200) {
            entries = ls.map((e) => Bus.fromJson(e)).toList();
          }else{
            entries=[];
          }
        });



      return response.body;
    } on Exception catch(e) {
      print(e);
    }
    return '';
  }
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
                    onPressed: () async{
                      search();

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
              ): const Center(
                child: Text('No Bus Found',),
              ),
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
                                    '${index+1}. ${entries[index].bus_name}',
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
                              key: Key("Detail${entries[index].bus_name}"),
                                onPressed: (){
                                  Navigator.pushNamed(context, '/BusDetails');
                                },
                                icon: const Icon(
                                Icons.info_rounded,
                                color: Colors.blue,
                                ),
                            ),
                            IconButton(
                              key: Key('Location${entries[index].bus_name}'),
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
                    ): const Card(child: Center(
                      child: Text('No Bus Found',),
                    ),);
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
