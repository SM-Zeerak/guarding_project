// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirebaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> addGuard(Map<String, dynamic> guardData) async {
//     try {
//       await _firestore.collection('guards').add({
//         'name': guardData['name'],
//         'mobile': guardData['mobile'],
//         'address': guardData['address'],
//         'cnic': guardData['cnic'],
//         'expiryDate': guardData['expiryDate'],
//         'dob': guardData['dob'],
//         'guardId': guardData['guardId'],
//         'imagePath': guardData['imagePath'],
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       throw Exception('Failed to add guard: $e');
//     }
//   }

//   Future<List<Map<String, dynamic>>> getGuards() async {
//     try {
//       QuerySnapshot snapshot = await _firestore.collection('guards').get();
//       return snapshot.docs.map((doc) {
//         return {
//           'name': doc['name'],
//           'mobile': doc['mobile'],
//           'address': doc['address'],
//           'cnic': doc['cnic'],
//           'expiryDate': doc['expiryDate'],
//           'dob': doc['dob'],
//           'guardId': doc['guardId'],
//           'imagePath': doc['imagePath'],
//           'timestamp': doc['timestamp'],
//         };
//       }).toList();
//     } catch (e) {
//       throw Exception('Failed to fetch guards: $e');
//     }
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addGuard(Map<String, dynamic> guardData) async {
    try {
      await _firestore.collection('guards').add({
        'name': guardData['name'],
        'mobile': guardData['mobile'],
        'address': guardData['address'],
        'cnic': guardData['cnic'],
        'expiryDate': guardData['expiryDate'],
        'dob': guardData['dob'],
        'guardId': guardData['guardId'],
        'imagePath': guardData['imagePath'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add guard: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getGuards() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('guards').get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id, // Include document ID for future updates or deletes
          'name': doc['name'],
          'mobile': doc['mobile'],
          'address': doc['address'],
          'cnic': doc['cnic'],
          'expiryDate': doc['expiryDate'],
          'dob': doc['dob'],
          'guardId': doc['guardId'],
          'imagePath': doc['imagePath'],
          'timestamp': doc['timestamp'],
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch guards: $e');
    }
  }

  Future<void> updateGuard(String docId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('guards').doc(docId).update(updatedData);
    } catch (e) {
      throw Exception('Failed to update guard: $e');
    }
  }

  Future<void> deleteGuard(String docId) async {
    try {
      await _firestore.collection('guards').doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete guard: $e');
    }
  }
}
