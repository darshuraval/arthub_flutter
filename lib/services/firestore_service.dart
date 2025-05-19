import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a document — auto-generate ID if [docId] is null
  Future<String> createDocument(String collection, Map<String, dynamic> data, {String? docId}) async {
    if (docId != null) {
      await _firestore.collection(collection).doc(docId).set(data);
      return docId;
    } else {
      final docRef = await _firestore.collection(collection).add(data);
      return docRef.id;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentById(String collection, String docId) async {
    return await _firestore.collection(collection).doc(docId).get();
  }

  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteDocument(String collection, String docId) async {
    await _firestore.collection(collection).doc(docId).delete();
  }

  Future<List<Map<String, dynamic>>> getAllDocuments(String collection) async {
    final querySnapshot = await _firestore.collection(collection).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getAllDocumentsWithId(String collection) async {
    final querySnapshot = await _firestore.collection(collection).get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> findDocumentsByField( String collection, String field, String value) async {
    final querySnapshot = await _firestore.collection(collection).where(field, isEqualTo: value).get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getDocumentsIdsByField(String collection, String field, String value) async {
    final querySnapshot = await _firestore.collection(collection).where(field, isEqualTo: value).get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }
  Future addFieldInDocument(String collection, String docId, String field, dynamic value) async {
    await _firestore.collection(collection).doc(docId).update({field: value});
  }
}


// await FirestoreService().createDocument('users', 'user123', {
//   'name': 'John Doe',
//   'email': 'john@example.com',
// });


// final doc = await FirestoreService().getDocumentById('users', 'user123');
// final data = doc.data();
// print(data?['name']); // Output: John Doe


// await FirestoreService().updateDocument('users', 'user123', {
//   'email': 'new_email@example.com',
// });

// await FirestoreService().deleteDocument('users', 'user123');


// final users = await FirestoreService().getAllDocuments('users');
// for (var user in users) {
//   print(user['name']);
// }


// final users = await FirestoreService().getAllDocumentsWithId('users');
// for (var user in users) {
//   print('User ID: ${user['id']} Name: ${user['name']}');
// }


// final results = await FirestoreService().findDocumentsByField('users', 'email', 'john@example.com');
// for (var user in results) {
//   print(user['name']);
// }


// class UserListScreen extends StatefulWidget {
//   @override
//   _UserListScreenState createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<UserListScreen> {
//   List<Map<String, dynamic>> _users = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadUsers();
//   }

//   Future<void> _loadUsers() async {
//     final users = await FirestoreService().getAllDocumentsWithId('users');
//     setState(() {
//       _users = users;
//       _loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return ListView.builder(
//       itemCount: _users.length,
//       itemBuilder: (context, index) {
//         final user = _users[index];
//         return ListTile(
//           title: Text(user['name']),
//           subtitle: Text(user['email']),
//         );
//       },
//     );
//   }
// }
