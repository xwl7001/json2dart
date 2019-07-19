import 'package:json_annotation/json_annotation.dart';

//part 'User.g.dart';

@JsonSerializable()
class User {
  String _name;
  String _father;
  String _friends;
  String _keywords;
  String _bankCards;
  int _age;

  User(
      {String name,
      String father,
      String friends,
      String keywords,
      String bankCards,
      int age}) {
    this._name = name;
    this._father = father;
    this._friends = friends;
    this._keywords = keywords;
    this._bankCards = bankCards;
    this._age = age;
  }

  String get name => _name;
  set name(String name) => _name = name;
  String get father => _father;
  set father(String father) => _father = father;
  String get friends => _friends;
  set friends(String friends) => _friends = friends;
  String get keywords => _keywords;
  set keywords(String keywords) => _keywords = keywords;
  String get bankCards => _bankCards;
  set bankCards(String bankCards) => _bankCards = bankCards;
  int get age => _age;
  set age(int age) => _age = age;

  User.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _father = json['father'];
    _friends = json['friends'];
    _keywords = json['keywords'];
    _bankCards = json['bankCards'];
    _age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['father'] = this._father;
    data['friends'] = this._friends;
    data['keywords'] = this._keywords;
    data['bankCards'] = this._bankCards;
    data['age'] = this._age;
    return data;
  }
}

