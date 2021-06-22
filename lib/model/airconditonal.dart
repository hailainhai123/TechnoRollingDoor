import 'package:flutter/cupertino.dart';

class Airconditional {
  String mahang;
  String cmd;
  String idprotocol;
  String power;
  String fan;
  String mode;
  String eco;
  String airflow;
  String nhietdo;
  String mac;
  Color color;
  List<dynamic> id;

  Airconditional(this.mahang, this.cmd, this.idprotocol, this.power, this.fan, this.mode,
      this.airflow, this.nhietdo, this.mac, this.eco);

  Airconditional.fromJson(Map<String, dynamic> json)
      : mahang = json['mahang'],
        cmd = json['cmd'],
        idprotocol = json['idprotocol'],
        power = json['power'],
        fan = json['fan'],
        mode = json['mode'],
        eco = json['eco'],
        airflow = json['airflow'],
        nhietdo = json['nhietdo'],
        mac = json['mac'];

  Map<String, dynamic> toJson() => {
    'mahang': mahang,
    'cmd': cmd,
    'idprotocol': idprotocol,
    'power': power,
    'fan': fan,
    'mode': mode,
    'mac': mac,
    'eco': eco,
    'airflow': airflow,
    'nhietdo': nhietdo,

  };

  @override
  String toString() {
    return '$mahang - $cmd - $idprotocol - $power - $fan- $mode - $eco - $airflow - $nhietdo';
  }
}
