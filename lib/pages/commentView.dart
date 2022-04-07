import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentView extends StatelessWidget {
  //final Text name;
  CommentView({Key? key}) : super(key: key);

  //final CollectionReference _comments =
      //FirebaseFirestore.instance.collection('comments');
    final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('comments').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                //final Text name = Text(doc.data()['userName']);
                //final Text message = Text(documentSnapshot2['message']);
                //final Text time = Text(documentSnapshot2['time']);
                return Card(
                  child: ListTile(
                    title: Text((doc.data() as dynamic)['message']),
                    //subtitle: Text((doc.data() as dynamic)['name']),
                    //: Text((doc.data() as dynamic)['time']),
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
              context: context, builder: (context) => const FeedbackDialog());
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({Key? key}) : super(key: key);

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: 
          //children: <Widget>[
            // TextFormField(
            //   controller: _controller,
            //   keyboardType: TextInputType.name,
            //   decoration: const InputDecoration(
            //     hintText: 'Enter your name here',
            //     filled: true,
            //   ),
            //   // maxLines: 5,
            //   maxLength: 4096,
            //   textInputAction: TextInputAction.done,
            //   validator: (String? text) {
            //     if (text == null || text.isEmpty) {
            //       return 'Please enter a value';
            //     }
            //     return null;
            //   },
            // ),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Enter your comment here',
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
            //),
          //],
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

              try {
                // Get a reference to the `feedback` collection
                final collection =
                    FirebaseFirestore.instance.collection('comments');

                // Write the server's timestamp and the user's feedback
                await collection.doc().set({
                  'message': _controller.text,
                  'time': FieldValue.serverTimestamp(),
                });

                message = 'Comment added successfully';
              } catch (e) {
                message = 'Error when posting comment';
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

