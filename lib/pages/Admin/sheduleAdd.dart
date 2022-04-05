import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricketapp/pages/Admin/playerMng.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class SheduleAdd extends StatefulWidget {
  const SheduleAdd({Key? key}) : super(key: key);

  @override
  _SheduleAdd createState() => _SheduleAdd();
}

class _SheduleAdd extends State<SheduleAdd> {

  TimeOfDay selectedTime = TimeOfDay.now();
  // text fields' controllers
  final TextEditingController _country1Controller = TextEditingController();
  final TextEditingController _country2Controller = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
 final TextEditingController _timeController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();

  final CollectionReference _sheduless =
      FirebaseFirestore.instance.collection('shedules');
  // This function is triggered when the floatting button or one of the edit buttons is pressed
  // Adding a product if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing product
Future<DateTime?> _pickDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(context: context, firstDate: DateTime(2019), lastDate: DateTime(2050), initialDate: DateTime(2022));
if(picked != null) {
  return picked;
}
}

_selectTime(BuildContext context) async {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial,
 
      );
      if(timeOfDay != null )
        {
          setState(() {
            selectedTime = timeOfDay;
            

          });
        }
  }
  


  Future<void> _createOrUpdateShedule([DocumentSnapshot? documentSnapshot4]) async {
    String action = 'create';
    if (documentSnapshot4 != null) {
      action = 'update';
      _country1Controller.text = documentSnapshot4['country1'];
    _country2Controller.text = documentSnapshot4['country2'];
    _dateController.text = documentSnapshot4['date'];
     _timeController.text = documentSnapshot4['time'];
    _venueController.text = documentSnapshot4['venue'];
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
                  controller: _country1Controller,
                  decoration: const InputDecoration(labelText: 'Country 1'),
                ),
                 TextField(
                  controller: _country2Controller,
                  decoration: const InputDecoration(labelText: 'Country 2'),
                ),
                
                IconButton(
                  onPressed: (){
                    _pickDate(context).then((value){
                      if (value != null){
                        _dateController.text = value.toString();
                        _dateController.text = formatDate(value, [MM, ' ', d, ', ', yyyy]);

                      }
                    } );
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
                       _timeController.text = (selectedTime.hour).toString() + ':' +(selectedTime.minute).toString();
            
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
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? country1 = _country1Controller.text;
                     final String? country2 = _country2Controller.text;
                     
                      final String? date = _dateController.text;
                      final String? time = _timeController.text;
                       final String? venue = _venueController.text;
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
                          "venue": venue});
                      }

                      if (action == 'update') {
                        // Update the product
                        await _sheduless
                            .doc(documentSnapshot4!.id)
                            .update({
                              "country1": country1,
                              "country2": country2,
                              "date": date,
                              "time" : time,
                              "venue": venue
                            });
                      }

                      // Clear the text fields
                      _country1Controller.text = '';
                      _country2Controller.text = '';
                      _dateController.text = '';
                      _timeController.text = '';
                      _venueController.text = '';
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
  Future<void> _deleteTeam(String sheduleId) async {
    await _sheduless.doc(sheduleId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted a shedule')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Shedule'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _sheduless.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot4 =
                    streamSnapshot.data!.docs[index];
                final Text cn1 = Text(documentSnapshot4['country1']);
                final Text cn2 = Text(documentSnapshot4['country2']);
                final Text date = Text(documentSnapshot4['date']);
                final Text vn = Text(documentSnapshot4['venue']);


                child:
                return Column(children: [

                  Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    onTap: () {
                     
                    },
                    title: vn,
                    contentPadding: EdgeInsets.symmetric(horizontal: 150),
                    
                    

                    //subtitle: Text(documentSnapshot['price'].toString()),
                    
                  ),
                ),
                  
                 Card(
                  margin: const EdgeInsets.all(10),
                  
                  child: ListTile(
                    onTap: () {
                     // Navigator.of(context).push(MaterialPageRoute(
                     //     builder: (context) => PlayerMng(name)));
                    },
                   
                    title: cn1,
                    contentPadding: EdgeInsets.symmetric(horizontal: 150),
                    

                    //subtitle: Text(documentSnapshot['price'].toString()),
                  
                  ),
                  
                ),
                
                Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    onTap: () {
                     
                    },
                    title: cn2,
                    contentPadding: EdgeInsets.symmetric(horizontal: 150),
                    

                    //subtitle: Text(documentSnapshot['price'].toString()),
                    
                  ),
                ),

                Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    onTap: () {
                     
                    },
                    title: date,
                    
                    

                    //subtitle: Text(documentSnapshot['price'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdateShedule(documentSnapshot4)),
                          // This icon button is used to delete a single product
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteTeam(documentSnapshot4.id)),
                        ],
                      ),
                    ),
                  ),
                ),


                ],);
                return Text("ok");
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
        onPressed: () => _createOrUpdateShedule(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
