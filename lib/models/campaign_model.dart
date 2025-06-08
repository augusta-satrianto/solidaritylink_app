class CampaignModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String location;
  final String city;
  final String province;
  final DateTime createdAt;
  final DateTime updatedAt;

  CampaignModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.city,
    required this.province,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      city: json['city'],
      province: json['province'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'location': location,
      'city': city,
      'province': province,
    };
  }
}
