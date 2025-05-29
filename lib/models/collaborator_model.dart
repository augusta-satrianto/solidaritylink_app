class Collaborator {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String location;
  final String organizer;
  final int maxParticipants;
  final List<String> participants;
  final String status;

  Collaborator({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.location,
    required this.organizer,
    required this.maxParticipants,
    required this.participants,
    required this.status,
  });

  // Dummy data
  static List<Collaborator> dummyCollaborators = [
    Collaborator(
      id: '1',
      title: 'Berbagi Makanan untuk Korban Banjir',
      description: 'Kegiatan berbagi makanan untuk korban banjir di Jakarta',
      eventDate: DateTime.now().add(const Duration(days: 3)),
      location: 'Jakarta Selatan',
      organizer: 'Yayasan Peduli Sosial',
      maxParticipants: 20,
      participants: ['1', '2', '3'],
      status: 'active',
    ),
    Collaborator(
      id: '2',
      title: 'Penggalangan Dana untuk Korban Gempa',
      description: 'Penggalangan dana untuk membantu korban gempa di Cianjur',
      eventDate: DateTime.now().add(const Duration(days: 5)),
      location: 'Cianjur',
      organizer: 'Relawan Indonesia',
      maxParticipants: 15,
      participants: ['1', '4', '5'],
      status: 'active',
    ),
  ];
} 