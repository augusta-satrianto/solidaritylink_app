import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solidaritylink_app/pages/rating/update_rating_page.dart';
import '../../models/review_model.dart';
import '../../shared/shared_values.dart';
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
  int? userId;
  late Future<List<ReviewModel>> futureReview;

  // Get All
  Future<List<ReviewModel>> fetchReview() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');

    final response = await http.get(
      Uri.parse('$baseUrl/api/reviews'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List campaignList = data['data'];
      return campaignList.map((item) => ReviewModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat review: ${response.body}');
    }
  }

  // Delete
  Future<void> deleteReview(int reviewId, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$baseUrl/api/reviews/$reviewId'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
      // Refresh data atau panggil ulang fetchReview()
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus review'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    futureReview = fetchReview();
  }

  Map<int, int> _calculateRatingStats(List<ReviewModel> reviews) {
    Map<int, int> starCount = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var review in reviews) {
      starCount[review.rating] = starCount[review.rating]! + 1;
    }
    return starCount;
  }

  double _calculateAverage(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0;
    int totalStars = reviews.fold(0, (sum, r) => sum + r.rating);
    return totalStars / reviews.length;
  }

  Widget _buildRatingSummary(List<ReviewModel> reviews) {
    final stats = _calculateRatingStats(reviews);
    final average = _calculateAverage(reviews);
    final total = reviews.length;

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
              const Text(
                "Rating",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
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
                            (_) => const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                          ),
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
    // final ratings = ratingController.getAllRatings();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rating List"),
        backgroundColor: const Color(0xFF5F8D5A),
      ),
      body: FutureBuilder<List<ReviewModel>>(
        future: futureReview,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data'));
          }

          final reviews = snapshot.data!;
          return ListView(
            children: [
              if (reviews.isNotEmpty) _buildRatingSummary(reviews),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  ReviewModel review = reviews[index];
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
                                  review.user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(review.date),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Bintang
                            Row(
                              children: List.generate(
                                review.rating,
                                (index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Komentar
                            Text(
                              review.comment,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            // Tombol edit dan delete
                            if (userId != null && userId == review.user.id)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => UpdateRatingPage(
                                                review: review,
                                              ),
                                        ),
                                      ).then(
                                        (_) => setState(() {
                                          futureReview = fetchReview();
                                        }),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: const Text('Konfirmasi'),
                                              content: const Text(
                                                'Yakin ingin menghapus review ini?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: const Text('Hapus'),
                                                ),
                                              ],
                                            ),
                                      );

                                      if (confirm == true) {
                                        await deleteReview(review.id, context);
                                        setState(() {
                                          futureReview = fetchReview();
                                        });
                                      }
                                    },
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
            ],
          );
        },
      ),
    );
  }
}
