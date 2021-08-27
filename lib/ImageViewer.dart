import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/FilesSection.dart';

RemoteConfig remoteConfig;

class ImageViewer extends StatefulWidget {
  final String name;
  final File file;
  final bool _insideSavedSection;

  ImageViewer(
      this.name, this.file, this._insideSavedSection, RemoteConfig remoteCfg) {
    remoteConfig = remoteCfg;
  }

  @override
  ImageViewerState createState() =>
      ImageViewerState(name, file, _insideSavedSection);
}

class ImageViewerState extends State<ImageViewer> {
  final String name;
  final File file;
  bool _insideSavedSection;

  ImageViewerState(this.name, this.file, this._insideSavedSection);

  Future<bool> _saveFile() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    final path = Directory(appDocDirectory.path + "/savedImages/");
    try {
      if (await path.exists()) {
        file.copy(path.path + "/$name");
      } else {
        path.create();
        file.copy(path.path + "/$name");
      }
    } on Exception {
      return false;
    }
    return true;
  }

  Future<bool> _deleteFile() async {
    try {
      file.delete();
    } on Exception {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Icon buttonIcon;
    if (_insideSavedSection)
      buttonIcon = Icon(Icons.delete);
    else
      buttonIcon = Icon(Icons.save);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (remoteConfig.getString("InterstitialAd") == "true" ||
                remoteConfig.getString("InterstitialAd").isEmpty) {
              adManager.showInterstitialAd();
            }
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Status Image"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg_screens.png'),
                fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Image.file(file)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FloatingActionButton(
                      heroTag: null,
                      child: buttonIcon,
                      onPressed: () async {
                        if (_insideSavedSection) {
                          if (await _deleteFile()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Successfully Deleted')));
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Unable to Delete')));
                          }
                        } else {
                          if (await _saveFile()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Successfully Saved!')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Unable to Save')));
                          }
                        }
                      }),
                ),
                shareButton(),
              ],
            ),
            !adManager.adFree?adManager.bannerAd:Container(),
          ],
        ),
      ),
      // bottomNavigationBar: FacebookAd().bannerAd,
    );
  }

  Widget shareButton() {
    if (_insideSavedSection) {
      return Padding(
        padding: EdgeInsets.all(20.0),
        child: FloatingActionButton(
          onPressed: () {
            _onShare();
          },
          child: Icon(Icons.share_outlined),
        ),
      );
    } else {
      return Padding(padding: EdgeInsets.zero);
    }
  }

  void _onShare() async {
    await Share.shareFiles([file.path]);
  }
}
