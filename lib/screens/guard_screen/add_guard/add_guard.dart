import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guarding_project/screens/HomeScreen/bottomNav/bottomNav.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:guarding_project/services/Admin/add_class_service.dart';

class AddGuardScreen extends StatefulWidget {
  @override
  _AddGuardScreenState createState() => _AddGuardScreenState();
}

class _AddGuardScreenState extends State<AddGuardScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _guardIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _image;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _cnicController.dispose();
    _expiryDateController.dispose();
    _dobController.dispose();
    _guardIdController.dispose();
    super.dispose();
  }
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _image = pickedFile;
    });
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    const cloudName = 'djltm3xyk';
    const uploadPreset = 'nam6mstj';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData);
      return jsonData['secure_url'];
    } else {
      print('Failed to upload image: ${response.statusCode}');
      return null;
    }
  }

  _saveGuard() async {
    if (_formKey.currentState?.validate() ?? false) {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await _uploadImageToCloudinary(File(_image!.path));
      }

      final guardData = {
        'name': _nameController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'address': _addressController.text.trim(),
        'cnic': _cnicController.text.trim(),
        'expiryDate': _expiryDateController.text.trim(),
        'dob': _dobController.text.trim(),
        'guardId': _guardIdController.text.trim(),
        'imagePath': imageUrl,
      };

      await FirebaseService().addGuard(guardData);

      // Navigator.pop(context);

      Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavScreen(isAdmin: false,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Guard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(File(_image!.path))
                        : null,
                    child: _image == null
                        ? Icon(Icons.camera_alt, size: 40)
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter name' : null,
                ),
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(labelText: 'Mobile'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter mobile' : null,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter address' : null,
                ),
                TextFormField(
                  controller: _cnicController,
                  decoration: InputDecoration(labelText: 'CNIC'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter CNIC' : null,
                ),
                TextFormField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(labelText: 'Expiry Date'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter expiry date' : null,
                ),
                TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter date of birth' : null,
                ),
                TextFormField(
                  controller: _guardIdController,
                  decoration: InputDecoration(labelText: 'Guard ID'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter guard ID' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveGuard,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
