import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricketapp/pages/Admin/playerMng.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../service/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class TeamAdd extends StatefulWidget {
  const TeamAdd({Key? key}) : super(key: key);

  @override
  _TeamAddState createState() => _TeamAddState();
}

class _TeamAddState extends State<TeamAdd> {
  var fileName;
  var path;
  var Collection = 'Teams';

  final Storage storage = Storage();
  final TextEditingController _countrynameController = TextEditingController();
  final TextEditingController _countryImageController = TextEditingController();
  final TextEditingController _countryDesController = TextEditingController();

  final CollectionReference _teamss =
      FirebaseFirestore.instance.collection('teams');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot1]) async {
    String action = 'create';
    bool _validate = false;
    if (documentSnapshot1 != null) {
      action = 'update';
      _countrynameController.text = documentSnapshot1['countryName'];
      _countryImageController.text = documentSnapshot1['img'].toString();
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
                  controller: _countrynameController,
                  decoration: InputDecoration(
                    labelText: 'CountryName',
                    errorText: _validate ? 'Value Can\'t Be Empty' : null,
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

                      _countryImageController.text = fileName.toString();
                    },
                    child: const Icon(Icons.camera_alt)),
                TextField(
                  controller: _countryImageController,
                  decoration: InputDecoration(
                    labelText: 'Image',
                    errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  ),
                ),
                TextField(
                  controller: _countryDesController,
                  decoration: InputDecoration(
                    labelText: 'Details',
                    errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  ),
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text(action == 'create' ? 'Create' : 'Update'),
                        onPressed: () async {
                          setState(() {
                            _countrynameController.text.isEmpty
                                ? _validate = true
                                : _validate = false;
                            _countryImageController.text.isEmpty
                                ? _validate = true
                                : _validate = false;
                            _countryDesController.text.isEmpty
                                ? _validate = true
                                : _validate = false;
                          });

                          final String? countryName =
                              _countrynameController.text;
                          _countryImageController.text = fileName.toString();
                          final String? countryImage =
                              _countryImageController.text;
                          final String? countryDes = _countryDesController.text;
                          // final double? price =
                          //  double.tryParse(_priceController.text);
                          if (countryName == ' ' ||
                              countryImage == null ||
                              countryDes == ' ') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('All fields must be filled')));
                          } else {
                            if (countryName != null) {
                              if (action == 'create') {
                                // Persist a new product to Firestore
                                await _teamss.add({
                                  "countryName": countryName,
                                  "img": countryImage,
                                  "Detail": countryDes
                                });
                              }

                              if (action == 'update') {
                                // Update the product
                                await _teamss
                                    .doc(documentSnapshot1!.id)
                                    .update({
                                  "countryName": countryName,
                                  "img": countryImage,
                                  "Detail": countryDes
                                });
                              }
                              storage
                                  .uploadImage(path, fileName)
                                  .then((value) => print('done'));

                              // Clear the text fields
                              _countrynameController.text = '';
                              _countryImageController.text = '';
                              _countryDesController.text = '';
                              // _priceController.text = '';

                              // Hide the bottom sheet
                              Navigator.of(context).pop();
                            }
                          }
                        },
                      )
                    ]),
              ],
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deleteTeam(String teamId) async {
    await _teamss.doc(teamId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted a team')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Country'),
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
                final Text name = Text(documentSnapshot1['countryName']);
                final Text img = Text(documentSnapshot1['img']);
                return Card(
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
                                builder: (context) => PlayerMng(name)));
                          },
                          title: name,

                          //subtitle: Text(documentSnapshot['price'].toString()),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                // Press this button to edit a single product
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _createOrUpdate(documentSnapshot1)),
                                // This icon button is used to delete a single product
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () =>
                                        _deleteTeam(documentSnapshot1.id)),
                              ],
                            ),
                          ),
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
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
