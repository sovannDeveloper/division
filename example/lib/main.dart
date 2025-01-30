import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';

import 'classwork.dart';
import 'list_media.dart';
import 'music.dart';
import 'video.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedFile>? list;
  String _status = '';

  @override
  void initState() {
    super.initState();
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        FlutterSharingIntent.instance.getMediaStream().listen((List<SharedFile> value) {
      setState(() {
        _status = 'While the app is in the memory';
        list = value;
      });

      print("Shared: getMediaStream ${value.map((f) => f.value).join(",")}");
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance.getInitialSharing().then((List<SharedFile> value) {
      print("Shared: getInitialMedia ${value.map((f) => f.value).join(",")}");
      setState(() {
        _status = 'While the app is closed';
        list = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyWidget());
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => YouTubeDownloaderScreen()));
              },
              child: Text('Yt Downloader')),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => MusicPlayerScreen()));
              },
              child: Text('Music')),
          // ElevatedButton(
          //     onPressed: () {
          //       Navigator.of(context).push(MaterialPageRoute(builder: (_) => VideoPlayerScreen()));
          //     },
          //     child: Text('Video')),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => MediaTabScreen()));
              },
              child: Text('Medias')),
        ],
      ),
    );
  }
}
