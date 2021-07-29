import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_stickers/flutter_whatsapp_stickers.dart';
import 'utils.dart';

class StickerInfo extends StatefulWidget {
  StickerInfo({this.stickerPack});

  final List stickerPack;

  @override
  _StickerInfoState createState() => _StickerInfoState(stickerPack);
}

class _StickerInfoState extends State<StickerInfo> {
  List stickerPack = [];
  final WhatsAppStickers _waStickers = WhatsAppStickers();

  _StickerInfoState(this.stickerPack);

  void _checkInstallationStatus() async {
    print('total sticker: ${stickerPack.length}');
    var tempName = stickerPack[0];
    bool tempInstall =
        await WhatsAppStickers().isStickerPackInstalled(tempName);
    if (tempInstall == true) {
      if (!stickerPack[6].contains(tempName)) {
        setState(() {
          stickerPack[6].add(tempName);
        });
      } else {
        if (stickerPack[6].contains(tempName)) {
          setState(() {
            stickerPack[6].remove(tempName);
          });
        }
      }
    }
    print('${stickerPack[6]}');
  }

  @override
  Widget build(BuildContext context) {
    List totalStickers = stickerPack[4];
    // List<Widget> fakeBottomButtons = [];
    // fakeBottomButtons.add(Container(
    //   height: 50,
    // ));
    Widget depInstallWidget;

    if (stickerPack[5] == true) {
      depInstallWidget = Text(
        'Sticker Added',
        style: TextStyle(
          fontSize: 18,
          color: Colors.teal,
        ),
      );
    } else {
      depInstallWidget = ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.teal)),
        onPressed: () async {
          _waStickers.addStickerPack(
              packageName: WhatsAppPackage.Consumer,
              stickerPackIdentifier: stickerPack[0],
              stickerPackName: stickerPack[1],
              listener: (action, result, {error = ''}) => processResponse(
                  action: action,
                  result: result,
                  error: error,
                  context: context,
                  successCallBack: () async {
                    setState(() {
                      _checkInstallationStatus();
                    });
                  }));
        },
        child: Text(
          'Add Sticker',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${stickerPack[1]} Stickers'),
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  'sticker_packs/${stickerPack[0]}/${stickerPack[3]}',
                  width: 100,
                  height: 100,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${stickerPack[1]}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    Text(
                      '${stickerPack[2]}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    depInstallWidget,
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: 1),
              itemCount: totalStickers.length,
              itemBuilder: (context, index) {
                var stickerImg =
                    'sticker_packs/${stickerPack[0]}/${totalStickers[index]['image_file']}';
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: Image.asset(
                    stickerImg,
                    width: 100,
                    height: 100,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // persistentFooterButtons: fakeBottomButtons,
    );
  }
}
