import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  Future<bool> linkDoctor(String doctorId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      
      await _db.collection('users').doc(user.uid).set({
        'authorized_doctors': FieldValue.arrayUnion([doctorId]),
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      
      return false;
    }
  }
  Future<void> unlinkDoctor(String doctorId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).update({
      'authorized_doctors': FieldValue.arrayRemove([doctorId])
    });
  }
  Stream<DocumentSnapshot> getMyDoctorConnections() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _db.collection('users').doc(user.uid).snapshots();
  }
}