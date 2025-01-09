// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:guarding_project/components/Buttons/custom_button.dart';
// import 'package:guarding_project/components/TextField/custom_textfield.dart';
// import 'package:guarding_project/screens/HomeScreen/bottomNav/bottomNav.dart';
// import 'package:guarding_project/screens/authScreen/authScreen.dart';
// import 'package:guarding_project/services/fetchUser/fetch_user_services.dart';
// import 'package:guarding_project/services/login_service/login_service.dart';
// import 'package:guarding_project/utils/size_utils.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: SizeUtils.getWidth(context) * 0.9,
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             CustomTextField(controller: _emailController, hintText: "Your Email..."),
//             SizedBox(height: 10),
//             CustomTextField(
//               controller: _passwordController,
//               hintText: "Your Password...",
//               isPass: true,
//             ),
//             SizedBox(height: 20),
//             CustomButton(
//               text: "Login",
//               onPressed: () async {
//                 String message = await LoginService().loginUser(
//                   email: _emailController.text.trim(),
//                   password: _passwordController.text.trim(),
//                 );

//                 if (message == "Login successful") {
//                   // Fetch the user data (including isAdmin)
//                   try {
//                     Map<String, dynamic> userData = await FetchUserService().getUserData();
//                     bool isAdmin = userData['isAdmin'];

//                     if (isAdmin) {
//                       // Redirect to an admin screen or display admin features
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => BottomNavScreen(isAdmin: true,)),
//                       );
//                       print("Admin true");
//                     } else {
//                       // Redirect to regular user screen
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => BottomNavScreen(isAdmin: false,)),
//                       );
//                        print("Admin false");
//                     }
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Error fetching user data: $e')),
//                     );
//                   }
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(message)),
//                   );
//                 }
//               },
//             ),
//             SizedBox(height: 30),
//             RichText(
//               text: TextSpan(
//                 text: "Don't have an account? ",
//                 style: TextStyle(color: Colors.grey, fontSize: 16),
//                 children: [
//                   TextSpan(
//                     text: "Sign Up",
//                     style: TextStyle(color: Colors.black, fontSize: 16),
//                     recognizer: TapGestureRecognizer()
//                       ..onTap = () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => AuthScreen(index: false),
//                           ),
//                         );
//                       },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:guarding_project/components/Buttons/custom_button.dart';
import 'package:guarding_project/components/TextField/custom_textfield.dart';
import 'package:guarding_project/screens/HomeScreen/bottomNav/bottomNav.dart';
import 'package:guarding_project/screens/authScreen/authScreen.dart';
import 'package:guarding_project/services/fetchUser/fetch_user_services.dart';
import 'package:guarding_project/services/login_service/login_service.dart';
import 'package:guarding_project/utils/size_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Load saved credentials from SharedPreferences
  _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  // Save credentials to SharedPreferences
  Future<void> _saveCredentials() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('rememberMe', _rememberMe);
  prefs.setString('email', _emailController.text.trim());
  prefs.setString('password', _passwordController.text.trim());
  
  // Save the isAdmin value
  Map<String, dynamic> userData = await FetchUserService().getUserData();
  bool isAdmin = userData['isAdmin'] ?? true;
  prefs.setBool('isAdmin', isAdmin); // Save the isAdmin status
}

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: SizeUtils.getWidth(context) * 0.9,
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomTextField(
                controller: _emailController, hintText: "Your Email..."),
            SizedBox(height: 10),
            CustomTextField(
              controller: _passwordController,
              hintText: "Your Password...",
              isPass: true,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                Text("Remember me"),
              ],
            ),
            CustomButton(
              text: "Login",
              onPressed: () async {
                String message = await LoginService().loginUser(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );

                if (message == "Login successful") {
                  // Save credentials if "Remember Me" is selected
                  if (_rememberMe) {
                    _saveCredentials();
                  } else {
                    _clearSavedCredentials();
                  }

                  // Fetch the user data (including isAdmin)
                  try {
                    Map<String, dynamic> userData =
                        await FetchUserService().getUserData();
                    bool isAdmin = userData['isAdmin'] ?? true;

                    if (isAdmin) {
                      // Redirect to an admin screen or display admin features
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavScreen(
                                  isAdmin: true,
                                )),
                      );
                      print("Admin true");
                    } else {
                      // Redirect to regular user screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavScreen(
                                  isAdmin: false,
                                )),
                      );
                      print("Admin false");
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error fetching user data: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
              },
            ),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(color: Colors.grey, fontSize: 16),
                children: [
                  TextSpan(
                    text: "Sign Up",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthScreen(index: false),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Clear saved credentials
  _clearSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
    prefs.remove('rememberMe');
  }
}
