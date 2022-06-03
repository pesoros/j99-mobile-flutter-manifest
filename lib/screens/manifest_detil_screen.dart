// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, non_constant_identifier_names, avoid_print, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:j99_mobile_manifest_flutter/controller/manifest_detil.dart';
import 'package:j99_mobile_manifest_flutter/model/makanan_model.dart';
import 'package:j99_mobile_manifest_flutter/utils/custom.dart';

class ManifestDetil extends StatefulWidget {
  @override
  State<ManifestDetil> createState() => _ManifestDetilState();
}

class _ManifestDetilState extends State<ManifestDetil> {
  String route = "";
  String reg_no = "";
  String nopol = "";
  String brand = "";
  String type_class = "";
  String resto_name = "";
  String driver = "";
  String assistant_1 = "";
  String assistant_2 = "";
  String assistant_3 = "";
  List<MakananModel> _listMakanan = [];

  @override
  void initState() {
    super.initState();
    getManifestDetail();
    getMakananList();
  }

  getManifestDetail() async {
    await ManifestDetail.list().then((value) {
      if (value == 404) {
      } else {
        setState(() {
          route = value['route'];
          reg_no = value['reg_no'];
          nopol = value['nopol'];
          brand = value['brand'];
          type_class = value['class'];
          resto_name = value['resto_name'];
          driver = value['driver'];
          assistant_1 = value['assistant_1'];
          assistant_2 = value['assistant_2'];
          assistant_3 = value['assistant_3'];
        });
      }
    });
  }

  getMakananList() async {
    await MakananList.list().then((value) {
      setState(() {
        _listMakanan = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: headerWidget(context),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              children: [
                SizedBox(height: 20),
                bodyWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  headerWidget(BuildContext context) {
    return PreferredSize(
      child: Container(
        padding: EdgeInsets.all(20),
        height: 70,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/j99-logo.png",
                  width: MediaQuery.of(context).size.width / 3,
                ),
                VerticalDivider(color: Colors.white),
                Text(
                  "Detail Manifest",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            GestureDetector(
              child: Row(
                children: [
                  Icon(
                    Icons.close_outlined,
                    color: Colors.white,
                    size: CustomSize.textXXL,
                  )
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      preferredSize: const Size.fromHeight(200.0),
    );
  }

  bodyWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("RUTE: " + route.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text("NO. REGISTRASI: " + reg_no.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text("NO. POLISI: " + nopol.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text("BRAND: " + brand.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text("KELAS: " + type_class.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text("RESTAURANT: " + resto_name.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text("DRIVER: " + driver.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text("ASSISTANT : " + assistant_1.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                (assistant_2 == "" || assistant_2 == null)
                    ? SizedBox()
                    : Text("ASSISTANT : " + assistant_2.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                (assistant_3 == "" || assistant_3 == null)
                    ? SizedBox()
                    : Text("ASSISTANT : " + assistant_3.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Divider(
                  thickness: 2,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text("MAKANAN : ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: _listMakanan.length,
                      itemBuilder: (context, index) {
                        MakananModel makanan = _listMakanan[index];
                        return Text(
                            makanan.nama_makanan +
                                ": " +
                                makanan.qty.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold));
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
