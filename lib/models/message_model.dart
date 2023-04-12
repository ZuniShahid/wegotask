class MessageModel {
  MessageModel({
    this.messageId,
    this.messageText,
    this.senderId,
    this.senderPicture,
    this.endTime,
    this.endate,
  });

  String? messageId;
  String? messageText;
  String? senderId;
  String? senderPicture;
  String? endTime;
  String? endate;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        messageId: json["message_id"],
        messageText: json["message_text"],
        senderId: json["sender_id"],
        senderPicture: json["sender_picture"],
        endTime: json["end_time"],
        endate: json["create_date"],
      );

  Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "message_text": messageText,
        "sender_id": senderId,
        "sender_picture": senderPicture,
        "end_time": endTime,
        "create_date": endate,
      };
}
