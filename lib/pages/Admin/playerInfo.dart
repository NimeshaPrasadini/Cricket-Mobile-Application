import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../service/storage_service.dart';

class PlayerInfo extends StatefulWidget {
  final Text plname;
  const PlayerInfo(this.plname, {Key? key}) : super(key: key);

  @override
  State<PlayerInfo> createState() => _PlayerInfoState();
}

class _PlayerInfoState extends State<PlayerInfo> {
  var fileName;
  var path;
  var Collection = 'Players';
  final Storage storage = Storage();
  final TextEditingController _playernameController = TextEditingController();
  final TextEditingController _ODIController = TextEditingController();
  final TextEditingController _ODIRunsController = TextEditingController();
  final TextEditingController _ODIAvgController = TextEditingController();
  final TextEditingController _ODISRController = TextEditingController();
  final TextEditingController _T20Controller = TextEditingController();
  final TextEditingController _T20RunsController = TextEditingController();
  final TextEditingController _T20AvgController = TextEditingController();
  final TextEditingController _T20SRController = TextEditingController();
  final TextEditingController _TestController = TextEditingController();
  final TextEditingController _TestRunsController = TextEditingController();
  final TextEditingController _TestAvgController = TextEditingController();
  final TextEditingController _TestSRController = TextEditingController();
  final TextEditingController _DesController = TextEditingController();

  final CollectionReference _playerss =
      FirebaseFirestore.instance.collection('players');

