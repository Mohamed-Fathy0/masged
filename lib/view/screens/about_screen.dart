import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'معلومات عن الجمعية',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF2B547E), // لون أزرق احترافي
        ),
        body: Container(
          color: const Color(0xFFECEFF1), // لون رمادي فاتح لخلفية الصفحة
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildHeader('نبذة عنا:'),
                _buildInfoCard(
                  'نسعى نحو التميز ونجتهد بالمساهمة في تحقيق الأهداف الإستراتيجية لرؤية ۲۰۳۰ من خلال أبعادها الملهمة. تمكين المسؤولية المجتمعية لتمكين أثر أكبر للقطاع غير الربحي. تعزيز القيم الإسلامية والهوية الوطنية عبر المحافظة على القيم والإرث التاريخي الإسلامي.',
                ),
                _buildHeader('الأهداف:'),
                _buildInfoCard(
                  '''• العمل على سد الإحتياج من بناء المساجد والمصليات المؤقتة.
• بناء المساجد والجوامع النموذجية.
• ترميم المساجد والجوامع.
• صيانة المساجد والجوامع وتأمين احتياجاتها من (الفرش، التكييف، التعطير، ...الخ).
• المساهمة في العناية بمساجد الطرق التي يرتادها المسافرون.
• تأمين احتياجات المساجد من التقنية لتبليغ العلم الشرعي.''',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _buildVisionMission('الرؤية',
                            'التميز في تقديم خدمات العناية ببيوت الله.')),
                    const SizedBox(width: 16),
                    Expanded(
                        child: _buildVisionMission('الرسالة',
                            'تقديم خدمات متكاملة للمساجد بجودة عالية عبر برامج متخصصة في العناية والصيانة والتطوير.')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2B547E), // لون أزرق
        ),
      ),
    );
  }

  Widget _buildInfoCard(String content) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: const TextStyle(
            fontFamily: "Arial",
            fontSize: 16,
            color: Color(0xFF37474F), // لون رمادي داكن
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _buildVisionMission(String title, String content) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  title == 'الرؤية' ? Icons.visibility : Icons.remove_red_eye,
                  color: const Color(0xFF2B547E), // لون أزرق
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37474F), // لون رمادي داكن
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF37474F), // لون رمادي داكن
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
