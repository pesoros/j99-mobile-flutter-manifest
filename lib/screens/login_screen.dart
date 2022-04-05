// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:j99_mobile_manifest_flutter/controller/login.dart';
import 'package:j99_mobile_manifest_flutter/screens/dashboard_screen.dart';
import 'package:j99_mobile_manifest_flutter/utils/variables.dart' as variable;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordVisible = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.black),
            child: bodyWidget(context)),
      ),
    );
  }

  bodyWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/j99-logo.png",
            width: MediaQuery.of(context).size.width / 1.5,
          ),
          SizedBox(height: 10),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.only(),
            height: 50,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: Colors.white),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: Colors.white),
                    borderRadius: BorderRadius.circular(15),
                  )),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(),
            height: 50,
            child: TextField(
              obscureText: !passwordVisible,
              controller: passwordController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          buttonWidget(context),
        ],
      ),
    );
  }

  buttonWidget(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Center(child: Text("Masuk")),
      ),
      onTap: () async {
        await Login.list(emailController.text, passwordController.text)
            .then((value) {
          if (value == 400) {
            Fluttertoast.showToast(
              msg: "Email / Password Salah",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              textColor: Colors.white,
              backgroundColor: Colors.red,
              fontSize: 16,
            );
          } else {
            if (value == null) {
              Fluttertoast.showToast(
                msg: "Belum Assign",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                textColor: Colors.white,
                backgroundColor: Colors.red,
                fontSize: 16,
              );
            } else {
              setState(() {
                variable.trip_id_no = value['trip_id_no'];
                variable.trip_date = value['trip_date'];
              });
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardScreen(),
                  ));
            }
          }
        });
      },
    );
  }
}
