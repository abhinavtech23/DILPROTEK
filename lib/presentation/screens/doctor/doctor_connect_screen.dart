import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorConnectScreen extends StatefulWidget {
  const DoctorConnectScreen({super.key});
  @override
  State<DoctorConnectScreen> createState() => _DoctorConnectScreenState();
}

class _DoctorConnectScreenState extends State<DoctorConnectScreen> {
  final _idCtrl = TextEditingController();
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser?.uid;

  void _link() async {
    if (_uid == null) return;
    await _db.collection('users').doc(_uid).set({
      "doctors": FieldValue.arrayUnion([_idCtrl.text])
    }, SetOptions(merge: true));
    _idCtrl.clear();
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Connect")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Grant access to your Cardiologist"),
            const SizedBox(height: 10),
            TextField(controller: _idCtrl, decoration: const InputDecoration(labelText: "Enter Doctor ID")),
            ElevatedButton(onPressed: _link, child: const Text("Authorize")),
            const SizedBox(height: 20),
            const Text("Authorized Doctors:"),
            if (_uid != null)
              StreamBuilder(
                stream: _db.collection('users').doc(_uid).snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) return const SizedBox();
                  final docs = snap.data!.data()?['doctors'] ?? [];
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(docs[i]),
                      trailing: const Icon(Icons.check, color: Colors.green),
                    ),
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}