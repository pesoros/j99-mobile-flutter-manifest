// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, non_constant_identifier_names, avoid_print, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:j99_mobile_manifest_flutter/controller/finance_add.dart';
import 'package:j99_mobile_manifest_flutter/controller/finance_list.dart';
import 'package:j99_mobile_manifest_flutter/model/finance_model.dart';
import 'package:j99_mobile_manifest_flutter/utils/custom.dart';
import 'package:indonesia/indonesia.dart';

class FinanceScreen extends StatefulWidget {
  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  TextEditingController nominalController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<FinanceListModel> _listFinance = [];

  double allowance = 0;
  double summary = 0;
  double total_spend = 0;
  double total_income = 0;

  @override
  void initState() {
    super.initState();
    getFinance();
  }

  getFinance() async {
    await Finance.list().then((value) {
      setState(() {
        allowance = value['allowance'].toDouble();
        summary = value['summary'].toDouble();
        total_spend = value['total_spend'].toDouble();
        total_income = value['total_income'].toDouble();
      });
      for (var data in value["data"] as List) {
        setState(() {
          _listFinance.add(FinanceListModel.fromJson(data));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: headerWidget(context),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 20),
                _balanceCard(context),
                SizedBox(height: 20),
                _listCost(context),
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
                  "Keuangan",
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

  _balanceCard(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        padding: EdgeInsets.only(left: 30, right: 30),
        height: 150,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/blurred.jpg')),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Uang Saku: " + rupiah(allowance),
                      style: TextStyle(fontSize: CustomSize.textS),
                    ),
                    Text(
                      "Pengeluaran: " + rupiah(total_income),
                      style: TextStyle(fontSize: CustomSize.textS),
                    ),
                    Text(
                      "Pemasukan: " + rupiah(total_spend),
                      style: TextStyle(fontSize: CustomSize.textS),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Saldo",
                      style: TextStyle(fontSize: CustomSize.textL),
                    ),
                    Text(
                      rupiah(summary),
                      style: TextStyle(
                          fontSize: CustomSize.textL,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        _addCost(context);
                      },
                    )
                  ],
                )
              ],
            ),
          ],
        ));
  }

  _listCost(BuildContext context) {
    _listFinance.sort((min, max) => max.created_at.compareTo(min.created_at));
    return Expanded(
        child: ListView.builder(
      itemCount: _listFinance.length,
      itemBuilder: (context, index) {
        FinanceListModel finance = _listFinance[index];
        return _listCostBody(
          context,
          finance.description,
          finance.nominal,
          finance.action,
          finance.created_at,
        );
      },
    ));
  }

  _listCostBody(
    BuildContext context,
    String description,
    String nominal,
    String action,
    String created_at,
  ) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30),
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
                      action.toUpperCase(),
                      style: TextStyle(
                        color: (action == "spend") ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Keterangan: " + description,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Nominal: " + rupiah(nominal),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Tanggal: " + created_at,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _addCost(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: __addCost(context),
            );
          },
        );
      },
    );
  }

  __addCost(BuildContext context) {
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
                      keyboardType: TextInputType.number,
                      controller: nominalController,
                      decoration: InputDecoration(
                        labelText: 'Nominal',
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
                  SizedBox(height: 20),
                  SizedBox(
                    child: TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
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
                        width: MediaQuery.of(context).size.width / 2.5,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            size: CustomSize.textXXL,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () async {
                        await AddFinance.list(
                          descriptionController.text,
                          nominalController.text,
                          "income",
                        ).then((value) async {
                          if (value['status'] == 200) {
                            await getFinance();
                            Navigator.pop(context);
                          }
                        });
                        setState(() {
                          nominalController.text = "";
                          descriptionController.text = "";
                        });
                      },
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Center(
                          child: Icon(
                            Icons.remove,
                            size: CustomSize.textXXL,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () async {
                        await AddFinance.list(
                          descriptionController.text,
                          nominalController.text,
                          "spend",
                        ).then((value) async {
                          if (value['status'] == 200) {
                            await getFinance();
                            Navigator.pop(context);
                          }
                        });
                        setState(() {
                          nominalController.text = "";
                          descriptionController.text = "";
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
