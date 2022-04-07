import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricketapp/pages/Admin/adminMenu.dart';
import 'package:cricketapp/pages/teamPage.dart';

import 'package:flutter/material.dart';

import '../service/storage_service.dart';
import 'design/app_theme.dart';

class TeamView extends StatefulWidget {
  const TeamView({Key? key}) : super(key: key);

  @override
  _TeamView createState() => _TeamView();
}

class _TeamView extends State<TeamView> {
  bool multiple = true;
  var fileName;
  var path;
  var Collection = 'Teams';
  final Storage storage = Storage();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final CollectionReference _teamss =
      FirebaseFirestore.instance.collection('teams');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.darkText,
        title: const Text(
          'Countries',
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.person_outlined),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AdminMenu()));
              })
        ],
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _teamss.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot1 =
                    streamSnapshot.data!.docs[index];
                final Text name = Text(
                  documentSnapshot1['countryName'],
                  style: TextStyle(
                    fontSize: 20,
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w400,
                  ),
                );
                final Text img = Text(documentSnapshot1['img']);
                return Card(
                    borderOnForeground: true,

                    // Colors.cyanAccent,
                    color: Color.fromARGB(255, 255, 255, 255),
                    elevation: 7,
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: storage.downloadURL(img.data.toString()),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                return Container(
                                    width: 120,
                                    height: 100,
                                    //padding: EdgeInsets.only(bottom: 5),
                                    child: Image.network(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    ));
                              }

                              return Container();
                            }),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TeamPage(name)));
                          },
                          title: name,

                          //subtitle: Text(documentSnapshot['price'].toString()),
                        ),
                      ],
                    ));
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
