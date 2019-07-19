import 'package:json_annotation/json_annotation.dart';

//part 'Profile.g.dart';

@JsonSerializable()
class Profile {
  String _name;
  int _age;
  bool _male;

  Profile({String name, int age, bool male}) {
    this._name = name;
    this._age = age;
    this._male = male;
  }

  String get name => _name;
  set name(String name) => _name = name;
  int get age => _age;
  set age(int age) => _age = age;
  bool get male => _male;
  set male(bool male) => _male = male;

  Profile.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _age = json['age'];
    _male = json['male'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['age'] = this._age;
    data['male'] = this._male;
    return data;
  }
}

