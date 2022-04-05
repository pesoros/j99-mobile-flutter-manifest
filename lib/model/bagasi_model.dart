// ignore_for_file: non_constant_identifier_names, unnecessary_new, prefer_collection_literals, unnecessary_this, avoid_print

class BagasiModel {
  String code;
  String type_from;
  String status;
  String created_at;
  String from;
  String to;

  BagasiModel({
    this.code,
    this.type_from,
    this.status,
    this.created_at,
    this.from,
    this.to,
  });

  BagasiModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    type_from = json['type_from'];
    status = json['status'];
    created_at = json['created_at'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['type_from'] = this.type_from;
    data['status'] = this.status;
    data['created_at'] = this.created_at;
    data['from'] = this.from;
    data['to'] = this.to;

    return data;
  }
}
