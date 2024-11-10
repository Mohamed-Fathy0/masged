import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:masged/model/maintenance_model.dart';

class RequestFixProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitRequest(MaintenanceRequest request) async {
    try {
      await _firestore.collection('maintenance_requests').add(request.toMap());
      notifyListeners();
    } catch (e) {
      print('Error submitting request: $e');
      rethrow;
    }
  }

  Future<void> updateRequestStatus(String requestId, String newStatus) async {
    try {
      await _firestore
          .collection('maintenance_requests')
          .doc(requestId)
          .update({
        'status': newStatus,
      });
      notifyListeners();
    } catch (e) {
      print('Error updating request status: $e');
      rethrow;
    }
  }

  Future<List<MaintenanceRequest>> fetchRequests() async {
    try {
      final snapshot =
          await _firestore.collection('maintenance_requests').get();
      return snapshot.docs
          .map((doc) => MaintenanceRequest.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching requests: $e');
      rethrow;
    }
  }
}
