import '../models/rating_model.dart';

class RatingController {
  final List<Rating> _ratings = [];

  /// Menambahkan rating baru ke daftar
  void addRating(Rating rating) {
    _ratings.add(rating);
  }

  /// Memperbarui rating berdasarkan indeks
  void updateRating(int index, Rating newRating) {
    if (index >= 0 && index < _ratings.length) {
      _ratings[index] = newRating;
    }
  }

  /// Memperbarui rating berdasarkan objek lama
  void updateRatingByObject(Rating oldRating, Rating newRating) {
    final index = _ratings.indexOf(oldRating);
    if (index != -1) {
      _ratings[index] = newRating;
    }
  }

  /// Menghapus rating berdasarkan indeks
  void deleteRating(int index) {
    if (index >= 0 && index < _ratings.length) {
      _ratings.removeAt(index);
    }
  }

  /// Menghapus rating berdasarkan objek
  void deleteRatingByObject(Rating rating) {
    _ratings.remove(rating);
  }

  /// Mengambil semua rating (read-only)
  List<Rating> getAllRatings() {
    return List.unmodifiable(_ratings);
  }
}
