//import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as path;


class NewsView extends StatefulWidget {
  const NewsView({Key? key}) : super(key: key);

  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  var fileName;
  var path;
  var Collection = 'News';
  final Storage storage = Storage();
  // text fields' controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _newsImageController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  //FirebaseStorage storage = FirebaseStorage.instance;

  final CollectionReference _newss =
      FirebaseFirestore.instance.collection('news');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a news if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing news
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _titleController.text = documentSnapshot['title'];
      _newsImageController.text = documentSnapshot['image'].toString();
      _descController.text = documentSnapshot['description'];
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
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'News Title'),
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

                      _newsImageController.text = fileName.toString();
                    },
                    child: const Icon(Icons.camera_alt)),
                TextField(
                  controller: _newsImageController,
                  decoration: const InputDecoration(labelText: 'image'),
                ),
                TextField(
                  keyboardType:
                      TextInputType.multiline,
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter your news here',
                   filled: true,  
                  ),
                  maxLines: 5,
                  maxLength: 4096,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Post' : 'Update'),
                  onPressed: () async {
                    final String? title = _titleController.text;
                    _newsImageController.text = fileName.toString();
                    final String? newsImage = _newsImageController.text;
                    final String? description = _descController.text;
                    if (title != null && description != null) {
                      if (action == 'create') {
                        // Persist a new news to Firestore
                        await _newss.add({"title": title, "image": newsImage, "description": description});
                      }

                      if (action == 'update') {
                        // Update the news
                        await _newss
                            .doc(documentSnapshot!.id)
                            .update({"title": title, "image": newsImage, "description": description});
                      }
                      storage
                          .uploadNewsImage(path, fileName)
                          .then((value) => print('done'));

                      // Clear the text fields
                      _titleController.text = '';
                      _newsImageController.text = '';
                      _descController.text = '';

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

  // Deleteing a news by id
  Future<void> _deleteNews(String newsId) async {
    await _newss.doc(newsId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted the news')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      // Using StreamBuilder to display all news from Firestore in real-time
      body: StreamBuilder(
        stream: _newss.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                //final Text name = Text(documentSnapshot['countryName']);
                final Text image = Text(documentSnapshot['image']);
                return Card(
                    //margin: const EdgeInsets.all(10),
                    elevation: 10,
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: storage.downloadURL(image.data.toString()),
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
                          title: Text(documentSnapshot['title']),
                          subtitle: Text(documentSnapshot['description']),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                // Press this button to edit a single news
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _createOrUpdate(documentSnapshot)),
                                // This icon button is used to delete a single news
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () =>
                                        _deleteNews(documentSnapshot.id)),
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
      // Add new news
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
