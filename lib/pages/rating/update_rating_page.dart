import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:solidaritylink_app/shared/shared_values.dart';
import 'dart:convert';

import '../../models/review_model.dart';

class UpdateRatingPage extends StatefulWidget {
  final ReviewModel review;

  const UpdateRatingPage({super.key, required this.review});

  @override
  State<UpdateRatingPage> createState() => _UpdateRatingPageState();
}

class _UpdateRatingPageState extends State<UpdateRatingPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _commentController;
  int? _selectedStars;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.review.comment);
    _selectedStars = widget.review.rating;
    _selectedDate = widget.review.date;
  }

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

  Future<void> _updateReview() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$baseUrl/api/reviews/${widget.review.id}'),
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

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // Kembali dan beri tanda sukses
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal update: ${response.body}'),
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
        title: const Text("Edit Review"),
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
                    "Edit Ulasan Anda",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F704D),
                    ),
                  ),
                  const SizedBox(height: 20),

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

                  ElevatedButton(
                    onPressed: _updateReview,
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
                      "Update Ulasan",
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
