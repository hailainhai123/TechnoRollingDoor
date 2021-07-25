import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_care/Widget/bezierContainer.dart';
import 'package:health_care/helper/loader.dart';
import 'package:health_care/login/login_page.dart';
import 'package:health_care/model/user.dart';
import 'package:health_care/response/RegisterResponse.dart';

import '../helper/constants.dart' as Constants;
import '../helper/mqttClientWrapper.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  MQTTClientWrapper mqttClientWrapper;
  User registerUser;
  String permissionValue = '1';
  String departmentValue = 'Khoa 1';
  final List<String> departmentItems = ['Khoa 1', 'Khoa 2', 'Khoa 3', 'Khoa 4'];
  final List<String> permissionItems = ['1', '2', '3', '4'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _success;
  String _userEmail;

  @override
  void initState() {
    mqttClientWrapper = MQTTClientWrapper(
        () => print('Success'), (message) => register(message));
    mqttClientWrapper.prepareMqttClient(Constants.mac);
    super.initState();
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController _controller,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter some text!';
                }
                return null;
              },
              controller: _controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        // _tryRegister();
        post();
        httpPost();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        margin: EdgeInsets.only(bottom: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightBlueAccent, Colors.blueAccent])),
        child: Text(
          'Đăng ký',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }


  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 42.0,
      ),
      child: Container(
        height: 50,
        width: 50,
        child: Image.asset(
          "assets/images/garage.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }


  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Tên đăng nhập", _emailController),
        _entryField("Mật khẩu", _passwordController, isPassword: true),
        _entryField("Tên", _nameController),
        _entryField("SĐT", _phoneNumberController),
        _entryField("Địa chỉ", _addressController),
        // _dropDownPermission(),
        // _dropDownDepartment(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .1),
                    // _title(),
                    _header(),
                    SizedBox(
                      height: 30,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    // SizedBox(height: height * .14),
                    // _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }

  void _tryRegister() async {
    registerUser = User(
      Constants.mac,
      _emailController.text,
      _passwordController.text,
      _nameController.text,
      _phoneNumberController.text,
      _addressController.text,
      '',
      '',
      '',
    );
    mqttClientWrapper.register(registerUser);
  }

  register(String message) {
    Map responseMap = jsonDecode(message);

    if (responseMap['result'] == 'true') {
      print('Login success');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                    registerUser: registerUser,
                  )));
    } else {
      _showToast(context);
    }
  }

  void _showToast(BuildContext context) {
    Dialogs.showAlertDialog(context, 'Đăng ký thất bại, vui lòng thử lại sau!');
  }

  Future<void> post() async {
    var client = http.Client();
    try {
      var uriResponse = await client.post(
          Uri.parse('http://103.146.23.146:8082/api/Accounts/register'),
          headers: <String, String>{
            'content-type': 'application/json; charset=utf-8'
          },
          body: jsonEncode(<String, String>{
            "phoneNumber": "0123456",
            "password": "123",
            "confirmPassword": "123"
          }),
      );
      print('_SignUpPageState.post: ${uriResponse.statusCode}');

      //khanhlh
      //parse body response to RegisterResponse
      var registerResponse = registerResponseFromJson(uriResponse.body);
      print('$registerResponse');

    } finally {
      client.close();
    }
  }

  Future<void> httpPost() async {
    var url = Uri.parse('http://103.146.23.146:8082/api/Accounts/register');
    var response = await http.post(
      url,
      headers: <String, String>{
        'content-type': 'application/json; charset=utf-8'
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print(await http.read('http://103.146.23.146:8082/api/Accounts/login'));
  }
}
