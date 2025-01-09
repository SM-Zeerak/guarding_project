import 'package:flutter/material.dart';
import 'package:guarding_project/screens/authScreen/login_tab/loginTab.dart';
import 'package:guarding_project/screens/authScreen/register_tab/registerTab.dart';
import 'package:guarding_project/utils/color_utils.dart';
import 'package:guarding_project/utils/image_utils.dart';
import 'package:guarding_project/utils/size_utils.dart';
import 'package:guarding_project/utils/textStyle_utils.dart';

class AuthScreen extends StatefulWidget {
  final bool index; // True for Login, False for Signup

  const AuthScreen({super.key, required this.index});
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool showLogin;

  @override
  void initState() {
    super.initState();
    showLogin = widget.index; // Initialize based on the passed index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: SizeUtils.getHeight(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(ImageUtils.logo), fit: BoxFit.cover)),
              ),
              Text('Welcome to KE',
                  style: TextStylesUtils.custom(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Text(!showLogin ? 'Create Account' : 'Login Here',
                  style: TextStylesUtils.custom(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ClrUtls.btnFontClr)),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  // height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: ClrUtls.btnFontClr),
                      borderRadius: BorderRadius.circular(10)),
                  // color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showLogin = true;
                            });
                          },
                          child: Container(
                            height: 45,
                            width: SizeUtils.getWidth(context) * 0.4,
                            decoration: BoxDecoration(
                              color: showLogin ? ClrUtls.blue : ClrUtls.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStylesUtils.custom(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      showLogin ? ClrUtls.white : ClrUtls.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showLogin = false;
                            });
                          },
                          child: Container(
                            height: 45,
                            width: SizeUtils.getWidth(context) * 0.4,
                            decoration: BoxDecoration(
                              color: !showLogin ? ClrUtls.blue : ClrUtls.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Signup',
                                style: TextStylesUtils.custom(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      !showLogin ? ClrUtls.white : ClrUtls.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Content Area
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: showLogin ? LoginScreen() : SignupScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
