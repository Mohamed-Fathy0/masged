// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceRequest {
  final String id;
  final String uid;
  final String applicantName;
  final String applicantRole;
  final String contactNumber;
  final String mosqueName;
  final String neighborhoodName;
  final String mosqueLocation;
  final String maintenanceStatus;
  // final String requestTypeM;
  final Map<String, Map<String, int>> servicesAndItems;

  final String problemDescription;
  final String fundingType;
  final String hasDonor;
  final String donorExpected;
  final String? donorContactNumber;
  final String fundingSource;
  final String? mosqueAddress;
  final List<String>? attachments;
  final String status;
  final String comment;
  final Timestamp requestTimestamp; // إضافة حقل توقيت الطلب

  MaintenanceRequest({
    required this.id,
    required this.uid,
    required this.applicantName,
    required this.applicantRole,
    required this.contactNumber,
    required this.mosqueName,
    required this.neighborhoodName,
    required this.mosqueLocation,
    required this.maintenanceStatus,
    required this.servicesAndItems,
    required this.problemDescription,
    required this.fundingType,
    required this.hasDonor,
    required this.donorExpected,
    this.donorContactNumber,
    required this.fundingSource,
    this.mosqueAddress,
    this.attachments,
    this.status = 'waiting',
    required this.comment,
    required this.requestTimestamp,
  });

  // تحويل كائن إلى خريطة لتخزينه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'applicantName': applicantName,
      'applicantRole': applicantRole,
      'contactNumber': contactNumber,
      'mosqueName': mosqueName,
      'donorExpected': donorExpected,
      'servicesAndItems': servicesAndItems.map(
        (key, value) => MapEntry(key, value.map((k, v) => MapEntry(k, v))),
      ),
      'neighborhoodName': neighborhoodName,
      'mosqueLocation': mosqueLocation,
      'maintenanceStatus': maintenanceStatus,
      // 'requestTypeM': requestTypeM,
      'problemDescription': problemDescription,
      'fundingType': fundingType,
      'hasDonor': hasDonor,
      'donorContactNumber': donorContactNumber,
      'fundingSource': fundingSource,
      'mosqueAddress': mosqueAddress,
      'attachments': attachments,
      'status': status,
      'comment': comment,
      'requestTimestamp': requestTimestamp,
    };
  }

  factory MaintenanceRequest.fromMap(Map<String, dynamic> map) {
    return MaintenanceRequest(
      id: map['id'],
      uid: map['uid'],
      applicantName: map['applicantName'] ?? '',
      donorExpected: map['donorExpected'] ?? '',
      applicantRole: map['applicantRole'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      mosqueName: map['mosqueName'] ?? '',
      comment: map['comment'] ?? '',
      neighborhoodName: map['neighborhoodName'] ?? '',
      mosqueLocation: map['mosqueLocation'] ?? '',
      maintenanceStatus: map['maintenanceStatus'] ?? '',
      //    requestTypeM: map['requestTypeM'] ?? '',
      problemDescription: map['problemDescription'] ?? '',
      fundingType: map['fundingType'] ?? '',
      hasDonor: map['hasDonor'] ?? false,
      donorContactNumber: map['donorContactNumber'],
      servicesAndItems: (map['servicesAndItems'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as Map<String, dynamic>).map((k, v) => MapEntry(k, v as int)),
        ),
      ),
      fundingSource: map['fundingSource'] ?? '',
      mosqueAddress: map['mosqueAddress'],
      attachments: List<String>.from(map['attachments'] ?? []),
      status: map['status'] ?? '',
      requestTimestamp: map['requestTimestamp'] ?? '',
    );
  }
  // إنشاء كائن MaintenanceRequest من مستند Firestore
  static MaintenanceRequest fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return MaintenanceRequest(
      id: doc.id,
      uid: data['uid'] as String,
      applicantName: data['applicantName'] as String,
      donorExpected: data['donorExpected'] as String,
      applicantRole: data['applicantRole'] as String,
      comment: data['comment'] as String,
      servicesAndItems:
          Map<String, Map<String, int>>.from(data['servicesAndItems']),
      contactNumber: data['contactNumber'] as String,
      mosqueName: data['mosqueName'] as String,
      neighborhoodName: data['neighborhoodName'] as String,
      mosqueLocation: data['mosqueLocation'] as String,
      maintenanceStatus: data['maintenanceStatus'] as String,
      //    requestTypeM: data['requestTypeM'] as String,
      problemDescription: data['problemDescription'] as String,
      fundingType: data['fundingType'] as String,
      hasDonor: data['hasDonor'] as String,
      donorContactNumber: data['donorContactNumber'] as String?,
      fundingSource: data['fundingSource'] as String,
      mosqueAddress: data['mosqueAddress'] as String?,
      attachments: List<String>.from(data['attachments'] ?? []),
      status: data['status'] ?? 'waiting',
      requestTimestamp: data['requestTimestamp'] ?? 'waiting',
    );
  }
}
