import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('خدمات الجمعية',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'قائمة الخدمات المقدمة',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildServiceCard(
                title: 'خدمات العنــاية',
                description:
                    "للحفاظ على نظافة وترتيب المساجد وتوفير مستلزمات النظافة لضمان جاهزيتها لاستقبال المصلين و لتعزيز الروحانية والطمأنينة داخل المسجد",
                icon: Icons.cleaning_services,
              ),
              _buildServiceCard(
                title: 'خدمات الصيــانة',
                description:
                    "خدمة الصيانة توفير خدمة الصيانه اللازمه بشكل منتظم من خلال أعمال الصيانة المتكاملة حفاظاً على جودة المرافق وتوفير جو هادئ ومريح للمصلين على مدار العام",
                icon: Icons.build,
              ),
              _buildServiceCard(
                title: 'خدمات الترميــم',
                description:
                    " إصلاح المساجد القديمة أو المتضررة  بهدف ضمان استمرارية وظيفتها كمكان للعبادة. يشمل الترميم إصلاح الأجزاء التالفة حتى لا تؤثر على راحة المصلين وللتأكد من  سلامة البنية التحتية للمسجد",
                icon: Icons.architecture,
              ),
              _buildServiceCard(
                title: 'خدمات الفـرش',
                description:
                    "توفر هذه الخدمة اختيار وتركيب سجاد يتناسب مع احتياجات المسجد لضمان بيئة مناسبة للعبادة",
                icon: Icons.weekend,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
      {required String title,
      required String description,
      required IconData icon}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
