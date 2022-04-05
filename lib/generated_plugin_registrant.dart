//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars

import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:mobile_scanner/mobile_scanner_web_plugin.dart';
import 'package:pdf_render/src/web/pdf_render_web_plugin.dart';
import 'package:printing/printing_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  FluttertoastWebPlugin.registerWith(registrar);
  MobileScannerWebPlugin.registerWith(registrar);
  PdfRenderWebPlugin.registerWith(registrar);
  PrintingPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
