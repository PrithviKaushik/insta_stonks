import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class UsernameProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _username;
  String? get username => _username;
  String? _biography;
  String? get biography => _biography;
  String? _profilePicUrlHd;
  String? get profilePicUrlHd => _profilePicUrlHd;

  Future<void> setUsername(String newUsername) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('profiles').doc(newUsername).set({
      'username': newUsername,
      'uid': uid,
    }, SetOptions(merge: true));

    _username = newUsername;
    notifyListeners();
  }

  Future<void> checkUsername() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // Try to find a profile that has the matching UID
    final query =
        await _firestore
            .collection('profiles')
            .where('uid', isEqualTo: uid)
            .limit(1)
            .get();

    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      _username = data['username'];
      _biography = data['biography'];
      _profilePicUrlHd = data['profile_pic_url_hd'];
    } else {
      _username = null;
      _biography = null;
      _profilePicUrlHd = null;
    }

    notifyListeners();
  }

  void reset() {
    _username = null;
    notifyListeners();
  }
}
