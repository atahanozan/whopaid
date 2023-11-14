class MessageModel {
  final bool read;
  final String senderUid;
  final String sentUid;
  final String message;
  final String payTo;
  final String sender;
  final int datetime;
  MessageModel({
    required this.read,
    required this.senderUid,
    required this.sentUid,
    required this.message,
    required this.payTo,
    required this.sender,
    required this.datetime,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> result = {
      "read": read,
      "senderUid": senderUid,
      "sentUid": sentUid,
      "message": message,
      "payTo": payTo,
      "sender": sender,
      "datetime": datetime,
    };

    return result;
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      read: map["read"],
      senderUid: map['senderUid'],
      sentUid: map['sentUid'],
      message: map['message'],
      payTo: map["payTo"],
      sender: map["sender"],
      datetime: map['datetime'],
    );
  }
}
