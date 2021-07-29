import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_stickers/flutter_whatsapp_stickers.dart';

Future<void> processResponse(
    {StickerPackResult action,
    bool result,
    String error,
    BuildContext context,
    Function successCallBack}) async {
  print('_listener');
  print(action);
  print(result);
  print(error);
  SnackBar snackBar;

  switch (action) {
    case StickerPackResult.SUCCESS:
    case StickerPackResult.ADD_SUCCESSFUL:
    case StickerPackResult.ALREADY_ADDED:
      successCallBack();
      break;
    case StickerPackResult.CANCELLED:
      snackBar = SnackBar(
          content: Text(
        'Cancelled Sticker Pack Install',
        style: TextStyle(fontSize: 18),
      ));
      break;
    case StickerPackResult.ERROR:
      snackBar = SnackBar(
        content: Text(
          'UnKnown Error',
          style: TextStyle(fontSize: 18),
        ),
      );
      break;
    case StickerPackResult.UNKNOWN:
      break;
  }
  if (snackBar != null && context != null) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
