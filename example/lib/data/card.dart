import 'package:json_annotation/json_annotation.dart';

//part 'Card.g.dart';

@JsonSerializable()
class Card {
  String _no;
  String _name;

  Card({String no, String name}) {
    this._no = no;
    this._name = name;
  }

  String get no => _no;
  set no(String no) => _no = no;
  String get name => _name;
  set name(String name) => _name = name;

  Card.fromJson(Map<String, dynamic> json) {
    _no = json['no'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['no'] = this._no;
    data['name'] = this._name;
    return data;
  }
}

