import 'package:badam/modul/html_converter.dart';
import 'package:badam/provider/property_provider.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  Future initValue;
  @override
  void initState() {
    initValue = PropertyProvider().getPageDetail("5448");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" درباره و ارتباط باما"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: initValue,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: getHtmlFile(snapshot.data['content']['rendered']),
                );
              default:
                return Text("مشکل پیش امد");
            }
          },
        ),
      ),
    );
  }
}
