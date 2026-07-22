import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/admin/services/admin_service.dart';
import 'package:netmu/features/movies/models/genre_dto.dart';
import 'package:netmu/features/movies/models/director_dto.dart';
import 'package:netmu/features/movies/models/actor_dto.dart';

class AdminCatalogScreen extends StatefulWidget {
  const AdminCatalogScreen({super.key});

  @override
  State<AdminCatalogScreen> createState() => _AdminCatalogScreenState();
}

class _AdminCatalogScreenState extends State<AdminCatalogScreen>
    with SingleTickerProviderStateMixin {
  late final AdminService _service;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _service = AdminService(
      () => Navigator.pushNamedAndRemoveUntil(
        context, "/auth/login", (route) => false,
      ),
    );
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        title: const Text(
          "Catalog",
          style: TextStyle(
            color: ColorTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ColorTheme.buttonPrimary,
          labelColor: ColorTheme.buttonPrimary,
          unselectedLabelColor: ColorTheme.textSecondary,
          tabs: const [
            Tab(text: "Genres"),
            Tab(text: "Directors"),
            Tab(text: "Actors"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _GenreTab(service: _service),
          _DirectorTab(service: _service),
          _ActorTab(service: _service),
        ],
      ),
    );
  }
}

// ── Genre Tab ──────────────────────────────────────────

class _GenreTab extends StatefulWidget {
  final AdminService service;
  const _GenreTab({required this.service});

  @override
  State<_GenreTab> createState() => _GenreTabState();
}

class _GenreTabState extends State<_GenreTab> {
  List<GenreDto> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await widget.service.getGenres();
    if (mounted) setState(() { _items = data; _isLoading = false; });
  }

  Future<void> _add() async {
    final name = await _showDialog(null);
    if (name != null) {
      await widget.service.createGenre(name);
      _load();
    }
  }

  Future<void> _edit(GenreDto item) async {
    final name = await _showDialog(item.name);
    if (name != null) {
      await widget.service.updateGenre(item.id, name);
      _load();
    }
  }

  Future<String?> _showDialog(String? current) async {
    final ctrl = TextEditingController(text: current);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(current == null ? "Add Genre" : "Edit Genre"),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Genre name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, ctrl.text.trim());
              ctrl.dispose();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
    return result;
  }

  Future<void> _delete(GenreDto item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Genre"),
        content: Text('Delete "${item.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: ColorTheme.buttonDanger),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await widget.service.deleteGenre(item.id);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    return Stack(
      children: [
        _items.isEmpty
            ? const Center(child: Text("No genres", style: TextStyle(color: ColorTheme.textSecondary)))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
                itemCount: _items.length,
                separatorBuilder: (_, _) => const Divider(height: 1, color: ColorTheme.border),
                itemBuilder: (_, i) => ListTile(
                  title: Text(_items[i].name, style: const TextStyle(color: ColorTheme.textPrimary)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: ColorTheme.info, size: 20),
                        onPressed: () => _edit(_items[i]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: ColorTheme.buttonDanger, size: 20),
                        onPressed: () => _delete(_items[i]),
                      ),
                    ],
                  ),
                ),
              ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            backgroundColor: ColorTheme.buttonPrimary,
            onPressed: _add,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// ── Director Tab ───────────────────────────────────────

class _DirectorTab extends StatefulWidget {
  final AdminService service;
  const _DirectorTab({required this.service});

  @override
  State<_DirectorTab> createState() => _DirectorTabState();
}

