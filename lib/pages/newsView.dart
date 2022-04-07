import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('news');

class NewsView extends StatefulWidget {
  const NewsView({Key? key}) : super(key: key);

  @override
  _NewsView createState() => _NewsView();
}

class _NewsView extends State<NewsView> {

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('news').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return ListView(
              children: snapshot.data!.docs.map((doc) {
              final Text title =
                            Text((doc.data() as dynamic)['title']);
                return Card(
                  child: ListTile(
                    title: title,
                    subtitle: Text((doc.data() as dynamic)['description']),
                  ),
                );
              }).toList(),
            );
        },
      ),
      //),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context, builder: (context) => const NewsDialog());
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewsDialog extends StatefulWidget {
  const NewsDialog({Key? key}) : super(key: key);

  @override
  State<NewsDialog> createState() => _NewsDialogState();
}

class _NewsDialogState extends State<NewsDialog> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _descontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _titlecontroller.dispose();
    _descontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _titlecontroller,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                hintText: 'Enter your title here',
                filled: true,
              ),
              textInputAction: TextInputAction.done,
              validator: (String? text) {
                if (text == null || text.isEmpty) {
                  return 'Please enter a value';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descontroller,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Enter your news here',
                filled: true,
              ),
              maxLines: 5,
              maxLength: 4096,
              textInputAction: TextInputAction.done,
              validator: (String? text) {
                if (text == null || text.isEmpty) {
                  return 'Please enter a value';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Post'),
          onPressed: () async {
            // Only if the input form is valid (the user has entered text)
            if (_formKey.currentState!.validate()) {
              // We will use this var to show the result
              // of this operation to the user
              String message;
              //String description;

              try {
                // Get a reference to the `news` collection
                final collection =
                    FirebaseFirestore.instance.collection('news');

                // Write the news title and description
                await collection.doc().set({
                  'title': _titlecontroller.text,
                  'description':  _descontroller.text,
                  'time': FieldValue.serverTimestamp(),
                });

                message = 'News added successfully';
              } catch (e) {
                message = 'Error when posting news';
              }

              // Show a snackbar with the result
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}

String? userUid;

Future<void> addNews({
  required String title,
  required String description,
}) async {
  DocumentReference documentReferencer =
      _mainCollection.doc(userUid).collection('news').doc();

  Map<String, dynamic> data = <String, dynamic>{
    "title": title,
    "description": description,
  };

  await documentReferencer
      .set(data)
      .whenComplete(() => log("News added to the database"))
      .catchError((e) => log(e));
}

Future<void> updateNews({
  required String title,
  required String description,
  required String docId,
}) async {
  DocumentReference documentReferencer =
      _mainCollection.doc(userUid).collection('news').doc(docId);

  Map<String, dynamic> data = <String, dynamic>{
    "title": title,
    "description": description,
  };

  await documentReferencer
      .update(data)
      .whenComplete(() => log("News updated in the database"))
      .catchError((e) => log(e));
}

Stream<QuerySnapshot> readNews() {
  CollectionReference notesItemCollection =
      _mainCollection.doc(userUid).collection('news');

  return notesItemCollection.snapshots();
}

Future<void> deleteNews({
  required String docId,
}) async {
  DocumentReference documentReferencer =
      _mainCollection.doc(userUid).collection('news').doc(docId);

  await documentReferencer
      .delete()
      .whenComplete(() => log('News deleted from the database'))
      .catchError((e) => log(e));
}
