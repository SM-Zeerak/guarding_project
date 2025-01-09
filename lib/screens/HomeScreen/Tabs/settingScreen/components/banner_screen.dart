import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  bool _isLoading = false;
  bool _isImageLoad = true;
  String? _deletingDocumentId;
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> uploadedImages = [];
  Future<void> pickAndUploadImage() async {
    setState(() {
      _isLoading = true;
    });

    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    // If no image is selected, reset _isLoading and exit
    if (pickedFile == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    File file = File(pickedFile.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('slider_images/$fileName')
          .putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('slider_images')
          .add({'url': downloadUrl, 'fileName': fileName});

      setState(() {
        uploadedImages
            .add({'url': downloadUrl, 'fileName': fileName, 'id': docRef.id});
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image uploaded successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading image: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> deleteImage(String fileName, String documentId) async {
    setState(() {
      _deletingDocumentId = documentId; // Set the deleting document ID
    });

    try {
      await FirebaseStorage.instance.ref('slider_images/$fileName').delete();
      await FirebaseFirestore.instance
          .collection('slider_images')
          .doc(documentId)
          .delete();

      setState(() {
        uploadedImages.removeWhere((image) => image['fileName'] == fileName);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting image: $e")),
      );
    } finally {
      setState(() {
        _deletingDocumentId = null; // Reset the deleting document ID
      });
    }
  }

  Future<void> fetchUploadedImages() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('slider_images').get();
      setState(() {
        uploadedImages = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'url': data['url'] ?? '',
            'fileName': data['fileName'] ?? '',
            'id': doc.id,
          };
        }).toList();
        _isImageLoad = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching images: $e")),
      );
      setState(() => _isImageLoad = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUploadedImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Images"),
        actions: [
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: Colors.black),
                )
              : IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: pickAndUploadImage,
                ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isLoading = false;
          });
        },
        child: _isImageLoad
            ? ListView.builder(
                itemCount: 6, // Number of shimmer placeholders
                itemBuilder: (context, index) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : uploadedImages.isEmpty
                ? Center(child: Text("No images uploaded yet."))
                : ListView.builder(
                    itemCount: uploadedImages.length,
                    itemBuilder: (context, index) {
                      final image = uploadedImages[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: NetworkImage(image['url']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: InkWell(
                                  onTap: () => deleteImage(
                                      image['fileName'], image['id']),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    child: _deletingDocumentId == image['id']
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(
                                              color: Colors.red,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.delete,
                                                color: Colors.red),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
