import 'package:flutter/material.dart';

void main() {
  runApp(const HomePage());
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(),
            StatsSection(),
            FeatureCards(),
            MotivasiGrid(),
            GallerySection(),
            TestimonialSection(),
            FooterSection(),
          ],
        ),
      ),
    );
  }
}

// ---------------- Header ----------------
class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/home.jpg',
          height: 320,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 320,
          width: double.infinity,
          color: Colors.black.withOpacity(0.5),
        ),
        Positioned.fill(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Ambil Peran Jadi Relawan',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  'Ubah niat baik jadi aksi baik hari ini',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------- Stats ----------------
class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              StatBox(icon: 'lan1.jpg', number: '561,213', label: 'Relawan'),
              StatBox(icon: 'lan2.jpg', number: '9,646', label: 'Organisasi'),
              StatBox(icon: 'lan3.jpg', number: '27,057', label: 'Aktivitas'),
            ],
          ),
        ),
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  final String icon;
  final String number;
  final String label;

  const StatBox({required this.icon, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/$icon', width: 50, height: 50),
        const SizedBox(height: 8),
        Text(number, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// ---------------- Features ----------------
class FeatureCards extends StatelessWidget {
  const FeatureCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.green, Colors.lightGreenAccent]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text("Website #1 untuk mencari relawan sosial",
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const Text("Lebih banyak relawan, lebih besar dampaknya.",
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Cari Aktivitas"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              InfoCard(title: "Jadi Relawan", icon: Icons.favorite, text: "Baru memulai untuk jadi relawan? Pelajari selengkapnya dan mulai cari aktivitas kerelawanan pertama kamu!"),
              InfoCard(title: "Cari Relawan", icon: Icons.group, text: "Butuh bantuan relawan? Pelajari selengkapnya dan temukan relawan yang tepat!"),
              InfoCard(title: "Kerjasama Team", icon: Icons.leaderboard, text: "Tingkatkan kerjasama yang baik bersama kami dengan melibatkan komunitas dan relawan lain!"),
            ],
          )
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String text;

  const InfoCard({required this.title, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red.shade100,
                child: Icon(icon, color: Colors.red),
              ),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(text, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Motivasi Grid ----------------
class MotivasiGrid extends StatelessWidget {
  const MotivasiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'bukan pahlawan besar tapi para RELAWAN',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: const [
              MotivasiBox(
                  color: Color(0xFFFFE7C6),
                  text: "Gunakan aplikasi untuk mendukung berbagai masalah sosial "),
              MotivasiBox(
                  color: Color(0xFFFFE6E1),
                  text: "Ayo luangkan sedikit waktu dan tenaga untuk turun langsung ke lapangan "),
              MotivasiBox(
                  color: Color(0xFFD9EAD3),
                  text: "Menjadi salah satu peringan bagi mereka yang membutuhkan."),
              MotivasiBox(
                  color: Color(0xFFE0E9F5),
                  text: "Gunakan untuk mendapatkan bantuan bagi yang membutuhkan  "),
            ],
          ),
        ),
      ],
    );
  }
}

class MotivasiBox extends StatelessWidget {
  final Color color;
  final String text;

  const MotivasiBox({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

// ---------------- Gallery ----------------
class GallerySection extends StatelessWidget {
  const GallerySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 310,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/kol11.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: Text(
                'Gallery',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Grid galeri gambar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3, // menyesuaikan dengan lg:grid-cols-3
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              GalleryImage('assets/kol9.jpeg'),
              GalleryImage('assets/kol8.jpg'),
              GalleryImage('assets/kol3.jpg'),
              GalleryImage('assets/kol4.jpg'),
              GalleryImage('assets/kol6.jpg'),
              GalleryImage('assets/kol7.jpg'),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget untuk setiap gambar galeri
class GalleryImage extends StatelessWidget {
  final String imagePath;

  const GalleryImage(this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
// ---------------- Rating & Testimonials ----------------
class TestimonialSection extends StatelessWidget {
  const TestimonialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bagian judul dan link
        Container(
          color: const Color(0xFFF9FAFB),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              const Text(
                'Testimoni',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                },
                child: const Text(
                  'Mereka yang pernah menggunakan SolidarityLink',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

        // Kartu Testimoni
        Container(
          color: const Color(0xFFF3F4F6),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Center(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: const [
                TestimonialCard(
                  image: 'assets/landing1.jpeg',
                  title: 'Gerakan Suka Membantu',
                  text:
                      'SolidarityLink berperan penting dalam mendukung Gerakan Suka Membantu dengan menghubungkan kami dengan ribuan relawan yang memiliki visi yang sama.',
                ),
                TestimonialCard(
                  image: 'assets/landing2.jpeg',
                  title: 'Teruntuk Project',
                  text:
                      'Platform SolidarityLink sangat mudah digunakan dan dapat menyatukan kebaikan, kami bertemu relawan dan komunitas sehingga dapat memperluas jangkauan program kami.',
                ),
                TestimonialCard(
                  image: 'assets/landing3.jpeg',
                  title: 'Relawan Peduli',
                  text:
                      'Melalui SolidarityLink, kami dapat lebih mudah menemukan relawan dengan berbagai keahlian yang mendukung misi sosial kami.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TestimonialCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;

  const TestimonialCard({
    super.key,
    required this.image,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          ClipOval(
            child: Image.asset(
              image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFFDC2626),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}
// ---------------- Footer Section ----------------
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 24),
        Center(
          child: Text(
            'SolidarityLink',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.green,
            ),
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: Text(
            'SolidarityLink adalah wadah online untuk mempertemukan antara relawan dan organisasi/komunitas sosial',
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Text(
            'Volunteer Hub Bandung\nJl. Telekomunikasi No.1\nTerusan Buah Batu',
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: Text(
            '+62 823 8278 6904',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Center(child: Text('Social Media')),
        SizedBox(height: 24),
      ],
    );
  }
}