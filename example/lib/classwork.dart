import 'package:flutter/material.dart';

class YouTubeDownloaderScreen extends StatefulWidget {
  @override
  _YouTubeDownloaderScreenState createState() => _YouTubeDownloaderScreenState();
}

class _YouTubeDownloaderScreenState extends State<YouTubeDownloaderScreen> {
  final TextEditingController _urlController = TextEditingController();
  String _selectedQuality = '720p';
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YouTube Downloader"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Video URL",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildUrlInputField(),
            SizedBox(height: 20),
            Text(
              "Select Quality",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildQualityDropdown(),
            SizedBox(height: 20),
            _buildDownloadButton(),
            if (_isDownloading) ...[
              SizedBox(height: 20),
              _buildDownloadProgress(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUrlInputField() {
    return TextField(
      controller: _urlController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Enter YouTube video URL",
        prefixIcon: Icon(Icons.link),
      ),
      keyboardType: TextInputType.url,
    );
  }

  Widget _buildQualityDropdown() {
    return DropdownButton<String>(
      value: _selectedQuality,
      onChanged: (String? newValue) {
        setState(() {
          _selectedQuality = newValue!;
        });
      },
      items: <String>['1080p', '720p', '480p', '360p', '240p']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      isExpanded: true,
    );
  }

  Widget _buildDownloadButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _isDownloading = true;
          });
          // Start download logic here
        },
        icon: Icon(Icons.download),
        label: Text("Download"),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          primary: Colors.red,
          textStyle: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildDownloadProgress() {
    return Column(
      children: [
        Text(
          "Downloading...",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(),
      ],
    );
  }
}
