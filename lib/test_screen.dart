import 'dart:convert';

import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:health_care/model/airconditonal.dart';
import 'package:health_care/response/airconditional_response.dart';
import 'package:health_care/response/model_airconditional_response.dart';
import 'package:health_care/response/power_response.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'helper/config.dart';
import 'helper/constants.dart' as Constants;
import 'helper/models.dart';
import 'helper/mqttClientWrapper.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<Id> tbs = List();
  List<IdModel> listModel = List();

  List<String> dropDownItems = List();
  List<String> dropDownItemsModel = List();

  String currentSelectedValue;
  String model;
  String mahang;
  String idprotocol;
  var color;

  int mode = 0;
  int fan = 0;
  int eco = 0;
  int air = 0;
  int nhietDo = 18;
  int power = 0;
  String power2;

  List<String> listMode = ['0', '1', '2', '3'];
  List<String> listFan = ['0', '2', '3', '4'];
  List<String> listEco = ['Eco', 'Nor', 'High'];
  List<String> listAir = ['0', '1', '2','3','4','5'];
  List<String> listPower = ['0', '1'];

  MQTTClientWrapper mqttClientWrapper;

  String pubTopic;

  @override
  void initState() {
    initMqtt();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildDepartment('Chọn hãng'),
            SizedBox(
              height: 30,
            ),
            buildModelAir('Chọn model'),
            // buildDepartment('Chọn loại'),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      buildModeButton(Icons.autorenew, 0),
                      buildModeButton(Icons.ac_unit, 1),
                      buildModeButton(Icons.wb_sunny_outlined, 2),
                      buildModeButton(Icons.waves_outlined, 3),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                sleek2(),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      buildFanButton('Auto', 0),
                      buildFanButton('Low', 1),
                      buildFanButton('Med', 2),
                      buildFanButton('High', 3),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     buildEcoButton('Eco', 0),
            //     buildEcoButton('Nor', 1),
            //     buildEcoButton('High', 2),
            //   ],
            // ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButtonMode(context),
                SizedBox(
                  width: 50,
                ),
                buildButtonFan(context),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButtonEco(context),
                SizedBox(
                  width: 50,
                ),
                buildButtonAirflow(context),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            buildButtonPower(),
          ],
        ),
      ),
    );
  }

  Widget sleek(String nhietdo) {
    double nd = double.tryParse(nhietdo);
    if (nd >= 200) nd = 200;
    return Container(
      width: 150,
      height: 150,
      child: SleekCircularSlider(
        appearance: CircularSliderAppearance(
          customColors: CustomSliderColors(
            progressBarColors: gradientColors,
            hideShadow: true,
            shadowColor: Colors.transparent,
          ),
          customWidths: CustomSliderWidths(progressBarWidth: 10),
          infoProperties: InfoProperties(
              mainLabelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              modifier: (double value) {
                final roundedValue = nd.ceil().toInt().toString();
                return '$roundedValue \u2103';
              }),
        ),
        min: 0,
        max: 200,
        initialValue: nd,
      ),
    );
  }

  Widget sleek2() {
    int i;
    return ClayContainer(
      height: 200,
      width: 200,
      color: Colors.white,
      borderRadius: 200,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Stack(
          children: [
            // Padding(
            //   padding: EdgeInsets.only(top: 120,left: 3),
            //   child: Container(
            //     width: 15,
            //     height: 1,
            //     color: Colors.black,
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(top: 108,left: 2),
            //   child: Container(
            //     width: 15,
            //     height: 1,
            //     color: Colors.black,
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(top: 94,left: 1),
            //   child: Container(
            //     width: 15,
            //     height: 1,
            //     color: Colors.black,
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(top: 70,left: 0),
            //   child: Container(
            //     width: 15,
            //     height: 1,
            //     color: Colors.black,
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(top: 80,left: 0),
            //   child: Container(
            //     width: 15,
            //     height: 1,
            //     color: Colors.black,
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.all(19),
              child: SleekCircularSlider(
                  min: 16,
                  max: 30,
                  initialValue: 18,
                  appearance: CircularSliderAppearance(
                    customColors: CustomSliderColors(
                      progressBarColors: gradientColors,
                      hideShadow: true,
                      shadowColor: Colors.transparent,
                    ),
                    infoProperties: InfoProperties(
                        mainLabelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                        ),
                        modifier: (double value) {
                          final roundedValue = value.ceil().toInt().toString();
                          return '$roundedValue \u2103';
                        }),
                  ),
                  onChange: (double value) {
                    if (power == 1) {
                      i = value.ceil().toInt();
                      nhietDo = i;
                      print(nhietDo);
                      Airconditional airconditional = Airconditional(
                        '',
                        'set',
                        idprotocol,
                        listPower[power],
                        listFan[fan],
                        listMode[mode],
                        listAir[air],
                        '${nhietDo}',
                        Constants.mac,
                        listEco[eco],
                      );
                      pubTopic = 'TECHNO1';
                      publishMessage(pubTopic, jsonEncode(airconditional));
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonMode(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        if (power == 1) {
          mode++;
          if (mode > 3) mode = 0;
          Airconditional airconditional = Airconditional(
            '',
            'set',
            idprotocol,
            listPower[power],
            listFan[fan],
            listMode[mode],
            listAir[air],
            '${nhietDo}',
            Constants.mac,
            listEco[eco],
          );
          pubTopic = 'TECHNO1';
          publishMessage(pubTopic, jsonEncode(airconditional));
          setState(() {});
        } else {}
      },
      child: Text('Mode'),
    );
  }

  Widget buildModeButton(IconData icon, int modeBtn) {
    var color;
    if (modeBtn == mode) {
      color = Colors.blue;
    } else {
      color = Colors.black;
    }
    return IconButton(
      onPressed: () {},
      icon: Icon(
        icon,
      ),
      color: color,
    );
  }

  Widget buildButtonFan(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        if (power == 1) {
          fan++;
          if (fan > 3) fan = 0;
          Airconditional airconditional = Airconditional(
            '',
            'set',
            idprotocol,
            listPower[power],
            listFan[fan],
            listMode[mode],
            listAir[air],
            '${nhietDo}',
            Constants.mac,
            listEco[eco],
          );
          pubTopic = 'TECHNO1';
          publishMessage(pubTopic, jsonEncode(airconditional));
          setState(() {});
        }
      },
      child: Text('Fan'),
    );
  }

  Widget buildFanButton(String text, int fanBtn) {
    var color;
    if (fanBtn == fan) {
      color = Colors.blue;
    } else {
      color = Colors.black;
    }
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }

  Widget buildButtonEco(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        if (power == 1) {
          eco++;
          if (eco > 2) eco = 0;
          Airconditional airconditional = Airconditional(
            '',
            'set',
            idprotocol,
            listPower[power],
            listFan[fan],
            listMode[mode],
            listAir[air],
            '${nhietDo}',
            Constants.mac,
            listEco[eco],
          );
          pubTopic = 'TECHNO1';
          publishMessage(pubTopic, jsonEncode(airconditional));
          setState(() {});
        }
      },
      child: Text('Eco'),
    );
  }

  Widget buildEcoButton(String text, int ecoBtn) {
    var color;
    if (ecoBtn == eco) {
      color = Colors.blue;
    } else {
      color = Colors.black;
    }
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }

  Widget buildButtonAirflow(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        if (power == 1) {
          air++;
          if (air > 5) air = 0;
          Airconditional airconditional = Airconditional(
            '',
            'set',
            idprotocol,
            listPower[power],
            listFan[fan],
            listMode[mode],
            listAir[air],
            '${nhietDo}',
            Constants.mac,
            listEco[eco],
          );
          pubTopic = 'TECHNO1';
          publishMessage(pubTopic, jsonEncode(airconditional));
          setState(() {});
        }
      },
      child: Text('Air'),
    );
  }

  Widget buildDepartment(String text) {
    return Container(
      height: 44,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5,
        ),
        border: Border.all(
          color: Colors.green,
        ),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '',
            ),
          ),
          Expanded(
            child: dropdownDepartment(),
          ),
        ],
      ),
    );
  }

  Widget dropdownDepartment() {
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text('Chọn hãng'),
          value: currentSelectedValue,
          isDense: true,
          onChanged: (newValue) {
            setState(() {
              currentSelectedValue = newValue;
              tbs.forEach((element) {
                if (element.hang == currentSelectedValue) {
                  mahang = element.mahang;
                }
              });
              print('_TestScreenState.dropdownDepartment mahang $mahang');
              getModel();
            });
            print('_TestScreenState.dropdownDepartment currentSelectedValue $currentSelectedValue');
          },
          items: dropDownItems.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildModelAir(String text) {
    return Container(
      height: 44,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5,
        ),
        border: Border.all(
          color: Colors.green,
        ),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '',
              maxLines: 2,
            ),
          ),
          Expanded(
            child: dropdownModelAir(),
          ),
        ],
      ),
    );
  }

  Widget dropdownModelAir() {
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text('Chọn model'),
          value: model,
          isDense: true,
          onChanged: (newValue) {
            setState(() {
              model = newValue;
              listModel.forEach((element) {
                if (element.model == model) {
                  idprotocol = element.idprotocol;
                }
              });
              pubProtocol();
            });
            print('_TestScreenState.dropdownDepartment $model');
          },
          items: dropDownItemsModel.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.clip,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> initMqtt() async {
    mqttClientWrapper = MQTTClientWrapper(
        () => print('Success'), (message) => handleDevice(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);

    getHang();

    mqttClientWrapper.subscribe(Constants.mac, (_message) {
      print('_DetailScreenState.initMqtt $_message');
      var powerResponse = powerResponseFromJson(_message);
      power2 = powerResponse.power;
      setState(() {
      });
      print('_TestScreenState.initMqtt $power2');
      if (power2 == '0') {
        power = 0;
      }
      if (power2 == '1'){
        power = 1;
      }
      print('_TestScreenState.initMqtt so $power');
    });
  }

  void pubProtocol() {
    Airconditional airconditional = Airconditional(
      '',
      'get',
      idprotocol,
      listPower[power],
      listFan[fan],
      listMode[mode],
      listAir[air],
      '${nhietDo}',
      Constants.mac,
      listEco[eco],
    );
    pubTopic = 'TECHNO1';
    publishMessage(pubTopic, jsonEncode(airconditional));
  }

  void subPower(String message){
    final powerResponse = powerResponseFromJson(message);
    power2 = powerResponse.power;
    print('_TestScreenState.subPower $power2');
  }

  void getModel() async {

    Airconditional a =
        Airconditional(mahang,'', '', '', '', '', '', '', Constants.mac, '');
    pubTopic = Constants.GET_MODEL;
    publishMessage(pubTopic, jsonEncode(a));
  }

  void getHang() async {
    Airconditional a =
        Airconditional('', '', '', '', '', '', '', '', Constants.mac, '');
    pubTopic = Constants.GET_HANG;
    publishMessage(pubTopic, jsonEncode(a));
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

  void handleDevice(String message) async {
    switch (pubTopic) {
      case Constants.GET_HANG:
        final airConditionerResponse = airConditionerResponseFromJson(message);
        tbs = airConditionerResponse.id;
        setState(() {});
        break;
      case Constants.GET_MODEL:
        final modelAirconditionalResponse =
            modelAirconditionalResponseFromJson(message);
        listModel = modelAirconditionalResponse.id;
        setState(() {});
        print('_TestScreenState.dropdownModelAir listmodel $listModel');
        break;
    }
    pubTopic = '';

    dropDownItems.clear();
    tbs.forEach((element) {
      dropDownItems.add(element.hang);
    });

    dropDownItemsModel.clear();
    listModel.forEach((element) {
      dropDownItemsModel.add(element.model);
    });
    print('_TestScreenState.handleDevice $dropDownItems');
    print('_TestScreenState.handleDeviceModel $dropDownItemsModel');
  }

  Widget buildButtonPower() {
    if (power == 0) {
      color = Colors.white;
    }

    if (power == 1) {
      color = Colors.red;
    }

    return RaisedButton(
      onPressed: () {
        power++;
        if (power > 1) power = 0;
        Airconditional airconditional = Airconditional(
          '',
          'set',
          idprotocol,
          listPower[power],
          listFan[fan],
          listMode[mode],
          listAir[air],
          '${nhietDo}',
          Constants.mac,
          listEco[eco],
        );
        pubTopic = 'TECHNO1';
        publishMessage(pubTopic, jsonEncode(airconditional));
        setState(() {});
      },
      child: Text('Power'),
      color: color,
    );
  }

  Widget changeColorPower(Airconditional airconditional, int i) {
    if (i == 0) {
      airconditional.color = Colors.red;
    }
  }
}
