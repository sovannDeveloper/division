import 'package:flutter/material.dart';

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool isPlaying = false;
  double currentSliderValue = 0;
  String currentSong = "Song Title - Artist Name";

  void _playPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _skipForward() {
    // Implement skipping forward logic
    setState(() {
      currentSong = "Next Song Title - Next Artist";
      currentSliderValue = 0;
    });
  }

  void _skipBackward() {
    // Implement skipping backward logic
    setState(() {
      currentSong = "Previous Song Title - Previous Artist";
      currentSliderValue = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Player"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAlbumArt(),
            SizedBox(height: 30),
            _buildSongTitle(),
            SizedBox(height: 20),
            _buildSlider(),
            SizedBox(height: 20),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumArt() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image:
              AssetImage('assets/album_art_placeholder.png'), // Replace with your album art asset
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSongTitle() {
    return Text(
      currentSong,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSlider() {
    return Slider(
      value: currentSliderValue,
      min: 0,
      max: 100,
      divisions: 100,
      label: currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          currentSliderValue = value;
        });
      },
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.skip_previous),
          iconSize: 50,
          onPressed: _skipBackward,
        ),
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          iconSize: 70,
          onPressed: _playPause,
        ),
        IconButton(
          icon: Icon(Icons.skip_next),
          iconSize: 50,
          onPressed: _skipForward,
        ),
      ],
    );
  }
}
