import 'package:flutter/material.dart';
import 'package:guarding_project/screens/HomeScreen/Tabs/homeTab/subScreen/cardDetailScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guarding_project/utils/color_utils.dart';

class AddSubjectScreen extends StatefulWidget {
  final String classTitle;
  final bool isAdmin;

  AddSubjectScreen({Key? key, required this.classTitle, required this.isAdmin})
      : super(key: key);

  @override
  _AddSubjectScreenState createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  late Stream<List<Map<String, String>>> _subjectStream;
  final TextEditingController _subjectController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _subjectStream = _getSubjects(widget.classTitle);
  }

  Stream<List<Map<String, String>>> _getSubjects(String classTitle) {
    return FirebaseFirestore.instance
        .collection('subjects')
        .where('classTitle', isEqualTo: classTitle)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return {
          'title': doc['title']?.toString() ?? '',
        };
      }).toList();
    });
  }

  _addSubject() async {
    if (_formKey.currentState?.validate() ?? false) {
      final subjectTitle = _subjectController.text.trim();

      // Add subject to Firestore
      await FirebaseFirestore.instance.collection('subjects').add({
        'title': subjectTitle,
        'classTitle': widget.classTitle,
      });

      // Clear text field after adding
      _subjectController.clear();

      // Close dialog
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ClrUtls.blue,
        title: Text(
          'Select Subject',
          style: TextStyle(color: ClrUtls.white),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: ClrUtls.white,
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, String>>>(
        stream: _subjectStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No subjects available.'));
          }

          List<Map<String, String>> subjectItems = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: subjectItems.length,
              itemBuilder: (context, index) {
                String subjectTitle = subjectItems[index]['title']!;

                return Card(
                  color: ClrUtls.white,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subjectTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Icon(Icons.keyboard_arrow_right)
                      ],
                    ),
                    onTap: () {
                      // Navigate to ClassDetailScreen and pass the subject's details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassDetailScreen(
                            classTitle: widget.classTitle,
                            isAdmin: widget.isAdmin,
                            subjectTitle:
                                subjectTitle, // Assuming true for admin, pass accordingly
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: widget.isAdmin == true
          ? FloatingActionButton(
              onPressed: () {
                // Show a dialog to add a new subject
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add New Subject'),
                      content: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _subjectController,
                          decoration:
                              InputDecoration(labelText: 'Subject Title'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a subject title';
                            }
                            return null;
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: _addSubject,
                          child: Text('Add Subject'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.add),
              tooltip: 'Add Subject',
            )
          : Container(),
    );
  }
}
