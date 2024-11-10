import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masged/view/screens/auth_screens/sms_verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isEmail = true;

  void _signUp() async {
    try {
      if (_isEmail) {
        // Email sign-up logic
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        User? user = userCredential.user;
        if (user != null) {
          await user.sendEmailVerification();
          Navigator.of(context).pushReplacementNamed('/verify-email');
        }
      } else {
        // Phone sign-up logic
        await _auth.verifyPhoneNumber(
          phoneNumber: _phoneController.text,
          verificationCompleted: (credential) async {
            await _auth.signInWithCredential(credential);
            Navigator.of(context).pushReplacementNamed('/home');
          },
          verificationFailed: (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('خطأ: ${e.message}')),
            );
          },
          codeSent: (verificationId, _) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    VerificationCodeScreen(verificationId: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {},
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('البريد الإلكتروني'),
                  selected: _isEmail,
                  onSelected: (selected) {
                    setState(() {
                      _isEmail = true;
                    });
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('الهاتف'),
                  selected: !_isEmail,
                  onSelected: (selected) {
                    setState(() {
                      _isEmail = false;
                    });
                  },
                ),
              ],
            ),
            if (_isEmail) ...[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'الاسم'),
              ),
              TextField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'البريد الإلكتروني'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'كلمة المرور'),
                obscureText: true,
              ),
            ] else ...[
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: const Text('إنشاء حساب'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/login'),
              child: const Text('هل لديك حساب؟ تسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }
}
