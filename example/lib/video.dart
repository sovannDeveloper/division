import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4', // Replace with your video URL
    )
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown after the video is initialized.
      })
      ..addListener(() {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
          SizedBox(height: 20),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.replay_10),
          iconSize: 30,
          onPressed: () {
            final currentPosition = _controller.value.position;
            final rewindPosition = Duration(seconds: currentPosition.inSeconds - 10);
            _controller.seekTo(rewindPosition);
          },
        ),
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          iconSize: 50,
          onPressed: _playPause,
        ),
        IconButton(
          icon: Icon(Icons.forward_10),
          iconSize: 30,
          onPressed: () {
            final currentPosition = _controller.value.position;
            final forwardPosition = Duration(seconds: currentPosition.inSeconds + 10);
            _controller.seekTo(forwardPosition);
          },
        ),
      ],
    );
  }
}
