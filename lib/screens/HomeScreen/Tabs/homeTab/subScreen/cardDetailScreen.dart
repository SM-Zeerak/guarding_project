import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:guarding_project/AdminControll/add_lession.dart';
import 'package:guarding_project/screens/HomeScreen/Tabs/homeTab/subScreen/function/downloadFunction.dart';
import 'package:guarding_project/screens/HomeScreen/Tabs/homeTab/subScreen/function/pdfViewer.dart';
import 'package:guarding_project/utils/color_utils.dart';

class ClassDetailScreen extends StatefulWidget {
  final String classTitle;
  final String subjectTitle; // Added subjectTitle
  final bool isAdmin;

  ClassDetailScreen(
      {Key? key,
      required this.classTitle,
      required this.subjectTitle,
      required this.isAdmin})
      : super(key: key);

  @override
  _ClassDetailScreenState createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  late Stream<List<Map<String, String>>> _lessonsStream;
  Map<String, ValueNotifier<double>> _downloadProgressMap = {};
  Map<String, ValueNotifier<bool>> _isDownloadingMap = {};
  Map<String, CancelToken> _cancelTokenMap = {};
  Map<String, bool> _isDownloadedMap = {}; // Track download status

  @override
  void initState() {
    super.initState();
    _lessonsStream = _getLessons(widget.classTitle, widget.subjectTitle);
  }

  // Update _getLessons to filter by both classTitle and subjectTitle
  Stream<List<Map<String, String>>> _getLessons(
      String classTitle, String subjectTitle) {
    return FirebaseFirestore.instance
        .collection('lessons')
        .where('classTitle', isEqualTo: classTitle)
        .where('subjectTitle',
            isEqualTo: subjectTitle) // Filter by subjectTitle
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return {
          'title': doc['title']?.toString() ?? '',
          'size': (doc['size']?.toString() ?? '0'),
          'path': doc['pdfUrl']?.toString() ?? '',
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    DownloadPdf downloadPdf = DownloadPdf();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ClrUtls.blue,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: ClrUtls.white,
          ),
        ),
        title: Text(
          '${widget.classTitle} - ${widget.subjectTitle}',
          style: TextStyle(color: ClrUtls.white),
        ), // Show class and subject
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, String>>>(
        stream: _lessonsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No lessons available.'));
          }

          List<Map<String, String>> pdfItems = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: pdfItems.length,
              itemBuilder: (context, index) {
                String lessonTitle = pdfItems[index]['title']!;
                String pdfUrl = pdfItems[index]['path']!;

                // Initialize progress, state, and download status for this lesson if not already initialized
                if (!_downloadProgressMap.containsKey(lessonTitle)) {
                  _downloadProgressMap[lessonTitle] = ValueNotifier<double>(0);
                  _isDownloadingMap[lessonTitle] = ValueNotifier<bool>(false);
                  _cancelTokenMap[lessonTitle] = CancelToken();
                  _isDownloadedMap[lessonTitle] = false; // Initialize to false
                }

                return Card(
                  color: ClrUtls.white,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                      size: 30,
                    ),
                    title: Text(
                      lessonTitle,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(pdfItems[index]['size']!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ValueListenableBuilder<double>(
                          valueListenable: _downloadProgressMap[lessonTitle]!,
                          builder: (context, progress, child) {
                            return _isDownloadingMap[lessonTitle]!.value
                                ? Row(
                                    children: [
                                      CircularProgressIndicator(
                                          value: progress / 100),
                                      SizedBox(height: 8),
                                      Text('${progress.toStringAsFixed(2)}%'),
                                      IconButton(
                                        icon: Icon(Icons.cancel,
                                            color: Colors.red),
                                        onPressed: () {
                                          downloadPdf.cancelDownload(
                                              _cancelTokenMap[lessonTitle]!);
                                          _isDownloadingMap[lessonTitle]!
                                              .value = false;
                                        },
                                      ),
                                    ],
                                  )
                                : _isDownloadedMap[lessonTitle]!
                                    ? Text(
                                        'Downloaded') // Show "Downloaded" text when complete
                                    : IconButton(
                                        icon: Icon(Icons.download,
                                            color: Colors.blue),
                                        onPressed: () {
                                          _downloadProgressMap[lessonTitle]!
                                              .value = 0;
                                          _isDownloadingMap[lessonTitle]!
                                              .value = true;
                                          _cancelTokenMap[lessonTitle] =
                                              CancelToken(); // Reset cancel token on new download
                                          downloadPdf
                                              .downloadPdf(
                                            context,
                                            pdfUrl,
                                            '$lessonTitle.pdf',
                                            _downloadProgressMap[lessonTitle]!,
                                            _isDownloadingMap[lessonTitle]!,
                                            _cancelTokenMap[lessonTitle]!,
                                          )
                                              .then((_) {
                                            // When download completes, update the download status
                                            if (_downloadProgressMap[
                                                        lessonTitle]!
                                                    .value ==
                                                100) {
                                              setState(() {
                                                _isDownloadingMap[lessonTitle]!
                                                    .value = false;
                                                _isDownloadedMap[lessonTitle] =
                                                    true; // Mark as downloaded
                                              });
                                            }
                                          });
                                        },
                                      );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_red_eye, color: Colors.green),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFViewerScreen(
                                  pdfPath: pdfUrl,
                                ),
                              ),
                            );
                          },
                        ),
                        widget.isAdmin
                            ? IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  try {
                                    // Show confirmation dialog before deleting
                                    bool confirmDelete = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Delete Lesson'),
                                              content: Text(
                                                  'Are you sure you want to delete this lesson?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  child: Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        ) ??
                                        false;

                                    if (confirmDelete) {
                                      // Delete the lesson from Firestore
                                      await FirebaseFirestore.instance
                                          .collection('lessons')
                                          .where('title',
                                              isEqualTo: lessonTitle)
                                          .get()
                                          .then((querySnapshot) async {
                                        for (var doc in querySnapshot.docs) {
                                          // Delete the PDF from Firebase Storage
                                          String pdfUrlToDelete = doc['pdfUrl'];
                                          Reference fileRef = FirebaseStorage
                                              .instance
                                              .refFromURL(pdfUrlToDelete);
                                          await fileRef.delete();
                                          // Now delete the Firestore document
                                          await doc.reference.delete();
                                        }
                                      });

                                      // Show confirmation message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Lesson deleted successfully')),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Error deleting lesson: $e')),
                                    );
                                  }
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddLessonDialog(
                    classTitle: widget.classTitle,
                    subjectTitle: widget.subjectTitle,
                  ),
                );
              },
              child: Icon(Icons.add),
              tooltip: 'Add Lesson',
            )
          : null,
    );
  }
}
