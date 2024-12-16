import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OfferServiceScreen extends StatefulWidget {
  const OfferServiceScreen({super.key});

  @override
  _OfferServiceScreenState createState() => _OfferServiceScreenState();
}

class _OfferServiceScreenState extends State<OfferServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _organizationNameController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _serviceDetailsController =
      TextEditingController();

  Future<void> _submitService() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('services').add({
          'storeName': _storeNameController.text,
          'organizationName': _organizationNameController.text,
          'phone': _phoneController.text,
          'specialization': _specializationController.text,
          'serviceDetails': _serviceDetailsController.text,
          'submittedAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'تم إرسال الخدمة بنجاح!',
                style: TextStyle(color: Colors.white),
              )),
        );

        // إعادة تعيين الحقول بعد الإرسال
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قدم خدماتك'),
          backgroundColor: const Color(0xFF004B6F),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                  controller: _storeNameController,
                  label: 'اسم المحل',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _organizationNameController,
                  label: 'اسم المؤسسة',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'الرقم',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _specializationController,
                  label: 'التخصص',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _serviceDetailsController,
                  label: 'الخدمة المقدمة بالتفصيل',
                  maxLines: 5,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004B6F),
                  ),
                  child: const Text('إرسال'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال $label';
        }
        return null;
      },
    );
  }
}
