import 'package:flutter/material.dart';
import 'pages/auth/login_page.dart';
import 'pages/home.dart';
import 'pages/news.dart';
import 'pages/method.dart';
import 'pages/aboutus.dart';
import 'pages/rating/rating_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SolidarityLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: Theme.of(
          context,
        ).colorScheme.copyWith(primary: Colors.green),
      ),
      home: MainLayout(child: HomePage()),
    );
  }
}

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F8D5A),
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/logo.jpg',
                height: 32,
                width: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'SolidarityLink',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions:
            MediaQuery.of(context).size.width > 600
                ? [
                  _buildNavButton(context, 'Beranda'),
                  _buildNavButton(context, 'Berita'),
                  _buildNavButton(context, 'Metode'),
                  _buildNavButton(context, 'Tentang Kami'),
                  _buildNavButton(context, 'Ulasan'),
                  _buildNavButton(context, 'Login'),
                ]
                : null,
      ),
      drawer:
          MediaQuery.of(context).size.width <= 500
              ? Drawer(
                child: Container(
                  color: const Color(0xFF5F8D5A),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: const Color(0xFF5F8D5A),
                        ),
                        child: const Text(
                          'SolidarityLink',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      _buildDrawerItem(context, 'Beranda'),
                      _buildDrawerItem(context, 'Berita'),
                      _buildDrawerItem(context, 'Metode'),
                      _buildDrawerItem(context, 'Tentang Kami'),
                      _buildDrawerItem(context, 'Ulasan'),
                      _buildDrawerItem(context, 'Login'),
                    ],
                  ),
                ),
              )
              : null,
      body: child,
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title) {
    return ListTile(
      tileColor: const Color(0xFF5F8D5A),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        _navigateToPage(context, title);
      },
    );
  }

  Widget _buildNavButton(BuildContext context, String title) {
    return TextButton(
      onPressed: () {
        _navigateToPage(context, title);
      },
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }

  void _navigateToPage(BuildContext context, String title) {
    Widget? targetPage;

    switch (title) {
      case 'Beranda':
        targetPage = HomePage();
        break;
      case 'Berita':
        targetPage = NewsPage();
        break;
      case 'Metode':
        targetPage = MethodPage();
        break;
      case 'Tentang Kami':
        targetPage = AboutUsPage();
        break;
      case 'Ulasan':
        targetPage = PageRatingPage();
        break;
      case 'Login':
        targetPage = LoginPage();
        break;
    }

    if (targetPage != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainLayout(child: targetPage!)),
      );
    }
  }
}
