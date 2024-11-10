import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Widget _buildWebsiteContact(String websiteLink) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => _launchUrl(websiteLink),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.web, color: Colors.white, size: 28),
              Text(
                "زر موقعنا الإلكتروني",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التواصل'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildWebsiteContact('https://www.masajidzulfi.org.sa/'),
              _buildContactCard(
                title: 'رقم الهاتف',
                icon: Icons.phone,
                content: '+966 505 383 833',
                onTap: () => _launchUrl('tel:+966505383833'),
              ),
              _buildContactCard(
                title: 'البريد الإلكتروني',
                icon: Icons.email,
                content: 'almasajid5358@gmail.com',
                onTap: () => _launchUrl('mailto:almasajid5358@gmail.com'),
              ),
              _buildContactCard(
                onTap: () =>
                    _launchUrl('https://maps.app.goo.gl/t6BXortbxeeJxNwE7'),
                title: 'العنوان',
                icon: Icons.location_on,
                content: 'محافظة الزلفي _ حي الفاروق',
              ),
              _buildContactCardWithSvg(
                title: 'منصة اكس',
                svgAsset: 'assets/icons8-twitterx.svg',
                content: 'https://x.com/almasajid5358',
                onTap: () => _launchUrl('https://x.com/almasajid5358'),
              ),
              _buildContactCardWithSvg(
                title: 'سناب شات',
                svgAsset: 'assets/icons8-snapchat.svg',
                content: 'https://www.snapchat.com/add/almasajid5358',
                onTap: () => _launchUrl(
                    'https://www.snapchat.com/add/almasajid5358?share_id=7PaqHwiqMTs&locale=ar-AE'),
              ),
              _buildContactCardWithSvg(
                title: 'يوتيوب',
                svgAsset: 'assets/icons8-youtube.svg',
                content:
                    'https://www.youtube.com/@almasajid5358?si=QEYwQQ25pSR00ZRW',
                onTap: () => _launchUrl(
                    'https://www.youtube.com/@almasajid5358?si=QEYwQQ25pSR00ZRW'),
              ),
              _buildContactCardWithSvg(
                title: 'واتساب',
                svgAsset: 'assets/icons8-whatsapp.svg',
                content: 'https://wa.me/966505383833',
                onTap: () => _launchUrl('https://wa.me/966505383833'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required IconData icon,
    required String content,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
        onTap: onTap,
        trailing: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildContactCardWithSvg(
      {required String title,
      required String svgAsset,
      required String content,
      VoidCallback? onTap,
      double? height}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: SvgPicture.asset(svgAsset, width: 32, height: height ?? 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
        onTap: onTap,
        trailing: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
