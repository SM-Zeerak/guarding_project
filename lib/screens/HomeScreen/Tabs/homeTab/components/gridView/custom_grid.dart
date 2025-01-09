// import 'package:flutter/material.dart';
// import 'package:guarding_project/screens/HomeScreen/Tabs/homeTab/subScreen/cardDetailScreen.dart';

// class GridWithCardsScreen extends StatelessWidget {
//   // Example data
//   final List<Map<String, String>> items = [
//     {'title': 'Class 1', 'icon': '🏫'},
//     {'title': 'Class 2', 'icon': '🏫'},
//     {'title': 'Class 3', 'icon': '🏫'},
//     {'title': 'Class 4', 'icon': '🏫'},
//     {'title': 'Class 5', 'icon': '🏫'},
//     {'title': 'Class 6', 'icon': '🏫'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // Number of columns
//           crossAxisSpacing: 10, // Horizontal spacing
//           mainAxisSpacing: 10, // Vertical spacing
//         ),
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           return CustomGridCard(
//             title: items[index]['title']!,
//             icon: items[index]['icon']!,
// onTap: () {
//   // Navigate to Details Page
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => ClassDetailScreen(
//         classTitle: items[index]['title']!,
//       ),
//     ),
//   );
// },
//           );
//         },
//       ),
//     );
//   }
// }

// class CustomGridCard extends StatelessWidget {
//   final String title;
//   final String icon;
//   final VoidCallback onTap;

//   const CustomGridCard({
//     Key? key,
//     required this.title,
//     required this.icon,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 icon,
//                 style: TextStyle(fontSize: 40),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guarding_project/AdminControll/add_subject.dart';
import 'package:guarding_project/screens/HomeScreen/Tabs/homeTab/subScreen/cardDetailScreen.dart';
import 'package:guarding_project/utils/color_utils.dart';

class GridWithCardsScreen extends StatelessWidget {
  final bool isAdmin;

  const GridWithCardsScreen({super.key, required this.isAdmin});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('gridItems')
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching grid items.'));
        }

        final items = snapshot.data?.docs ?? [];

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index].data() as Map<String, dynamic>;
              return CustomGridCard(
                title: item['title'],
                icon: item['icon'],
                onTap: () {
                  // Navigate to Details Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => 
                      AddSubjectScreen(
                        classTitle: item['title']!,
                        isAdmin: isAdmin,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class CustomGridCard extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const CustomGridCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: ClrUtls.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                icon,
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
