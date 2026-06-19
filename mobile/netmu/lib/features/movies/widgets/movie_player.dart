import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:netmu/l10n/app_localizations.dart';

class VideoPage extends StatefulWidget {
  final String url;
  const VideoPage({super.key, required this.url});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late ChewieController _controller;

  @override
  void initState() {
    super.initState();

    // Use fallback value
    Uri uri = Uri.parse(
      widget.url == ""
          ? "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"
          : widget.url,
    );

    // Initialize video controller
    final videoController = VideoPlayerController.networkUrl(uri)
      ..initialize().then((_) {
        setState(() {});
      });

    // Use Chewie video controller
    _controller = ChewieController(
      videoPlayerController: videoController,
      autoPlay: false,
      looping: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.videoPlayerTitle)),
      body: Center(child: Chewie(controller: _controller),),
    );
  }
}
