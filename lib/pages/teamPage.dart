import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricketapp/pages/player.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../service/storage_service.dart';

class TeamPage extends StatefulWidget {
  final Text name;
  const TeamPage(this.name, {Key? key}) : super(key: key);

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  var fileName;
  var path;

  var Collection = 'Players';

  final Storage storage = Storage();
  final CollectionReference _playerss =
      FirebaseFirestore.instance.collection('players');
  final CollectionReference _teamss =
      FirebaseFirestore.instance.collection('teams');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.name,
      ),

      // Using StreamBuilder to display all products from Firestore in real-time
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              StreamBuilder(
                stream: _teamss
                    .where('countryName', isEqualTo: widget.name.data)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot1 =
                              streamSnapshot.data!.docs[index];
                          final Text Countryimg =
                              Text(documentSnapshot1['img']);
                          final Text Countrydes =
                              Text(documentSnapshot1['Detail']);
                          var Collection = 'Teams';
                          return Column(children: [
                            Card(
                              child: Column(children: [
                                FutureBuilder(
                                    future: storage.downloadURL(
                                        Countryimg.data.toString()),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        return Container(
                                            width: 180,
                                            height: 150,
                                            //padding: EdgeInsets.only(bottom: 5),
                                            child: Image.network(
                                              snapshot.data!,
                                              fit: BoxFit.cover,
                                            ));
                                      }

                                      return Container();
                                    }),
                                Card(
                                  elevation: 7,
                                  margin: const EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text(documentSnapshot1['Detail']),
                                  ),
                                ),
                              ]),
                            ),
                          ]);
                        });
                  }
                  return const Text('ok');
                },
              ),
              ListTile(
                title: Text('Team Players'),
              ),
              StreamBuilder(
                stream: _playerss
                    .where('countryName', isEqualTo: widget.name.data)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot2 =
                            streamSnapshot.data!.docs[index];
                        final Text plname =
                            Text(documentSnapshot2['PlayerName']);
                        final Text img = Text(documentSnapshot2['Image']);
                        return Column(
                          children: [
                            Card(
                                elevation: 7,
                                child: Column(
                                  children: [
                                    FutureBuilder(
                                        future: storage
                                            .downloadURL(img.data.toString()),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData) {
                                            return Container(
                                                width: 100,
                                                height: 100,
                                                //padding: EdgeInsets.only(bottom: 5),
                                                child: Image.network(
                                                  snapshot.data!,
                                                  fit: BoxFit.cover,
                                                ));
                                          }

                                          return Container();
                                        }),
                                    // margin: const EdgeInsets.all(10),
                                    ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Player(plname)));
                                      },
                                      title: plname,
                                      subtitle: Text(documentSnapshot2['type']),
                                    ),
                                  ],
                                ))
                          ],
                        );
                        return const Text('ok');
                      },
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          )),

      // Add new product
    );
  }
}
