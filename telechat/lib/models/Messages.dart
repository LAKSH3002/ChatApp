class Messages{
  late final String toId;
  late final String msg;
  late final String read;
  late final String type;
  late final String fromId; 
  late final String sent;

  Messages({
    required this.toId,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
  });

  Messages.fromJson(Map<String, dynamic> json){
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    type = json['type'].toString();
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson(){
      final data = <String, dynamic>{};
      data['toId'] = toId;
      data['msg'] = msg;
      data['read'] = read;
      data['type'] = type;
      data['fromId'] = fromId;
      data['sent'] = sent;
      return data;
  }
}

enum Type{ text, image}