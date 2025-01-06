import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String mobileNo = '';
  String address = '';
  String cnic = '';
  String currentPostingAddress = '';
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadData() async {
  if (_formKey.currentState!.validate() && _image != null) {
    _formKey.currentState!.save();
    final imageUrl = await uploadImage(_image!);

    try {
      // Add user document with a generated ID
      final docRef = await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'mobileNo': mobileNo,
        'address': address,
        'cnic': cnic,
        'currentPostingAddress': currentPostingAddress,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),  // Optional: timestamp
      });

      // Add the userDetails document inside the generated user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(docRef.id) // Use the generated document ID
          .set({
        'name': name,
        'mobileNo': mobileNo,
        'address': address,
        'cnic': cnic,
        'currentPostingAddress': currentPostingAddress,
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saved successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving data: $e')));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields and select an image.')));
  }
}




  Future<String> uploadImage(File image) async {
    final uri =
        Uri.parse('https://api.cloudinary.com/v1_1/djltm3xyk/image/upload');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => name = value!,
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mobile No'),
                onSaved: (value) => mobileNo = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter your mobile number' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                onSaved: (value) => address = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter your address' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'CNIC'),
                onSaved: (value) => cnic = value!,
                validator: (value) => value!.isEmpty ? 'Enter your CNIC' : null,
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Current Posting Address'),
                onSaved: (value) => currentPostingAddress = value!,
                validator: (value) => value!.isEmpty
                    ? 'Enter your current posting address'
                    : null,
              ),
              SizedBox(height: 10),
              _image == null ? Text('No image selected.') : Image.file(_image!),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _uploadData,
                child: Text('Save Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
