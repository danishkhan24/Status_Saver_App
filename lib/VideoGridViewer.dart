import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'VideoPlay.dart';

class VideoGridViewer extends StatefulWidget {
  final Directory videoDir;
  final bool insideSavedSection;

  const VideoGridViewer(this.videoDir, this.insideSavedSection);

  @override
  VideoGridViewerState createState() =>
      VideoGridViewerState(videoDir, insideSavedSection);
}

class VideoGridViewerState extends State<VideoGridViewer>
    with AutomaticKeepAliveClientMixin<VideoGridViewer> {
  final Directory videoDir;
  final bool _insideSavedSection;

  VideoGridViewerState(this.videoDir, this._insideSavedSection);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    try {
      var videoList = videoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".mp4"))
          .toList(growable: false);

      if (videoList.isEmpty) {
        return Container(
          child: Icon(Icons.storage),
        );
      }

      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GridView.builder(
          itemCount: videoList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1),
          itemBuilder: (context, index) {
            File file = new File(videoList[index]);
            return Card(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return VideoApp(file, _insideSavedSection);
                      },
                    ),
                  ).then((value) {
                    if (_insideSavedSection) setState(() {});
                  });
                },
                child: FutureBuilder(
                  future: _getThumb(file),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Stack(alignment: Alignment.center, children: [
                          Container(
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                    image: snapshot.data,
                                    fit: BoxFit.fill)),
                          ),
                          Container(height: 50, width: 50,child: Icon(Icons.play_circle_fill, size: 50,)),
                        ]);
                      } else if (snapshot.hasError) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Text("Preview Failed");
                      }
                    } else {
                      return Hero(
                        tag: videoList[index],
                        child: SizedBox(
                          height: 500,
                          child: Icon(Icons.videocam),
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      );
    } on Exception {
      return Container(
        child: Icon(Icons.storage),
      );
    }
  }

  Future<ImageProvider> _getThumb(File videoFile) async {
    Uint8List thumb = await VideoThumbnail.thumbnailData(
      video: videoFile.path,
      imageFormat: ImageFormat.JPEG,
      quality: 20,
    );
    return MemoryImage(thumb);
  }
}
