import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FetchUserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Fetch user data from Firestore using the user's email (or UID)
        DocumentSnapshot snapshot = await _firestore
            .collection('users') // Make sure to adjust the collection name
            .doc(user.uid) // Assuming the user's UID is used as the document ID
            .get();

        if (snapshot.exists) {
          // Return the user data (you can modify this based on your database structure)
          return snapshot.data() as Map<String, dynamic>;
        } else {
          throw Exception('User not found');
        }
      } else {
        throw Exception('No user logged in');
      }
    } catch (e) {
      rethrow; // Propagate the error
    }
  }
}
