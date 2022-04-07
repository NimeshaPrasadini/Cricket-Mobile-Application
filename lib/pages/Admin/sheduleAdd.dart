import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricketapp/pages/Admin/MatchEdit.dart';
import 'package:cricketapp/pages/Admin/playerMng.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../service/storage_service.dart';

class SheduleAdd extends StatefulWidget {
  const SheduleAdd({Key? key}) : super(key: key);

  @override
  _SheduleAdd createState() => _SheduleAdd();
}

class _SheduleAdd extends State<SheduleAdd> {
  var Collection = 'Teams';
  var Country1 = Text('aa');
  var Country2 = Text('bb');
  String selectedValue = 'Upcoming';
  List<String> items = [
    'Upcoming',
    'Finished',
  ];

  String? selectedCountry1;
  String? selectedCountry2;
  List<String> countries = [
    'Sri Lanka',
    'India',
    'Australia',
    'Newzeland',
    'England',
    'SouthAfrica',
    'Bangladesh',
    'Pakistan'
  ];
  final Storage storage = Storage();
  TimeOfDay selectedTime = TimeOfDay.now();
  // text fields' controllers
  final TextEditingController _country1Controller = TextEditingController();
  final TextEditingController _country2Controller = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  final TextEditingController _resultController = TextEditingController();
  final TextEditingController _country1ScoreController =
      TextEditingController();
  final TextEditingController _country2ScoreController =
      TextEditingController();

