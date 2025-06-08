import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solidaritylink_app/shared/shared_values.dart';

import '../nabila/main_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isShow = false;

  void _register() async {
    FocusScope.of(context).unfocus(); // Tutup keyboard

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama, email, dan password wajib diisi'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': pass,
          'password_confirmation': pass,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final userId = data['data']['user']['id'];
        final name = data['data']['user']['name'];
        final email = data['data']['user']['email'];
        final token = data['data']['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userId);
        await prefs.setString('name', name);
        await prefs.setString('email', email);
        await prefs.setString('token', token);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainScreen()),
          (route) => false,
        );
      } else if (response.statusCode == 422) {
        final errors = data['errors'];
        String errorMessage = 'Registrasi gagal';

        if (errors['email'] != null) {
          errorMessage = errors['email'][0];
        } else if (errors['password'] != null) {
          errorMessage = errors['password'][0];
        } else if (errors['name'] != null) {
          errorMessage = errors['name'][0];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        final message = data['message'] ?? 'Registrasi gagal';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xffE7ECFA)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xffE7ECFA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xffE7ECFA)),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/logo.jpg', width: 100),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Nama'),
                  SizedBox(height: 4),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Masukkan nama';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: Colors.grey[400],
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Email'),
                  SizedBox(height: 4),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Masukkan email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan email',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: Colors.grey[400],
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Kata Sandi'),
                  SizedBox(height: 4),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isShow,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan kata sandi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan kata sandi',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: Colors.grey[400],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isShow ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isShow = !isShow;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _register,
                      child: const Text('Register'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.grey[500]),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
