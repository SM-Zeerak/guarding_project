import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guarding_project/screens/guardingDetail/guard_detail/guard_detail_page.dart';

class User {
  final String id; // Make sure you have an ID for each user
  final String name;
  final String mobileNo;
  final String imageUrl;
  String currentPosting;
  List<String> postingHistory;  // Ensure it's a list of strings.

  User({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.imageUrl,
    required this.currentPosting,
    required this.postingHistory,
  });


  // Factory constructor to create a User object from Firestore document data
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,  // Use Firestore document ID
      name: data['name'],
      mobileNo: data['mobileNo'],
      imageUrl: data['imageUrl'],
      currentPosting: data['currentPostingAddress'],
      postingHistory: List<String>.from(data['postingHistory'] ?? []),
    );
  }
}


class UsersPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<User>> _fetchUsers() async {
    final querySnapshot = await _firestore.collection('users').get();
    return querySnapshot.docs.map((doc) {
      return User.fromFirestore(doc);  // Create User using fromFirestore
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: FutureBuilder<List<User>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data ?? [];

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.imageUrl),
                ),
                title: Text(user.name),
                subtitle: Text(user.mobileNo),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailPage(user: user),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}