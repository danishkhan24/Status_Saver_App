import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'ImageGridViewer.dart';
import 'VideoGridViewer.dart';

Directory appDocDirectory;

class FilesSection extends StatefulWidget {
  FilesSection(Directory appDocDir) {
    appDocDirectory = appDocDir;
  }

  @override
  FilesSectionState createState() => FilesSectionState(appDocDirectory);
}

class FilesSectionState extends State<FilesSection> with AutomaticKeepAliveClientMixin<FilesSection>{
  final appDocDirectory;

  FilesSectionState(this.appDocDirectory);

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: drawer(),
        ),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(Icons.remove_red_eye),
              ),
              Tab(
                icon: Icon(Icons.cloud_download),
              ),
              Tab(
                icon: Icon(Icons.emoji_emotions_outlined),
              ),
              Tab(
                icon: Icon(Icons.web_outlined),
              ),
            ],
          ),
          title: Text('Status Saver'),
          actions: [
            ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0)),
                child: Icon(Icons.share_outlined)),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0)),
              child: Icon(Icons.help_center_outlined),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg_screens.png'),
                  fit: BoxFit.fill)),
          child: TabBarView(
            children: [
              NestedTabBar(Directory('/storage/emulated/0/Pictures/'),
                  Directory('/storage/emulated/0/Movies/'), false),
              NestedTabBar(appDocDirectory, appDocDirectory, true),
              Container(
                child: Icon(Icons.emoji_emotions_outlined),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.98,
                    child: WebView(
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                        Factory<HorizontalDragGestureRecognizer>(
                              () => HorizontalDragGestureRecognizer(),
                        ),
                      },
                      gestureNavigationEnabled: true,
                      userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36",
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: 'https://web.whatsapp.com',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawer() {
    final screenHeight = MediaQuery.of(context).size.height;
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: screenHeight * 0.4,
          child: DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Color(0xFF122829),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: screenHeight * 0.1,
                  width: screenHeight * 0.1,
                  child:
                      Image(image: AssetImage('assets/images/splash_logo.png')),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Status Saver',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          height: screenHeight * 0.6,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.remove_red_eye),
                title: Text('Statuses'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.business_center),
                title: Text('Business Statuses'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(Icons.card_membership),
                title: Text('Remove Ads'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(Icons.star_border),
                title: Text('Rate'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading: Icon(Icons.share_outlined),
                title: Text('Share'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class NestedTabBar extends StatefulWidget {
  final Directory photoDir;
  final Directory videoDir;
  final bool insideSavedSection;

  NestedTabBar(this.photoDir, this.videoDir, this.insideSavedSection);

  @override
  _NestedTabBarState createState() =>
      _NestedTabBarState(photoDir, videoDir, insideSavedSection);
}

class _NestedTabBarState extends State<NestedTabBar>
    with AutomaticKeepAliveClientMixin<NestedTabBar>, TickerProviderStateMixin {
  Directory photoDir;
  final Directory videoDir;
  bool insideSavedSection;
  TabController _nestedTabController;

  _NestedTabBarState(this.photoDir, this.videoDir, this.insideSavedSection);

  @override
  void initState() {
    super.initState();
    _nestedTabController = new TabController(length: 2, vsync: this);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TabBar(
          controller: _nestedTabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.photo_size_select_actual_outlined),
            ),
            Tab(
              icon: Icon(Icons.videocam),
            ),
          ],
        ),
        Container(
          height: screenHeight * 0.725,
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              ImageGridViewer(photoDir, insideSavedSection),
              VideoGridViewer(videoDir, insideSavedSection),
            ],
          ),
        )
      ],
    );
  }
}
