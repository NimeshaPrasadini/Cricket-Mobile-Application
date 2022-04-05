import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricketapp/pages/Admin/adminMenu.dart';
import 'package:cricketapp/pages/teamPage.dart';

import 'package:flutter/material.dart';

class TeamView extends StatefulWidget {
  const TeamView({Key? key}) : super(key: key);

  @override
  _TeamView createState() => _TeamView();
}

class _TeamView extends State<TeamView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final CollectionReference _teamss =
      FirebaseFirestore.instance.collection('teams');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
        actions: [
          IconButton(
              icon: Icon(Icons.person_outlined),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AdminMenu()));
              })
        ],
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
                          builder: (context) => TeamPage(name)));
                    },
                    title: name,
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
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
    );
  }
}
