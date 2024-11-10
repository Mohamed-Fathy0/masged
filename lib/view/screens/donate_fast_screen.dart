import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonateFastScreen extends StatelessWidget {
  const DonateFastScreen({super.key});

  // الروابط
  final String storeLink = 'https://www.masajidzulfi.org.sa/donations/';
  final String donationLink = 'http://ehsan.sa/waqf?org=5358';
  final String websiteLink = 'https://www.masajidzulfi.org.sa/';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التبرع السريع'),
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade50, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLinkCard(
                  title: 'رابط المتجر',
                  icon: Icons.store,
                  url: storeLink,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                _buildLinkCard(
                  title: "تبرع وقف في منصة احسان",
                  icon: Icons.volunteer_activism,
                  url: donationLink,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                _buildLinkCard(
                  title: 'رابط الموقع الإلكتروني',
                  icon: Icons.web,
                  url: websiteLink,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget لبناء كارد للرابط
  Widget _buildLinkCard({
    required String title,
    required IconData icon,
    required String url,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لفتح الرابط
  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }
}
