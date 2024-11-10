import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masged/view/screens/auth_screens/login_screen.dart';
import 'package:masged/view/screens/care_request_screen.dart';
import 'package:masged/view/screens/build_request_screen.dart';
import 'package:masged/view/screens/prayer_room_request_screen.dart';
import 'package:masged/view/screens/request_fix_screen.dart';

class RequestTypeScreen extends StatelessWidget {
  const RequestTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("اختر نوع الطلب"),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green.shade100, Colors.white],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  buildMenuButton(
                    context,
                    'طلب الصيانة',
                    Icons.build,
                    const LinearGradient(
                      colors: [
                        Color(0xFF004B6F), // أزرق غامق
                        Color(0xFF003B54), // أزرق داكن أكثر
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    const RequestFixScreen(),
                  ),
                  buildMenuButton(
                    context,
                    'طلب البناء والترميم',
                    Icons.auto_fix_high,
                    const LinearGradient(
                      colors: [
                        Color(0xFF8D6E63), // بيج داكن
                        Color(0xFF5D4037), // بني غامق مع لمسة بيج
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    const RequestBuildingRepairScreen(),
                  ),
                  buildMenuButton(
                    context,
                    'طلب العناية',
                    Icons.home_repair_service,
                    const LinearGradient(
                      colors: [
                        Color(0xFF004B6F), // أزرق غامق
                        Color(0xFF37474F), // أزرق رصاصي غامق
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    const PeriodicCareRequestScreen(),
                  ),
                  buildMenuButton(
                    context,
                    'طلب مصلى مؤقت',
                    Icons.mosque,
                    const LinearGradient(
                      colors: [
                        Color(0xFF607D8B), // أزرق رمادي متوسط
                        Color(0xFF004B6F), // أزرق غامق
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    const PrayerRoomRequestScreen(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuButton(
    BuildContext context,
    String title,
    IconData icon,
    Gradient gradient,
    Widget nextPage,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: () {
          User? user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextPage),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.white),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
