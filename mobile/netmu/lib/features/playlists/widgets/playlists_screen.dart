import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/playlists/models/playlist.dart';
import 'package:netmu/features/playlists/services/playlist_service.dart';
import 'package:netmu/features/playlists/widgets/playlist_detail_screen.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  late final PlaylistService _service;
  List<Playlist> _playlists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = PlaylistService(() => Navigator.pushNamedAndRemoveUntil(context, "/auth/login", (r) => false));
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    setState(() => _isLoading = true);
    final list = await _service.getPlaylists();
    if (mounted) {
      setState(() {
        _playlists = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _createPlaylist() async {
    final name = await _showPlaylistDialog(title: "New Playlist");
    if (name != null && name.isNotEmpty) {
      final id = await _service.createPlaylist(name);
      if (id != null) {
        await _loadPlaylists();
      }
    }
  }

  Future<void> _editPlaylist(Playlist p) async {
    final name = await _showPlaylistDialog(title: "Rename Playlist", initialText: p.name);
    if (name != null && name.isNotEmpty && name != p.name) {
      final success = await _service.updatePlaylist(p.id, name);
      if (success) {
        await _loadPlaylists();
      }
    }
  }

  Future<void> _deletePlaylist(Playlist p) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorTheme.surface,
        title: const Text("Delete Playlist", style: TextStyle(color: ColorTheme.textPrimary)),
        content: Text("Are you sure you want to delete '${p.name}'?", style: const TextStyle(color: ColorTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _service.deletePlaylist(p.id);
      if (success) {
        await _loadPlaylists();
      }
    }
  }

  Future<String?> _showPlaylistDialog({required String title, String initialText = ""}) {
    final controller = TextEditingController(text: initialText);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorTheme.surface,
        title: Text(title, style: const TextStyle(color: ColorTheme.textPrimary)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Playlist Name",
            filled: true,
            fillColor: ColorTheme.background,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text("Save")),
        ],
      ),
    );
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
          "My Playlists",
          style: TextStyle(color: ColorTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: ColorTheme.buttonPrimary),
            onPressed: _createPlaylist,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _playlists.isEmpty
              ? const Center(
                  child: Text(
                    "No playlists yet.",
                    style: TextStyle(color: ColorTheme.textSecondary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _playlists.length,
                  itemBuilder: (context, index) {
                    final p = _playlists[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: ColorTheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.playlist_play, color: ColorTheme.buttonPrimary, size: 40),
                        title: Text(p.name, style: const TextStyle(color: ColorTheme.textPrimary, fontWeight: FontWeight.bold)),
                        subtitle: Text("${p.movieCount} movies", style: const TextStyle(color: ColorTheme.textSecondary)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.amber, size: 20),
                              onPressed: () => _editPlaylist(p),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                              onPressed: () => _deletePlaylist(p),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PlaylistDetailScreen(playlist: p)),
                          ).then((_) => _loadPlaylists());
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
