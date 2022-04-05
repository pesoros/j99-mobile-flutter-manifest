// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
          allowDuplicates: false,
          controller: MobileScannerController(
              facing: CameraFacing.back, torchEnabled: false),
          onDetect: (barcode, args) {
            final String code = barcode.rawValue;
            print(code);
            Navigator.pop(context, code);
          }),
    );
  }
}
