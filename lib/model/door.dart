import 'package:flutter/cupertino.dart';

class Door {
  String matb;
  String vitri;
  String cmd;
  String iduser;
  String mac;
  Color color;
  List<dynamic> id;

  Door(this.matb,  this.vitri, this.cmd, this.iduser, this.mac,);

  Door.fromJson(Map<String, dynamic> json)
      : matb = json['matb'],
        vitri = json['vitri'],
        cmd = json['cmd'],
        iduser = json['iduser'],
        mac = json['mac'];

  Map<String, dynamic> toJson() => {
    'matb': matb,
    'vitri': vitri,
    'cmd': cmd,
    'iduser': iduser,
    'mac': mac,
  };

  @override
  String toString() {
    return '$matb - $vitri - $cmd -$iduser';
  }
}
