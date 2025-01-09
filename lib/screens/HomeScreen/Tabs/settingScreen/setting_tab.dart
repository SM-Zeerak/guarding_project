import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guarding_project/screens/HomeScreen/Tabs/profileSetupScreen/profileSetupScreen.dart';
import 'package:guarding_project/screens/HomeScreen/Tabs/settingScreen/components/banner_screen.dart';
import 'package:guarding_project/screens/HomeScreen/Tabs/settingScreen/components/setting_cards.dart';
import 'package:guarding_project/screens/authScreen/authScreen.dart';
import 'package:guarding_project/utils/color_utils.dart';
import 'package:guarding_project/utils/image_utils.dart';
import 'package:guarding_project/utils/textStyle_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingTab extends StatefulWidget {
  final bool isAdmin;
  SettingTab({super.key, required this.isAdmin});

  @override
  State<SettingTab> createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  bool _isAdmin = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchAdminStatus();
    _isAdmin = widget.isAdmin;
  }

  Future<void> _fetchAdminStatus() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _isAdmin = doc['admin'] ?? false;
      });
    }
  }

// Future<void> logout(BuildContext context) async {
//   try {
//     await FirebaseAuth.instance.signOut();

//     // Navigate to LoginScreen after logout
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => AuthScreen(index: true,)),
//     );
//   } catch (e) {
//     print('Logout Failed: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Logout Failed: ${e.toString()}')),
//     );
//   }
// }

  Future<void> logout(BuildContext context) async {
    try {
      // Sign out the user from Firebase Authentication
      await FirebaseAuth.instance.signOut();

      // Clear the "Remember Me" credentials from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('rememberMe');
      prefs.remove('isAdmin');

      // Navigate to the AuthScreen (Login Screen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen(index: true)),
      );
    } catch (e) {
      print('Logout Failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout Failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ClrUtls.blue,
        title: Text(
          "Setting Tab",
          style:
              TextStylesUtils.custom(fontSize: 24, fontWeight: FontWeight.w500, color: ClrUtls.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                SettingCards(
                  icon: ImageUtils.setting,
                  text: 'Account Information',
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profilesetupscreen(
                                  isUser: true,
                                )));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                _isAdmin
                    ? SettingCards(
                        icon: ImageUtils.location,
                        text: 'Banner Screen',
                        ontap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageUploadScreen()));
                        },
                      )
                    : SizedBox.shrink(),
               _isAdmin
                    ? 
                SizedBox(
                  height: 20,
                ): SizedBox.shrink(),
                // SettingCards(
                //   icon: ImageUtils.history,
                //   text: 'History Purchase',
                //   ontap: (){

                //   },
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // SettingCards(
                //   icon: ImageUtils.notification,
                //   text: 'Notifications Settings',
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                SettingCards(
                  icon: ImageUtils.privacy,
                  text: 'Privacy & Policy',
                ),
                SizedBox(
                  height: 20,
                ),
                SettingCards(
                  icon: ImageUtils.support,
                  text: 'Help & Support',
                ),
                SizedBox(
                  height: 20,
                ),
                SettingCards(
                  ontap: () => logout(context),
                  icon: ImageUtils.logout,
                  text: 'Logout',
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
