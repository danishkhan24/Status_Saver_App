import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'stickers_information.dart';
import 'utils.dart';
import 'package:flutter_whatsapp_stickers/flutter_whatsapp_stickers.dart';

class StickersPage extends StatefulWidget {
  @override
  _StickersPageState createState() => _StickersPageState();
}

class _StickersPageState extends State<StickersPage> with AutomaticKeepAliveClientMixin<StickersPage>{
  final WhatsAppStickers _waStickers = WhatsAppStickers();
  List stickerList = [];
  List installedStickers = [];

  void _loadSticker() async {
    String data =
        await rootBundle.loadString("sticker_packs/sticker_packs.json");
    final response = json.decode(data.toString());
    var tempList = [];

    for (int i = 0; i < response['sticker_packs'].length; i++) {
      tempList.add(response['sticker_packs'][i]);
    }
    setState(() {
      stickerList.addAll(tempList);
    });
    _checkInstallationStatuses();
  }

  void _checkInstallationStatuses() async {
    print('total stickers: ${stickerList.length}');
    for (var j = 0; j < stickerList.length; j++) {
      var tempName = stickerList[j]['identifier'];
      bool tempInstall =
          await WhatsAppStickers().isStickerPackInstalled(tempName);
      if (tempInstall == true) {
        if (!installedStickers.contains(tempName)) {
          setState(() {
            installedStickers.add(tempName);
          });
        }
      } else {
        if (installedStickers.contains(tempName)) {
          setState(() {
            installedStickers.remove(tempName);
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSticker();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: stickerList.length,
        itemBuilder: (context, index) {
          if (stickerList.length == 0) {
            return Container(
              child: CircularProgressIndicator(),
            );
          } else {
            var stickerId = stickerList[index]['identifier'];
            var stickerName = stickerList[index]['name'];
            var stickerPublisher = stickerList[index]['publisher'];
            var stickerTrayIcon = stickerList[index]['tray_image_file'];
            var tempStickerList = [];
            bool stickerInstalled = false;
            if (installedStickers.contains(stickerId)) {
              stickerInstalled = true;
            } else {
              stickerInstalled = false;
            }
            tempStickerList.add(stickerList[index]['identifier']);
            tempStickerList.add(stickerList[index]['name']);
            tempStickerList.add(stickerList[index]['publisher']);
            tempStickerList.add(stickerList[index]['tray_image_file']);
            tempStickerList.add(stickerList[index]['stickers']);
            tempStickerList.add(stickerInstalled);
            tempStickerList.add(installedStickers);
            return stickerPack(tempStickerList, stickerName, stickerPublisher,
                stickerId, stickerTrayIcon, stickerInstalled);
          }
        },
      ),
    );
  }

  Widget stickerPack(List stickerList, String name, String publisher,
      String identifier, String stickerTrayIcon, bool installed) {
    Widget depInstallWidget;
    if (installed == true) {
      depInstallWidget = IconButton(
        onPressed: () {},
        icon: Icon(Icons.check),
      );
    } else {
      depInstallWidget = IconButton(
        icon: Icon(Icons.add),
        onPressed: () async {
          _waStickers.addStickerPack(
            packageName: WhatsAppPackage.Consumer,
            stickerPackIdentifier: identifier,
            stickerPackName: name,
            listener: (action, result, {error = ''}) => processResponse(
              action: action,
              result: result,
              error: error,
              successCallBack: () async {
                _checkInstallationStatuses();
              },
              context: context,
            ),
          );
        },
      );
    }
    return Container(
      padding: EdgeInsets.all(5),
      child: Material(
        child: ListTile(
          tileColor: Colors.black,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    StickerInfo(stickerPack: stickerList)));
          },
          title: Text(
            '$name',
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Text(
            '$publisher',
            style: TextStyle(fontSize: 18),
          ),
          leading: Image.asset('sticker_packs/$identifier/$stickerTrayIcon'),
          trailing: Column(
            children: [
              depInstallWidget,
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
