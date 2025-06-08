import 'user_model.dart';

class ReviewModel {
  final int id;
  final int userId;
  final String comment;
  final int rating;
  final DateTime date;
  final UserModel user;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.comment,
    required this.rating,
    required this.date,
    required this.user,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      userId: json['user_id'],
      comment: json['comment'],
      rating: json['rating'],
      date: DateTime.parse(json['date']),
      user: UserModel.fromJson(json['user']),
    );
  }
}
