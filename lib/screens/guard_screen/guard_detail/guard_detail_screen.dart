import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guarding_project/screens/HomeScreen/bottomNav/bottomNav.dart';
import 'package:guarding_project/services/Admin/add_class_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class GuardDetailScreen extends StatefulWidget {
   Map<String, dynamic> guardData;

  GuardDetailScreen({required this.guardData});

  @override
  _GuardDetailScreenState createState() => _GuardDetailScreenState();
}

class _GuardDetailScreenState extends State<GuardDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _addressController;
  late TextEditingController _cnicController;
  late TextEditingController _expiryDateController;
  late TextEditingController _dobController;
  late TextEditingController _guardIdController;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.guardData['name']);
    _mobileController = TextEditingController(text: widget.guardData['mobile']);
    _addressController = TextEditingController(text: widget.guardData['address']);
    _cnicController = TextEditingController(text: widget.guardData['cnic']);
    _expiryDateController = TextEditingController(text: widget.guardData['expiryDate']);
    _dobController = TextEditingController(text: widget.guardData['dob']);
    _guardIdController = TextEditingController(text: widget.guardData['guardId']);
  }

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

 Future<void> _pickImage() async {
  // Show a dialog to choose between camera and gallery
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Select Image Source"),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            // Pick image from the gallery
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(source: ImageSource.gallery);
            setState(() {
              _image = pickedFile;
            });
          },
          child: Text("Gallery"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            // Pick image from the camera
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(source: ImageSource.camera);
            setState(() {
              _image = pickedFile;
            });
          },
          child: Text("Camera"),
        ),
      ],
    ),
  );
}


Future<String?> _uploadImageToCloudinary(File imageFile) async {
  try {
  
    const cloudName = 'djltm3xyk';
    const uploadPreset = 'nam6mstj';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    // Create multipart request
    final uploadRequest = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] =uploadPreset  // Your Cloudinary upload preset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    // Send the request
    final response = await uploadRequest.send();

    // Wait for the response and decode it
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      // Successfully uploaded
      final jsonResponse = json.decode(responseData);
      return jsonResponse['secure_url'];  // Return the URL of the uploaded image
    } else {
      // Handle failure
      print('Failed to upload image: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}


  // Future<void> _updateGuard() async {
  //   String? imageUrl = widget.guardData['imagePath'];
  //   if (_image != null) {
  //     imageUrl = await _uploadImageToCloudinary(File(_image!.path));
  //   }

  //   final updatedData = {
  //     'name': _nameController.text.trim(),
  //     'mobile': _mobileController.text.trim(),
  //     'address': _addressController.text.trim(),
  //     'cnic': _cnicController.text.trim(),
  //     'expiryDate': _expiryDateController.text.trim(),
  //     'dob': _dobController.text.trim(),
  //     'guardId': _guardIdController.text.trim(),
  //     'imagePath': imageUrl,
  //   };

  //   await FirebaseService().updateGuard(widget.guardData['id'], updatedData);

  //   Navigator.pop(context);
  // }

  Future<void> _updateGuard() async {
  String? imageUrl = widget.guardData['imagePath'];
  if (_image != null) {
    imageUrl = await _uploadImageToCloudinary(File(_image!.path));
  }

  final updatedData = {
    'name': _nameController.text.trim(),
    'mobile': _mobileController.text.trim(),
    'address': _addressController.text.trim(),
    'cnic': _cnicController.text.trim(),
    'expiryDate': _expiryDateController.text.trim(),
    'dob': _dobController.text.trim(),
    'guardId': _guardIdController.text.trim(),
    'imagePath': imageUrl,
  };

  // Update guard data in Firebase
  await FirebaseService().updateGuard(widget.guardData['id'], updatedData);

  // After successful update, update the guardData and rebuild the widget
  setState(() {
    widget.guardData = updatedData;  // Update the guardData with the new values
  });

  // Show success message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Guard updated successfully.')),
  );
}


  Future<void> _deleteGuard() async {
    await FirebaseService().deleteGuard(widget.guardData['id']);
    if (widget.guardData['imagePath'] != null) {
      // Delete image from Cloudinary
      // Implement deletion logic...
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavScreen(isAdmin: true)));
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text('Guard Details'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteGuard,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(File(_image!.path))
                        : NetworkImage(widget.guardData['imagePath']),
                    child: _image == null ? Icon(Icons.camera_alt, size: 40) : null,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(labelText: 'Mobile'),
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextFormField(
                  controller: _cnicController,
                  decoration: InputDecoration(labelText: 'CNIC'),
                ),
                TextFormField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(labelText: 'Expiry Date'),
                ),
                TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                ),
                TextFormField(
                  controller: _guardIdController,
                  decoration: InputDecoration(labelText: 'Guard ID'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateGuard,
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
