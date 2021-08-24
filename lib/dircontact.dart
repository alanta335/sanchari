import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DirContact extends StatefulWidget {
  const DirContact({Key? key}) : super(key: key);

  @override
  _DirContactState createState() => _DirContactState();
}

const police_no = 'tel:+91 100';
const help_no = 'tel:+91 123456789';

class _DirContactState extends State<DirContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Direct contact"),
      ),
      body: Container(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await launch(police_no);
              },
              child: Text("contact police"),
            ),
            ElevatedButton(
              onPressed: () async {
                await launch(help_no);
              },
              child: Text("contact helpline"),
            ),
          ],
        ),
      ),
    );
  }
}
