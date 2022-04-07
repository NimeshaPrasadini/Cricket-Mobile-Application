import 'package:cricketapp/pages/Admin/playerInfo.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../service/storage_service.dart';

class PlayerMng extends StatefulWidget {
  final Text name;
  const PlayerMng(this.name, {Key? key}) : super(key: key);

  @override
  State<PlayerMng> createState() => _PlayerMngState();
}

class _PlayerMngState extends State<PlayerMng> {
  var fileName;
  var path;

  var Collection = 'Players';
  final Storage storage = Storage();
  final TextEditingController _playernameController = TextEditingController();
  final TextEditingController _countryNameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _ImageController = TextEditingController();
  final TextEditingController _DesController = TextEditingController();
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
  final TextEditingController _countryDesController = TextEditingController();
  final CollectionReference _teamss =
      FirebaseFirestore.instance.collection('teams');
  final CollectionReference _playerss =
      FirebaseFirestore.instance.collection('players');

  Future<void> _createOrUpdateDetail(
      [DocumentSnapshot? documentSnapshot1]) async {
    String action = 'create';
    if (documentSnapshot1 != null) {
      action = 'update';

      _countryDesController.text = documentSnapshot1['Detail'].toString();
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
                  controller: _countryDesController,
                  decoration: const InputDecoration(labelText: 'Details'),
                ),
                /* TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),*/
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? countryDes = _countryDesController.text;
                    // final double? price =
                    //  double.tryParse(_priceController.text);
                    if (countryDes != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _teamss.add({"Detail": countryDes});
                      }

                      if (action == 'update') {
                        // Update the product
                        await _teamss
                            .doc(documentSnapshot1!.id)
                            .update({"Detail": countryDes});
                      }

                      // Clear the text fields

                      _countryDesController.text = '';
                      // _priceController.text = '';

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

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot2]) async {
    String action = 'create';

    if (documentSnapshot2 != null) {
      action = 'update';
      _playernameController.text = documentSnapshot2['PlayerName'];
      _countryNameController.text = documentSnapshot2['countryName'];
      _typeController.text = documentSnapshot2['type'];
      _ImageController.text = documentSnapshot2['Image'];
      _DesController.text = documentSnapshot2['Description'];
      _ODIController.text = documentSnapshot2['ODI'];
      _ODIRunsController.text = documentSnapshot2['ODIRuns'];
      _ODIAvgController.text = documentSnapshot2['ODIAvg'];
      _ODISRController.text = documentSnapshot2['ODISR'];
      _T20Controller.text = documentSnapshot2['T20'];
      _T20RunsController.text = documentSnapshot2['T20Runs'];
      _T20AvgController.text = documentSnapshot2['T20Avg'];
      _T20SRController.text = documentSnapshot2['T20SR'];
      _TestController.text = documentSnapshot2['Test'];
      _TestRunsController.text = documentSnapshot2['TestRuns'];
      _TestAvgController.text = documentSnapshot2['TestAvg'];
      _TestSRController.text = documentSnapshot2['TestSR'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 2,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _playernameController,
                  decoration: const InputDecoration(labelText: 'Player Name'),
                ),
                TextField(
                  controller: _countryNameController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                  ),
                ),
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      final results = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg'],
                      );
                      if (results == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No file selected'),
                          ),
                        );
                        return null;
                      }
                      path = results.files.single.path!;
                      fileName = results.files.single.name;

                      _ImageController.text = fileName.toString();
                      // _countryNameController.text = widget.name.data.toString();
                    },
                    child: const Icon(Icons.camera_alt)),
                TextField(
                  controller: _ImageController,
                  decoration: const InputDecoration(
                    labelText: 'Image',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () => _createOrUpdateDes(),
                        child: const Text('Detail')),
                    Spacer(
                      flex: 1,
                    ),
                    ElevatedButton(
                        onPressed: () => _createOrUpdateODI(),
                        child: const Text('ODI')),
                    Spacer(
                      flex: 1,
                    ),
                    ElevatedButton(
                        onPressed: () => _createOrUpdateT20(),
                        child: const Text('T20')),
                    Spacer(
                      flex: 1,
                    ),
                    ElevatedButton(
                        onPressed: () => _createOrUpdateTEST(),
                        child: const Text('Test')),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text(action == 'create' ? 'Create' : 'Update'),
                        onPressed: () async {
                          final String? PlayerName = _playernameController.text;

                          final String? countryName =
                              _countryNameController.text;
                          _countryNameController.text =
                              widget.name.data.toString();
                          final String? type = _typeController.text;
                          _ImageController.text = fileName.toString();

                          final String? Img = _ImageController.text;
                          final String? Des = _DesController.text;
                          final String? ODI = _ODIController.text;
                          final String? ODIRuns = _ODIRunsController.text;
                          final String? ODIAverage = _ODIAvgController.text;
                          final String? ODISR = _ODISRController.text;
                          final String? T20 = _T20Controller.text;
                          final String? T20Runs = _T20RunsController.text;
                          final String? T20Avg = _T20AvgController.text;
                          final String? T20SR = _T20SRController.text;
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
                                "countryName": countryName,
                                "type": type,
                                "Image": Img,
                                "Description": Des,
                                "ODI": ODI,
                                "ODIRuns": ODIRuns,
                                "ODIAvg": ODIAverage,
                                "ODISR": ODISR,
                                "T20": T20,
                                "T20Runs": T20Runs,
                                "T20Avg": T20Avg,
                                "T20SR": T20SR,
                                "Test": Test,
                                "TestRuns": TestRuns,
                                "TestAvg": TestAvg,
                                "TestSR": TestSR,
                              });
                            }

                            if (action == 'update') {
                              // Update the product
                              await _playerss
                                  .doc(documentSnapshot2!.id)
                                  .update({
                                "PlayerName": PlayerName,
                                "countryName": countryName,
                                "type": type,
                                "Image": Img,
                                "Description": Des,
                                "ODI": ODI,
                                "ODIRuns": ODIRuns,
                                "ODIAvg": ODIAverage,
                                "ODISR": ODISR,
                                "T20": T20,
                                "T20Runs": T20Runs,
                                "T20Avg": T20Avg,
                                "T20SR": T20SR,
                                "Test": Test,
                                "TestRuns": TestRuns,
                                "TestAvg": TestAvg,
                                "TestSR": TestSR,
                              });
                            }

                            storage
                                .uploadImage(path, fileName)
                                .then((value) => print('done'));

                            // Clear the text fields
                            _playernameController.text = '';
                            _countryNameController.text = '';
                            _typeController.text = '';
                            _ImageController.text = '';
                            _DesController.text = '';
                            _ODIController.text = '';
                            _ODIRunsController.text = '';
                            _ODIAvgController.text = '';
                            _ODISRController.text = '';
                            _T20Controller.text = '';
                            _T20RunsController.text = '';
                            _T20AvgController.text = '';
                            _T20SRController.text = '';
                            _TestController.text = '';
                            _TestRunsController.text = '';
                            _TestAvgController.text = '';
                            _TestSRController.text = '';

                            // Hide the bottom sheet
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ])
              ],
            ),
          );
        });
  }

  Future<void> _createOrUpdateDes([DocumentSnapshot? documentSnapshot2]) async {
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
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Back')),

                //  double.tryParse(_priceController.text);
              ],
            ),
          );
        });
  }

  Future<void> _createOrUpdateODI([DocumentSnapshot? documentSnapshot2]) async {
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
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Back')),
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> _createOrUpdateT20([DocumentSnapshot? documentSnapshot3]) async {
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
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Back')),
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> _createOrUpdateTEST(
      [DocumentSnapshot? documentSnapshot3]) async {
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
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Back')),
                  ],
                )
              ],
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deletePlayer(String teamId) async {
    await _playerss.doc(teamId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a player')));
  }

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
                                    trailing: SizedBox(
                                      width: 70,
                                      child: Row(
                                        children: [
                                          // Press this button to edit a single product
                                          IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () =>
                                                  _createOrUpdateDetail(
                                                      documentSnapshot1)),
                                          // This icon button is used to delete a single product
                                        ],
                                      ),
                                    ),
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
                                                    PlayerInfo(plname)));
                                      },
                                      title: plname,
                                      subtitle: Text(documentSnapshot2['type']),
                                      trailing: SizedBox(
                                        width: 100,
                                        child: Row(
                                          children: [
                                            // Press this button to edit a single product
                                            IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () =>
                                                    _createOrUpdate(
                                                        documentSnapshot2)),
                                            // This icon button is used to delete a single product
                                            IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () => _deletePlayer(
                                                    documentSnapshot2.id)),
                                          ],
                                        ),
                                      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
