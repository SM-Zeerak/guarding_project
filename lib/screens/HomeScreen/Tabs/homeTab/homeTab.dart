import 'package:flutter/material.dart';
import 'package:guarding_project/screens/guard_screen/add_guard/add_guard.dart';
import 'package:guarding_project/screens/HomeScreen/Tabs/homeTab/components/Image_Slider/custom_slider.dart';
import 'package:guarding_project/screens/HomeScreen/Tabs/homeTab/components/gridView/custom_grid.dart';
import 'package:guarding_project/screens/guard_screen/guard_detail/guard_detail_screen.dart';
import 'package:guarding_project/services/Admin/add_class_service.dart';
import 'package:guarding_project/services/fetchUser/fetch_user_services.dart';
import 'package:guarding_project/utils/color_utils.dart';
import 'package:guarding_project/utils/image_utils.dart';
import 'package:guarding_project/utils/size_utils.dart';

class HomeTab extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<Map<String, dynamic>>(
  //     future: FetchUserService().getUserData(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(child: CircularProgressIndicator());
  //       }

  //       if (snapshot.hasError) {
  //         return Center(child: Text('Error fetching user data.'));
  //       }

  //       final isAdmin = snapshot.data?['isAdmin'] ?? false;

  //       return Scaffold(
  //         key: _scaffoldKey,
  //         appBar: AppBar(
  //           automaticallyImplyLeading:
  //               false, // Removes the default leading icon
  //           backgroundColor: ClrUtls.blue,
  //           title: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   Container(
  //                     width: 60,
  //                     height: 60,
  //                     decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: ClrUtls.blue,
  //                         image: DecorationImage(
  //                             image: AssetImage(ImageUtils.logo),
  //                             fit: BoxFit.fill)),
  //                   ),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   Text(
  //                     "Karachi Eductation",
  //                     style: TextStyle(color: ClrUtls.white),
  //                   ),
  //                 ],
  //               ),
  //               IconButton(
  //                 icon: Icon(Icons.menu, color: ClrUtls.white),
  //                 onPressed: () {
  //                   _scaffoldKey.currentState?.openDrawer(); // Opens the drawer
  //                 },
  //               ),
  //             ],
  //           ),
  //           centerTitle: true,
  //         ),
  //         drawer: Drawer(
  //           child: ListView(
  //             padding: EdgeInsets.zero,
  //             children: <Widget>[
  //               DrawerHeader(
  //                 decoration: BoxDecoration(
  //                   color: ClrUtls.blue,
  //                 ),
  //                 child: Text(
  //                   'Menu',
  //                   style: TextStyle(
  //                     color: ClrUtls.white,
  //                     fontSize: 24,
  //                   ),
  //                 ),
  //               ),
  //               ListTile(
  //                 leading: Icon(Icons.home),
  //                 title: Text('Home'),
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   // Navigate to Home Screen if needed
  //                 },
  //               ),
  //               ListTile(
  //                 leading: Icon(Icons.settings),
  //                 title: Text('Settings'),
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   // Navigate to Settings Screen
  //                 },
  //               ),
  //               ListTile(
  //                 leading: Icon(Icons.logout),
  //                 title: Text('Logout'),
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   // Implement Logout functionality
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         body: Center(
  //           child: Container(
  //             width: SizeUtils.getWidth(context) * 0.9,
  //             child: Column(
  //               children: [
  //                 SizedBox(height: 20),
  //                 Container(
  //                   height: 200,
  //                   child: CustomSlider(image: [ImageUtils.banner],),
  //                 ),

  //               ],
  //             ),
  //           ),
  //         ),
  //         floatingActionButton: isAdmin
  //             ? FloatingActionButton(
  //                 onPressed: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => AddGuardScreen(),
  //                     ),
  //                   );
  //                 },
  //                 child: Icon(Icons.add),
  //               )
  //             : null,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FirebaseService().getGuards(), // Service to fetch guards
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching guards.'));
        }

        final guards = snapshot.data ?? [];

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Guard List'),
          ),
          drawer: Drawer(
              // Drawer configuration
              ),
          body: GridView.builder(
            padding: EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: guards.length,
            itemBuilder: (context, index) {
              final guard = guards[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuardDetailScreen(guardData: guard),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: guard['imagePath'] != null
                            ? Image.network(
                                guard['imagePath'],
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                              progress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error),
                              )
                            : Icon(Icons.image, size: 80, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(guard['name'], style: TextStyle(fontSize: 16)),
                            Text('ID: ${guard['guardId']}',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddGuardScreen(),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
