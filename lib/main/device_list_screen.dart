import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health_care/dialogWidget/edit_device_dialog.dart';
import 'package:health_care/helper/models.dart';
import 'package:health_care/helper/mqttClientWrapper.dart';
import 'package:health_care/model/door.dart';
import 'package:health_care/model/thietbi.dart';
import 'package:health_care/response/door_response.dart';

import '../helper/constants.dart' as Constants;
import '../navigator.dart';
import '../rolling_door_remote.dart';
import 'detail_screen.dart';

class DeviceListScreen extends StatefulWidget {
  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  static const GET_DEPARTMENT = 'logindiadiem';
  static const LOGIN_DEVICE = 'gettb';

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  List<Door> doors = List();
  List<Message> tbs = List();

  MQTTClientWrapper mqttClientWrapper;

  String pubTopic;
  int selectedIndex;

  bool isLoading = true;

  @override
  void initState() {
    initMqtt();
    super.initState();
  }

  Future<void> initMqtt() async {
    mqttClientWrapper = MQTTClientWrapper(
            () => print('Success'), (message) => handleDevice(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);
    getDevices();
  }

  void getDevices() async {
    // ThietBi t = ThietBi('', '', '', '', '', Constants.mac, '');
    Door door = Door('', '', '', '', Constants.mac);
    pubTopic = LOGIN_DEVICE;
    publishMessage(pubTopic, jsonEncode(door));
    // showLoadingDialog();
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

  void showLoadingDialog() {
    setState(() {
      isLoading = true;
    });
    // Dialogs.showLoadingDialog(context, _keyLoader);
  }

  void hideLoadingDialog() {
    setState(() {
      isLoading = false;
    });
    // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Bạn muốn thoát ứng dụng ?'),
        // content: new Text('Bạn muốn thoát ứng dụng?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Hủy'),
          ),
          new FlatButton(
            onPressed: () => exit(0),
            // Navigator.of(context).pop(true),
            child: new Text('Đồng ý'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Danh sách thiết bị'),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      child: Column(
        children: [
          buildTableTitle(),
          horizontalLine(),
          // buildListView(),
          horizontalLine(),
        ],
      ),
    );
  }

  Widget buildTableTitle() {
    return Container(
      color: Colors.white,
      height: 40,
      child: Row(
        children: [
          buildTextLabel('STT', 1),
          verticalLine(),
          buildTextLabel('Mã', 3),
          verticalLine(),
          // buildTextLabel('Ảnh', 3),
          // verticalLine(),
          buildTextLabel('Vị trí', 3),
          // verticalLine(),
          // buildTextLabel('Sửa', 1),
        ],
      ),
    );
  }

  Widget buildTextLabel(String data, int flexValue) {
    return Expanded(
      child: Text(
        data,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      flex: flexValue,
    );
  }

  Widget buildListView() {
    return Container(
      child: Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: tbs.length,
          itemBuilder: (context, index) {
            return itemView(index);
          },
        ),
      ),
    );
  }

  Widget itemView(int index) {
    return InkWell(
      onTap: () async {
        navigatorPush(
          context,
          RollingDoor(),);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Column(
          children: [
            Container(
              height: 40,
              child: Row(
                children: [
                  buildTextData('${index + 1}', 1),
                  verticalLine(),
                  buildTextData(doors[index].matb, 3),
                  verticalLine(),
                  buildTextData('', 3),
                  verticalLine(),
                  buildTextData('${doors[index].vitri}', 3),
                  // verticalLine(),
                  // buildEditBtn(index,1),
                ],
              ),
            ),
            horizontalLine(),
          ],
        ),
      ),
    );
  }

  Widget buildEditBtn(int index, int flex) {
    return Expanded(
      child: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async {

          }),
      flex: flex,
    );
  }

  Widget buildTextData(String data, int flexValue) {
    return Expanded(
      child: Text(
        data,
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
      flex: flexValue,
    );
  }

  Widget buildStatusDevice(bool data, int flexValue) {
    return Expanded(
      child: data
          ? Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
      )
          : Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
      ),
      flex: flexValue,
    );
  }

  Widget verticalLine() {
    return Container(
      height: double.infinity,
      width: 1,
      color: Colors.grey,
    );
  }

  Widget horizontalLine() {
    return Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey,
    );
  }

  void removeDevice(int index) async {
    setState(() {
      tbs.removeAt(index);
    });
  }

  void handleDevice(String message) async {
    switch (pubTopic) {
      case GET_DEPARTMENT:
        break;
      case LOGIN_DEVICE:
        final doorResponse = doorResponseFromJson(message);
        tbs = doorResponse.message ;
        setState(() {});
        doors.clear();
        tbs.forEach((element) {
          doors.add(Door(element.matb, element.vitri, '', element.id, Constants.mac));
        });
        print('_DetailScreenState.handle addpage doors: ${doors.length}');
        break;
    }
    pubTopic = '';
  }

  @override
  void dispose() {
    super.dispose();
  }
}
