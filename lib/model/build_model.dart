// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestBuildingRepair {
  final String uid;
  final String id;
  final String applicantName;
  final String applicantRole;
  final String contactNumber;
  final String mosqueName;
  final String neighborhoodName;
  final String mosqueLocation;
  final String serviceType;
  final String constructionType;
  final String maintenanceType;
  final String facilitiesType;
  final String problemDescription;
  final String importanceLevel;
  final String budget;
  final String fundingType;
  final String hasDonor;
  final String donorContactNumber;
  final String fundingSource;
  final String mosqueAddress;
  final String donorExpected;
  final List<String> attachments;
  final String status;
  final String comment;
  final Timestamp requestTimestamp; // إضافة حقل توقيت الطلب

  RequestBuildingRepair({
    required this.uid,
    required this.id,
    required this.applicantName,
    required this.applicantRole,
    required this.contactNumber,
    required this.mosqueName,
    required this.neighborhoodName,
    required this.mosqueLocation,
    required this.serviceType,
    required this.constructionType,
    required this.maintenanceType,
    required this.facilitiesType,
    required this.problemDescription,
    required this.importanceLevel,
    required this.budget,
    required this.fundingType,
    required this.hasDonor,
    required this.donorContactNumber,
    required this.fundingSource,
    required this.mosqueAddress,
    required this.donorExpected,
    required this.attachments,
    required this.status,
    required this.comment,
    required this.requestTimestamp,
  });

  // تحويل النموذج إلى خريطة لإرسالها إلى Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'id': id,
      'applicantName': applicantName,
      'donorExpected': donorExpected,
      'comment': comment,
      'applicantRole': applicantRole,
      'contactNumber': contactNumber,
      'mosqueName': mosqueName,
      'neighborhoodName': neighborhoodName,
      'mosqueLocation': mosqueLocation,
      'serviceType': serviceType,
      'constructionType': constructionType,
      'maintenanceType': maintenanceType,
      'facilitiesType': facilitiesType,
      'problemDescription': problemDescription,
      'importanceLevel': importanceLevel,
      'budget': budget,
      'fundingType': fundingType,
      'hasDonor': hasDonor,
      'donorContactNumber': donorContactNumber,
      'fundingSource': fundingSource,
      'mosqueAddress': mosqueAddress,
      'attachments': attachments,
      'status': status,
      'requestTimestamp': requestTimestamp, // إضافة توقيت الطلب إلى الخريطة
    };
  }

  // تحويل مستند Firestore إلى نموذج
  factory RequestBuildingRepair.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RequestBuildingRepair(
      uid: data['uid'],
      id: data['id'],
      applicantName: data['applicantName'],
      applicantRole: data['applicantRole'],
      donorExpected: data['donorExpected'],
      contactNumber: data['contactNumber'],
      comment: data['comment'],
      mosqueName: data['mosqueName'],
      neighborhoodName: data['neighborhoodName'],
      mosqueLocation: data['mosqueLocation'],
      serviceType: data['serviceType'],
      constructionType: data['constructionType'],
      maintenanceType: data['maintenanceType'],
      facilitiesType: data['facilitiesType'],
      problemDescription: data['problemDescription'],
      importanceLevel: data['importanceLevel'],
      budget: data['budget'],
      fundingType: data['fundingType'],
      hasDonor: data['hasDonor'],
      donorContactNumber: data['donorContactNumber'],
      fundingSource: data['fundingSource'],
      mosqueAddress: data['mosqueAddress'],
      attachments: List<String>.from(data['attachments']),
      status: data['status'],
      requestTimestamp:
          data['requestTimestamp'] as Timestamp, // قراءة توقيت الطلب من المستند
    );
  }
}
