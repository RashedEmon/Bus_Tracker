import 'dart:convert';
class LocationInfo{
  String latitude='';
  String longitude='';
  String bearing='';
  String speed='';
  String accuracy='';
  String time='';


  LocationInfo(this.latitude, this.longitude, this.bearing, this.speed,
      this.accuracy, this.time);


  factory LocationInfo.fromJson(dynamic json) {
    return LocationInfo(json['latitude'] as String, json['longitude'] as String,json['bearing'] as String,json['speed'] as String,json['accuracy'] as String,json['time'] as String);
  }

}