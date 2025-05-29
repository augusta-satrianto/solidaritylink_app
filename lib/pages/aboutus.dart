import 'package:flutter/material.dart';

void main() {
  runApp(const AboutUsPage());
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SolidarityLink',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const PrivacyPolicyPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoCard(
                  'Menyediakan Pasar Aksi Baik',
                  'Membuat proses mencari relawan dan aktivitas sosial menjadi lebih mudah melalui platform teknologi yang kami bangun yakni Indorelawan.org',
                ),
                _infoCard(
                  'Membuat Kampanye Gotong Royong',
                  'Menghidupkan kembali nilai gotong royong dengan meningkatkan ketertarikan anak muda untuk terlibat menjadi relawan dalam aktivitas sosial',
                ),
                _infoCard(
                  'Pemberdayaan Organisasi Sosial',
                  'Meningkatkan kemampuan organisasi sosial dalam bekerja dengan relawan dengan menyediakan berbagai pelatihan manajemen relawan dan pembuatan modul pembelajaran',
                ),
                const SizedBox(height: 24),
                const Text(
                  'KEBIJAKAN DAN PRIVASI',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kebijakan kami dan aplikasi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'SolidarityLink memahami untuk melindungi privasi dan kerahasiaan informasi pribadi Anda. Kami berkomitmen untuk menjaga dan menggunakan informasi pribadi Anda dengan aman. Kebijakan privasi ini menjelaskan bagaimana kami mengumpulkan, menyimpan, menggunakan dan melindungi informasi pribadi Anda ketika Anda menggunakan aplikasi ini. Kami tidak bertukar untuk informasi yang kami kumpulkan dengan cara afiliasi (misalnya melalui survei, panggilan telepon, atau dokumen tertulis).',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lingkup kebijakan privasi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Ketika Anda mendaftarkan diri untuk layanan kami, Anda memberikan berbagai informasi untuk menerima akses dan layanan tertentu. Kami akan mengumpulkan beberapa informasi yang bisa diidentifikasi secara pribadi (seperti nama, email, dsb) dan non-pribadi (seperti lokasi, jenis perangkat, dsb). Informasi ini digunakan terbatas untuk kebutuhan layanan kami, termasuk laporan perkembangan program sosial kami, pemberian dukungan layanan profesional atau komunikasi dengan Anda sebagai mitra. Tidak akan ada informasi yang disebarluaskan kepada Pihak Ketiga (kecuali untuk organisasi yang juga merupakan mitra) tanpa ada izin dan konfirmasi informasi ini.',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Email / Telepon',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Ketika kami menerima informasi dari untuk layanan kami, kami akan simpan untuk menghubungi Anda dalam kaitan layanan ini. Kami akan menghapus data saat Anda tidak ingin melanjutkan program dari layanan kami atau menghubungi secara langsung kepada tim kami. Kami tidak akan menghubungi Anda untuk hal lain selain kepentingan layanan aplikasi ini. Jika Anda memutuskan untuk berhenti dari layanan kami, silakan hubungi kami melalui kontak yang disediakan. Data Anda akan dihapus sepenuhnya dari database dengan layanan pengelolaan data yang digunakan.',
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
      ),
    );
  }

  Widget _infoCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}
