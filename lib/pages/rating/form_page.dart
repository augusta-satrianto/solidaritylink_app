import 'package:flutter/material.dart';
import 'package:solidaritylink_app/models/review_model.dart';
import '../../models/rating_model.dart';
import '../../controllers/rating_controller.dart';
import 'dart:async';

final ratingController = RatingController();

class FormPage extends StatefulWidget {
  final ReviewModel review;

  const FormPage({super.key, required this.review});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();

  int? _selectedStars;
  DateTime _selectedDate = DateTime.now();

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

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text("Create Review"),
        backgroundColor: const Color(0xFF5F8D5A),
      ),
      body: Center(
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
                  "Buat Ulasan Baru",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3F704D),
                  ),
                ),
                const SizedBox(height: 20),

                // Judul
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Bagaimana kesan anda tentang website ini?",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty
                              ? "Judul ulasan tidak boleh kosong"
                              : null,
                ),
                const SizedBox(height: 16),

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
                          value!.isEmpty ? "Komentar tidak boleh kosong" : null,
                ),
                const SizedBox(height: 16),

                // Dropdown Rating
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
                          value == null ? "Pilih rating terlebih dahulu" : null,
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
                // ElevatedButton(
                //   onPressed: _saveRating,
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color(0xFF4D8156),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 32,
                //       vertical: 14,
                //     ),
                //   ),
                //   child: const Text(
                //     "Simpan Ulasan",
                //     style: TextStyle(fontSize: 16, color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
