import 'package:flutter/material.dart';
import 'package:guarding_project/import_file.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isRememberMe = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isRememberMe = !_isRememberMe;
                            });
                          },
                          child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: ClrUtils.iconselected),
                                  borderRadius: BorderRadius.circular(5),
                                  color: !_isRememberMe
                                      ? ClrUtils.background
                                      : ClrUtils.iconselected),
                              child: Center(
                                  child: _isRememberMe
                                      ? Icon(
                                          Icons.check,
                                          color: ClrUtils.greyColor,
                                          size: 14,
                                        )
                                      : null)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CustomText(
                          text: 'Remember me',
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                      text: "Login",
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Homescreen()));
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: "Don't have an account? ",
                        fontSize: 14,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()));
                        },
                        child: CustomText(
                          text: "Sign Up",
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
