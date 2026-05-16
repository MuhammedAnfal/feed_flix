import 'package:feed_flix/features/home/presentation/providers/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;
  final int index;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.index,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  void dispose() {
    // Don't dispose the controller here as it's managed by VideoProvider
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(
      builder: (context, videoProvider, child) {
        final isCurrentVideo = videoProvider?.currentPlayingIndex == widget.index;
        final controller = videoProvider.currentController;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Thumbnail (shown when video is not playing or not initialized)
            if (!isCurrentVideo || controller == null || !controller.value.isInitialized)
              Image.network(
                widget.thumbnailUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    height: 300,
                    child: const Icon(Icons.error),
                  );
                },
              ),

            // Video Player (shown when current video is playing and initialized)
            if (isCurrentVideo && controller != null && controller.value.isInitialized)
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),

            // Play Button overlay for thumbnail
            if (!isCurrentVideo)
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.play_arrow, size: 50, color: Colors.white),
                  onPressed: () {
                    videoProvider.playVideo(widget.index, widget.videoUrl);
                  },
                ),
              ),

            // Video Progress Indicator
            if (isCurrentVideo && controller != null && controller.value.isInitialized)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: Colors.red,
                    bufferedColor: Colors.grey,
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),

            // Control Buttons
            if (isCurrentVideo && controller != null && controller.value.isInitialized)
              Positioned(
                bottom: 30,
                left: 10,
                right: 10,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        if (controller.value.isPlaying) {
                          videoProvider?.pauseVideo();
                        } else {
                          videoProvider.resumeVideo();
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${_formatDuration(controller.value.position)} / '
                        '${_formatDuration(controller.value.duration)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.fullscreen, color: Colors.white, size: 30),
                      onPressed: () {
                        videoProvider?.toggleFullScreen();
                      },
                    ),
                  ],
                ),
              ),

            // Loading indicator
            if (isCurrentVideo && controller != null && !controller.value.isInitialized)
              const CircularProgressIndicator(color: Colors.white),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "$hours:$minutes:$seconds";
    } else {
      return "$minutes:$seconds";
    }
  }
}
