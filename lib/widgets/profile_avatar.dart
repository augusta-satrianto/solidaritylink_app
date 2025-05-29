import 'package:flutter/material.dart'; // Mengimpor package Material Design dari Flutter

// Membuat widget kustom bernama ProfileAvatar yang tidak berubah (StatelessWidget)
class ProfileAvatar extends StatelessWidget {
  // Nama pengguna, akan digunakan untuk mengambil inisial
  final String name;

  // Ukuran avatar (diameter lingkaran), default-nya 100
  final double size;

  // Warna latar belakang avatar (opsional)
  final Color? backgroundColor;

  // Warna teks/inisial dalam avatar (opsional)
  final Color? textColor;

  // Constructor ProfileAvatar, menerima parameter wajib 'name' dan opsional lainnya
  const ProfileAvatar({
    super.key, // Kunci unik widget (biasanya digunakan dalam widget tree)
    required this.name, // Parameter wajib
    this.size = 100,     // Default size jika tidak diberikan
    this.backgroundColor, // Opsional
    this.textColor,       // Opsional
  });

  // Getter untuk mengambil inisial dari nama pengguna
  String get _initials {
    if (name.isEmpty) return ''; // Jika nama kosong, kembalikan string kosong

    final nameParts = name.split(' '); // Pisahkan nama berdasarkan spasi
    if (nameParts.length == 1) {
      // Jika hanya satu kata (contoh: "Nabila")
      return nameParts[0].substring(0, 1).toUpperCase(); // Ambil huruf pertama dan ubah jadi kapital
    }

    // Jika lebih dari satu kata (contoh: "Nabila Putri")
    return '${nameParts[0].substring(0, 1)}${nameParts[1].substring(0, 1)}'.toUpperCase(); 
    // Ambil huruf pertama dari dua kata pertama dan kapitalisasi
  }

  @override
  Widget build(BuildContext context) {
    // Bangun tampilan widget
    return Container(
      width: size, // Lebar avatar
      height: size, // Tinggi avatar
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.green[400], // Warna latar (default hijau jika tidak diisi)
        shape: BoxShape.circle, // Membuat bentuk lingkaran
        boxShadow: [
          // Memberikan efek bayangan
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Warna bayangan dengan transparansi 10%
            blurRadius: 10, // Radius blur bayangan
            offset: const Offset(0, 5), // Posisi bayangan (0 kanan/kiri, 5 ke bawah)
          ),
        ],
      ),
      child: Center(
        // Menempatkan isi ke tengah lingkaran
        child: Text(
          _initials, // Menampilkan inisial pengguna
          style: TextStyle(
            color: textColor ?? Colors.white, // Warna teks, default putih
            fontSize: size * 0.4, // Ukuran font proporsional terhadap ukuran avatar
            fontWeight: FontWeight.bold, // Teks ditebalkan
          ),
        ),
      ),
    );
  }
}
