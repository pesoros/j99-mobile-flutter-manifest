// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:j99_mobile_manifest_flutter/screens/bagasi_screen.dart';
import 'package:j99_mobile_manifest_flutter/screens/checkin_screen.dart';
import 'package:j99_mobile_manifest_flutter/screens/finance_screen.dart';
import 'package:j99_mobile_manifest_flutter/screens/login_screen.dart';
import 'package:j99_mobile_manifest_flutter/screens/manifest_detil_screen.dart';
import 'package:j99_mobile_manifest_flutter/utils/custom.dart';
import 'package:blur/blur.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:j99_mobile_manifest_flutter/utils/variables.dart' as variable;

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  @override
  void initState() {
    super.initState();
    checkBluetooth();
  }

  checkBluetooth() async {
    if (await bluetoothPrint.isOn) {
    } else {
      bluetoothCheckModal();
    }
  }

  bluetoothCheckModal() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nyalakan Bluetooth!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: headerWidget(context),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            bodyWidget(context),
            SizedBox(height: 30),
            buttonWidget(context),
          ],
        )),
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
          children: [
            Image.asset(
              "assets/images/j99-logo.png",
              width: MediaQuery.of(context).size.width / 3,
            ),
            VerticalDivider(color: Colors.white),
            Text(
              "Manifest",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      preferredSize: const Size.fromHeight(200.0),
    );
  }

  bodyWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Blur(
                blur: 1,
                blurColor: Colors.black,
                colorOpacity: 0.1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset('assets/images/ariel-tatum.jpg',
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover),
                ),
              ),
              Center(
                  child: Text(
                'Ku Injak Kopling Agar Kau Bisa Shopping'.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: CustomSize.textS,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 5.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ))
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(
            child: Container(
              height: 50,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.details,
                        color: Colors.white,
                        size: CustomSize.textXXL,
                      ),
                      SizedBox(width: 30),
                      Text(
                        "Detail Manifest",
                        style: TextStyle(
                          fontSize: CustomSize.textL,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManifestDetil(),
                  ));
            },
          ),
          SizedBox(height: 30),
          GestureDetector(
            child: Container(
              height: 50,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        color: Colors.white,
                        size: CustomSize.textXXL,
                      ),
                      SizedBox(width: 30),
                      Text(
                        "Keuangan",
                        style: TextStyle(
                          fontSize: CustomSize.textL,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FinanceScreen(),
                  ));
            },
          ),
          SizedBox(height: 30),
          GestureDetector(
            child: Container(
              height: 50,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: CustomSize.textXXL,
                      ),
                      SizedBox(width: 30),
                      Text(
                        "Check-In",
                        style: TextStyle(
                          fontSize: CustomSize.textL,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckinScreen(),
                  ));
            },
          ),
          SizedBox(height: 30),
          GestureDetector(
            child: Container(
              height: 50,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.luggage,
                        color: Colors.white,
                        size: CustomSize.textXXL,
                      ),
                      SizedBox(width: 30),
                      Text(
                        "Bagasi",
                        style: TextStyle(
                          fontSize: CustomSize.textL,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BagasiScreen(),
                  ));
            },
          ),
        ],
      ),
    );
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
          setState(() {
            variable.trip_id_no = null;
            variable.trip_date = null;
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
        },
      ),
    );
  }
}
