import 'dart:io';
import 'package:flutter/material.dart';
import 'package:status_saver/AdManager.dart';
import 'ImageViewer.dart';

class ImageGridViewer extends StatefulWidget{
  final Directory photoDir;
  final bool insideSavedSection;
  final adManager;

  const ImageGridViewer(this.photoDir, this.insideSavedSection, this.adManager);
  @override
  ImageGridViewerState createState() => ImageGridViewerState(photoDir, insideSavedSection, adManager);
}

class ImageGridViewerState extends State<ImageGridViewer> with AutomaticKeepAliveClientMixin<ImageGridViewer>{
  final Directory photoDir;
  final bool _insideSavedSection;
  final FacebookAd adManager;

  ImageGridViewerState(this.photoDir, this._insideSavedSection, this.adManager);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    try {
      var imageList = photoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".jpg"))
          .toList(growable: true);

      if(imageList.isEmpty){
        return Container(child: Icon(Icons.storage),);
      }

      return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GridView.builder(
          itemCount: imageList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1),
          itemBuilder: (context, index) {
            File file = new File(imageList[index]);
            String name = file.path
                .split('/')
                .last;
            return Card(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ImageViewer(name, file, _insideSavedSection);
                      },
                    ),
                  ).then((value) => setState(() {}));
                },
                child: Image.file(
                  file,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    }
    on Exception{
      return Container(child: Icon(Icons.storage),);
    }
  }
}
