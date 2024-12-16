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
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
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
            bodyLarge: TextStyle(fontFamily: 'TheYearofTheCamel'),
            bodyMedium: TextStyle(fontFamily: 'TheYearofTheCamel'),
            displayLarge: TextStyle(fontFamily: 'TheYearofTheCamel'),
            displayMedium: TextStyle(fontFamily: 'TheYearofTheCamel'),
            displaySmall: TextStyle(fontFamily: 'TheYearofTheCamel'),
            headlineMedium: TextStyle(fontFamily: 'TheYearofTheCamel'),
            headlineSmall: TextStyle(fontFamily: 'TheYearofTheCamel'),
            titleLarge: TextStyle(fontFamily: 'TheYearofTheCamel'),
            titleMedium: TextStyle(fontFamily: 'TheYearofTheCamel'),
            titleSmall: TextStyle(fontFamily: 'TheYearofTheCamel'),
            bodySmall: TextStyle(fontFamily: 'TheYearofTheCamel'),
            labelLarge: TextStyle(fontFamily: 'TheYearofTheCamel'),
          ),
        ),
        home: const MainScreen(), //SelectLocationScreen
      ),
    );
  }
}
