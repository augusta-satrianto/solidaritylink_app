class MessageModel {
  int id;
  int senderId;
  int receiverId;
  String text;
  String? imagePath;
  DateTime time;
  int? replyToId;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    this.imagePath,
    required this.time,
    this.replyToId,
  });
}
