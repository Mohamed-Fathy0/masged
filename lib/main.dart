import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:masged/firebase_options.dart';
import 'package:masged/providers/build_request_provider.dart';
import 'package:masged/providers/care_request_provider.dart';
import 'package:masged/providers/maintenance_request_provider.dart';
import 'package:masged/view/screens/auth_screens/email_verification_screen.dart';
import 'package:masged/view/screens/auth_screens/forget_password.dart';
import 'package:masged/view/screens/auth_screens/login_screen.dart';
import 'package:masged/view/screens/auth_screens/signup_screen.dart';
import 'package:masged/view/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RequestFixProvider()),
        ChangeNotifierProvider(create: (_) => BuildRequestProvider()),
        ChangeNotifierProvider(create: (_) => CareRequestProvider()),
      ],
      child: MaterialApp(
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/verify-email': (context) => const EmailVerificationScreen(),
          '/home': (context) => const MainScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
        },
        debugShowCheckedModeBanner: false,
        title: 'مساجد',
        theme: ThemeData(
          primaryColor: const Color(0xFF004B6F), // الأزرق الداكن
          scaffoldBackgroundColor: const Color(0xFFF5F1E5), // البيج الفاتح
          appBarTheme: const AppBarTheme(
            color: Color(0xFF004B6F), // لون AppBar بنفس لون الأزرق الداكن
            iconTheme:
                IconThemeData(color: Colors.white), // الأيقونات في AppBar
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor:
                  const Color(0xFF004B6F), // لون النصوص على الأزرار
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontFamily: 'Uthmanic'),
            bodyMedium: TextStyle(fontFamily: 'Uthmanic'),
            displayLarge: TextStyle(fontFamily: 'Uthmanic'),
            displayMedium: TextStyle(fontFamily: 'Uthmanic'),
            displaySmall: TextStyle(fontFamily: 'Uthmanic'),
            headlineMedium: TextStyle(fontFamily: 'Uthmanic'),
            headlineSmall: TextStyle(fontFamily: 'Uthmanic'),
            titleLarge: TextStyle(fontFamily: 'Uthmanic'),
            titleMedium: TextStyle(fontFamily: 'Uthmanic'),
            titleSmall: TextStyle(fontFamily: 'Uthmanic'),
            bodySmall: TextStyle(fontFamily: 'Uthmanic'),
            labelLarge: TextStyle(fontFamily: 'Uthmanic'),
          ),
        ),
        home: const MainScreen(), //SelectLocationScreen
      ),
    );
  }
}
