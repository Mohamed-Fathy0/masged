// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class CareRequest {
  final String id;
  final String uid;
  final String applicantName;
  final String applicantRole;
  final String contactNumber;
  final String mosqueName;
  final String neighborhoodName;
  final String mosqueAddress;
  final Map<String, Map<String, int>> servicesAndItems;
  final Map<String, int> additionalItems;
  final String? donationAmount;
  final String? donorContactNumberController;
  final String? donorExpectedontroller;
  final String status;
  final String comment;
  final Timestamp requestTimestamp;

  CareRequest({
    required this.id,
    required this.uid,
    required this.applicantName,
    required this.applicantRole,
    required this.contactNumber,
    required this.mosqueName,
    required this.neighborhoodName,
    required this.mosqueAddress,
    required this.servicesAndItems,
    required this.additionalItems,
    this.donationAmount,
    this.donorContactNumberController,
    this.donorExpectedontroller,
    required this.status,
    required this.comment,
    required this.requestTimestamp,
  });

  // تحويل الكائن إلى خريطة لتخزينه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'applicantName': applicantName,
      'applicantRole': applicantRole,
      'contactNumber': contactNumber,
      'mosqueName': mosqueName,
      'neighborhoodName': neighborhoodName,
      'mosqueAddress': mosqueAddress,
      'servicesAndItems': servicesAndItems.map(
        (key, value) => MapEntry(key, value.map((k, v) => MapEntry(k, v))),
      ),
      'additionalItems': additionalItems,
      'donationAmount': donationAmount,
      'donorContactNumberController': donorContactNumberController,
      'donorExpectedontroller': donorExpectedontroller,
      'status': status,
      'comment': comment,
      'requestTimestamp': requestTimestamp,
    };
  }

  // إنشاء كائن CareRequest من مستند Firestore
  static CareRequest fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CareRequest(
      id: doc.id,
      uid: data['uid'] as String,
      applicantName: data['applicantName'] as String,
      applicantRole: data['applicantRole'] as String,
      contactNumber: data['contactNumber'] as String,
      mosqueName: data['mosqueName'] as String,
      neighborhoodName: data['neighborhoodName'] as String,
      mosqueAddress: data['mosqueAddress'] as String,
      servicesAndItems:
          Map<String, Map<String, int>>.from(data['servicesAndItems']),
      additionalItems: Map<String, int>.from(data['additionalItems']),
      donationAmount: data['donationAmount'] as String?,
      donorContactNumberController:
          data['donorContactNumberController'] as String?,
      donorExpectedontroller: data['donorExpectedontroller'] as String?,
      status: "status",
      comment: "comment",
      requestTimestamp: "requestTimestamp" as Timestamp,
    );
  }

  // إنشاء كائن CareRequest من خريطة
  static CareRequest fromMap(Map<String, dynamic> map) {
    return CareRequest(
      id: map['id'] as String,
      uid: map['uid'] as String,
      applicantName: map['applicantName'] as String,
      applicantRole: map['applicantRole'] as String,
      contactNumber: map['contactNumber'] as String,
      mosqueName: map['mosqueName'] as String,
      neighborhoodName: map['neighborhoodName'] as String,
      mosqueAddress: map['mosqueAddress'] as String,
      servicesAndItems: (map['servicesAndItems'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as Map<String, dynamic>).map((k, v) => MapEntry(k, v as int)),
        ),
      ),
      additionalItems: (map['additionalItems'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as int),
      ),
      donationAmount: map['donationAmount'] as String?,
      donorContactNumberController:
          map['donorContactNumberController'] as String?,
      donorExpectedontroller: map['donorExpectedontroller'] as String?,
      status: map['status'] as String,
      comment: map['comment'] as String,
      requestTimestamp: map['requestTimestamp'] as Timestamp,
    );
  }
}
