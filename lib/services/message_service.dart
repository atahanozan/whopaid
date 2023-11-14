import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whopayed/model/message_model.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<MessageModel> addMessage(
    bool read,
    String senderUid,
    String sentUid,
    String message,
    String payTo,
    String sender,
    int datetime,
  ) async {
    final messages = MessageModel(
      read: read,
      senderUid: senderUid,
      sentUid: sentUid,
      message: message,
      payTo: payTo,
      sender: sender,
      datetime: datetime,
    );

    _firestore.collection("Messages").add(messages.toMap());

    return messages;
  }
}
