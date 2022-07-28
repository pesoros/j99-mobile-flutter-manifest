// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_import, avoid_unnecessary_containers, non_constant_identifier_names, deprecated_member_use, unnecessary_new, sized_box_for_whitespace, prefer_collection_literals, unused_local_variable, await_only_futures, library_prefixes, unrelated_type_equality_checks, dead_code, void_checks
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:j99_mobile_manifest_flutter/controller/passengger_checkin.dart';
import 'package:j99_mobile_manifest_flutter/controller/passengger_list.dart';
import 'package:j99_mobile_manifest_flutter/model/passengger_model.dart';
import 'package:j99_mobile_manifest_flutter/utils/custom.dart';
import 'package:j99_mobile_manifest_flutter/widget/passengger_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:j99_mobile_manifest_flutter/widget/scanqr_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CheckinScreen extends StatefulWidget {
  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice _device;

  TextEditingController ticketNumber = TextEditingController();
  List<PassenggerModel> _listPassengger = [];
  bool isLoading = true;
  double printWidth = 1000;
  double printHeight = 1960;

  bool secondPrint = false;

  @override
  void initState() {
    super.initState();
    getPassanggerList();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  getPassanggerList() async {
    await PassanggerList.list().then((value) {
      setState(() {
        _listPassengger = value;
        isLoading = false;
        ticketNumber.text = "";
      });
    });
  }

  initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 1));

    bool isConnected = await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) {
      setState(() {
        _device = _device;
      });

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  printTicket(String code) async {
    String url = dotenv.env['BASE_URL'] + "/print/ticket/thermal?code=" + code;
    Uri parseUrl = Uri.parse(url);
    final response = await http.get(parseUrl);

    PdfDocument doc = await PdfDocument.openData(response.bodyBytes);
    int pageCount = doc.pageCount;
    print(pageCount.toString());

    if (pageCount == 1) {
      PdfPage page = await doc.getPage(1);
      PdfPageImage pageImage = await page.render(
        backgroundFill: true,
        width: printWidth.toInt(),
        height: printHeight.toInt(),
        fullWidth: printWidth,
        fullHeight: printHeight,
      );
      var img = await pageImage.createImageIfNotAvailable();

      Map<String, dynamic> config = Map();
      List<LineText> list = List();

      ByteData imagedata = await img.toByteData(format: ImageByteFormat.png);
      List<int> imageBytes = imagedata.buffer
          .asUint8List(imagedata.offsetInBytes, imagedata.lengthInBytes);
      String base64Image = base64Encode(imageBytes);
      list.add(LineText(
        type: LineText.TYPE_IMAGE,
        content: base64Image,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ));
      await bluetoothPrint.printReceipt(config, list);
    } else {
      PdfPage page = await doc.getPage(1);
      PdfPageImage pageImage = await page.render(
        backgroundFill: true,
        width: printWidth.toInt(),
        height: printHeight.toInt(),
        fullWidth: printWidth,
        fullHeight: printHeight,
      );
      var img = await pageImage.createImageIfNotAvailable();

      Map<String, dynamic> config = Map();
      List<LineText> list = List();

      ByteData imagedata = await img.toByteData(format: ImageByteFormat.png);
      List<int> imageBytes = imagedata.buffer
          .asUint8List(imagedata.offsetInBytes, imagedata.lengthInBytes);
      String base64Image = base64Encode(imageBytes);
      list.add(LineText(
        type: LineText.TYPE_IMAGE,
        content: base64Image,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ));
      await bluetoothPrint.printReceipt(config, list);
    }
  }

  secondPrintTicket(String code) async {
    String url = dotenv.env['BASE_URL'] + "/print/ticket/thermal?code=" + code;
    Uri parseUrl = Uri.parse(url);
    final response = await http.get(parseUrl);

    PdfDocument doc = await PdfDocument.openData(response.bodyBytes);
    int pageCount = doc.pageCount;

    PdfPage page = await doc.getPage(2);
    PdfPageImage pageImage = await page.render(
      backgroundFill: true,
      width: printWidth.toInt(),
      height: printHeight.toInt(),
      fullWidth: printWidth,
      fullHeight: printHeight,
    );
    var img = await pageImage.createImageIfNotAvailable();

    Map<String, dynamic> config = Map();
    List<LineText> list = List();

    ByteData imagedata = await img.toByteData(format: ImageByteFormat.png);
    List<int> imageBytes = imagedata.buffer
        .asUint8List(imagedata.offsetInBytes, imagedata.lengthInBytes);
    String base64Image = base64Encode(imageBytes);
    list.add(LineText(
      type: LineText.TYPE_IMAGE,
      content: base64Image,
      align: LineText.ALIGN_CENTER,
      linefeed: 1,
    ));
    await bluetoothPrint.printReceipt(config, list);
  }

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
                  selectPrintWidget(context),
                  Expanded(
                    child: (isLoading)
                        ? Center(child: CircularProgressIndicator())
                        : bodyWidget(context),
                  ),
                ],
              ),
            ),
            floatingActionButton: _getFAB()));
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
                  "Check-In",
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

  selectPrintWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (!_connected)
            ? Container(
                margin: EdgeInsets.only(left: 10),
                child: StreamBuilder<List<BluetoothDevice>>(
                    stream: bluetoothPrint.scanResults,
                    initialData: [],
                    builder: (context, snapshot) => DropdownButtonHideUnderline(
                          child: DropdownButton<BluetoothDevice>(
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: CustomSize.textS),
                            dropdownColor: Colors.red,
                            hint: Text(
                              "Pilih Printer",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: CustomSize.textS),
                            ),
                            icon: Icon(
                              Icons.arrow_downward,
                              size: 2,
                              color: Colors.black,
                            ),
                            onChanged: (data) {
                              setState(() {
                                _device = data;
                              });
                            },
                            items: snapshot.data
                                .map<DropdownMenuItem<BluetoothDevice>>((data) {
                              return DropdownMenuItem<BluetoothDevice>(
                                value: data,
                                child: Text(data.name),
                              );
                            }).toList(),
                          ),
                        )),
              )
            : Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.all(3),
                    height: 20,
                    width: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Printer Connected",
                    style: TextStyle(
                        color: Colors.white, fontSize: CustomSize.textS),
                  )
                ],
              ),
        Row(
          children: [
            Container(
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () {
                  initBluetooth();
                },
              ),
            ),
            Container(
              child: OutlinedButton(
                child: Text(
                  'Connect',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: _connected
                    ? null
                    : () async {
                        if (_device != null && _device.address != null) {
                          await bluetoothPrint.connect(_device);
                        } else {
                          setState(() {});
                        }
                      },
              ),
            ),
            Container(
              child: OutlinedButton(
                child: Text('Disconnect', style: TextStyle(color: Colors.red)),
                onPressed: _connected
                    ? () async {
                        await bluetoothPrint.disconnect();
                      }
                    : null,
              ),
            )
          ],
        )
      ],
    );
  }

  bodyWidget(BuildContext context) {
    return SizedBox(
        child: ListView.builder(
      itemCount: _listPassengger.length,
      itemBuilder: (context, index) {
        PassenggerModel passengger = _listPassengger[index];
        return Slidable(
            startActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    if (_connected) {
                      printTicket(passengger.ticket_number);
                    } else {
                      Fluttertoast.showToast(
                        msg: "Nyalakan Bluetooth",
                        toastLength: Toast.LENGTH_LONG,
                        fontSize: CustomSize.textS,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.print,
                  label: 'Print Tiket',
                ),
                (passengger.baggage == "Bawa")
                    ? SlidableAction(
                        onPressed: (context) async {
                          if (_connected) {
                            secondPrintTicket(passengger.ticket_number);
                            print("2");
                          } else {
                            Fluttertoast.showToast(
                              msg: "Nyalakan Bluetooth",
                              toastLength: Toast.LENGTH_LONG,
                              fontSize: CustomSize.textS,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        icon: Icons.print,
                        label: 'Print Bagasi',
                      )
                    : SizedBox(),
              ],
            ),
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await PassenggerCheckin.list(passengger.ticket_number, "1");
                    getPassanggerList();
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.arrow_forward_ios,
                  label: 'Masuk',
                ),
                SlidableAction(
                  onPressed: (context) async {
                    await PassenggerCheckin.list(passengger.ticket_number, "2");
                    getPassanggerList();
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
              passengger.name,
              passengger.ticket_number,
              passengger.seat_number,
              passengger.food_name,
              passengger.baggage,
              passengger.checkin_status,
              passengger.pickup_trip_location,
              passengger.drop_trip_location,
              passengger.url_print,
              passengger.dep_time,
              passengger.arr_time,
              passengger.kelas,
            ));
      },
    ));
  }

  _bodyWidget(
    BuildContext context,
    String name,
    String ticket_number,
    String seat_number,
    String food_name,
    String baggage,
    String checkin_status,
    String pickup_trip_location,
    String drop_trip_location,
    String url_print,
    String dep_time,
    String arr_time,
    String kelas,
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
                      "Nama: " + name ?? "",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "No. Tiket: " + ticket_number ?? "",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "No. Kursi: " + kelas + " - " + seat_number,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Makanan: $food_name" ?? "Makanan: ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Bagasi: " + baggage ?? "",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Asal: " + pickup_trip_location + " - " + dep_time,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Tujuan: " + drop_trip_location + " - " + arr_time,
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
                      checkin_status,
                      style: TextStyle(
                        fontSize: CustomSize.textS,
                        color: (checkin_status == "Menunggu")
                            ? Colors.red
                            : (checkin_status == "Sudah Masuk")
                                ? Colors.green
                                : (checkin_status == "Sudah Sampai")
                                    ? Colors.grey
                                    : Colors.white,
                      ),
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
                            await PassenggerCheckin.list(value, "1");
                            Navigator.pop(context);
                            getPassanggerList();
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
                          await PassenggerCheckin.list(ticketNumber.text, "1");
                          ticketNumber.text = "";
                          getPassanggerList();
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
                            await PassenggerCheckin.list(value, "2");
                            Navigator.pop(context);
                            getPassanggerList();
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
                          await PassenggerCheckin.list(ticketNumber.text, "2");
                          ticketNumber.text = "";
                          getPassanggerList();
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
