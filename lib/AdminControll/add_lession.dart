import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddLessonDialog extends StatefulWidget {
  final String classTitle;
  final String subjectTitle;

  AddLessonDialog(
      {Key? key, required this.classTitle, required this.subjectTitle})
      : super(key: key);

  @override
  _AddLessonDialogState createState() => _AddLessonDialogState();
}

class _AddLessonDialogState extends State<AddLessonDialog> {
  final titleController = TextEditingController();
  File? pdfFile;
  String? fileName;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Lesson'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Lesson Title'),
          ),
          SizedBox(height: 10),
          if (pdfFile != null)
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.blue)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('File Selected: $fileName'),
              ),
            ),
          SizedBox(height: 10),
          pdfFile == null
              ? ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );

                    if (result != null) {
                      setState(() {
                        pdfFile = File(result.files.single.path!);
                        fileName = result.files.single.name;
                      });
                    }
                  },
                  child: Text('Attach PDF File'),
                )
              : Container(),
          SizedBox(height: 10),
          if (isLoading)
            Center(
                child: CircularProgressIndicator()), // Show loader while saving
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        !isLoading
            ? TextButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty && pdfFile != null) {
                    setState(() {
                      isLoading = true; // Show loader when save is initiated
                    });

                    try {
                      FirebaseStorage storage = FirebaseStorage.instance;
                      String fileNameToUpload =
                          'lesson_${DateTime.now().millisecondsSinceEpoch}.pdf';
                      Reference ref =
                          storage.ref().child('lessons/$fileNameToUpload');
                      UploadTask uploadTask = ref.putFile(pdfFile!);

                      TaskSnapshot snapshot = await uploadTask;
                      String fileUrl = await snapshot.ref.getDownloadURL();

                      await FirebaseFirestore.instance
                          .collection('lessons')
                          .add({
                        'title': titleController.text,
                        'size': pdfFile!.lengthSync().toString(),
                        'pdfUrl': fileUrl,
                        'classTitle': widget.classTitle,
                        'subjectTitle': widget.subjectTitle,
                      });

                      Navigator.of(context)
                          .pop(); // Close the dialog after saving
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    } finally {
                      setState(() {
                        isLoading = false; // Hide loader after saving
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Please fill in all fields and attach a file')),
                    );
                  }
                },
                child: Text('Save Lesson'),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
