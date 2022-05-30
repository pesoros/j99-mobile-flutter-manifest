// ignore_for_file: non_constant_identifier_names, unnecessary_new, prefer_collection_literals, unnecessary_this, avoid_print

class MakananModel {
  String nama_makanan;
  int qty;

  MakananModel({
    this.nama_makanan,
    this.qty,
  });

  MakananModel.fromJson(Map<String, dynamic> json) {
    nama_makanan = json['nama_makanan'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama_makanan'] = this.nama_makanan;
    data['qty'] = this.qty;
    return data;
  }
}
