import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masged/view/screens/about_screen.dart';
import 'package:masged/view/screens/contact_screen.dart';
import 'package:masged/view/screens/auth_screens/login_screen.dart';
import 'package:masged/view/screens/profile_screen.dart'; // أضف هذا السطر
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String url =
        "https://sites.google.com/view/masaged/%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9?authuser=3";
    return Drawer(
      child: Column(
        children: <Widget>[
          // Header section
          const UserAccountsDrawerHeader(
            accountName: Text('جمعية مساجد'),
            accountEmail: Text('info@masjed.org'),
            currentAccountPicture: CircleAvatar(
              radius: 30, // تصغير الحجم الخارجي للـ CircleAvatar
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 30, // تصغير الحجم الداخلي للـ CircleAvatar
                backgroundImage: AssetImage("assets/logoicon.png"),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF004B6F),
            ),
          ),

          // List of items
          if (user == null)
            ListTile(
              leading: const Icon(Icons.login, color: Color(0xFF004B6F)),
              title: const Text('تسجيل الدخول'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            )
          else
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF004B6F)),
              title: Text(user.email ?? 'الحساب'),
              onTap: () {
                // فتح شاشة البروفايل
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.info, color: Color(0xFF004B6F)),
            title: const Text('معلومات الجمعية'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone, color: Color(0xFF004B6F)),
            title: const Text('تواصل معنا'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy, color: Color(0xFF004B6F)),
            title: const Text('سياسة الخصوصية'),
            onTap: () => _launchURL(url),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
