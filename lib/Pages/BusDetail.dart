class Bus{
  String bus_id='';
  String bus_name='';
  String bus_type='';
  bool bus_active_status=true;
  String source='';
  String destination='';
  String departureTime='';
  bool is_on=true;
  String routes='';

  Bus(
      this.bus_id,
      this.bus_name,
      this.bus_type,
      this.bus_active_status,
      this.source,
      this.destination,
      this.departureTime,
      this.is_on,
      this.routes);

  factory Bus.fromJson(dynamic json) {
    return Bus(json['bus_id'] as String, json['bus_name'] as String,json['bus_type'] as String,json['bus_active_status'] as bool,json['source'] as String,json['destination'] as String,json['departureTime'] as String,json['is_on'] as bool,json['routes'] as String);
  }

}