// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:health_care/dialogWidget/edit_user_dialog.dart';
// import 'package:health_care/helper/models.dart';
// import 'package:health_care/helper/mqttClientWrapper.dart';
// import 'package:health_care/helper/shared_prefs_helper.dart';
// import 'package:health_care/login/login_page.dart';
// import 'package:health_care/model/department.dart';
// import 'package:health_care/model/user.dart';
// import 'package:health_care/navigator.dart';
// import 'package:health_care/response/device_response.dart';
//
// import '../helper/constants.dart' as Constants;
//
// class UserProfilePage extends StatefulWidget {
//   final String quyen;
//
//   const UserProfilePage({Key key, this.quyen}) : super(key: key);
//
//   @override
//   _UserProfilePageState createState() => _UserProfilePageState();
// }
//
// class _UserProfilePageState extends State<UserProfilePage> {
//   static const GET_INFO_USER = 'getinfouser';
//   static const GET_DEPARTMENT = 'loginkhoa';
//   MQTTClientWrapper mqttClientWrapper;
//   SharedPrefsHelper sharedPrefsHelper;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _departmentController = TextEditingController();
//   final TextEditingController _permissionController = TextEditingController();
//   User user;
//   String pubTopic = '';
//   List<Department> departments = List();
//   var dropDownItems = [''];
//
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     sharedPrefsHelper = SharedPrefsHelper();
//     user = User(
//       '',
//       'Tên đăng nhập',
//       'Mật khẩu',
//       'Tên',
//       'SĐT',
//       'Địa chỉ',
//       'Khoa',
//       'Quyền',
//       '',
//     );
//     initMqtt();
//     super.initState();
//   }
//
//   Future<void> initMqtt() async {
//     mqttClientWrapper =
//         MQTTClientWrapper(() => print('Success'), (message) => handle(message));
//     await mqttClientWrapper.prepareMqttClient(Constants.mac);
//     getInfoUser();
//   }
//
//   void getInfoUser() async {
//     pubTopic = GET_INFO_USER;
//     String email = await sharedPrefsHelper.getStringValuesSF('email');
//     String password = await sharedPrefsHelper.getStringValuesSF('password');
//     if (email.isNotEmpty && password.isNotEmpty) {
//       User user = User(Constants.mac, email, password, '', '', '', '', '', '');
//       publishMessage('getinfouser', jsonEncode(user));
//     }
//     showLoadingDialog();
//   }
//
//   void getDepartment() {
//     Department d = Department('', '','', Constants.mac);
//     pubTopic = GET_DEPARTMENT;
//     publishMessage(pubTopic, jsonEncode(d));
//     showLoadingDialog();
//   }
//
//   Widget _placeContainer(String title, Color color, Widget icon) {
//     return Column(
//       children: <Widget>[
//         Container(
//             height: 50,
//             width: MediaQuery.of(context).size.width - 40,
//             padding: EdgeInsets.all(10),
//             margin: EdgeInsets.symmetric(vertical: 5),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15), color: color),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   title,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600),
//                 ),
//                 icon != null ? icon : Spacer(),
//               ],
//             ))
//       ],
//     );
//   }
//
//   Widget _editContainer(String title, Color color, Widget icon) {
//     return InkWell(
//       onTap: () async {
//         // getDepartment();
//         await showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return Dialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0)),
//                 //this right here
//                 child: Container(
//                   child: EditUserDialog(
//                     user: user,
//                     deleteCallback: (param) {
//                       getInfoUser();
//                     },
//                     updateCallback: (updatedDevice) {
//                       getInfoUser();
//                     },
//                     // switchValue: widget.switchValue,
//                   ),
//                 ),
//               );
//             });
//       },
//       child: Column(
//         children: <Widget>[
//           Container(
//               height: 50,
//               width: MediaQuery.of(context).size.width - 40,
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.symmetric(vertical: 5),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15), color: color),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     title,
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600),
//                   ),
//                   icon != null ? icon : Spacer(),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
//
//   Widget _logoutContainer(String title, Color color, Widget icon) {
//     return InkWell(
//       onTap: () {
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: new Text('Bạn muốn đăng xuất ?'),
//                 // content: new Text('Bạn muốn thoát ứng dụng?'),
//                 actions: <Widget>[
//                   new FlatButton(
//                     onPressed: () => Navigator.of(context).pop(false),
//                     child: new Text('Hủy'),
//                   ),
//                   new FlatButton(
//                     onPressed: () {
//                       setState(() {
//                         navigatorPushAndRemoveUntil(context, LoginPage());
//                       });
//                     },
//                     child: new Text('Đồng ý'),
//                   ),
//                 ],
//               );
//             });
//       },
//       child: Column(
//         children: <Widget>[
//           Container(
//               height: 50,
//               width: MediaQuery.of(context).size.width - 40,
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.symmetric(vertical: 5),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15), color: color),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     title,
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600),
//                   ),
//                   icon != null ? icon : Spacer(),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
//
//   Widget _emailPasswordWidget() {
//     _emailController.text = user.user;
//     _passwordController.text = user.pass;
//     _nameController.text = user.tenDecode;
//     _phoneNumberController.text = user.sdt;
//     _addressController.text = user.nhaDecode;
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         children: <Widget>[
//           _entryField("Tên đăng nhập", _emailController, false),
//           _entryField("Mật khẩu", _passwordController, false, isPassword: true),
//           _entryField("Tên", _nameController, true),
//           _entryField("SĐT", _phoneNumberController, true),
//           _entryField("Địa chỉ", _addressController, true),
//           _entryField("Khoa", _departmentController, true),
//           _entryField("Quyền", _permissionController, true),
//           SizedBox(height: 10),
//           _button('Cập nhật'),
//           _button('Hủy')
//         ],
//       ),
//     );
//   }
//
//   Widget _entryField(
//       String title, TextEditingController _controller, bool isEnable,
//       {bool isPassword = false}) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             title,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           TextFormField(
//               enabled: isEnable,
//               validator: (String value) {
//                 if (value.isEmpty) {
//                   return 'Vui lòng nhập đủ thông tin!';
//                 }
//                 return null;
//               },
//               controller: _controller,
//               obscureText: isPassword,
//               decoration: InputDecoration(
//                   border: InputBorder.none,
//                   fillColor: Color(0xfff3f3f4),
//                   filled: true))
//         ],
//       ),
//     );
//   }
//
//   Widget _backButton() {
//     return InkWell(
//       onTap: () {
//         Navigator.pop(context);
//       },
//       child: Container(
//         // padding: EdgeInsets.symmetric(horizontal: 10),
//         child: Row(
//           children: <Widget>[
//             Container(
//               // padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
//               child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
//             ),
//             // Text('Back',
//             //     style: TextStyle(
//             //         fontSize: 16,
//             //         fontWeight: FontWeight.w500,
//             //         color: Colors.white))
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Tài khoản'),
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Container(
//         color: Color(0xffe7eaf2),
//         height: double.infinity,
//         child: SingleChildScrollView(
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.fromLTRB(40.0, 40, 40, 40),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 user.tenDecode.isEmpty
//                     ? Container()
//                     : CircleAvatar(
//                     backgroundColor: Colors.brown.shade800,
//                     minRadius: 40,
//                     child: Text(
//                       user.tenDecode[0],
//                       style: TextStyle(fontSize: 30),
//                     )),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 _placeContainer(
//                     user.tenDecode != null
//                         ? 'Tên: ${user.tenDecode}'
//                         : 'Chưa nhập tên',
//                     Color(0xffffffff),
//                     null),
//                 _placeContainer(
//                     user.user != null
//                         ? 'Tên ĐN: ${user.user}'
//                         : 'Tên ĐN: ',
//                     Color(0xffffffff),
//                     null),
//                 _placeContainer(
//                     user.nhaDecode != null
//                         ? 'Địa chỉ: ${user.nhaDecode}'
//                         : 'Chưa nhập địa chỉ',
//                     Color(0xffffffff),
//                     null),
//                 _placeContainer(
//                     user.sdt != null
//                         ? 'SĐT: ${user.sdt}'
//                         : 'Chưa nhập SĐT',
//                     Color(0xffffffff),
//                     null),
//                 // _placeContainer(
//                 //     user.quyen != null
//                 //         ? 'Quyền: ${user.quyen}'
//                 //         : 'Chưa có quyền',
//                 //     Color(0xff8f48ff),
//                 //     null),
//                 // user.quyen != '1'
//                 //     ? _placeContainer(
//                 //         user.khoa != null
//                 //             ? 'Khoa: ${user.khoa}'
//                 //             : 'Chưa có khoa',
//                 //         Color(0xff8f48ff),
//                 //         null)
//                 //     : Container(),
//                 _editContainer(
//                     'Sửa thông tin', Color(0xffffffff), Icon(Icons.edit)),
//                 int.parse(widget.quyen) == 0
//                     ? _placeContainer('Thêm tài khoản', Color(0xffffffff),
//                     Icon(Icons.add))
//                     : Container(),
//                 _logoutContainer(
//                     'Đăng xuất',
//                     Color(0xffffffff),
//                     Icon(
//                       Icons.power_settings_new,
//                       color: Colors.red,
//                     )),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _button(String text) {
//     return InkWell(
//       onTap: () {
//         _tryEdit();
//         Navigator.of(context).pop(false);
//       },
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         padding: EdgeInsets.symmetric(vertical: 10),
//         margin: EdgeInsets.only(bottom: 10),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(5)),
//             boxShadow: <BoxShadow>[
//               BoxShadow(
//                   color: Colors.grey.shade200,
//                   offset: Offset(2, 4),
//                   blurRadius: 5,
//                   spreadRadius: 2)
//             ],
//             gradient: LinearGradient(
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//                 colors: [
//                   Colors.blueAccent,
//                   Colors.blue,
//                 ])),
//         child: Text(
//           text,
//           style: TextStyle(fontSize: 20, color: Colors.white),
//         ),
//       ),
//     );
//   }
//
//   handle(String message) async {
//     DeviceResponse response = DeviceResponse.fromJson(jsonDecode(message));
//
//     print('Response: ${response.id}');
//
//     switch (pubTopic) {
//       case GET_DEPARTMENT:
//         departments = response.id.map((e) => Department.fromJson(e)).toList();
//         dropDownItems.clear();
//         departments.forEach((element) {
//           dropDownItems.add(element.madiadiem);
//         });
//         hideLoadingDialog();
//         print('_DeviceListScreenState.handleDevice ${dropDownItems.length}');
//         print('_DeviceListScreenState.handleDevice ${user.toString()}');
//
//         await showDialog(
//             barrierDismissible: false,
//             context: context,
//             builder: (BuildContext context) {
//               return Dialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0)),
//                 //this right here
//                 child: Container(
//                   child: Stack(
//                     children: [
//                       EditUserDialog(
//                         user: user,
//                         dropDownItems: dropDownItems,
//                         deleteCallback: (param) {
//                           getInfoUser();
//                         },
//                         updateCallback: (updatedDevice) {
//                           getInfoUser();
//                         },
//                       ),
//                       Positioned(
//                         right: 0.0,
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             getInfoUser();
//                           },
//                           child: Align(
//                             alignment: Alignment.topRight,
//                             child: CircleAvatar(
//                               radius: 14.0,
//                               backgroundColor: Colors.white,
//                               child: Icon(Icons.close, color: Colors.black),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             });
//
//         break;
//       case GET_INFO_USER:
//         setState(() {
//           List<User> users = response.id.map((e) => User.fromJson(e)).toList();
//           user = users[0];
//         });
//         hideLoadingDialog();
//         break;
//     }
//     pubTopic = '';
//   }
//
//   Future<void> _tryEdit() async {
//     User user = User(
//       Constants.mac,
//       _emailController.text,
//       _passwordController.text,
//       _nameController.text,
//       _phoneNumberController.text,
//       _addressController.text,
//       _departmentController.text,
//       _permissionController.text,
//       '',
//     );
//     user.iduser = await sharedPrefsHelper.getStringValuesSF('iduser');
//     publishMessage('updateuser', jsonEncode(user));
//   }
//
//   void showLoadingDialog() {
//     setState(() {
//       isLoading = true;
//     });
//     // Dialogs.showLoadingDialog(context, _keyLoader);
//   }
//
//   void hideLoadingDialog() {
//     setState(() {
//       isLoading = false;
//     });
//     // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
//   }
//
//   Future<void> publishMessage(String topic, String message) async {
//     if (mqttClientWrapper.connectionState ==
//         MqttCurrentConnectionState.CONNECTED) {
//       mqttClientWrapper.publishMessage(topic, message);
//     } else {
//       await initMqtt();
//       mqttClientWrapper.publishMessage(topic, message);
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_care/dialogWidget/edit_user_dialog.dart';
import 'package:health_care/helper/constants.dart' as Constants;
import 'package:health_care/helper/models.dart';
import 'package:health_care/helper/mqttClientWrapper.dart';
import 'package:health_care/helper/shared_prefs_helper.dart';
import 'package:health_care/login/login_page.dart';
import 'package:health_care/model/user.dart';
import 'package:health_care/navigator.dart';

class UserProfilePage extends StatefulWidget {
  final bool switchValue;

  const UserProfilePage({Key key, this.switchValue}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  MQTTClientWrapper mqttClientWrapper;
  SharedPrefsHelper sharedPrefsHelper;
  User user;
  String pubTopic = '';
  var dropDownItems = [''];

  bool isLoading = true;

  @override
  void initState() {
    sharedPrefsHelper = SharedPrefsHelper();
    user = User(
      '',
      'Tên đăng nhập',
      'Mật khẩu',
      'Tên',
      'SĐT',
      'Địa chỉ',
      'Khoa',
      'Quyền',
      '',
    );
    initMqtt();
    super.initState();
  }

  Future<void> initMqtt() async {
    mqttClientWrapper =
        MQTTClientWrapper(() => print('Success'), (message) => handle(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);
    getInfoUser();
  }

  void getInfoUser() async {
    if (widget.switchValue) {
      pubTopic = Constants.GET_INFO_PARENT;
    } else {
      pubTopic = Constants.GET_INFO_USER;
    }
    String email = await sharedPrefsHelper.getStringValuesSF('email');
    String password = await sharedPrefsHelper.getStringValuesSF('password');
    if (email.isNotEmpty && password.isNotEmpty) {
      User user = User(
        Constants.mac,
        email,
        password,
        '',
        '',
        '',
        '',
        '',
        '',
      );
      publishMessage(pubTopic, jsonEncode(user));
    }
    showLoadingDialog();
  }

  void getDepartment() {
    // Department d = Department('', '', Constants.mac);
    // pubTopic = Constants.GET_DEPARTMENT;
    // publishMessage(pubTopic, jsonEncode(d));
    // showLoadingDialog();
  }

  Widget _placeContainer(String title, Color color, Widget icon) {
    if (title.length > 20) {
      title = title.substring(0, 20) + '...';
    }
    return Column(
      children: <Widget>[
        Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 40,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: color),
            child: Row(
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                icon ?? Spacer(),
              ],
            ))
      ],
    );
  }

  Widget _editContainer(String title, Color color, Widget icon) {
    return InkWell(
      onTap: () async {
        // getDepartment();
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                //this right here
                child: Container(
                  child: EditUserDialog(
                    user: user,
                    deleteCallback: (param) {
                      getInfoUser();
                    },
                    updateCallback: (updatedDevice) {
                      getInfoUser();
                    },
                    switchValue: widget.switchValue,
                  ),
                ),
              );
            });
      },
      child: Column(
        children: <Widget>[
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: color),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  icon != null ? icon : Spacer(),
                ],
              ))
        ],
      ),
    );
  }

  Widget _logoutContainer(String title, Color color, Widget icon) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text('Bạn muốn đăng xuất ?'),
                // content: new Text('Bạn muốn thoát ứng dụng?'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('Hủy'),
                  ),
                  new FlatButton(
                    onPressed: () {
                      setState(() {
                        navigatorPushAndRemoveUntil(context, LoginPage());
                      });
                    },
                    child: new Text('Đồng ý'),
                  ),
                ],
              );
            });
      },
      child: Column(
        children: <Widget>[
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: color),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  icon != null ? icon : Spacer(),
                ],
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tài khoản'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Color(0xffe7eaf2),
              height: double.infinity,
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(40.0, 40, 40, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      user.tenDecode.isEmpty
                          ? Container()
                          : CircleAvatar(
                              backgroundColor: Colors.brown.shade800,
                              minRadius: 40,
                              child: Text(
                                user.tenDecode[0].toUpperCase(),
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              )),
                      SizedBox(
                        height: 15,
                      ),
                      _placeContainer(
                          user.tenDecode != null
                              ? 'Tên: ${user.tenDecode}'
                              : 'Chưa nhập tên',
                          Colors.white,
                          null),
                      _placeContainer(
                          'Tên ĐN: ${user.user ?? ''}', Colors.white, null),
                      _placeContainer(
                          user.nhaDecode != null
                              ? 'Địa chỉ: ${user.nhaDecode}'
                              : 'Chưa nhập địa chỉ',
                          Colors.white,
                          null),
                      _placeContainer(
                          user.sdt != null
                              ? 'SĐT: ${user.sdt}'
                              : 'Chưa nhập SĐT',
                          Colors.white,
                          null),
                      // _placeContainer(
                      //     user.quyen != null
                      //         ? 'Quyền: ${user.quyen}'
                      //         : 'Chưa có quyền',
                      //     Color(0xff8f48ff),
                      //     null),
                      // user.quyen != '1'
                      //     ? _placeContainer(
                      //         user.khoa != null
                      //             ? 'Khoa: ${user.khoa}'
                      //             : 'Chưa có khoa',
                      //         Color(0xff8f48ff),
                      //         null)
                      //     : Container(),
                      _editContainer(
                          'Sửa thông tin', Color(0xffffffff), Icon(Icons.edit)),
                      _logoutContainer(
                        'Đăng xuất',
                        Color(0xffffffff),
                        Icon(
                          Icons.power_settings_new,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  handle(String message) async {

    switch (pubTopic) {
      case Constants.GET_INFO_USER:
      case Constants.GET_INFO_PARENT:
        break;
    }
    pubTopic = '';
  }

  void showLoadingDialog() {
    setState(() {
      isLoading = true;
    });
  }

  void hideLoadingDialog() {
    setState(() {
      isLoading = false;
    });
  }

  Future<void> publishMessage(String topic, String message) async {
    if (mqttClientWrapper.connectionState ==
        MqttCurrentConnectionState.CONNECTED) {
      mqttClientWrapper.publishMessage(topic, message);
    } else {
      await initMqtt();
      mqttClientWrapper.publishMessage(topic, message);
    }
  }
}
