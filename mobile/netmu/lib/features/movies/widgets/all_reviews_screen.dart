import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/core/utils/api/token_storage.dart';
import 'package:netmu/core/utils/jwt/jwt_utils.dart';
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
  String? _currentUserId;
  String? _editingReviewId;

  @override
  void initState() {
    super.initState();
    _service = ReviewService(() => Navigator.pushNamedAndRemoveUntil(context, "/auth/login", (r) => false));
    _loadCurrentUser();
    _loadReviews();
  }

  Future<void> _loadCurrentUser() async {
    final storage = SecureTokenStorage();
    final token = await storage.getAccessToken();
    if (token != null) {
      try {
        final payload = JwtUtils.decode(token);
        setState(() {
          _currentUserId = payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ?? payload['sub'];
        });
      } catch (e) {
        // ignore
      }
    }
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
    
    bool success;
    if (_editingReviewId != null) {
      success = await _service.updateReview(_editingReviewId!, _controller.text, _rating);
    } else {
      success = await _service.addReview(widget.movieId, _controller.text, _rating);
    }

    if (success) {
      _controller.clear();
      setState(() {
        _editingReviewId = null;
        _rating = 5;
      });
      await _loadReviews();
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _editReview(Review review) {
    setState(() {
      _editingReviewId = review.id;
      _controller.text = review.content;
      _rating = review.rating ?? 5;
    });
  }

  Future<void> _deleteReview(String reviewId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorTheme.surface,
        title: const Text("Delete Review", style: TextStyle(color: ColorTheme.textPrimary)),
        content: const Text("Are you sure you want to delete this review?", style: TextStyle(color: ColorTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      final success = await _service.deleteReview(reviewId);
      if (success) {
        await _loadReviews();
      } else {
        setState(() => _isLoading = false);
      }
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
                      final isOwner = _currentUserId != null && review.userId == _currentUserId;
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
                                Expanded(
                                  child: Text(
                                    review.userName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: ColorTheme.textPrimary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                                if (isOwner)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () => _editReview(review),
                                        child: const Icon(Icons.edit, size: 16, color: ColorTheme.buttonPrimary),
                                      ),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: () => _deleteReview(review.id!),
                                        child: const Icon(Icons.delete, size: 16, color: Colors.redAccent),
                                      ),
                                    ],
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
                        if (_editingReviewId != null)
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Editing Review...", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _editingReviewId = null;
                                    _controller.clear();
                                    _rating = 5;
                                  });
                                },
                                child: const Text("Cancel"),
                              )
                            ],
                           ),
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
                                decoration: InputDecoration(
                                  hintText: _editingReviewId != null ? "Edit your review..." : "Write a review...",
                                  filled: true,
                                  fillColor: ColorTheme.surface,
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
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

