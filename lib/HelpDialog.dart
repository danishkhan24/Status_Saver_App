import 'package:flutter/material.dart';

class HelpButton {
  Widget popup(int index, BuildContext context) {
    Widget content;
    if (index == 0) {
      content = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.arrow_forward),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Check out your desired stories/statuses"),
                )),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_forward),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Click on any image/video to view and share"),
                )),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_forward),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Click the save button to Save photo/video permanently"),
                ))
              ],
            )
          ],
        ),
      );
    } else if (index == 1) {
      content = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.arrow_forward),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Click share icon to share saved images/videos"),
                )),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_forward),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text("Click delete button to delete saved images/videos"),
                )),
              ],
            )
          ],
        ),
      );
    } else if (index == 2) {
      content = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.arrow_forward),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Click any Sticker pack to view/add to WhatsApp"),
                ))
              ],
            ),
          ],
        ),
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.arrow_forward),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Open WhatsApp on your phone"),
                )),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_forward),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Tap Menu or Settings and select Linked Devices"),
                )),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_forward),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Point your phone to this screen to capture the code"),
                )),
              ],
            )
          ],
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 20,
      backgroundColor: Colors.black87,
      child: Container(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                "Help",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
            ),
            SizedBox(height: 10),
            Center(child: content),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,0,20,10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF3d4e4f))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
