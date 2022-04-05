import 'package:cricketapp/pages/Admin/teamAdd.dart';

import 'package:flutter/material.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({Key? key}) : super(key: key);

  @override
  State<AdminMenu> createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Admin Menu'),
          ),
          body: Center(
              child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.all(25),
              child: OutlineButton(
                child: Text(
                  "Team Managment",
                  style: TextStyle(fontSize: 20.0),
                ),
                highlightedBorderColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => TeamAdd()));
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: OutlineButton(
                child: Text(
                  "Add Players",
                  style: TextStyle(fontSize: 20.0),
                ),
                highlightedBorderColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () {},
              ),
            ),
          ]))),
    );
  }
}
