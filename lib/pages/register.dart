import 'dart:convert';
import 'dart:developer';

import 'package:app1/pages/config/config.dart';
import 'package:app1/pages/login.dart';
import 'package:app1/pages/request/customer_regis_req.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController namecolor = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController image = TextEditingController();
  String url = '';

@override
void initState() {
super.initState();
Configuration.getConfig().then(
  (config) {
	url = config['apiEndpoint'];
  },
);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ลงทะเบียนสมาชิกใหม่',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        toolbarHeight: 80,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'ชื่อนามสกุล',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: namecolor,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.blueAccent,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'หมายเลขโทรศัพท์',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: phoneNumber,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.blueAccent,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'อีเมล',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.blueAccent,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'รูป',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: image,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.blueAccent,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'รหัสผ่าน',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.blueAccent,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'ยืนยันรหัสผ่าน',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: confirmPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.blueAccent,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                FilledButton(
                  onPressed: register,
                  child: Text('สมัครสมาชิก', style: TextStyle(fontSize: 16)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'มีบัญชีผู้ใช้แล้ว?',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 192, 186, 186),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('เข้าสู่ระบบ'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() {
    if(password.text == confirmPassword.text) {
        CustomerRegisterPostResponse req = CustomerRegisterPostResponse(
      fullname: namecolor.text,
      phone: phoneNumber.text,
      email: email.text,
      image: image.text,
      password: password.text,
      
    );
   
       http
        .post(Uri.parse("$url/customers"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerRegisterPostResponseToJson(req))
        .then(
      (value) {
        log(value.body);

      },
    ).catchError((error) {
      log('Error $error');
    });
    }
    else{
      log('paassword not match');
    }
    

  }
}
