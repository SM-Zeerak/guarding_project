import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guarding_project/components/Buttons/custom_button.dart';
import 'package:guarding_project/components/TextField/custom_textfield.dart';
import 'package:guarding_project/screens/HomeScreen/bottomNav/bottomNav.dart';
import 'package:guarding_project/utils/color_utils.dart';
import 'package:guarding_project/utils/image_utils.dart';
import 'package:guarding_project/utils/size_utils.dart';
import 'package:guarding_project/utils/textStyle_utils.dart';

class Profilesetupscreen extends StatefulWidget {
  final bool isUser;
  Profilesetupscreen({super.key, required this.isUser});

  @override
  _ProfilesetupscreenState createState() => _ProfilesetupscreenState();
}

class _ProfilesetupscreenState extends State<Profilesetupscreen> {
  TextEditingController _selectCountry = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();

  bool _isUser = false;
  File? _imageFile; // Variable to store selected image
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  String? profilePictureUrl; // Declare this variable to store the profile picture URL

  @override
  void initState() {
    super.initState();
    _isUser = widget.isUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return;
    }
    String userId = user.uid;

    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        setState(() {
          _fullNameController.text = userDoc['fullName'] ?? '';
          _phoneNumberController.text = userDoc['phoneNumber'] ?? '';
          _selectCountry.text = userDoc['country'] ?? '';
          _aboutController.text = userDoc['about'] ?? '';

          // Load profile picture if available
          profilePictureUrl = userDoc['profilePictureUrl']; // Save the URL here
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          print("Image Url: ${_imageFile}");
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _saveProfile() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    String userId = user.uid;
    String imageUrl = '';

    // If there's a new image, upload it to Firebase Storage
    if (_imageFile != null) {
      try {
        String fileName = '${userId}_profile_pic.jpg';
        Reference storageRef = _storage.ref().child('profile_pictures/$fileName');
        UploadTask uploadTask = storageRef.putFile(_imageFile!);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    try {
      await _firestore.collection('users').doc(userId).set({
        'fullName': _fullNameController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'country': _selectCountry.text.trim(),
        'about': _aboutController.text.trim(),
        'profilePictureUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => BottomNavScreen(isAdmin: false,)),
      // );

      SnackBar(content: Text('Profile saved successfully!'));
    } catch (e) {
      print("Error saving user profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isUser
          ? AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: ClrUtls.primary,
            )
          : null,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: SizeUtils.getWidth(context) * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  !_isUser ? "Profile Setup" : "Profile Edit",
                  style: TextStylesUtils.custom(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: ClrUtls.darkBrown),
                ),
                SizedBox(height: 20),
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!) // For local image
                          : (profilePictureUrl != null && profilePictureUrl!.isNotEmpty)
                              ? NetworkImage(profilePictureUrl!) // For remote image URL
                              : AssetImage(ImageUtils.logo) as ImageProvider, // Default image
                      radius: 80,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.camera),
                                    title: Text("Take a photo"),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      _pickImage(ImageSource.camera);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.photo_library),
                                    title: Text("Choose from gallery"),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      _pickImage(ImageSource.gallery);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ClrUtls.blue,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.image_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text("Upload Picture", style: TextStylesUtils.custom(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )),
                SizedBox(height: 20),
                CustomTextField(
                  controller: _fullNameController,
                  hintText: "Full Name...",
                  hintColor: ClrUtls.grey,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  controller: _phoneNumberController,
                  hintText: "Phone Number...",
                  hintColor: ClrUtls.grey,
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: "Save",
                  textColor: ClrUtls.btnFontClr,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  width: SizeUtils.getWidth(context) * 0.85,
                  height: 51,
                  borderRadius: 300,
                  color: ClrUtls.secondaryDark,
                  onPressed: _saveProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
