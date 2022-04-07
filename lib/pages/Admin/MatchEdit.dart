import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../service/storage_service.dart';

class MatchEdit extends StatefulWidget {
  final Text match;
  const MatchEdit(this.match, {Key? key}) : super(key: key);

  @override
  State<MatchEdit> createState() => _MatchEditState();
}

class _MatchEditState extends State<MatchEdit> {
  var Country1 = Text('aa');
  var Country2 = Text('bb');
  final Storage storage = Storage();

  final CollectionReference _sheduless =
      FirebaseFirestore.instance.collection('shedules');
  final CollectionReference _teamss =
      FirebaseFirestore.instance.collection('teams');
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();
  final TextEditingController _country1ScoreController =
      TextEditingController();
  final TextEditingController _country2ScoreController =
      TextEditingController();

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot4]) async {
    String action = 'create';
    if (documentSnapshot4 != null) {
      action = 'update';

      _statusController.text = documentSnapshot4['status'];
      _resultController.text = documentSnapshot4['result'];
      _country1ScoreController.text = documentSnapshot4['country1Score'];
      _country2ScoreController.text = documentSnapshot4['country2Score'];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _statusController,
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
                TextField(
                  controller: _resultController,
                  decoration: const InputDecoration(
                    labelText: 'ODI Matches',
                  ),
                ),
                TextField(
                  controller: _country1ScoreController,
                  decoration: const InputDecoration(
                    labelText: 'Runs',
                  ),
                ),
                TextField(
                  controller: _country2ScoreController,
                  decoration: const InputDecoration(
                    labelText: 'Average',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? status = _statusController.text;
                    final String? result = _resultController.text;
                    final String? cn1Score = _country1ScoreController.text;
                    final String? cn2Score = _country2ScoreController.text;

                    // final double? price =
                    //  double.tryParse(_priceController.text);
                    if (status != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _sheduless.add({
                          "status": status,
                          "result": result,
                          "country1Score": cn1Score,
                          "country2Score": cn2Score
                        });
                      }

                      if (action == 'update') {
                        // Update the product
                        await _sheduless.doc(documentSnapshot4!.id).update({
                          "status": status,
                          "result": result,
                          "country1Score": cn1Score,
                          "country2Score": cn2Score
                        });
                      }

                      // Clear the text fields

                      _statusController.text = '';
                      _resultController.text = '';
                      _country1ScoreController.text = '';
                      _country2ScoreController.text = '';

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Shedule'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: SafeArea(
        child: StreamBuilder(
          stream: _sheduless
              .where('time', isEqualTo: widget.match.data)
              .snapshots(),
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
                  final Text res = Text(documentSnapshot4['result']);
                  final Text cn1score =
                      Text(documentSnapshot4['country1Score']);
                  final Text cn2score =
                      Text(documentSnapshot4['country2Score']);
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
                                    var userDocument = streamSnapshot.data;
                                    final DocumentSnapshot documentSnapshot1 =
                                        streamSnapshot.data!.docs[index];
                                    final Text Countryimg =
                                        Text(documentSnapshot1['img']);
                                    return FutureBuilder(
                                        future: storage.downloadURL(
                                            Countryimg.data.toString()),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
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
                                  //padding: const EdgeInsets.symmetric(vertical: 20),
                                  children: [
                                    IconButton(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            55, 0, 0, 0),
                                        iconSize: 20,
                                        icon: const Icon(Icons.edit),
                                        onPressed: () =>
                                            _createOrUpdate(documentSnapshot4)),
                                    // This icon button is used to delete a single product
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 0),
                                      child: cn1score,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          50, 0, 0, 0),
                                      child: cn2score,
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
                                              0, 20, 0, 0),
                                      child: res,
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
                                    var userDocument = streamSnapshot.data;
                                    final DocumentSnapshot documentSnapshot1 =
                                        streamSnapshot.data!.docs[index];
                                    final Text Countryimg =
                                        Text(documentSnapshot1['img']);
                                    return FutureBuilder(
                                        future: storage.downloadURL(
                                            Countryimg.data.toString()),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
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
