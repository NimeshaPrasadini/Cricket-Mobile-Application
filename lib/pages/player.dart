import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../service/storage_service.dart';
import 'design/app_theme.dart';

class Player extends StatefulWidget {
  final Text plname;
  const Player(this.plname, {Key? key}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  var Collection = 'Players';
  final Storage storage = Storage();
  final CollectionReference _playerss =
      FirebaseFirestore.instance.collection('players');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.plname,
      ),

      // Using StreamBuilder to display all products from Firestore in real-time
      body: SafeArea(
        child: StreamBuilder(
          stream: _playerss
              .where('PlayerName', isEqualTo: widget.plname.data)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot3 =
                      streamSnapshot.data!.docs[index];
                  final Text img = Text(documentSnapshot3['Image']);
                  return Column(children: [
                    Card(
                        child: Column(children: [
                      FutureBuilder(
                          future: storage.downloadURL(img.data.toString()),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Container(
                                  width: 150,
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
                          title: Text(
                            documentSnapshot3['Description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.darkText,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ])),
                    Card(
                      elevation: 7,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('ODI Matches'
                            '           '
                            'Runs'
                            '           '
                            'AVG'
                            '           '
                            'SR'),
                        subtitle: Text(documentSnapshot3['ODI'] +
                            "                                " +
                            documentSnapshot3['ODIRuns'] +
                            "            " +
                            documentSnapshot3['ODIAvg'] +
                            "             " +
                            documentSnapshot3['ODISR']),
                      ),
                    ),
                    Card(
                      elevation: 7,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('T20 Matches'
                            '           '
                            'Runs'
                            '           '
                            'AVG'
                            '           '
                            'SR'),
                        subtitle: Text(documentSnapshot3['T20'] +
                            "                                   " +
                            documentSnapshot3['T20Runs'] +
                            "              " +
                            documentSnapshot3['T20Avg'] +
                            "            " +
                            documentSnapshot3['T20SR']),
                      ),
                    ),
                    Card(
                      elevation: 7,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('Test Matches'
                            '           '
                            'Runs'
                            '           '
                            'AVG'
                            '           '
                            'SR'),
                        subtitle: Text(documentSnapshot3['Test'] +
                            "                                   " +
                            documentSnapshot3['TestRuns'] +
                            "              " +
                            documentSnapshot3['TestAvg'] +
                            "              " +
                            documentSnapshot3['TestSR']),
                      ),
                    )
                  ]);
                  return Text("");
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
