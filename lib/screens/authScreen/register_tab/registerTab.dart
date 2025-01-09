import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:guarding_project/components/Buttons/custom_button.dart';
import 'package:guarding_project/components/TextField/custom_textfield.dart';
import 'package:guarding_project/screens/HomeScreen/bottomNav/bottomNav.dart';
import 'package:guarding_project/screens/authScreen/authScreen.dart';
import 'package:guarding_project/services/Register_services/register_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();


  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            SizedBox(height: 20),
            CustomTextField(
                controller: _nameController, hintText: "Your Name..."),
            SizedBox(height: 10),
            CustomTextField(
                controller: _emailController, hintText: "Your Email..."),
            SizedBox(height: 10),
            CustomTextField(
              controller: _passwordController,
              hintText: "Your Password...",
              isPass: true,
            ),
             SizedBox(height: 10),
            CustomTextField(
              controller: _phoneController,
              hintText: "Your Mobule No...",
            ),
            SizedBox(height: 20),
            CustomButton(
              text: "Register",
              onPressed: () async {
                String message = await RegisterService().registerUser(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                  phoneNo: _phoneController.text.trim(),
                );

                if (message == "User registered successfully") {

                  SnackBar(content: Text("User registered successfully"));
                  // Navigate to Login screen on success
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthScreen(index: false),
                    ),
                  );

                  _emailController.clear();
                  _passwordController.clear();
                  _nameController.clear();
                } else {
                  // Show error message if registration fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
              },
            ),
            SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: "Do you have an account? ",
                style: TextStyle(color: Colors.grey, fontSize: 16),
                children: [
                  TextSpan(
                    text: "Login",
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
