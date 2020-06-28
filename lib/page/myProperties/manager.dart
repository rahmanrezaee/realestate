import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ManagerPage extends StatefulWidget {
  ManagerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'پروفایل',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {}),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4 - 10,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 20,
                        spreadRadius: 10,
                      )
                    ],
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 105,
                      width: 105,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(52.5),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColorLight,
                              spreadRadius: 2,
                            )
                          ]),
                      child: CircleAvatar(
                        backgroundColor: Colors.black45,
                        radius: 50,
                        child: FaIcon(
                          FontAwesomeIcons.userAlt,
                          size: 33,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 35),
                      child: Text(
                        'رحمان رضایی',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 40, right: 34, left: 34),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 3),
                     
                      child: ListTile(
                        contentPadding: EdgeInsets.only(
                            top: 0, left: 10, right: 10, bottom: 10),
                        onTap: () => Navigator.pushNamed(
                            context, "/myPropertyList",
                            arguments: 1.toString()),
                        leading: Icon(
                          Icons.list,
                          size: 28,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          'لیست املاک من',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 3),
                     
                      child: ListTile(
                        contentPadding: EdgeInsets.only(
                            top: 0, left: 10, right: 10, bottom: 10),
                        onTap: () =>
                            Navigator.pushNamed(context, "/favoritePage"),
                        leading: Icon(
                          Icons.favorite_border,
                          size: 28,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          'لیست علاقه مندان',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 3),
                     
                      child: ListTile(
                        contentPadding: EdgeInsets.only(
                            top: 0, left: 10, right: 10, bottom: 10),
                        onTap: () {
                          Navigator.pushNamed(context, "/profile");
                        },
                        leading: Icon(
                          Icons.settings,
                          size: 28,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          'پروفایل',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 3),
                     
                      child: ListTile(
                        contentPadding: EdgeInsets.only(
                            top: 0, left: 10, right: 10, bottom: 10),
                        onTap: () {},
                        leading: Icon(
                          Icons.message,
                          size: 28,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          'تماس باما',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 3),
                     
                      child: ListTile(
                        contentPadding: EdgeInsets.only(
                            top: 0, left: 10, right: 10, bottom: 10),
                        onTap: () {},
                        leading: Icon(
                          Icons.inbox,
                          size: 28,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        title: Text(
                          'شرایط مقرارات',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
