import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/movies/models/review.dart';
import 'package:netmu/features/movies/services/review_service.dart';

class AllReviewsScreen extends StatefulWidget {
  final String movieId;

  const AllReviewsScreen({super.key, required this.movieId});

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  late final ReviewService _service;
  List<Review> _reviews = [];
  bool _isLoading = true;
  final TextEditingController _controller = TextEditingController();
  int _rating = 5;

  @override
  void initState() {
    super.initState();
    _service = ReviewService(() => Navigator.pushNamedAndRemoveUntil(context, "/auth/login", (r) => false));
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final res = await _service.getReviews(widget.movieId, 1, 100);
    if (mounted) {
      setState(() {
        _reviews = res.$1;
        _isLoading = false;
      });
    }
  }

  Future<void> _submitReview() async {
    if (_controller.text.isEmpty) return;
    setState(() => _isLoading = true);
    final success = await _service.addReview(widget.movieId, _controller.text, _rating);
    if (success) {
      _controller.clear();
      await _loadReviews();
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      appBar: AppBar(
        backgroundColor: ColorTheme.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorTheme.textPrimary),
        title: const Text(
          "All Reviews",
          style: TextStyle(color: ColorTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: _reviews.length,
                    itemBuilder: (context, index) {
                      final review = _reviews[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ColorTheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  review.userName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: ColorTheme.textPrimary),
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      Icons.star,
                                      size: 14,
                                      color: i < (review.rating ?? 0) ? Colors.amber : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              review.content,
                              style: const TextStyle(color: ColorTheme.textSecondary),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Review Input Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: ColorTheme.background,
                    border: Border(top: BorderSide(color: ColorTheme.surface, width: 1)),
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Text("Rating: ", style: TextStyle(color: ColorTheme.textPrimary)),
                            ...List.generate(
                              5,
                              (i) => GestureDetector(
                                onTap: () => setState(() => _rating = i + 1),
                                child: Icon(
                                  Icons.star,
                                  color: i < _rating ? Colors.amber : Colors.grey,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  hintText: "Write a review...",
                                  filled: true,
                                  fillColor: ColorTheme.surface,
                                  border: OutlineInputBorder(borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send, color: ColorTheme.buttonPrimary),
                              onPressed: _submitReview,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
