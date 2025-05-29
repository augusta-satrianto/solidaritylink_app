import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  final List<Map<String, String>> newsList = [
    {
      "title": "Galang Dana Banjir Malang",
      "image": "assets/kol8.jpg",
      "location": "Malang",
      "date": "28 Maret 2024",
      "description":
          "Kota Batu, Malang, Jawa Timur, terkena banjir yang menelan korban jiwa. Masyarakat membutuhkan bantuan segera."
    },
    {
      "title": "Membangun Rumah di Surga",
      "image": "assets/kol4.jpg",
      "location": "Sumatra Utara",
      "date": "25 Maret 2024",
      "description":
          "Warga desa Pematang sedang membangun masjid dan membutuhkan bantuan berupa tenaga dari teman-teman semua."
    },
    {
      "title": "Bencana Alam Melanda Sulawesi",
      "image": "assets/kol10.jpeg",
      "location": "Sulawesi Tengah",
      "date": "20 Maret 2023",
      "description":
          "Gempa bumi berkekuatan 6.5 SR mengguncang Sulawesi Tengah, merusak ratusan rumah dan infrastruktur penting."
    },
    {
      "title": "Anak Menjadi Tulang Punggung Keluarga",
      "image": "assets/kol11.jpeg",
      "location": "Jawa Timur",
      "date": "18 Maret 2024",
      "description":
          "Anak yang bersekolah di bangku dasar rela berjualan sepulang sekolah demi memenuhi kebutuhan keluarganya."
    },
    {
      "title": "Penyaluran Bantuan Untuk Sumatra Barat",
      "image": "assets/landing2.jpeg",
      "location": "Sumatra Barat",
      "date": "15 Maret 2024",
      "description":
          "Penyaluran bantuan berupa pakaian, makanan, obat-obatan ke posko pengungsian korban banjir lahar dingin."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            // Bagian daftar berita
            ...newsList.map((news) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        news['image']!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news['title']!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            news['description']!,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.location_pin,
                                  color: Colors.red, size: 24),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(news['location']!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text(news['date']!,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600])),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            // Bagian footer informasi
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'SolidarityLink',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'SolidarityLink adalah wadah online untuk mempertemukan antara relawan dan organisasi/komunitas sosial',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Volunteer Hub Bandung\nJl. Telekomunikasi No.1\nTerusan Buah Batu',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                '+62 823 8278 6904',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Center(child: Text('Social Media')),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
