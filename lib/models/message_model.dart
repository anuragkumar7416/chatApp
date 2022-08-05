

import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String? msg;
  String? timestamp;
  String? type;
  String? id;
  Message(
      this.msg,
      this.timestamp,
      this.type,
      this.id,
      );

  Message.fromSnapshot(Map snapshot)
      :
        msg =snapshot['msg'].toString(),
        timestamp =snapshot['timestamp'].toString(),
        type = snapshot['type'].toString(),
         id = snapshot['id'].toString();


  // Map<String, dynamic> toJson() => {
  //   'msg':msg,
  //   'timestamp':timestamp,
  //   'type':type,
  //   'id': id,
  // };

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'msg': msg,
    'timestamp': timestamp,
    'type': type,
    'id': id,
  };
  Message.fromJson(Map<dynamic, dynamic> json)
      : msg = json['msg'] ,
       timestamp = json['timestamp'] ,
        type = json['type'] ,
        id = json['id'] ;

}