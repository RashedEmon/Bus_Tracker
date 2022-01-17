import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bus_tracker/Pages/Bus_Details.dart';
import 'package:bus_tracker/Pages/Bus_Location.dart';
import 'package:http/http.dart' as http;
import '../Pages/BusDetail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(
      MaterialApp(
        title: 'Bus Tracker',
        // routes: {
        //   // '/BusDetails': (context)=> const BusDetail(bus: ,),
        //   // '/BusLocation': (context)=> const BusLocation(),
        // },
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
  //List<String> days=['Saturday', 'Sunday', 'Monday','Tuesday','Wednesday','Thursday','Friday'];
  List<String> destinationPlaces=['DSC', 'Dhanmondi', 'Uttora'];
  List entries=[];
  bool isNotFound=false;
  bool networkError=false;
  String _startingPlace='';
  String _destinationPlace='';
  bool isLoading=false;
  bool searchShouldPerform=false;
  var client = http.Client();
  search() async{
    setState(() {
      isLoading=true;
      isNotFound=false;
      networkError=false;
    });
    var uri=Uri(scheme: 'http',host: '192.168.1.120',port: 8000,path: 'api/search/$_startingPlace/$_destinationPlace',);
    print(uri.toString());
    http.Response response;
    try {
      response = await client.get(uri);
      //print(jsonDecode(response.body).runtimeType);
      var ls;
      if(response.statusCode<400 && response.statusCode>=200){
        ls=jsonDecode(response.body) as List;
      }else{
        if(response.statusCode==404){
          setState(() {
            isNotFound=true;
            networkError=false;
            isLoading=false;
          });
        }else{
          setState(() {
            networkError=true;
            isNotFound=false;
            isLoading=false;
          });
        }

      }


        setState(() {
          if(response.statusCode<400 && response.statusCode>=200) {
            isLoading=false;
            entries = ls.map((e) => Bus.fromJson(e)).toList();
          }else{
            entries=[];
          }
        });

      return response.body;
    } on Exception catch(e) {
      print(e);
      if(e.toString().contains('Network is unreachable')){
        debugPrint('please check your internet connection');
      }
      setState(() {
        networkError=true;
        isNotFound=false;
        isLoading=false;
      });
    }
    return '';
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    print(_startingPlace+_destinationPlace);
                    debugPrint('enter');
                    setState(() {
                      _startingPlace=val.toString();
                      if( _startingPlace!='' && _destinationPlace!='' && val.toString()!=_destinationPlace){
                        print('enter if starting');
                        searchShouldPerform=true;
                      }else{
                        debugPrint('enter else starting');
                        searchShouldPerform=false;
                      }

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
                    print(_startingPlace+_destinationPlace);
                    setState(() {
                      _destinationPlace=val.toString();
                      if( _startingPlace!='' && _destinationPlace!='' && val.toString()!=_startingPlace){
                        print('enter if destination');
                        searchShouldPerform=true;
                      }else{
                        debugPrint('enter else destination');
                        searchShouldPerform=false;
                      }
                    });

                  },
                ),
                const SizedBox(height: 25,),
                ElevatedButton(
                    onPressed: searchShouldPerform?() async{
                      search();

                    }:null,
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
                child: Text('',),
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
                              key: Key("Detail${entries[index].bus_name}"),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BusDetail(bus: entries[index]),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                Icons.info_rounded,
                                color: Colors.blue,
                                ),
                            ),
                            IconButton(
                              key: Key('Location${entries[index].bus_name}'),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BusLocation(bus: entries[index]),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                ),
                                )
                          ]
                    ),
                        )
                    ): const Text('');
                  }
              ),
              const SizedBox(height: 20,),
              isNotFound? const Card(
                color: Colors.redAccent,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No Bus Found',
                    style: TextStyle(
                        color: Colors.white,
                    ),
                    ),
                  ),
              ),):const Text(''),
              networkError? const Card(
                color: Colors.redAccent,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('Network Problem',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),):const Text(''),
              isLoading? const Center(
                child: SpinKitCircle(
                  color: Colors.blue,
                  size: 50.0,
                ),
              ):const Text('')
          ]
          ),

        ),

        ),
      ),

       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
