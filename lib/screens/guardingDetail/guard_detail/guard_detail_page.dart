import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guarding_project/screens/guardingDetail/list_guard/guardPage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserDetailPage extends StatefulWidget {
   User user;

  UserDetailPage({required this.user});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late TextEditingController _nameController;
  late TextEditingController _mobileNoController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _mobileNoController = TextEditingController(text: widget.user.mobileNo);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileNoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String> _uploadImage(File image) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/djltm3xyk/image/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = 'nam6mstj' // Use your actual preset name
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final data = json.decode(responseData.body);
      return data['secure_url']; // Return the image URL
    } else {
      throw Exception('Image upload failed');
    }
  }

 void _addNewPosting() async {
  final newPostingController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add New Posting'),
        content: TextField(
          controller: newPostingController,
          decoration: InputDecoration(
            labelText: 'Enter New Posting Address',
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
            onPressed: () {
              setState(() {
                // Ensure the posting history is updated properly
                widget.user.postingHistory.add(newPostingController.text);
                widget.user.currentPosting = newPostingController.text;
              });
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}


Future<void> _saveUserData() async {
  String imageUrl = widget.user.imageUrl;
  if (_image != null) {
    imageUrl = await _uploadImage(_image!);
  }

  // Debug: Check the updated postingHistory
  print('Updated posting history: ${widget.user.postingHistory}');

  try {
    // Update user data with the new posting history
  FirebaseFirestore.instance.collection('users').doc(widget.user.id).get().then((snapshot) {
  if (snapshot.exists) {
    var data = snapshot.data()!;
    User user = User(
      id: snapshot.id,
      name: data['name'],
      mobileNo: data['mobileNo'],
      imageUrl: data['imageUrl'],
      currentPosting: data['currentPostingAddress'],
      postingHistory: List<String>.from(data['postingHistory'] ?? []),  // Ensure this is a list.
    );
    setState(() {
      widget.user = user;
    });
  }
});

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User data updated!')));
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating user data: $e')));
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.user.imageUrl),
            ),
            SizedBox(height: 16),
            Text('Name: ${widget.user.name}', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Edit Name'),
            ),
            SizedBox(height: 10),
            Text('Mobile No: ${widget.user.mobileNo}', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _mobileNoController,
              decoration: InputDecoration(labelText: 'Edit Mobile No'),
            ),
            SizedBox(height: 20),
            Text('Current Posting: ${widget.user.currentPosting}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Posting History:', style: TextStyle(fontSize: 18)),
            ...widget.user.postingHistory.map((posting) {
              return ListTile(
                title: Text(posting),
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewPosting,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveUserData,
          child: Text('Save Changes'),
        ),
      ),
    );
  }
}
