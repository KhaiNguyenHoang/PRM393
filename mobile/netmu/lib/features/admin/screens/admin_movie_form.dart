import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/movies/models/movie.dart';
import 'package:netmu/features/movies/models/genre_dto.dart';
import 'package:netmu/features/movies/models/director_dto.dart';
import 'package:netmu/features/movies/models/actor_dto.dart';
import 'package:netmu/features/movies/services/movie_service.dart';
import 'package:netmu/features/admin/services/admin_service.dart';

class AdminMovieForm extends StatefulWidget {
  final Movie? movie;

  const AdminMovieForm({super.key, this.movie});

  @override
  State<AdminMovieForm> createState() => _AdminMovieFormState();
}

class _AdminMovieFormState extends State<AdminMovieForm> {
  late final MovieService _movieService;
  late final AdminService _adminService;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _durationCtrl;
  late TextEditingController _videoUrlCtrl;
  late TextEditingController _imageUrlCtrl;

  List<GenreDto> _allGenres = [];
  List<DirectorDto> _allDirectors = [];
  List<ActorDto> _allActors = [];

  Set<String> _selectedGenreIds = {};
  Set<String> _selectedDirectorIds = {};
  Set<String> _selectedActorIds = {};

  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isLoadingCatalog = true;

  bool get isEditing => widget.movie != null;

  @override
  void initState() {
    super.initState();
    _movieService = MovieService(
      () => Navigator.pushNamedAndRemoveUntil(
        context, "/auth/login", (route) => false,
      ),
    );
    _adminService = AdminService(
      () => Navigator.pushNamedAndRemoveUntil(
        context, "/auth/login", (route) => false,
      ),
    );

    _titleCtrl = TextEditingController(text: widget.movie?.title ?? '');
    _descCtrl = TextEditingController(text: widget.movie?.description ?? '');
    _durationCtrl = TextEditingController(
      text: widget.movie?.durationInMinutes.toString() ?? '',
    );
    _videoUrlCtrl = TextEditingController(text: widget.movie?.videoUrl ?? '');
    _imageUrlCtrl = TextEditingController(text: widget.movie?.imageUrl ?? '');

    if (isEditing) {
      final m = widget.movie!;
      _selectedGenreIds = m.genres.map((g) => g.id).toSet();
      _selectedDirectorIds = m.directors.map((d) => d.id).toSet();
      _selectedActorIds = m.actors.map((a) => a.id).toSet();
    }

    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    final results = await Future.wait([
      _adminService.getGenres(),
      _adminService.getDirectors(),
      _adminService.getActors(),
    ]);
    if (mounted) {
      setState(() {
        _allGenres = results[0] as List<GenreDto>;
        _allDirectors = results[1] as List<DirectorDto>;
        _allActors = results[2] as List<ActorDto>;
        _isLoadingCatalog = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final body = {
      "title": _titleCtrl.text.trim(),
      "description": _descCtrl.text.trim(),
      "durationInMinutes": int.tryParse(_durationCtrl.text.trim()) ?? 0,
      "videoUrl": _videoUrlCtrl.text.trim(),
      "imageUrl": _imageUrlCtrl.text.trim(),
      "genreIds": _selectedGenreIds.toList(),
      "directorIds": _selectedDirectorIds.toList(),
      "actorIds": _selectedActorIds.toList(),
    };

    bool success;
    if (isEditing) {
      success = await _movieService.updateMovie(widget.movie!.id, body);
    } else {
      success = await _movieService.createMovie(body);
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save movie")),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _durationCtrl.dispose();
    _videoUrlCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.background,
      appBar: AppBar(
        backgroundColor: ColorTheme.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorTheme.textPrimary),
        title: Text(
          isEditing ? "Edit Movie" : "Add Movie",
          style: const TextStyle(
            color: ColorTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Save"),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: _inputDec("Title"),
                    validator: (v) => (v == null || v.trim().isEmpty) ? "Required" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: _inputDec("Description"),
                    maxLines: 3,
                    validator: (v) => (v == null || v.trim().isEmpty) ? "Required" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _durationCtrl,
                    decoration: _inputDec("Duration (minutes)"),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return "Required";
                      if (int.tryParse(v.trim()) == null) return "Invalid number";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _videoUrlCtrl,
                    decoration: _inputDec("Video URL"),
                    validator: (v) => (v == null || v.trim().isEmpty) ? "Required" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _imageUrlCtrl,
                    decoration: _inputDec("Image URL"),
                    validator: (v) => (v == null || v.trim().isEmpty) ? "Required" : null,
                  ),
                  const SizedBox(height: 24),
                  if (_isLoadingCatalog)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    _buildMultiSelect("Genres", _allGenres.map((g) => _SelectItem(g.id, g.name)).toList(), _selectedGenreIds),
                    const SizedBox(height: 16),
                    _buildMultiSelect("Directors", _allDirectors.map((d) => _SelectItem(d.id, d.name)).toList(), _selectedDirectorIds),
                    const SizedBox(height: 16),
                    _buildMultiSelect("Actors", _allActors.map((a) => _SelectItem(a.id, a.name)).toList(), _selectedActorIds),
                  ],
                ],
              ),
            ),
    );
  }

  InputDecoration _inputDec(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: ColorTheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildMultiSelect(String title, List<_SelectItem> items, Set<String> selected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ColorTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = selected.contains(item.id);
            return FilterChip(
              label: Text(item.name),
              selected: isSelected,
              selectedColor: ColorTheme.buttonPrimary.withValues(alpha: 0.15),
              checkmarkColor: ColorTheme.buttonPrimary,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    selected.add(item.id);
                  } else {
                    selected.remove(item.id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SelectItem {
  final String id;
  final String name;
  const _SelectItem(this.id, this.name);
}
