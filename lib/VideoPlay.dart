import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoApp extends StatefulWidget {
  final File videoFile;
  final bool _insideSavedSection;
  final adManager;

  VideoApp(this.videoFile, this._insideSavedSection, this.adManager);

  @override
  _VideoAppState createState() =>
      _VideoAppState(videoFile, _insideSavedSection, adManager);
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;
  VideoProgressIndicator videoProgressIndicator;
  File videoFile;
  String name;
  bool _insideSavedSection;
  final adManager;

  _VideoAppState(this.videoFile, this._insideSavedSection, this.adManager) {
    name = videoFile.path.split('/').last;
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.setLooping(true);
    videoProgressIndicator = new VideoProgressIndicator(
      _controller,
      allowScrubbing: true,
    );
    videoProgressIndicator.createState();
  }

  Future<bool> _saveFile() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    final path = Directory(appDocDirectory.path + "/savedImages/");
    try {
      if (await path.exists()) {
        videoFile.copy(path.path + "/$name");
      } else {
        path.create();
        videoFile.copy(path.path + "/$name");
      }
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> _deleteFile() async {
    try {
      videoFile.delete();
    } on Exception {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Icon buttonIcon;
    if (_insideSavedSection)
      buttonIcon = Icon(Icons.delete);
    else
      buttonIcon = Icon(Icons.save);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            adManager.showInterstitialAd();
            Navigator.pop(context);
          },
        ),
        title: Text("Video Status"),
      ),
      body: Stack(children: [
        SizedBox(
          child: Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.all(8.0),
          child: videoProgressIndicator,
        ),
      ]),
      persistentFooterButtons: [
        FloatingActionButton(
          heroTag: name,
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
        FloatingActionButton(
          onPressed: () async {
            if (_insideSavedSection) {
              if (await _deleteFile()) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully Deleted')));
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Unable to Delete')));
              }
            } else {
              if (await _saveFile()) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully Saved!')));
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Unable to Save')));
              }
            }
          },
          child: buttonIcon,
        ),
        shareButton(),
      ],
    );
  }

  Widget shareButton() {
    if (_insideSavedSection) {
      return FloatingActionButton(
        onPressed: () {
          _onShare();
        },
        child: Icon(Icons.share_outlined),
      );
    } else {
      return Padding(padding: EdgeInsets.zero);
    }
  }

  void _onShare() async {
    await Share.shareFiles([videoFile.path]);
  }
}
