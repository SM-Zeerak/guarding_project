// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:guarding_project/import_file.dart';

// class RegisterScreen extends StatelessWidget {
//   RegisterScreen({super.key});

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> _register() async {
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       print('User registered: ${userCredential.user?.email}');
//     } on FirebaseAuthException catch (e) {
//       // Handle errors
//       print('Error: $e');
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           width: screenWidth(context) * 0.92,
//           decoration: BoxDecoration(
//               border: Border.all(width: 1, color: ClrUtils.greyColor),
//               borderRadius: BorderRadius.circular(20),
//               color: ClrUtils.background,
//               boxShadow: [
//                 BoxShadow(
//                   color: ClrUtils.greyColor,
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ]),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CustomTextField(
//                       controller: _emailController,
//                       prefixIcon: Icons.email,
//                       hintText: "Type Email..."),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   CustomTextField(
//                       controller: _passwordController,
//                       prefixIcon: Icons.lock,
//                       isPassword: true,
//                       hintText: "Type Password..."),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   CustomButton(text: "Register", onPressed: _register),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     children: [
//                       CustomText(
//                         text: "Do you have an account?",
//                         fontSize: 14,
//                       ),
//                       InkWell(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => LoginScreen()));
//                         },
//                         child: CustomText(
//                           text: "Sign In",
//                           fontSize: 14,
//                           color: ClrUtils.iconselected,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guarding_project/import_file.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _register(BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save user info to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': _emailController.text.trim(),
        'created_at': DateTime.now(),
        // Add other user fields if needed
      });

      // Clear the input fields
      _emailController.clear();
      _passwordController.clear();

      // Show success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registered: ${userCredential.user?.email}')),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registration failed. Please try again.';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      
      // Show error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth(context) * 0.92,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: ClrUtils.greyColor),
              borderRadius: BorderRadius.circular(20),
              color: ClrUtils.background,
              boxShadow: [
                BoxShadow(
                  color: ClrUtils.greyColor,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                      controller: _emailController,
                      prefixIcon: Icons.email,
                      hintText: "Type Email..."),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      controller: _passwordController,
                      prefixIcon: Icons.lock,
                      isPassword: true,
                      hintText: "Type Password..."),
                  SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    text: "Register",
                    onPressed: () => _register(context),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: "Do you have an account?",
                        fontSize: 14,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: CustomText(
                          text: "Sign In",
                          fontSize: 14,
                          color: ClrUtils.iconselected,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
