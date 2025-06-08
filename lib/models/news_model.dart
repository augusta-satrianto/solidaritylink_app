class NewsModel {
  final int id;
  final String title;
  final String description;
  final String location;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
