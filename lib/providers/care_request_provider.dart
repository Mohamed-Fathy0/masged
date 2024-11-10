import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:masged/model/care_model.dart';

class CareRequestProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitRequest(CareRequest request) async {
    try {
      await _firestore.collection('care_requests').add(request.toMap());
      notifyListeners();
    } catch (e) {
      print('Error submitting request: $e');
      rethrow;
    }
  }

  Future<List<CareRequest>> fetchRequests() async {
    try {
      final snapshot = await _firestore.collection('care_requests').get();
      return snapshot.docs
          .map((doc) => CareRequest.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching requests: $e');
      rethrow;
    }
  }
}
