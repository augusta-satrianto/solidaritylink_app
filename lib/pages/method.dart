import 'package:flutter/material.dart';

void main() => runApp(MethodPage());

class MethodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              StepCard(
                stepNumber: 1,
                title: 'Daftar sebagai relawan',
                description:
                    'Luangkan sedikit waktu untuk membantu sesama melalui berbagai cara dan tindakan sederhana. '
                    'Terkadang, hal kecil yang kita lakukan bisa memberikan dampak besar bagi orang lain. '
                    'Mari kita berbuat baik dengan tulus.',
                imagePath: 'assets/login.jpg',
                borderColor: Colors.orange,
              ),
              StepCard(
                stepNumber: 2,
                title: 'Lengkapi Profil',
                description:
                    'Kelengkapan profil memengaruhi kesuksesan Anda dalam berbagi. Profil yang jelas dan akurat '
                    'membangun kepercayaan, memudahkan orang lain mengenali peran Anda.',
                imagePath: 'assets/profil.jpg',
                borderColor: Colors.blue,
              ),
              StepCard(
                stepNumber: 3,
                title: 'Cari aktivitas terkait',
                description:
                    'Terjun langsung atau memberi donasi, keduanya bisa sangat membantu yang membutuhkan. '
                    'Tindakan kecil punya potensi besar untuk merubah hidup orang lain. Mari bersama-sama '
                    'meringankan beban sesama.',
                imagePath: 'assets/aktifitas.jpg',
                borderColor: Colors.green,
              ),
              StepCard(
                stepNumber: 4,
                title: 'Dokumentasi',
                description:
                    'Dengan fitur ini, pengguna dapat dengan mudah mengakses dan membagikan data dengan akurat. '
                    'Dengan fitur dokumentasi yang efisien, proses kerja menjadi lebih terstruktur dan kolaboratif.',
                imagePath: 'assets/mengajar1.png',
                borderColor: Colors.red,
              ),
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
      ),
    );
  }
}

class StepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;
  final String imagePath;
  final Color borderColor;

  StepCard({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                stepNumber.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              radius: 14,
            ),
            SizedBox(height: 8),
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Text(description),
            SizedBox(height: 8),
            Image.asset(imagePath, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
