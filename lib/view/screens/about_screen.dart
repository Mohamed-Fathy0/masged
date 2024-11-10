import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('معلومات عن الجمعية'),
          backgroundColor: const Color(0xFF004B6F), // لون أزرق داكن
        ),
        body: Container(
          color: const Color(0xFFF5F5DC), // لون بيج فاتح للخلفية
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildHeader('نبذة عنا:'),
                _buildInfoCard(
                  'تسعى نحو التميز ونجتهد بالمساهمة في تحقيق الأهداف الإستراتيجية لرؤية۲۰۳۰ من خلال أبعادها الملهمة .تمكين المسؤولية المجتمعية لتمكين أثر أكبر للقطاع الغير ربحي . تعزيز القيم الإسلامية والهوية الوطنية عبر المحافظة على القيم والإرث التاريخي الإسلامي .',
                ),
                _buildHeader('الأهداف:'),
                _buildInfoCard(
                  '''• العمل على سد الإحتياج من بناء المساجد والمصليات المؤقتة.
• بناء المساجد والجوامع النموذجية.
• ترميم المساجد والجوامع.
• صيانة المساجد والجوامع وتأمين احتياجاتها من ( الفرش ، التكييف ، التعطير ، ...الخ).
• المساهمة في العناية بمساجد الطرق التي يرتادها المسافرون.
• تأمين احتياجات المساجد من التقنية لتبليغ العلم الشرعي.''',
                ),
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
                // _buildHeader('نبذة عن الجمعية:'),
                // _buildInfoCard(
                //   'نسعى نحو التميز ونجتهد للمساهمة في تحقيق الأهداف الاستراتيجية لرؤية ٢٠٣٠. تمكين المسؤولية المجتمعية لتحفيز أكبر  للمشاركة في الأوقاف والتبرعات، والمساهمة الوطنية في المحافظة على التراث الإسلامي.',
                // ),
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
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B4513), // لون بيج غامق
        ),
      ),
    );
  }

  Widget _buildInfoCard(String content) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: const TextStyle(
            fontFamily: "Arial",
            fontSize: 16,
            color: Colors.black87,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _buildVisionMission(String title, String content) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(title == 'الرؤية' ? Icons.visibility : Icons.message,
                    color: const Color(0xFF004B6F)), // أيقونة بلون أزرق
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B4513), // لون بيج غامق
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
