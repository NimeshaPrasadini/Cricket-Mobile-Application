import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricketapp/pages/Admin/playerMng.dart';
import 'package:flutter/material.dart';

class TeamAdd extends StatefulWidget {
  const TeamAdd({Key? key}) : super(key: key);

  @override
  _TeamAddState createState() => _TeamAddState();
}

class _TeamAddState extends State<TeamAdd> {
  // text fields' controllers
  final TextEditingController _countrynameController = TextEditingController();
  //final TextEditingController _priceController = TextEditingController();

  final CollectionReference _teamss =
      FirebaseFirestore.instance.collection('teams');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot1]) async {
    String action = 'create';
    if (documentSnapshot1 != null) {
      action = 'update';
      _countrynameController.text = documentSnapshot1['countryName'];
      //_priceController.text = documentSnapshot['price'].toString();
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
                  decoration: const InputDecoration(labelText: 'CountryName'),
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
                    final String? countryName = _countrynameController.text;
                    // final double? price =
                    //  double.tryParse(_priceController.text);
                    if (countryName != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _teamss.add({"countryName": countryName});
                      }

                      if (action == 'update') {
                        // Update the product
                        await _teamss
                            .doc(documentSnapshot1!.id)
                            .update({"countryName": countryName});
                      }

                      // Clear the text fields
                      _countrynameController.text = '';
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
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
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
                );
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