  Future<void> _createOrUpdateDes([DocumentSnapshot? documentSnapshot3]) async {
    String action = 'create';

    if (documentSnapshot3 != null) {
      action = 'update';

      _DesController.text = documentSnapshot3['Description'];
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
                  controller: _DesController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? Des = _DesController.text;

                    //  double.tryParse(_priceController.text);
                    if (Des != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        _playerss.add({
                          "Description": Des,
                        });
                      }
                      if (action == 'update') {
                        // Update the product
                        await _playerss.doc(documentSnapshot3!.id).update({
                          "Description": Des,
                        });
                      }
                      // Clear the text fields
                      _DesController.text = '';

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

  Future<void> _menu() async {
    floatingActionButton:
    FloatingActionButton(
      onPressed: () => _createOrUpdateODI(),
      child: const Icon(Icons.add),
    );

    floatingActionButton:
    FloatingActionButton(
      onPressed: () => _createOrUpdateT20(),
      child: const Icon(Icons.add),
    );

    floatingActionButton:
    FloatingActionButton(
      onPressed: () => _createOrUpdateTEST(),
      child: const Icon(Icons.add),
    );
  }

  Future<void> _createOrUpdateODI([DocumentSnapshot? documentSnapshot3]) async {
    String action = 'create';

    if (documentSnapshot3 != null) {
      action = 'update';
      _playernameController.text = documentSnapshot3['PlayerName'];
      _ODIController.text = documentSnapshot3['ODI'];
      _ODIRunsController.text = documentSnapshot3['ODIRuns'];
      _ODIAvgController.text = documentSnapshot3['ODIAvg'];
      _ODISRController.text = documentSnapshot3['ODISR'];
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
                  controller: _playernameController,
                  decoration: const InputDecoration(labelText: 'Player Name'),
                ),
                TextField(
                  controller: _ODIController,
                  decoration: const InputDecoration(
                    labelText: 'ODI Matches',
                  ),
                ),
                TextField(
                  controller: _ODIRunsController,
                  decoration: const InputDecoration(
                    labelText: 'Runs',
                  ),
                ),
                TextField(
                  controller: _ODIAvgController,
                  decoration: const InputDecoration(
                    labelText: 'Average',
                  ),
                ),
                TextField(
                  controller: _ODISRController,
                  decoration: const InputDecoration(
                    labelText: 'Strike Rate',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? PlayerName = _playernameController.text;
                    final String? ODI = _ODIController.text;
                    final String? ODIRuns = _ODIRunsController.text;
                    final String? ODIAverage = _ODIAvgController.text;
                    final String? ODISR = _ODISRController.text;
                    //  double.tryParse(_priceController.text);
                    if (PlayerName != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _playerss.add({
                          "PlayerName": PlayerName,
                          "ODI": ODI,
                          "ODIRuns": ODIRuns,
                          "ODIAvg": ODIAverage,
                          "ODISR": ODISR
                        });
                      }
                      if (action == 'update') {
                        // Update the product
                        await _playerss.doc(documentSnapshot3!.id).update({
                          "PlayerName": PlayerName,
                          "ODI": ODI,
                          "ODIRuns": ODIRuns,
                          "ODIAvg": ODIAverage,
                          "ODISR": ODISR
                        });
                      }
                      // Clear the text fields
                      _playernameController.text = '';
                      _ODIController.text = '';
                      _ODIRunsController.text = '';
                      _ODIAvgController.text = '';
                      _ODISRController.text = '';

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

  Future<void> _createOrUpdateT20([DocumentSnapshot? documentSnapshot3]) async {
    String action = 'create';
    if (documentSnapshot3 != null) {
      action = 'update';
      _playernameController.text = documentSnapshot3['PlayerName'];
      _T20Controller.text = documentSnapshot3['T20'];
      _T20RunsController.text = documentSnapshot3['T20Runs'];
      _T20AvgController.text = documentSnapshot3['T20Avg'];
      _T20SRController.text = documentSnapshot3['T20SR'];
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
                  controller: _playernameController,
                  decoration: const InputDecoration(labelText: 'Player Name'),
                ),
                TextField(
                  controller: _T20Controller,
                  decoration: const InputDecoration(
                    labelText: 'T20 Matches',
                  ),
                ),
                TextField(
                  controller: _T20RunsController,
                  decoration: const InputDecoration(
                    labelText: 'Runs',
                  ),
                ),
                TextField(
                  controller: _T20AvgController,
                  decoration: const InputDecoration(
                    labelText: 'Average',
                  ),
                ),
                TextField(
                  controller: _T20SRController,
                  decoration: const InputDecoration(
                    labelText: 'Strike Rate',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? PlayerName = _playernameController.text;
                    final String? T20 = _T20Controller.text;
                    final String? T20Runs = _T20RunsController.text;
                    final String? T20Avg = _T20AvgController.text;
                    final String? T20SR = _T20SRController.text;
                    //  double.tryParse(_priceController.text);
                    if (PlayerName != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _playerss.add({
                          "PlayerName": PlayerName,
                          "T20": T20,
                          "T20Runs": T20Runs,
                          "T20Avg": T20Avg,
                          "T20SR": T20SR,
                        });
                      }
                      if (action == 'update') {
                        // Update the product
                        await _playerss.doc(documentSnapshot3!.id).update({
                          "PlayerName": PlayerName,
                          "T20": T20,
                          "T20Runs": T20Runs,
                          "T20Avg": T20Avg,
                          "T20SR": T20SR,
                        });
                      }
                      // Clear the text fields
                      _playernameController.text = '';
                      _T20Controller.text = '';
                      _T20RunsController.text = '';
                      _T20AvgController.text = '';
                      _T20SRController.text = '';

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

  Future<void> _createOrUpdateTEST(
      [DocumentSnapshot? documentSnapshot3]) async {
    String action = 'create';
    if (documentSnapshot3 != null) {
      action = 'update';
      _playernameController.text = documentSnapshot3['PlayerName'];
      _TestController.text = documentSnapshot3['Test'];
      _TestRunsController.text = documentSnapshot3['TestRuns'];
      _TestAvgController.text = documentSnapshot3['TestAvg'];
      _TestSRController.text = documentSnapshot3['TestSR'];
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
                  controller: _playernameController,
                  decoration: const InputDecoration(labelText: 'Player Name'),
                ),
                TextField(
                  controller: _TestController,
                  decoration: const InputDecoration(
                    labelText: 'Test Matches',
                  ),
                ),
                TextField(
                  controller: _TestRunsController,
                  decoration: const InputDecoration(
                    labelText: 'Runs',
                  ),
                ),
                TextField(
                  controller: _TestAvgController,
                  decoration: const InputDecoration(
                    labelText: 'Average',
                  ),
                ),
                TextField(
                  controller: _TestSRController,
                  decoration: const InputDecoration(
                    labelText: 'Strike Rate',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? PlayerName = _playernameController.text;
                    final String? Test = _TestController.text;
                    final String? TestRuns = _T20RunsController.text;
                    final String? TestAvg = _TestAvgController.text;
                    final String? TestSR = _TestSRController.text;
                    //  double.tryParse(_priceController.text);
                    if (PlayerName != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _playerss.add({
                          "PlayerName": PlayerName,
                          "Test": Test,
                          "TestRuns": TestRuns,
                          "TestAvg": TestAvg,
                          "TestSR": TestSR,
                        });
                      }
                      if (action == 'update') {
                        // Update the product
                        await _playerss.doc(documentSnapshot3!.id).update({
                          "PlayerName": PlayerName,
                          "Test": Test,
                          "TestRuns": TestRuns,
                          "TestAvg": TestAvg,
                          "TestSR": TestSR,
                        });
                      }
                      // Clear the text fields
                      _playernameController.text = '';
                      _TestController.text = '';
                      _TestRunsController.text = '';
                      _TestAvgController.text = '';
                      _TestSRController.text = '';

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
                          title: Text(documentSnapshot3['Description']),
                          trailing: SizedBox(
                            width: 70,
                            child: Row(
                              children: [
                                // Press this button to edit a single product
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _createOrUpdateDes(documentSnapshot3)),
                                // This icon button is used to delete a single product
                              ],
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
                            '      '
                            'Runs'
                            '      '
                            'AVG'
                            '      '
                            'SR'),
                        subtitle: Text(documentSnapshot3['ODI'] +
                            "                          " +
                            documentSnapshot3['ODIRuns'] +
                            "       " +
                            documentSnapshot3['ODIAvg'] +
                            "       " +
                            documentSnapshot3['ODISR']),
                        trailing: SizedBox(
                          width: 70,
                          child: Row(
                            children: [
                              // Press this button to edit a single product
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _createOrUpdateODI(documentSnapshot3)),
                              // This icon button is used to delete a single product
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 7,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('T20 Matches'
                            '      '
                            'Runs'
                            '      '
                            'AVG'
                            '      '
                            'SR'),
                        subtitle: Text(documentSnapshot3['T20'] +
                            "                             " +
                            documentSnapshot3['T20Runs'] +
                            "         " +
                            documentSnapshot3['T20Avg'] +
                            "      " +
                            documentSnapshot3['T20SR']),
                        trailing: SizedBox(
                          width: 70,
                          child: Row(
                            children: [
                              // Press this button to edit a single product
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _createOrUpdateT20(documentSnapshot3)),
                              // This icon button is used to delete a single product
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 7,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('Test Matches'
                            '      '
                            'Runs'
                            '      '
                            'AVG'
                            '      '
                            'SR'),
                        subtitle: Text(documentSnapshot3['Test'] +
                            "                              " +
                            documentSnapshot3['TestRuns'] +
                            "         " +
                            documentSnapshot3['TestAvg'] +
                            "       " +
                            documentSnapshot3['TestSR']),
                        trailing: SizedBox(
                          width: 70,
                          child: Row(
                            children: [
                              // Press this button to edit a single product
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _createOrUpdateTEST(documentSnapshot3)),
                              // This icon button is used to delete a single product
                            ],
                          ),
                        ),
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
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdateDes(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
