import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
//import 'package:flutter/foundation.dart';
import 'dart:io';

class CommentView extends StatefulWidget {
  const CommentView({Key? key}) : super(key: key);

  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {

  // text fields' controllers
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();


  final CollectionReference _newss =
      FirebaseFirestore.instance.collection('comments');

  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a news if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing comment
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _messageController.text = documentSnapshot['message'];
      _usernameController.text = documentSnapshot['userName'];
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
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'User Name',
                    hintText: 'Enter your name',
                   filled: true,  
                  ),   
                ),
                TextField(
                  keyboardType:
                      TextInputType.multiline,
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                    hintText: 'Enter your comment',
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
                    final String? message = _messageController.text;
                    final String? userName = _usernameController.text;
                    if (message != null && userName != null) {
                      if (action == 'create') {
                        // Persist a new comment to Firestore
                        await _newss.add({"message": message, "userName": userName, "time": FieldValue.serverTimestamp()});
                      }

                      if (action == 'update') {
                        // Update the comment
                        await _newss
                            .doc(documentSnapshot!.id)
                            .update({"message": message, "userName": userName, "time": FieldValue.serverTimestamp()});
                      }

                      // Clear the text fields
                      _messageController.text = '';
                      _usernameController.text = '';

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

  // Deleteing a comment by id
  Future<void> _deleteNews(String newsId) async {
    await _newss.doc(newsId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted the comment')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      // Using StreamBuilder to display all comments from Firestore in real-time
      body: StreamBuilder(
        stream: _newss.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                final Timestamp timestamp = documentSnapshot['time'] as Timestamp;
                final DateTime dateTime = timestamp.toDate();
                final String dateString = dateTime.toString();
                bool isFavourite = true;
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 10,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(documentSnapshot['userName'] + '  \n' + dateString),
                    title: Text(documentSnapshot['message']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single comment
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // This icon button is used to delete a single comment
                          // IconButton(
                          //     icon: const Icon(Icons.delete),
                          //     onPressed: () =>
                          //         _deleteNews(documentSnapshot.id)),                     
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: isFavourite ? Colors.grey : Colors.blueGrey
                            ),
                            onPressed: ()
                            {
                                setState(()
                                {
                                  isFavourite = !isFavourite;
                                });
                            }
                          ),

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
      // Add new comment
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
