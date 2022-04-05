// ignore_for_file: non_constant_identifier_names, prefer_collection_literals, unnecessary_this, avoid_print, unnecessary_new

class FinanceListModel {
  String description;
  String nominal;
  String action;
  String created_at;

  FinanceListModel({
    this.description,
    this.nominal,
    this.action,
    this.created_at,
  });

  FinanceListModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    nominal = json['nominal'];
    action = json['action'];
    created_at = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['nominal'] = this.nominal;
    data['action'] = this.action;
    data['created_at'] = this.created_at;

    return data;
  }
}
