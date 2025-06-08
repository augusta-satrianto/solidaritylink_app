import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:solidaritylink_app/shared/shared_values.dart';

class CreateRatingPage extends StatefulWidget {
  const CreateRatingPage({super.key});

  @override
  State<CreateRatingPage> createState() => _CreateRatingPageState();
}

class _CreateRatingPageState extends State<CreateRatingPage> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int? _selectedStars;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveReview() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/api/reviews'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'comment': _commentController.text,
        'rating': _selectedStars,
        'date': _selectedDate.toIso8601String().split('T').first,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review berhasil dikirim'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal: ${response.body}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text("Create Review"),
        backgroundColor: const Color(0xFF5F8D5A),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFDFF1DC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Tulis Ulasan Anda",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F704D),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Komentar
                  TextFormField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Komentar",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? "Komentar tidak boleh kosong"
                                : null,
                  ),
                  const SizedBox(height: 16),

                  // Rating
                  DropdownButtonFormField<int>(
                    value: _selectedStars,
                    decoration: InputDecoration(
                      labelText: "Rating (1 - 5)",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: List.generate(5, (index) {
                      final value = index + 1;
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        _selectedStars = value;
                      });
                    },
                    validator:
                        (value) =>
                            value == null
                                ? "Pilih rating terlebih dahulu"
                                : null,
                  ),
                  const SizedBox(height: 16),

                  // Tanggal
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Tanggal",
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        controller: TextEditingController(
                          text:
                              "${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Simpan
                  ElevatedButton(
                    onPressed: _saveReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4D8156),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      "Simpan Ulasan",
                      style: TextStyle(fontSize: 16, color: Colors.white),
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
