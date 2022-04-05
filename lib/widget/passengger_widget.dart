// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:j99_mobile_manifest_flutter/utils/custom.dart';

class PassenggerWidget extends StatelessWidget {
  final String name;
  final String phone;
  final String identity;
  final String baggage;
  final String status;

  PassenggerWidget({
    this.phone,
    this.name,
    this.identity,
    this.baggage,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2.0, color: Colors.white),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _bodyWidget(),
          ],
        ),
      ),
    );
  }

  _bodyWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nama: " + name,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              "No. Identitas: " + identity,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              "No. Handphone: " + phone,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              (baggage == "1") ? "Bawa Bagasi" : "Tidak Bawa Bagasi",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Status",
              style: TextStyle(
                  fontSize: CustomSize.textS,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              (status == '0') ? "Belum Masuk" : "Sudah Masuk",
              style: (status == '0')
                  ? TextStyle(fontSize: CustomSize.textS, color: Colors.red)
                  : TextStyle(fontSize: CustomSize.textS, color: Colors.green),
            )
          ],
        )
      ],
    );
  }
}
