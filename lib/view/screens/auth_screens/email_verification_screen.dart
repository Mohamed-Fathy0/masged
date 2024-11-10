import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isVerified = false;
  bool _isLoading = false;

  Future<void> _checkEmailVerified() async {
    setState(() {
      _isLoading = true;
    });
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;
    setState(() {
      _isVerified = user?.emailVerified ?? false;
      _isLoading = false;
    });
    if (_isVerified) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      _showSnackbar('البريد الإلكتروني لم يتم تأكيده بعد.');
    }
  }

  Future<void> _resendVerificationEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      _showSnackbar('تم إعادة إرسال بريد التحقق.');
    } catch (e) {
      _showSnackbar('فشل في إعادة إرسال البريد الإلكتروني.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تأكيد البريد الإلكتروني'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'تم إرسال بريد التحقق إلى بريدك الإلكتروني. يرجى التحقق من بريدك والنقر على الرابط لتأكيد الحساب.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _checkEmailVerified,
                      child: const Text('تم تأكيد الحساب'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _resendVerificationEmail,
                      child: const Text('إعادة إرسال البريد الإلكتروني'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
