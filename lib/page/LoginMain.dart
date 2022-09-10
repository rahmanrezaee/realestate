
import 'package:badam/provider/auth_provider.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  Auth auth;
  LoginScreen({this.auth});

  @override
  _LoginScreenPageState createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreen> {

  void refersh(data){

    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    
    return   Scaffold(
      appBar: AppBar(title: Text("حساب کاربری")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                "برای ثبت و مدیریت آگهی های خود وارد سیستم شوید.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.pushNamed(context, "/codephoneVarify").then((value)=> refersh),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "ورود / ثبت نام",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> formAuth = [
    TextField(
      // controller: password,
      decoration: InputDecoration(
        icon: Icon(Icons.account_circle),
        labelText: 'پسورد تان را وارد کنید',
      ),
    ),
  ];

}
