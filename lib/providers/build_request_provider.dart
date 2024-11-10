import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:masged/model/build_model.dart';

class BuildRequestProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRequest(RequestBuildingRepair request) async {
    try {
      await _firestore.collection('repair_requests').add(request.toMap());
      notifyListeners();
    } catch (e) {
      // Handle any errors here
      print('Failed to add request: $e');
    }
  }
}