class _DirectorTabState extends State<_DirectorTab> {
  List<DirectorDto> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await widget.service.getDirectors();
    if (mounted) setState(() { _items = data; _isLoading = false; });
  }

  Future<void> _add() async {
    final result = await _showDialog(null);
    if (result != null) {
      await widget.service.createDirector(result);
      _load();
    }
  }

  Future<void> _edit(DirectorDto item) async {
    final result = await _showDialog(item);
    if (result != null) {
      await widget.service.updateDirector(item.id, result);
      _load();
    }
  }

  Future<Map<String, dynamic>?> _showDialog(DirectorDto? current) async {
    final nameCtrl = TextEditingController(text: current?.name ?? '');
    final bioCtrl = TextEditingController(text: current?.bio ?? '');
    final imgCtrl = TextEditingController(text: current?.imageUrl ?? '');
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(current == null ? "Add Director" : "Edit Director"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: "Name"), autofocus: true),
            const SizedBox(height: 12),
            TextField(controller: bioCtrl, decoration: const InputDecoration(hintText: "Bio"), maxLines: 2),
            const SizedBox(height: 12),
            TextField(controller: imgCtrl, decoration: const InputDecoration(hintText: "Image URL")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, {
              "name": nameCtrl.text.trim(),
              "bio": bioCtrl.text.trim(),
              "imageUrl": imgCtrl.text.trim(),
            }),
            child: const Text("Save"),
          ),
        ],
      ),
    );
    return result;
  }

  Future<void> _delete(DirectorDto item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Director"),
        content: Text('Delete "${item.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: ColorTheme.buttonDanger),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await widget.service.deleteDirector(item.id);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    return Stack(
      children: [
        _items.isEmpty
            ? const Center(child: Text("No directors", style: TextStyle(color: ColorTheme.textSecondary)))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
                itemCount: _items.length,
                separatorBuilder: (_, _) => const Divider(height: 1, color: ColorTheme.border),
                itemBuilder: (_, i) => ListTile(
                  title: Text(_items[i].name, style: const TextStyle(color: ColorTheme.textPrimary)),
                  subtitle: Text(_items[i].bio, style: const TextStyle(color: ColorTheme.textSecondary, fontSize: 12), maxLines: 1),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: ColorTheme.info, size: 20),
                        onPressed: () => _edit(_items[i]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: ColorTheme.buttonDanger, size: 20),
                        onPressed: () => _delete(_items[i]),
                      ),
                    ],
                  ),
                ),
              ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            backgroundColor: ColorTheme.buttonPrimary,
            onPressed: _add,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// ── Actor Tab ──────────────────────────────────────────

class _ActorTab extends StatefulWidget {
  final AdminService service;
  const _ActorTab({required this.service});

  @override
  State<_ActorTab> createState() => _ActorTabState();
}

class _ActorTabState extends State<_ActorTab> {
  List<ActorDto> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await widget.service.getActors();
    if (mounted) setState(() { _items = data; _isLoading = false; });
  }

  Future<void> _add() async {
    final result = await _showDialog(null);
    if (result != null) {
      await widget.service.createActor(result);
      _load();
    }
  }

  Future<void> _edit(ActorDto item) async {
    final result = await _showDialog(item);
    if (result != null) {
      await widget.service.updateActor(item.id, result);
      _load();
    }
  }

  Future<Map<String, dynamic>?> _showDialog(ActorDto? current) async {
    final nameCtrl = TextEditingController(text: current?.name ?? '');
    final bioCtrl = TextEditingController(text: current?.bio ?? '');
    final imgCtrl = TextEditingController(text: current?.imageUrl ?? '');
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(current == null ? "Add Actor" : "Edit Actor"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: "Name"), autofocus: true),
            const SizedBox(height: 12),
            TextField(controller: bioCtrl, decoration: const InputDecoration(hintText: "Bio"), maxLines: 2),
            const SizedBox(height: 12),
            TextField(controller: imgCtrl, decoration: const InputDecoration(hintText: "Image URL")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, {
              "name": nameCtrl.text.trim(),
              "bio": bioCtrl.text.trim(),
              "imageUrl": imgCtrl.text.trim(),
            }),
            child: const Text("Save"),
          ),
        ],
      ),
    );
    return result;
  }

  Future<void> _delete(ActorDto item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Actor"),
        content: Text('Delete "${item.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: ColorTheme.buttonDanger),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await widget.service.deleteActor(item.id);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    return Stack(
      children: [
        _items.isEmpty
            ? const Center(child: Text("No actors", style: TextStyle(color: ColorTheme.textSecondary)))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
                itemCount: _items.length,
                separatorBuilder: (_, _) => const Divider(height: 1, color: ColorTheme.border),
                itemBuilder: (_, i) => ListTile(
                  title: Text(_items[i].name, style: const TextStyle(color: ColorTheme.textPrimary)),
                  subtitle: Text(_items[i].bio, style: const TextStyle(color: ColorTheme.textSecondary, fontSize: 12), maxLines: 1),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: ColorTheme.info, size: 20),
                        onPressed: () => _edit(_items[i]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: ColorTheme.buttonDanger, size: 20),
                        onPressed: () => _delete(_items[i]),
                      ),
                    ],
                  ),
                ),
              ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            backgroundColor: ColorTheme.buttonPrimary,
            onPressed: _add,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
