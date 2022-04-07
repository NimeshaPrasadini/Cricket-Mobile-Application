import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../service/storage_service.dart';

class Shedule extends StatefulWidget {
  const Shedule({Key? key}) : super(key: key);

  @override
  State<Shedule> createState() => _SheduleState();
}

class _SheduleState extends State<Shedule> {
  var Collection = 'Teams';
  var Country1 = Text('aa');
  var Country2 = Text('bb');
  final Storage storage = Storage();

  final CollectionReference _sheduless =
      FirebaseFirestore.instance.collection('shedules');
  final CollectionReference _teamss =
      FirebaseFirestore.instance.collection('teams');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Shedule'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: SafeArea(
        child: StreamBuilder(
          stream: _sheduless.where('status', isEqualTo: '').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot4 =
                      streamSnapshot.data!.docs[index];
                  Text cn1 = Text(documentSnapshot4['country1']);
                  Country1 = cn1;
                  Text cn2 = Text(documentSnapshot4['country2']);
                  Country2 = cn2;
                  final Text date = Text(documentSnapshot4['date']);
                  final Text vn = Text(documentSnapshot4['venue']);
                  return GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Container(
                      width: 420,
                      height: 150,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3,
                            color: Color(0x32000000),
                            offset: Offset(0, 1),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(60),
                                bottomRight: Radius.circular(60),
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60),
                              ),
                              child: StreamBuilder(
                                  stream: _teamss
                                      .where('countryName',
                                          isEqualTo: Country1.data)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot>
                                          streamSnapshot) {
                                    if (!streamSnapshot.hasData) {
                                      return const Text("Loading");
                                    }
                                    return Container(
                                        width: 140,
                                        height: 100,
                                        child: ListView.builder(

                                            //var userDocument = streamSnapshot.data;
                                            itemCount: streamSnapshot
                                                .data!.docs.length,
                                            itemBuilder: (context, index) {
                                              final DocumentSnapshot
                                                  documentSnapshot1 =
                                                  streamSnapshot
                                                      .data!.docs[index];
                                              final Text Countryimg = Text(
                                                  documentSnapshot1['img']);
                                              return FutureBuilder(
                                                  future: storage.downloadURL(
                                                      Countryimg.data
                                                          .toString()),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<String>
                                                              snapshot) {
                                                    if (snapshot.connectionState ==
                                                            ConnectionState
                                                                .done &&
                                                        snapshot.hasData) {
                                                      //padding: EdgeInsets.only(bottom: 5),
                                                      return Image.network(
                                                        snapshot.data!,
                                                        width: 140,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      );
                                                    }

                                                    return Container();
                                                  });
                                            }));
                                  })),
                          const Spacer(
                            flex: 1,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      child: Text(documentSnapshot4['venue']),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: const [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          50, 0, 0, 0),
                                      child: Text('VS'),
                                    ),

                                    /* Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 3, 0, 0),
                                      child: Text(documentSnapshot4['date']),
                                    ),*/
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      child: Text(documentSnapshot4['date']),
                                    ),

                                    /* Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 3, 0, 0),
                                      child: Text(documentSnapshot4['date']),
                                    ),*/
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              40, 6, 0, 0),
                                      child: Text(documentSnapshot4['time']),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(60),
                                bottomLeft: Radius.circular(60),
                                topRight: Radius.circular(60),
                                topLeft: Radius.circular(60),
                              ),
                              child: StreamBuilder(
                                  stream: _teamss
                                      .where('countryName',
                                          isEqualTo: Country2.data)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot>
                                          streamSnapshot) {
                                    if (!streamSnapshot.hasData) {
                                      return new Text("Loading");
                                    }
                                    return Container(
                                        width: 140,
                                        height: 100,
                                        child: ListView.builder(

                                            //var userDocument = streamSnapshot.data;
                                            itemCount: streamSnapshot
                                                .data!.docs.length,
                                            itemBuilder: (context, index) {
                                              final DocumentSnapshot
                                                  documentSnapshot1 =
                                                  streamSnapshot
                                                      .data!.docs[index];
                                              final Text Countryimg = Text(
                                                  documentSnapshot1['img']);
                                              return FutureBuilder(
                                                  future: storage.downloadURL(
                                                      Countryimg.data
                                                          .toString()),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<String>
                                                              snapshot) {
                                                    if (snapshot.connectionState ==
                                                            ConnectionState
                                                                .done &&
                                                        snapshot.hasData) {
                                                      return Image.network(
                                                        snapshot.data!,
                                                        width: 140,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      );
                                                    }

                                                    return Container();
                                                  });
                                            }));
                                  })),
                        ],
                      ),
                    ),
                  );
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