  final CollectionReference _sheduless =
      FirebaseFirestore.instance.collection('shedules');
  final CollectionReference _teamss =
      FirebaseFirestore.instance.collection('teams');
  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
  Future<DateTime?> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2019),
        lastDate: DateTime(2050),
        initialDate: DateTime(2022));
    if (picked != null) {
      return picked;
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot2]) async {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      child: TextField(
                        controller: _statusController,
                        decoration: const InputDecoration(labelText: 'Status'),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        itemPadding:
                            EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        hint: Text(
                          'Select Status',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                            _statusController.text = selectedValue.toString();
                          });
                        },
                        buttonHeight: 40,
                        buttonWidth: 140,
                        itemHeight: 40,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _resultController,
                  decoration: const InputDecoration(
                    labelText: 'Result',
                  ),
                ),
                TextField(
                  controller: _country1ScoreController,
                  decoration: const InputDecoration(
                    labelText: 'Team 1 Score',
                  ),
                ),
                TextField(
                  controller: _country2ScoreController,
                  decoration: const InputDecoration(
                    labelText: 'Team 2 Score',
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

  Future<void> _createOrUpdateShedule(
      [DocumentSnapshot? documentSnapshot4]) async {
    String action = 'create';
    if (documentSnapshot4 != null) {
      action = 'update';
      _country1Controller.text = documentSnapshot4['country1'];
      _country2Controller.text = documentSnapshot4['country2'];
      _dateController.text = documentSnapshot4['date'];
      _timeController.text = documentSnapshot4['time'];
      _venueController.text = documentSnapshot4['venue'];

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      child: TextField(
                        controller: _country1Controller,
                        decoration:
                            const InputDecoration(labelText: 'Country 1'),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        itemPadding:
                            EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        hint: Text(
                          'Select Country',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: countries
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedCountry1,
                        onChanged: (value) {
                          setState(() {
                            selectedCountry1 = value as String;
                            _country1Controller.text =
                                selectedCountry1.toString();
                          });
                        },
                        buttonHeight: 40,
                        buttonWidth: 140,
                        itemHeight: 40,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      child: TextField(
                        controller: _country2Controller,
                        decoration:
                            const InputDecoration(labelText: 'Country 2'),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        itemPadding:
                            EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        hint: Text(
                          'Select Country',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: countries
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedCountry2,
                        onChanged: (value) {
                          setState(() {
                            selectedCountry2 = value as String;
                            _country2Controller.text =
                                selectedCountry2.toString();
                          });
                        },
                        buttonHeight: 40,
                        buttonWidth: 140,
                        itemHeight: 40,
                      ),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      _pickDate(context).then((value) {
                        if (value != null) {
                          _dateController.text = value.toString();
                          _dateController.text =
                              formatDate(value, [MM, ' ', d, ', ', yyyy]);
                        }
                      });
                    },
                    icon: Icon(Icons.calendar_today)),
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _selectTime(context);
                    selectedTime.format(context);
                    _timeController.text = (selectedTime.hour).toString() +
                        ':' +
                        (selectedTime.minute).toString();
                  },
                  child: Text("Choose Time"),
                ),
                TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                ),
                TextField(
                  controller: _venueController,
                  decoration: const InputDecoration(labelText: 'Venue'),
                ),
                /* TextField(
                  keyboardType:
                      const InputDecoration(decimal: true),
                  controller: _country2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Country 2',
                  ),
                ),*/
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  ElevatedButton(
                      onPressed: () => _createOrUpdate(),
                      child: const Text('Result')),
                ]),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? country1 = _country1Controller.text;

                    final String? country2 = _country2Controller.text;

                    final String? date = _dateController.text;
                    final String? time = _timeController.text;
                    final String? venue = _venueController.text;
                    final String? status = _statusController.text;
                    final String? result = _resultController.text;
                    final String? cn1Score = _country1ScoreController.text;
                    final String? cn2Score = _country2ScoreController.text;

                    // final double? price =
                    //  double.tryParse(_priceController.text);
                    if (country1 != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _sheduless.add({
                          "country1": country1,
                          "country2": country2,
                          "date": date,
                          "time": time,
                          "venue": venue,
                          "status": status,
                          "result": result,
                          "country1Score": cn1Score,
                          "country2Score": cn2Score
                        });
                      }

                      if (action == 'update') {
                        // Update the product
                        await _sheduless.doc(documentSnapshot4!.id).update({
                          "country1": country1,
                          "country2": country2,
                          "date": date,
                          "time": time,
                          "venue": venue,
                          "status": status,
                          "result": result,
                          "country1Score": cn1Score,
                          "country2Score": cn2Score
                        });
                      }

                      // Clear the text fields
                      _country1Controller.text = '';
                      _country2Controller.text = '';
                      _dateController.text = '';
                      _timeController.text = '';
                      _venueController.text = '';
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

  // Deleteing a product by id
  Future<void> _deleteTeam(String sheduleId) async {
    await _sheduless.doc(sheduleId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a shedule')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Shedule'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: SafeArea(
        child: StreamBuilder(
          stream: _sheduless.where('status', isEqualTo: '').snapshots(),
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
                  final Text date = Text(documentSnapshot4['date']);
                  final Text vn = Text(documentSnapshot4['venue']);
                  final Text match = Text(documentSnapshot4['time']);
                  return GestureDetector(
                    /*
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Container(
                      width: 400,
                      height: 100,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Card(
                                elevation: 20,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                margin: EdgeInsets.all(10),
                                //child: Flexible(
                                /*  child: ListTile(
                                    onTap: () {},
                                    title: vn,
                                    //contentPadding: EdgeInsets.symmetric(horizontal: 150),

                                    //subtitle: Text(documentSnapshot['price'].toString()),
                                  ),*/
                                //),
                              ),
                            ],
                          ),
                          Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            margin: const EdgeInsets.all(10),
                            /*  child: ListTile(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => PlayerMng(name)));
                              },

                              title: cn1,
                              // contentPadding: EdgeInsets.symmetric(horizontal: 150),

                              //subtitle: Text(documentSnapshot['price'].toString()),
                            ),*/
                          ),
                          /* Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        onTap: () {},
                        title: cn2,
                        contentPadding: EdgeInsets.symmetric(horizontal: 150),

                        //subtitle: Text(documentSnapshot['price'].toString()),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        onTap: () {},
                        title: date,

                        //subtitle: Text(documentSnapshot['price'].toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              // Press this button to edit a single product
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _createOrUpdateShedule(
                                      documentSnapshot4)),
                              // This icon button is used to delete a single product
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _deleteTeam(documentSnapshot4.id)),
                            ],
                          ),
                        ),
                      ),
                    ),*/
                        ],
                      ),
                    ),
                    */
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MatchEdit(match)));
                    },
                    //onTap: () => FocusScope.of(context).unfocus(),
                    child: Container(
                      width: 420,
                      height: 170,
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
                                    return Container(
                                        width: 140,
                                        height: 100,
                                        child: ListView.builder(

                                            //var userDocument = streamSnapshot.data;
                                            itemCount: streamSnapshot
                                                .data!.docs.length,
                                            itemBuilder: (context, index) {
                                              final DocumentSnapshot
                                                  documentSnapshot1 =
                                                  streamSnapshot
                                                      .data!.docs[index];
                                              final Text Countryimg = Text(
                                                  documentSnapshot1['img']);
                                              return FutureBuilder(
                                                  future: storage.downloadURL(
                                                      Countryimg.data
                                                          .toString()),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<String>
                                                              snapshot) {
                                                    if (snapshot.connectionState ==
                                                            ConnectionState
                                                                .done &&
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
                                            }));
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
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      child: Text(documentSnapshot4['venue']),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: const [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          50, 0, 0, 0),
                                      child: Text('VS'),
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
                                              0, 0, 0, 0),
                                      child: Text(documentSnapshot4['date']),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              40, 6, 0, 0),
                                      child: Text(documentSnapshot4['time']),
                                    ),
                                  ],
                                ),
                                Row(
                                  //padding: const EdgeInsets.symmetric(vertical: 20),
                                  children: [
                                    IconButton(
                                        iconSize: 20,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _createOrUpdateShedule(
                                            documentSnapshot4)),
                                    // This icon button is used to delete a single product
                                    IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () =>
                                            _deleteTeam(documentSnapshot4.id)),
                                  ],
                                )
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
                                    return Container(
                                        width: 140,
                                        height: 100,
                                        child: ListView.builder(
                                            //var userDocument = streamSnapshot.data;
                                            itemCount: streamSnapshot
                                                .data!.docs.length,
                                            itemBuilder: (context, index) {
                                              final DocumentSnapshot
                                                  documentSnapshot1 =
                                                  streamSnapshot
                                                      .data!.docs[index];
                                              final Text Countryimg = Text(
                                                  documentSnapshot1['img']);
                                              return FutureBuilder(
                                                  future: storage.downloadURL(
                                                      Countryimg.data
                                                          .toString()),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<String>
                                                              snapshot) {
                                                    if (snapshot.connectionState ==
                                                            ConnectionState
                                                                .done &&
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
                                            }));
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
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdateShedule(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
