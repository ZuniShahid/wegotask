class MessageModel {
  MessageModel({
    this.messageId,
    this.messageText,
    this.senderId,
    this.senderPicture,
    this.createdAt,
  });

  String? messageId;
  String? messageText;
  String? senderId;
  String? senderPicture;
  DateTime? createdAt;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        messageId: json["_id"],
        messageText: json["message"],
        senderId: json["sender_id"],
        senderPicture: json["image"],
    createdAt: json['created_at'].toDate()
      );

  Map<String, dynamic> toJson() => {
        "_id": messageId,
        "message": messageText,
        "sender_id": senderId,
        "image": senderPicture,
      };
}
