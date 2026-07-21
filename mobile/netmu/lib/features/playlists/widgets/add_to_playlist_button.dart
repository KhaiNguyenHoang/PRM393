import 'package:flutter/material.dart';
import 'package:netmu/core/themes/theme.dart';
import 'package:netmu/features/playlists/models/playlist.dart';
import 'package:netmu/features/playlists/services/playlist_service.dart';

class AddToPlaylistButton extends StatefulWidget {
  final String movieId;

  const AddToPlaylistButton({super.key, required this.movieId});

  @override
  State<AddToPlaylistButton> createState() => _AddToPlaylistButtonState();
}

class _AddToPlaylistButtonState extends State<AddToPlaylistButton> {
  late final PlaylistService _service;

  @override
  void initState() {
    super.initState();
    _service = PlaylistService(() => Navigator.pushNamedAndRemoveUntil(context, "/auth/login", (r) => false));
  }

  void _showPlaylistsModal() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorTheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _PlaylistsModal(service: _service, movieId: widget.movieId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.playlist_add, color: ColorTheme.textPrimary),
      onPressed: _showPlaylistsModal,
    );
  }
}

class _PlaylistsModal extends StatefulWidget {
  final PlaylistService service;
  final String movieId;

  const _PlaylistsModal({required this.service, required this.movieId});

  @override
  State<_PlaylistsModal> createState() => _PlaylistsModalState();
}

class _PlaylistsModalState extends State<_PlaylistsModal> {
  List<Playlist> _playlists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    final res = await widget.service.getPlaylists();
    if (mounted) {
      setState(() {
        _playlists = res;
        _isLoading = false;
      });
    }
  }

  Future<void> _togglePlaylist(Playlist p) async {
    Navigator.pop(context); // close modal immediately
    final isAdded = p.movieIds.contains(widget.movieId);
    
    bool success;
    if (isAdded) {
      success = await widget.service.removeMovieFromPlaylist(p.id, widget.movieId);
    } else {
      success = await widget.service.addMovieToPlaylist(p.id, widget.movieId);
    }
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isAdded ? "Removed from ${p.name}" : "Added to ${p.name}"),
        backgroundColor: isAdded ? Colors.orange : Colors.green,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Add to Playlist", style: TextStyle(color: ColorTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (_isLoading)
            const CircularProgressIndicator()
          else if (_playlists.isEmpty)
            const Text("No playlists available.", style: TextStyle(color: ColorTheme.textSecondary))
          else
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _playlists.length,
                itemBuilder: (context, index) {
                  final p = _playlists[index];
                  final isAdded = p.movieIds.contains(widget.movieId);
                  
                  return ListTile(
                    leading: Icon(
                      isAdded ? Icons.playlist_add_check : Icons.playlist_play,
                      color: ColorTheme.buttonPrimary
                    ),
                    title: Text(p.name, style: const TextStyle(color: ColorTheme.textPrimary)),
                    subtitle: isAdded 
                      ? const Text("Đã thêm vào playlist này", style: TextStyle(color: ColorTheme.buttonPrimary, fontSize: 12)) 
                      : null,
                    trailing: isAdded ? const Icon(Icons.check, color: ColorTheme.buttonPrimary) : null,
                    onTap: () => _togglePlaylist(p),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
