import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:status_saver/AdManager.dart';
import 'package:status_saver/HelpDialog.dart';
import 'package:status_saver/stickers/stickers-page.dart';
import 'package:status_saver/whatsappweb.dart';
import 'ImageGridViewer.dart';
import 'VideoGridViewer.dart';

Directory appDocDirectory;
FacebookAd adManager;
RemoteConfig remoteConfig;

class FilesSection extends StatefulWidget {
  FilesSection(Directory appDocDir, FacebookAd adMgr, RemoteConfig remoteCfg) {
    appDocDirectory = appDocDir;
    adManager = adMgr;
    remoteConfig = remoteCfg;
  }

  @override
  FilesSectionState createState() => FilesSectionState(appDocDirectory);
}

class FilesSectionState extends State<FilesSection>
    with AutomaticKeepAliveClientMixin<FilesSection> {
  final appDocDirectory;
  int index = 0;

  FilesSectionState(this.appDocDirectory);

  @override
  void initState() {
    super.initState();
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
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
          // resizeToAvoidBottomInset: false,
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
                  icon: Icon(Icons.emoji_symbols),
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
                onPressed: () {
                  var index = DefaultTabController.of(context).index;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return HelpButton().popup(index, context);
                      });
                },
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
                remoteConfig.getString("SeenTab") == "true" ||
                        remoteConfig.getString("SeenTab").isEmpty
                    ? NestedTabBar(
                        Directory(
                            '/storage/emulated/0/WhatsApp/Media/.Statuses'),
                        Directory(
                            '/storage/emulated/0/WhatsApp/Media/.Statuses'),
                        false,
                        adManager)
                    : Container(child: Icon(Icons.error_outline)),
                remoteConfig.getString("SavedTab") == "true" ||
                        remoteConfig.getString("SavedTab").isEmpty
                    ? NestedTabBar(
                        appDocDirectory, appDocDirectory, true, adManager)
                    : Container(
                        child: Icon(Icons.error_outline),
                      ),
                remoteConfig.getString("StickerTab") == "true" ||
                        remoteConfig.getString("StickerTab").isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: StickersPage(),
                          ),
                        ],
                      )
                    : Container(child: Icon(Icons.error_outline)),
                remoteConfig.getString("WebTab") == "true" ||
                        remoteConfig.getString("WebTab").isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: WhatsAppWeb(),
                          )
                        ],
                      )
                    : Container(child: Icon(Icons.error_outline)),
              ],
            ),
          ),
          bottomNavigationBar: remoteConfig.getString("MainBanner") == "true" ||
                  remoteConfig.getString("MainBanner").isEmpty
              ? Container(height: 50, child: adManager.bannerAd)
              : SizedBox(height: 50,),
        );
      }),
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
  final adManager;

  NestedTabBar(
      this.photoDir, this.videoDir, this.insideSavedSection, this.adManager);

  @override
  _NestedTabBarState createState() =>
      _NestedTabBarState(photoDir, videoDir, insideSavedSection, adManager);
}

class _NestedTabBarState extends State<NestedTabBar>
    with AutomaticKeepAliveClientMixin<NestedTabBar>, TickerProviderStateMixin {
  Directory photoDir;
  final Directory videoDir;
  final adManager;
  bool insideSavedSection;
  TabController _nestedTabController;

  _NestedTabBarState(
      this.photoDir, this.videoDir, this.insideSavedSection, this.adManager);

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
          height: screenHeight * 0.69,
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              ImageGridViewer(photoDir, insideSavedSection, adManager, remoteConfig),
              VideoGridViewer(videoDir, insideSavedSection, adManager),
            ],
          ),
        )
      ],
    );
  }
}
