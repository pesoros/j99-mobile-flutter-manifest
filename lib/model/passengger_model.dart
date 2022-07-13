// ignore_for_file: non_constant_identifier_names, unnecessary_new, prefer_collection_literals, unnecessary_this, avoid_print

class PassenggerModel {
  String name;
  String ticket_number;
  String seat_number;
  String food_name;
  String baggage;
  String checkin_status;
  String pickup_trip_location;
  String drop_trip_location;
  String url_print;

  PassenggerModel({
    this.name,
    this.ticket_number,
    this.seat_number,
    this.food_name,
    this.baggage,
    this.checkin_status,
    this.pickup_trip_location,
    this.drop_trip_location,
    this.url_print,
  });

  PassenggerModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ticket_number = json['ticket_number'];
    seat_number = json['seat_number'];
    food_name = json['food_name'];
    baggage = json['baggage'];
    checkin_status = json['checkin_status'];
    pickup_trip_location = json['pickup_trip_location'];
    drop_trip_location = json['drop_trip_location'];
    url_print = json['url_print'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['ticket_number'] = this.ticket_number;
    data['seat_number'] = this.seat_number;
    data['food_name'] = this.food_name;
    data['baggage'] = this.baggage;
    data['checkin_status'] = this.checkin_status;
    data['pickup_trip_location'] = this.pickup_trip_location;
    data['drop_trip_location'] = this.drop_trip_location;
    data['url_print'] = this.url_print;

    return data;
  }
}
