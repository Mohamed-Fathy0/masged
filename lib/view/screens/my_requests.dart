import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class MyRequests extends StatefulWidget {
  const MyRequests({super.key});

  @override
  _MyRequestsState createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
  }

  Future<List<Map<String, dynamic>>> _getUserRequests() async {
    if (currentUser == null) return [];

    final uid = currentUser!.uid;
    List<Map<String, dynamic>> allRequests = [];

    final careRequestsSnapshot = await _firestore
        .collection('care_requests')
        .where('uid', isEqualTo: uid)
        .get();
    final maintenanceRequestsSnapshot = await _firestore
        .collection('maintenance_requests')
        .where('uid', isEqualTo: uid)
        .get();
    final repairRequestsSnapshot = await _firestore
        .collection('repair_requests')
        .where('uid', isEqualTo: uid)
        .get();
    final prayerRoomRequestSnapshot = await _firestore
        .collection('prayer_room_requests')
        .where('uid', isEqualTo: uid)
        .get();

    allRequests.addAll(careRequestsSnapshot.docs.map((doc) {
      final data = doc.data();
      data['requestType'] = 'careRequest';
      return data;
    }));

    allRequests.addAll(maintenanceRequestsSnapshot.docs.map((doc) {
      final data = doc.data();
      data['requestType'] = 'maintenanceRequest';
      return data;
    }));

    allRequests.addAll(repairRequestsSnapshot.docs.map((doc) {
      final data = doc.data();
      data['requestType'] = 'buildingRepair';
      return data;
    }));

    allRequests.addAll(prayerRoomRequestSnapshot.docs.map((doc) {
      final data = doc.data();
      data['requestType'] = 'prayerRoom';
      return data;
    }));

    return allRequests;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('طلباتي'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getUserRequests(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('حدث خطأ أثناء جلب الطلبات'));
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(child: Text('لا يوجد طلبات لهذا المستخدم'));
            } else if (snapshot.hasData) {
              final requests = snapshot.data!;
              return ListView.builder(
                itemCount: requests.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemBuilder: (context, index) {
                  final request = requests[index];
                  final requestType = request['requestType'] ?? 'unknown';
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const Icon(Icons.assignment_turned_in,
                          color: Colors.teal),
                      title: Text(
                        request['mosqueName'] ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // تكبير حجم الخط
                            color: Colors.black),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request['applicantName'] ?? 'الاسم غير متوفر',
                            style: const TextStyle(
                              fontSize: 16, // تكبير الخط للنصوص
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4), // مساحة صغيرة بين النصوص
                          Text(
                            'نوع الطلب: ${_getRequestTypeLabel(requestType)}',
                            style: const TextStyle(
                              fontSize: 14, // تحديد حجم الخط لنوع الطلب
                              color: Colors.blueGrey, // لون مختلف لنوع الطلب
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.teal),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestDetailsScreen(
                              requestData: request,
                              requestType: requestType,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('لا يوجد بيانات'));
            }
          },
        ),
      ),
    );
  }

  String _getRequestTypeLabel(String requestType) {
    switch (requestType) {
      case 'careRequest':
        return 'طلب عناية';
      case 'maintenanceRequest':
        return 'طلب صيانة';
      case 'buildingRepair':
        return 'طلب بناء وترميم';
      case 'prayerRoom':
        return 'طلب مصلى مؤقت';
      default:
        return 'نوع غير معروف';
    }
  }
}

class RequestDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> requestData;
  final String requestType;

  const RequestDetailsScreen({
    super.key,
    required this.requestData,
    required this.requestType,
  });

  @override
  String formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل الطلب'),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: _buildRequestDetails(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRequestDetails() {
    List<Widget> details = [];

    const textStyleBold = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
    const textStyleNormal = TextStyle(fontSize: 16);

    details.add(_buildDetailCard('اسم المقدم:', requestData['applicantName'],
        textStyleBold, textStyleNormal));
    details.add(_buildDetailCard('صفة المقدم:', requestData['applicantRole'],
        textStyleBold, textStyleNormal));
    details.add(_buildDetailCard('رقم التواصل:', requestData['contactNumber'],
        textStyleNormal, textStyleNormal));
    if (requestData['mosqueName'] != null) {
      details.add(_buildDetailCard('اسم المسجد:', requestData['mosqueName'],
          textStyleNormal, textStyleNormal));
    }
    if (requestData['neighborhoodName'] != null) {
      details.add(_buildDetailCard('اسم الحي:', requestData['neighborhoodName'],
          textStyleNormal, textStyleNormal));
    }
    details.add(_buildDetailCard('موقع المسجد:', requestData['mosqueAddress'],
        textStyleNormal, textStyleNormal));

    details.add(const SizedBox(height: 20));

    switch (requestType) {
      case 'buildingRepair':
        details.addAll(_buildBuildingRepairDetails(textStyleNormal));
        break;
      case 'careRequest':
        details.addAll(_buildCareRequestDetails(textStyleNormal));
        break;
      case 'maintenanceRequest':
        details.addAll(_buildMaintenanceRequestDetails(textStyleNormal));
        break;
      case 'prayerRoom':
        details.addAll(_buildPrayerRoomDetails(textStyleNormal));
        break;
      default:
        details.add(const Text(
          'نوع الطلب غير معروف.',
          style: textStyleNormal,
        ));
    }

    return details;
  }

  Widget _buildDetailCard(
      String label, dynamic value, TextStyle labelStyle, TextStyle valueStyle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        title: Text(label, style: labelStyle),
        subtitle: Text(value?.toString() ?? 'غير متوفر', style: valueStyle),
      ),
    );
  }

  List<Widget> _buildBuildingRepairDetails(TextStyle textStyle) {
    List<Widget> details = [];

    details.add(_buildDetailCard(
        'وصف الطلب:', requestData['problemDescription'], textStyle, textStyle));
    if (requestData['fundingType'] != null) {
      details.add(_buildDetailCard(
          'نوع التمويل:', requestData['fundingType'], textStyle, textStyle));
    }

    if (requestData['serviceType'] != null) {
      details.add(_buildDetailCard(
          'نوع الخدمة:', requestData['serviceType'], textStyle, textStyle));
    }
    if (requestData['hasDonor'] != null) {
      details.add(_buildDetailCard(
          'هل يوجد متبرع:', requestData['hasDonor'], textStyle, textStyle));
    }
    if (requestData['donorContactNumber'] != null &&
        requestData['donorContactNumber'] != "") {
      details.add(_buildDetailCard('مبلغ التبرع:',
          requestData['donorContactNumber'], textStyle, textStyle));
    }
    if (requestData['donorExpected'] != null &&
        requestData['donorExpected'] != "") {
      details.add(_buildDetailCard('القيمة المتوقعة:',
          requestData['donorExpected'], textStyle, textStyle));
    }
    if (requestData['status'] != null) {
      details.add(_buildDetailCard(
          'حالة الطلب:', requestData['status'], textStyle, textStyle));
    }
    if (requestData['comment'] != null) {
      details.add(_buildDetailCard(
          'ملاحظة:', requestData['comment'], textStyle, textStyle));
    }
    if (requestData['requestTimestamp'] != null) {
      final timestamp = requestData['requestTimestamp'] as Timestamp;
      final formattedDate = formatTimestamp(timestamp);
      details.add(_buildDetailCard(
          'تاريخ تقديم الطلب:', formattedDate, textStyle, textStyle));
    }

    return details;
  }

  List<Widget> _buildCareRequestDetails(TextStyle textStyle) {
    List<Widget> details = [];
    if (requestData['servicesAndItems'] != null) {
      final servicesAndItems =
          requestData['servicesAndItems'] as Map<String, dynamic>;

      servicesAndItems.forEach((service, items) {
        if (items is Map<String, dynamic>) {
          final itemMap = items.cast<String, int>();
          final itemsList = itemMap.entries
              .where((e) => e.value > 0)
              .map((e) => '${e.key}: ${e.value}')
              .join(', ');

          if (itemsList.isNotEmpty) {
            details.add(_buildDetailCard(
                'الخدمة: $service', itemsList, textStyle, textStyle));
          }
        }
      });
    }

    if (requestData['additionalItems'] != null) {
      details.add(Text('البنود الإضافية:', style: textStyle));

      final additionalItems =
          requestData['additionalItems'] as Map<String, dynamic>;
      final additionalItemsMap = additionalItems.cast<String, int>();
      additionalItemsMap.forEach((key, value) {
        if (value > 0) {
          details.add(Text('$key: $value', style: textStyle));
        }
      });
    }

    if (requestData['donorContactNumber'] != null &&
        requestData['donorContactNumber'] != "") {
      details.add(_buildDetailCard('مبلغ التبرع:',
          requestData['donorContactNumber'], textStyle, textStyle));
    }
    if (requestData['donorExpected'] != null &&
        requestData['donorExpected'] != "") {
      details.add(_buildDetailCard('القيمة المتوقعة:',
          requestData['donorExpected'], textStyle, textStyle));
    }

    if (requestData['status'] != null) {
      details.add(_buildDetailCard(
          'حالة الطلب:', requestData['status'], textStyle, textStyle));
    }
    if (requestData['comment'] != null) {
      details.add(_buildDetailCard(
          'ملاحظة:', requestData['comment'], textStyle, textStyle));
    }
    if (requestData['requestTimestamp'] != null) {
      final timestamp = requestData['requestTimestamp'] as Timestamp;
      final formattedDate = formatTimestamp(timestamp);
      details.add(_buildDetailCard(
          'تاريخ تقديم الطلب:', formattedDate, textStyle, textStyle));
    }

    return details;
  }

  List<Widget> _buildMaintenanceRequestDetails(TextStyle textStyle) {
    List<Widget> details = [];
    if (requestData['requestTimestamp'] != null) {
      final timestamp = requestData['requestTimestamp'] as Timestamp;
      final formattedDate = formatTimestamp(timestamp);
      details.add(_buildDetailCard(
          'تاريخ تقديم الطلب:', formattedDate, textStyle, textStyle));
    }
    if (requestData['problemDescription'] != null) {
      details.add(_buildDetailCard('وصف المشكلة:',
          requestData['problemDescription'], textStyle, textStyle));
    }

    if (requestData['servicesAndItems'] != null) {
      final servicesAndItems =
          requestData['servicesAndItems'] as Map<String, dynamic>;

      servicesAndItems.forEach((service, items) {
        if (items is Map<String, dynamic>) {
          final itemMap = items.cast<String, int>();
          final itemsList = itemMap.entries
              .where((e) => e.value > 0)
              .map((e) => '${e.key}: ${e.value}')
              .join(', ');

          if (itemsList.isNotEmpty) {
            details.add(_buildDetailCard(
                'الخدمة: $service', itemsList, textStyle, textStyle));
          }
        }
      });
    }
    // if (requestData['requestTypeM'] != null) {
    //   details.add(_buildDetailCard(
    //       'نوع الصيانة:', requestData['requestTypeM'], textStyle, textStyle));
    // }
    // تحقق إذا كان requestTypeM هو قائمة
    if (requestData['requestTypeM'] != null) {
      String requestTypeDisplay;

      if (requestData['requestTypeM'] is List) {
        // إذا كان قائمة، انضم العناصر بفاصلة
        requestTypeDisplay = (requestData['requestTypeM'] as List).join(', ');
      } else {
        // إذا لم يكن قائمة، اعرضه كالنص العادي
        requestTypeDisplay = requestData['requestTypeM'].toString();
      }

      details.add(_buildDetailCard(
          'نوع الصيانة:', requestTypeDisplay, textStyle, textStyle));
    }

    if (requestData['fundingType'] != null) {
      details.add(_buildDetailCard(
          'نوع التمويل:', requestData['fundingType'], textStyle, textStyle));
    }
    if (requestData['hasDonor'] != null) {
      details.add(_buildDetailCard(
          'هل يوجد متبرع:', requestData['hasDonor'], textStyle, textStyle));
    }
    if (requestData['donorContactNumber'] != null &&
        requestData['donorContactNumber'] != "") {
      details.add(_buildDetailCard('مبلغ التبرع:',
          requestData['donorContactNumber'], textStyle, textStyle));
    }
    if (requestData['donorExpected'] != null &&
        requestData['donorExpected'] != "") {
      details.add(_buildDetailCard('القيمة المتوقعة:',
          requestData['donorExpected'], textStyle, textStyle));
    }
    if (requestData['status'] != null) {
      details.add(_buildDetailCard(
          'حالة الطلب:', requestData['status'], textStyle, textStyle));
    }
    if (requestData['comment'] != null) {
      details.add(_buildDetailCard(
          'ملاحظة:', requestData['comment'], textStyle, textStyle));
    }
    if (requestData['requestTimestamp'] != null) {
      final timestamp = requestData['requestTimestamp'] as Timestamp;
      final formattedDate = formatTimestamp(timestamp);
      details.add(_buildDetailCard(
          'تاريخ تقديم الطلب:', formattedDate, textStyle, textStyle));
    }

    return details;
  }

  List<Widget> _buildPrayerRoomDetails(TextStyle textStyle) {
    List<Widget> details = [];

    if (requestData['address'] != null) {
      details.add(_buildDetailCard(
          'العنوان', requestData['address'], textStyle, textStyle));
    }
    if (requestData['durationDays'] != null) {
      details.add(_buildDetailCard(
          'عدد الأيام', requestData['durationDays'], textStyle, textStyle));
    }
    if (requestData['timestamp'] != null) {
      final timestamp = requestData['timestamp'] as Timestamp;
      final formattedDate = formatTimestamp(timestamp);
      details.add(_buildDetailCard(
          'تاريخ البداية:', formattedDate, textStyle, textStyle));
    }
    if (requestData['endDate'] != null) {
      final timestamp = requestData['endDate'] as Timestamp;
      final formattedDate = formatTimestamp(timestamp);
      details.add(_buildDetailCard(
          'تاريخ النهاية:', formattedDate, textStyle, textStyle));
    }
    if (requestData['status'] != null) {
      details.add(_buildDetailCard(
          'حالة الطلب:', requestData['status'], textStyle, textStyle));
    }

    if (requestData['timestamp'] != null) {
      final timestamp = requestData['timestamp'] as Timestamp;
      final formattedDate = formatTimestamp(timestamp);
      details.add(_buildDetailCard(
          'تاريخ تقديم الطلب:', formattedDate, textStyle, textStyle));
    }

    return details;
  }
}
