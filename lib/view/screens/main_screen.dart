import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masged/view/screens/auth_screens/login_screen.dart';
import 'package:masged/view/screens/donate_fast_screen.dart';
import 'package:masged/view/screens/my_requests.dart';
import 'package:masged/view/screens/offer_service_screen.dart';
import 'package:masged/view/screens/request_type_screen.dart';
import 'package:masged/view/screens/services_screen.dart';
import 'package:masged/view/widgets/custom_button.dart';
import 'package:masged/view/widgets/custom_drawer.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مساجد',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
        ),
        drawer: const CustomDrawer(),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green.shade50, Colors.white],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: ListView(
                children: <Widget>[
                  Center(child: Image.asset("assets/logo.png", height: 120)),
                  const SizedBox(height: 30),
                  buildMenuButton(
                    context,
                    'تقديم الطلب',
                    Icons.edit_note,
                    Colors.blue, // أزرق فاتح وغامق متوازن
                    const RequestTypeScreen(),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1C3D73), // أزرق متوسطة الغمق
                        Color(0xFF1C3D73), // أزرق غامق
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  buildMenuButton(
                    context,
                    'قدم خدماتك',
                    Icons.room_service,
                    Colors.blue, // أزرق فاتح وغامق متوازن
                    const OfferServiceScreen(),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF37474F), // أزرق غامق
                        Color(0xFF37474F), // أزرق غامق
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  buildMenuButtonMyOrders(
                    context,
                    'طلباتي',
                    Icons.info,
                    const LinearGradient(
                      colors: [
                        Color(0xFF8B6A4F), // بيج غامق قليلاً (لون متزن)
                        Color(0xFF8B6A4F), // بيج غامق
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    const MyRequests(),
                  ),
                  buildMenuButton(
                    context,
                    'تبرع سريع',
                    Icons.volunteer_activism,
                    Colors.grey, // درجات رصاصي واضحة
                    const DonateFastScreen(),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF455A64), // رصاصي متوسط الغمق
                        Color(0xFF455A64), // رصاصي غامق
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  buildMenuButton(
                    context,
                    'خدمات الجمعية',
                    Icons.list_alt,
                    Colors.blueGrey, // درجات بين الأزرق والرصاصي مع تغميق
                    const ServicesPage(),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF37474F), // أزرق رمادي غامق قليلاً
                        Color(0xFF37474F), // أزرق رمادي غامق
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildMenuButtonMyOrders(
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
