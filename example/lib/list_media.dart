import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaTabScreen extends StatefulWidget {
  @override
  _MediaTabScreenState createState() => _MediaTabScreenState();
}

class _MediaTabScreenState extends State<MediaTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> mp3Files = [
    "Song 1",
    "Song 2",
    "Song 3",
    "Song 4",
  ];

  final List<String> videoFiles = [
    "Video 1",
    "Video 2",
    "Video 3",
    "Video 4",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Player'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.music_note), text: 'MP3'),
            Tab(icon: Icon(Icons.video_library), text: 'Video'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMp3List(),
          _buildVideoList(),
        ],
      ),
    );
  }

  Widget _buildMp3List() {
    return ListView.builder(
      itemCount: mp3Files.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.music_note),
          title: Text(mp3Files[index]),
          onTap: () {
            // Handle MP3 play action
            print("Playing ${mp3Files[index]}");
          },
        );
      },
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      itemCount: videoFiles.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.video_library),
          title: Text(videoFiles[index]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                  videoUrl:
                      'https://www.example.com/video${index + 1}.mp4', // Replace with actual video URLs
                  title: videoFiles[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  VideoPlayerScreen({required this.videoUrl, required this.title});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown after the video is initialized.
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
          icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          iconSize: 50,
          onPressed: () {
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            });
          },
        ),
      ],
    );
  }
}
