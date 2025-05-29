import 'package:flutter/material.dart';
import 'form_page.dart';
import '../controllers/rating_controller.dart';
import '../models/rating_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Future<Map<String, dynamic>> getReviewController() async{
//   var url = Uri.parse('http://10.60.41.45:8000');
//   var response = await http.get(url);
//   var list = jsonDecode(response.body);
// }
class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  void _deleteRating(int index) {
    setState(() {
      ratingController.deleteRating(index);
    });
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return months[month - 1];
  }

  Map<int, int> _calculateRatingStats(List<Rating> ratings) {
    Map<int, int> starCount = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var rating in ratings) {
      starCount[rating.stars] = starCount[rating.stars]! + 1;
    }
    return starCount;
  }

  double _calculateAverage(List<Rating> ratings) {
    if (ratings.isEmpty) return 0;
    int totalStars = ratings.fold(0, (sum, r) => sum + r.stars);
    return totalStars / ratings.length;
  }

  Widget _buildRatingSummary(List<Rating> ratings) {
    final stats = _calculateRatingStats(ratings);
    final average = _calculateAverage(ratings);
    final total = ratings.length;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.green.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("Rating",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Icon(
                    index < average.round() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 28,
                  );
                }),
              ),
              Text(
                average.toStringAsFixed(1),
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const Text("out of 5"),
              Text("$total Total ratings"),
              const SizedBox(height: 16),
              Column(
                children: List.generate(5, (i) {
                  int star = 5 - i;
                  int count = stats[star]!;
                  double percent = total > 0 ? count / total : 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                              star,
                              (_) => const Icon(Icons.star,
                                  size: 14, color: Colors.amber)),
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: percent,
                            color: Colors.green,
                            backgroundColor: Colors.grey.shade300,
                            minHeight: 10,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text("${(percent * 100).round()}%"),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ratings = ratingController.getAllRatings();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rating List"),
        backgroundColor: const Color(0xFF5F8D5A),
      ),
      body: Column(
        children: [
          if (ratings.isNotEmpty) _buildRatingSummary(ratings),
          Expanded(
            child: ListView.builder(
              itemCount: ratings.length,
              itemBuilder: (context, index) {
                Rating rating = ratings[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.green.shade100),
                    ),
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul dan Nama + Tanggal
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                rating.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${rating.date.day} ${_getMonthName(rating.date.month)}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Bintang
                          Row(
                            children: List.generate(
                              rating.stars,
                              (index) => const Icon(Icons.star,
                                  color: Colors.amber, size: 20),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Komentar
                          Text(
                            '"${rating.comment}"',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          // Tombol edit dan delete
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FormPage(
                                        editIndex: index,
                                        existingRating: rating,
                                      ),
                                    ),
                                  ).then((_) => setState(() {}));
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteRating(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
