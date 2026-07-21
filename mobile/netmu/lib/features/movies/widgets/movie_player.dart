import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:netmu/features/history/services/history_service.dart';
import 'package:netmu/l10n/app_localizations.dart';

class VideoPage extends StatefulWidget {
  final String url;
  final String? movieId;

  const VideoPage({super.key, required this.url, this.movieId});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late ChewieController _controller;
  late HistoryService _historyService;
  bool _hasRecorded = false;

  @override
  void initState() {
    super.initState();

    _historyService = HistoryService(() {});

    Uri uri = Uri.parse(
      widget.url == ""
          ? "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"
          : widget.url,
    );

    final videoController = VideoPlayerController.networkUrl(uri)
      ..initialize().then((_) {
        setState(() {});
      });

    _controller = ChewieController(
      videoPlayerController: videoController,
      autoPlay: false,
      looping: false,
    );
  }

  void _recordHistory() {
    if (_hasRecorded || widget.movieId == null) return;
    _hasRecorded = true;
    _historyService.createHistory(widget.movieId!, 0);
  }

  @override
  void dispose() {
    _recordHistory();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.videoPlayerTitle),
      ),
      body: Center(child: Chewie(controller: _controller)),
    );
  }
}
