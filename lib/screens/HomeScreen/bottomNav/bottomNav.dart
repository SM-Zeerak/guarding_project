import 'package:flutter/material.dart';
import 'package:guarding_project/screens/HomeScreen/Tabs/homeTab/homeTab.dart';
import 'package:guarding_project/screens/HomeScreen/Tabs/profileSetupScreen/profileSetupScreen.dart';
import 'package:guarding_project/screens/HomeScreen/Tabs/settingScreen/setting_tab.dart';
import 'package:guarding_project/utils/color_utils.dart';

class BottomNavScreen extends StatefulWidget {
  final bool isAdmin;

  const BottomNavScreen({super.key, required this.isAdmin});
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

// class _BottomNavScreenState extends State<BottomNavScreen> {
//   int _selectedIndex = 0;
// bool _isAdmin = false;

// @override
// void initState() {
//   super.initState();
//   _isAdmin = widget.isAdmin;
// }
  

//   // List of Screens
//   final List<Widget> _screens = [
//     HomeTab(),
//     Profilesetupscreen(isUser: false,),
//     SettingTab(isAdmin: _isAdmin),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex], // Display the selected screen
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex, // Current active tab
//         onTap: _onItemTapped, // Handle tab selection
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//       ),
//     );
//   }
// }

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  bool _isAdmin = false;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _isAdmin = widget.isAdmin;

    // Initialize the screens list after _isAdmin is set
    _screens = [
      HomeTab(),
      Profilesetupscreen(isUser: false),
      SettingTab(isAdmin: _isAdmin),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Current active tab
        onTap: _onItemTapped, // Handle tab selection
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        backgroundColor: ClrUtls.blue,
        selectedItemColor: ClrUtls.white,
        unselectedItemColor: ClrUtls.lightWhite,
      ),
    );
  }
}
