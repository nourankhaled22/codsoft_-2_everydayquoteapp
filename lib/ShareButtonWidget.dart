import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

class ShareButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Share Button Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Share Button Example'),
        ),
        body: Center(
          child: ShareButton(),
        ),
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  void _shareMessage(BuildContext context) {
    String message = "Check out this awesome quote!"; // Replace with your actual message

    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.share),
      onPressed: () {
        _shareMessage(context);
      },
    );
  }
}
