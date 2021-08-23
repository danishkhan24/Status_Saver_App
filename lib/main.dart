import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:status_saver/AdManager.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import './FilesSection.dart';
import 'package:provider/provider.dart';
import 'ProviderModel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
  runApp(ChangeNotifierProvider(
    create: (context) => ProviderModel(),
      child: MaterialApp(home: MyApp(),)));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Status Saver',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF3d4e4f),
        fontFamily: 'Georgia',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'WhatsApp Status Saver'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool permissionGranted;
  FacebookAd facebookAd = FacebookAd();
  RemoteConfig remoteConfig;
  bool isLoading = true;

  remoteSetup() async {
    await Firebase.initializeApp();
    final remoteCfg = RemoteConfig.instance;

    await remoteCfg.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 24)));
    remoteCfg.fetchAndActivate();
    remoteConfig = remoteCfg;

    setState(() {
      isLoading = false;
    });
  }

  @override
  initState() {
    var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.initialize();
    super.initState();
    facebookAd.loadInterstitialAd();
    remoteSetup();
  }

  @override
  void dispose() {
    var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.subscription.cancel();
    super.dispose();
  }

  Future _getStoragePermission() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory path = Directory(appDocDirectory.path + "/savedImages/");

    if (await Permission.storage.request().isGranted) {
      permissionGranted = true;
      if (!await path.exists()) {
        path.create();
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FilesSection(path, facebookAd, remoteConfig)),
      );
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      permissionGranted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
            image: AssetImage('assets/images/bg.png'), fit: BoxFit.fill),
      ),
      child: splashScreen(),
    );
  }

  Widget splashScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
              height: 120,
              child: !isLoading
                  ? remoteConfig.getString("SplashAd") == "true" ||
                          remoteConfig.getString("SplashAd").isEmpty
                      ? facebookAd.nativeAd
                      : null
                  : null),
          SizedBox(
            height: 150,
          ),
          Container(
              width: 120,
              height: 120,
              child: Image(image: AssetImage('assets/images/splash_logo.png'))),
          SizedBox(
            height: 100,
          ),
          Text('Welcome to Status Saver!',
              style: Theme.of(context).textTheme.headline1),
          ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Color(0xFF122829),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Color(0xFF122829))),
            ),
            onPressed: () {
              if (remoteConfig.getString("InterstitialAd") == "true" ||
                  remoteConfig.getString("InterstitialAd").isEmpty) {
                facebookAd.showInterstitialAd();
              }
              _getStoragePermission();
            },
          ),
        ],
      ),
    );
  }
}
