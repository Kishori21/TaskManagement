import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class InfoJsonModel{
  final String _id;
  final String _name;

  String get name => _name;

  InfoJsonModel(this._id, this._name);

  String get id => _id;
  Map getJson() {
    var map={};
    map["id"]=id;
    return map;
  }


}