import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:app1/pages/config/config.dart';
import 'package:app1/pages/register.dart';
import 'package:app1/pages/request/customer_login_post_req.dart';
import 'package:app1/pages/response/customer_login_post_res.dart';
import 'package:app1/pages/showtrip.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    String text = '';
  int number = 0;
  String phoneNo = '';
  String url = '';
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController password = TextEditingController();
 @override
void initState() {
super.initState();
Configuration.getConfig().then(
  (config) {
	url = config['apiEndpoint'];
  },
);
}
 void login() {
    CustomerLoginPostRequest req =
        CustomerLoginPostRequest(phone: phoneNoCtl.text, password: password.text);
    http
        .post(Uri.parse("$url/customers/login"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerLoginPostRequestToJson(req))
        .then(
      (value) {
        phoneNoCtl.clear();
        password.clear();
        log(value.body);
        CustomerLoginPostResponse customerLoginPostResponse =
            customerLoginPostResponseFromJson(value.body);
        log(customerLoginPostResponse.customer.fullname);
        log(customerLoginPostResponse.customer.email);
        if(customerLoginPostResponse.message == 'Login successful') {
          Navigator.push(
	context,
	MaterialPageRoute(
	  builder: (context) => LishTrip(cid: customerLoginPostResponse.customer.idx,),
	));

        } else {
          log('Login failed: ${customerLoginPostResponse.message}');
        }
      },
    ).catchError((error) {
      log('Error $error');
    });
  }
  void register() {
   Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            InkWell(
              child: Image.asset('assets/images/test-removebg-preview.png'),

            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text('หมายเลขโทรศัพท์', style: TextStyle(fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                controller: phoneNoCtl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.phone_android_outlined),
                  prefixIconColor: Colors.blueAccent,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text('รหัสผ่าน', style: TextStyle(fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                obscureText: true,
                controller: password,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.lock_clock_outlined),
                  prefixIconColor: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 30),
             Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton(
              onPressed: () {
                register();
              },
              child: const Text('register', style: TextStyle(fontSize: 18)),
            ),
            FilledButton(
              onPressed: (){
                login();
              },
              child: const Text('login', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
          ],
        ),
      ),
    );
  }
}




  