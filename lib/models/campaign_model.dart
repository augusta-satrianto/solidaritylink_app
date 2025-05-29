class Campaign {
  final String id;
  final String title;
  final String location;
  final String city;
  final String description;
  final List<String> needs;
  final String currentCondition;
  final DateTime reportDate;
  final String emergencyContact;
  final List<String> images;
  final String imageDescription;
  final String userId;

  Campaign({
    required this.id,
    required this.title,
    required this.location,
    required this.city,
    required this.description,
    required this.needs,
    required this.currentCondition,
    required this.reportDate,
    required this.emergencyContact,
    required this.images,
    required this.imageDescription,
    required this.userId,
  });

  // Dummy data
  static List<Campaign> dummyCampaigns = [
    Campaign(
      id: '1',
      title: 'Bantuan Korban Banjir Jakarta',
      location: 'Kelurahan Manggarai',
      city: 'Jakarta Selatan',
      description: 'Banjir melanda area pemukiman warga',
      needs: ['Makanan', 'Pakaian', 'Obat-obatan'],
      currentCondition: 'Air masih menggenang setinggi 50cm',
      reportDate: DateTime.now(),
      emergencyContact: '081234567890',
      images: ['https://via.placeholder.com/300'],
      imageDescription: 'Kondisi banjir di area pemukiman',
      userId: '1',
    ),
    Campaign(
      id: '2',
      title: 'Bantuan Korban Gempa',
      location: 'Desa Sukamaju',
      city: 'Cianjur',
      description: 'Gempa bumi melanda desa',
      needs: ['Tenda', 'Makanan', 'Obat-obatan', 'Uang'],
      currentCondition: 'Banyak rumah rusak',
      reportDate: DateTime.now().subtract(const Duration(days: 2)),
      emergencyContact: '081234567891',
      images: ['https://via.placeholder.com/300'],
      imageDescription: 'Kondisi rumah yang rusak',
      userId: '1',
    ),
  ];
} 