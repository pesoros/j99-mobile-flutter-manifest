// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_import, avoid_unnecessary_containers, non_constant_identifier_names, deprecated_member_use, unnecessary_new, sized_box_for_whitespace, prefer_collection_literals, unused_local_variable, await_only_futures, library_prefixes, unnecessary_import, unused_field
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:j99_mobile_manifest_flutter/controller/bagasi_checkin.dart';
import 'package:j99_mobile_manifest_flutter/controller/bagasi_list.dart';
import 'package:j99_mobile_manifest_flutter/model/bagasi_model.dart';
import 'package:j99_mobile_manifest_flutter/utils/custom.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:j99_mobile_manifest_flutter/widget/scanqr_widget.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class BagasiScreen extends StatefulWidget {
  @override
  State<BagasiScreen> createState() => _BagasiScreenState();
}

class _BagasiScreenState extends State<BagasiScreen> {
  // BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  // bool _connected = false;
  BluetoothDevice _device;

  TextEditingController ticketNumber = TextEditingController();
  List<BagasiModel> _listBagasi = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getBagasiList();
    // WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  getBagasiList() async {
    await BagasiList.list().then((value) {
      setState(() {
        _listBagasi = value;
        isLoading = false;
      });
    });
  }

  // initBluetooth() async {
  //   bluetoothPrint.startScan(timeout: Duration(seconds: 1));

  //   bool isConnected = await bluetoothPrint.isConnected;

  //   bluetoothPrint.state.listen((state) {
  //     setState(() {
  //       _device = _device;
  //     });

  //     switch (state) {
  //       case BluetoothPrint.CONNECTED:
  //         setState(() {
  //           _connected = true;
  //         });
  //         break;
  //       case BluetoothPrint.DISCONNECTED:
  //         setState(() {
  //           _connected = false;
  //         });
  //         break;
  //       default:
  //         break;
  //     }
  //   });

  //   if (!mounted) return;

  //   if (isConnected) {
  //     setState(() {
  //       _connected = true;
  //     });
  //   }
  // }

  // printTicket(String code) async {
  //   String url = dotenv.env['BASE_URL'] + "/print/ticket/thermal?code=" + code;
  //   Uri parseUrl = Uri.parse(url);
  //   final response = await http.get(parseUrl);

  //   Map<String, dynamic> config = Map();
  //   List<LineText> list = List();

  //   PdfDocument doc = await PdfDocument.openData(response.bodyBytes);
  //   int pageCount = doc.pageCount;
  //   PdfPage page = await doc.getPage(pageCount);
  //   PdfPageImage pageImage = await page.render(
  //     backgroundFill: true,
  //     width: 2000,
  //     height: 4000,
  //     fullWidth: 2000,
  //     fullHeight: 4000,
  //   );
  //   var img = await pageImage.createImageIfNotAvailable();

  //   ByteData imagedata = await img.toByteData(format: ImageByteFormat.png);
  //   List<int> imageBytes = imagedata.buffer
  //       .asUint8List(imagedata.offsetInBytes, imagedata.lengthInBytes);
  //   String base64Image = base64Encode(imageBytes);
  //   list.add(LineText(
  //     type: LineText.TYPE_IMAGE,
  //     content: base64Image,
  //   ));

  //   await bluetoothPrint.printReceipt(config, list);
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: headerWidget(context),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.black),
          child: Column(
            children: [
              // selectPrintWidget(context),
              Expanded(
                child: bodyWidget(context),
              ),
            ],
          ),
        ),
        floatingActionButton: _getFAB(),
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
                  "Bagasi",
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

  // selectPrintWidget(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       (!_connected)
  //           ? Container(
  //               margin: EdgeInsets.only(left: 10),
  //               child: StreamBuilder<List<BluetoothDevice>>(
  //                   stream: bluetoothPrint.scanResults,
  //                   initialData: [],
  //                   builder: (context, snapshot) => DropdownButtonHideUnderline(
  //                         child: DropdownButton<BluetoothDevice>(
  //                           style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: CustomSize.textS),
  //                           dropdownColor: Colors.red,
  //                           hint: Text(
  //                             "Pilih Printer",
  //                             style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: CustomSize.textS),
  //                           ),
  //                           icon: Icon(
  //                             Icons.arrow_downward,
  //                             size: 2,
  //                             color: Colors.black,
  //                           ),
  //                           onChanged: (data) {
  //                             setState(() {
  //                               _device = data;
  //                             });
  //                           },
  //                           items: snapshot.data
  //                               .map<DropdownMenuItem<BluetoothDevice>>((data) {
  //                             return DropdownMenuItem<BluetoothDevice>(
  //                               value: data,
  //                               child: Text(data.name),
  //                             );
  //                           }).toList(),
  //                         ),
  //                       )),
  //             )
  //           : Row(
  //               children: [
  //                 Container(
  //                   margin: EdgeInsets.only(left: 10),
  //                   padding: EdgeInsets.all(3),
  //                   height: 20,
  //                   width: 20,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         color: Colors.green,
  //                         borderRadius: BorderRadius.all(Radius.circular(50))),
  //                   ),
  //                 ),
  //                 SizedBox(width: 5),
  //                 Text(
  //                   "Printer Connected",
  //                   style: TextStyle(
  //                       color: Colors.white, fontSize: CustomSize.textS),
  //                 )
  //               ],
  //             ),
  //       Row(
  //         children: [
  //           Container(
  //             child: IconButton(
  //               icon: Icon(
  //                 Icons.refresh,
  //                 color: Colors.white,
  //                 size: 18,
  //               ),
  //               onPressed: () {
  //                 initBluetooth();
  //               },
  //             ),
  //           ),
  //           Container(
  //             child: OutlinedButton(
  //               child: Text(
  //                 'Connect',
  //                 style: TextStyle(color: Colors.green),
  //               ),
  //               onPressed: _connected
  //                   ? null
  //                   : () async {
  //                       if (_device != null && _device.address != null) {
  //                         await bluetoothPrint.connect(_device);
  //                       } else {
  //                         setState(() {});
  //                       }
  //                     },
  //             ),
  //           ),
  //           Container(
  //             child: OutlinedButton(
  //               child: Text('Disconnect', style: TextStyle(color: Colors.red)),
  //               onPressed: _connected
  //                   ? () async {
  //                       await bluetoothPrint.disconnect();
  //                     }
  //                   : null,
  //             ),
  //           )
  //         ],
  //       )
  //     ],
  //   );
  // }

  bodyWidget(BuildContext context) {
    return SizedBox(
        child: ListView.builder(
      itemCount: _listBagasi.length,
      itemBuilder: (context, index) {
        BagasiModel bagasi = _listBagasi[index];
        return Slidable(
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await BagasiCheckin.list(bagasi.code, "1");
                    getBagasiList();
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.arrow_forward_ios,
                  label: 'Masuk',
                ),
                SlidableAction(
                  onPressed: (context) async {
                    await BagasiCheckin.list(bagasi.code, "2");
                    getBagasiList();
                  },
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  icon: Icons.arrow_back_ios,
                  label: 'Keluar',
                ),
              ],
            ),
            child: _bodyWidget(
              context,
              bagasi.code,
              bagasi.type_from,
              bagasi.status,
              bagasi.from,
              bagasi.to,
            ));
      },
    ));
  }

  _bodyWidget(
    BuildContext context,
    String code,
    String type_from,
    String status,
    String from,
    String to,
  ) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Code: " + code,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Jenis: " + type_from,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "From: " + from,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "To: " + to,
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
                      status,
                      style: TextStyle(
                          fontSize: CustomSize.textS, color: Colors.red),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getFAB() {
    return SpeedDial(
      overlayColor: Colors.black,
      animatedIcon: AnimatedIcons.menu_home,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
            child: Icon(Icons.qr_code),
            backgroundColor: Colors.white,
            onTap: () {
              _addCheckin(context);
            },
            label: 'Checkin',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 16.0),
            labelBackgroundColor: Colors.white),
        SpeedDialChild(
            child: Icon(Icons.qr_code),
            backgroundColor: Colors.white,
            onTap: () {
              _addCheckout(context);
            },
            label: 'Checkout',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 16.0),
            labelBackgroundColor: Colors.white)
      ],
    );
  }

  _addCheckin(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(child: __addCheckin(context));
      },
    );
  }

  __addCheckin(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 30),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Container(
                      height: 5,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                    ),
                  ),
                  SizedBox(
                    child: TextField(
                      controller: ticketNumber,
                      decoration: InputDecoration(
                        labelText: 'Nomor Tiket',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black26),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black26),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: 70,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Center(
                            child: Icon(
                          Icons.qr_code,
                          color: Colors.white,
                        )),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ScanQRWidget(),
                          ),
                        ).then(
                          (value) async {
                            await BagasiCheckin.list(value, "1");
                            Navigator.pop(context);
                            getBagasiList();
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 70,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Center(
                            child: Text(
                          "Check-In",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      onTap: () async {
                        if (ticketNumber.text == "") {
                          Fluttertoast.showToast(
                            msg: "Isi Nomor Tiket",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                          );
                        } else {
                          await BagasiCheckin.list(ticketNumber.text, "1");
                          ticketNumber.text = "";
                          getBagasiList();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  _addCheckout(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(child: __addCheckout(context));
      },
    );
  }

  __addCheckout(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 30),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Container(
                      height: 5,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                    ),
                  ),
                  SizedBox(
                    child: TextField(
                      controller: ticketNumber,
                      decoration: InputDecoration(
                        labelText: 'Nomor Tiket',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black26),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black26),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: 70,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Center(
                            child: Icon(
                          Icons.qr_code,
                          color: Colors.white,
                        )),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ScanQRWidget(),
                          ),
                        ).then(
                          (value) async {
                            await BagasiCheckin.list(value, "2");
                            Navigator.pop(context);
                            getBagasiList();
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 70,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Center(
                            child: Text(
                          "Check-Out",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                      onTap: () async {
                        if (ticketNumber.text == "") {
                          Fluttertoast.showToast(
                            msg: "Isi Nomor Tiket",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                          );
                        } else {
                          await BagasiCheckin.list(ticketNumber.text, "2");
                          ticketNumber.text = "";
                          getBagasiList();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30, left: 30, right: 30),
      child: GestureDetector(
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Center(child: Text("Keluar")),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
