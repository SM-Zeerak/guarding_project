import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guarding_project/screens/HomeScreen/bottomNav/bottomNav.dart';
import 'package:guarding_project/screens/authScreen/authScreen.dart';
import 'package:guarding_project/utils/color_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool isLoggedIn = prefs.getBool('rememberMe') ?? false;
//   await Firebase.initializeApp();
//   runApp(MyApp(
//     isLoggedIn: isLoggedIn,
//   ));
// }

// class MyApp extends StatelessWidget {
//   final bool isLoggedIn;
//   MyApp({super.key, required this.isLoggedIn});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           scaffoldBackgroundColor: Colors.white,
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//         ),
//         home: isLoggedIn
//             ? BottomNavScreen(isAdmin: false)
//             : AuthScreen(
//                 index: true,
//               )
//         //  AuthScreen(index: true,),
//         );
//   }
// }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('rememberMe') ?? false;
  bool isAdmin = prefs.getBool('isAdmin') ?? false;

  await Firebase.initializeApp();
  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    isAdmin: isAdmin,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isAdmin;

  MyApp({super.key, required this.isLoggedIn, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn
          ? BottomNavScreen(isAdmin: isAdmin) // Pass the isAdmin value
          : AuthScreen(index: true),
    );
  }
}
