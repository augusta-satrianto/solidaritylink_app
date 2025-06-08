// Widget MainScreen adalah tampilan utama dengan navigasi bawah
import 'package:flutter/material.dart';
import 'package:solidaritylink_app/pages/chat/chat_page.dart';

import '../rating/rating_page.dart';
import 'campaign_screen.dart';
import 'collaborator_screen.dart';
import 'dashboard_screen.dart';
import 'message_screen.dart';
import 'rating_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState(); // Membuat state untuk widget MainScreen
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Menyimpan indeks menu bawah yang sedang dipilih

  // Daftar tampilan (screen) yang sesuai dengan menu navigasi bawah
  final List<Widget> _screens = [
    const DashboardScreen(), // Index 0: Beranda
    const CampaignScreen(), // Index 1: Kampanye
    const CollaboratorScreen(), // Index 2: Kolaborator
    const ChatPage(), // Index 3: Pesan
    // const RatingScreen(), // Index 4: Penilaian
    const PageRatingPage(),
    // const RatingScreen(), // Index 4: Penilaian
  ];

  // Fungsi saat item navigasi bawah diklik
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Perbarui tampilan berdasarkan menu yang diklik
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _screens[_selectedIndex], // Menampilkan screen sesuai menu yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        type:
            BottomNavigationBarType
                .fixed, // Semua item tetap terlihat (tidak shifting)
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), // Ikon Beranda
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign), // Ikon Kampanye
            label: 'Kampanye',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group), // Ikon Kolaborator
            label: 'Kolaborator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message), // Ikon Pesan
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star), // Ikon Pesan
            label: 'Ulasan',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.star), // Ikon Penilaian
          //   label: 'Penilaian',
          // ),
        ],
        currentIndex: _selectedIndex, // Menandai item yang sedang aktif
        selectedItemColor: Colors.blue, // Warna ikon dan teks saat aktif
        unselectedItemColor:
            Colors.grey, // Warna ikon dan teks saat tidak aktif
        onTap: _onItemTapped, // Aksi saat item diklik
      ),
    );
  }
}
