import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  final Text plname;
  const Player(this.plname, {Key? key}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final CollectionReference _playerss =
      FirebaseFirestore.instance.collection('players');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widget.plname,
        ),
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
                    return Column(children: [
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
        ));
  }
}
