import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masged/view/screens/map.dart';

class PrayerRoomRequestScreen extends StatefulWidget {
  const PrayerRoomRequestScreen({super.key});

  @override
  _PrayerRoomRequestScreenState createState() =>
      _PrayerRoomRequestScreenState();
}

class _PrayerRoomRequestScreenState extends State<PrayerRoomRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController applicantNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? _mosqueAddress;

  String? applicantRole;
  bool isLoading = false;

  DateTime? startDate;
  DateTime? endDate;
  int? durationDays;

  final List<String> roles = [
    'إمام',
    'مؤذن',
    'ممثل عن إدارة المسجد',
    'متبرع',
    'موظف الجمعية',
    'آخر'
  ];

  @override
  void dispose() {
    applicantNameController.dispose();
    contactNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void resetForm() {
    setState(() {
      applicantNameController.clear();
      contactNumberController.clear();
      addressController.clear();
      applicantRole = null;
      startDate = null;
      endDate = null;
      durationDays = null;
      _formKey.currentState?.reset();
    });
  }

  void calculateDuration() {
    if (startDate != null && endDate != null) {
      setState(() {
        durationDays =
            endDate!.difference(startDate!).inDays + 1; // +1 لتضمين يوم البداية
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
        calculateDuration();
      });
    }
  }

  void submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      try {
        if (applicantNameController.text.isNotEmpty &&
            applicantRole != null &&
            contactNumberController.text.isNotEmpty &&
            addressController.text.isNotEmpty &&
            startDate != null &&
            endDate != null) {
          final prayerRoomRequest = {
            'applicantName': applicantNameController.text,
            'applicantRole': applicantRole,
            'contactNumber': contactNumberController.text,
            'address': addressController.text,
            'mosqueAddress': _mosqueAddress!,
            'uid': user?.uid ?? 'unknown',
            'startDate':
                startDate != null ? Timestamp.fromDate(startDate!) : null,
            'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
            'durationDays': durationDays,
            'timestamp': Timestamp.now(),
            "status": "في الانتظار",
          };

          await FirebaseFirestore.instance
              .collection('prayer_room_requests')
              .add(prayerRoomRequest);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'سيتم معالجة طلبك وفق معايير الأولوية. سنتواصل معك قريباً.'),
              backgroundColor: Colors.green,
            ),
          );

          resetForm();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('الرجاء إدخال جميع الحقول المطلوبة.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في إرسال الطلب: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text("طلب مصلى مؤقت")),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSection('معلومات المُقدم للطلب', [
                _buildTextField(
                  label: 'اسم المُقدم',
                  controller: applicantNameController,
                  validator: (value) =>
                      _requiredFieldValidator(value, 'اسم المُقدم'),
                ),
                _buildDropdownField(
                  'صفة المُقدم',
                  roles,
                  (value) => setState(() => applicantRole = value),
                ),
                _buildTextField(
                  label: 'رقم التواصل',
                  controller: contactNumberController,
                  inputType: TextInputType.phone,
                  validator: (value) =>
                      _requiredFieldValidator(value, 'رقم التواصل'),
                ),
                _buildTextField(
                  label: 'العنوان بالتفصيل',
                  controller: addressController,
                  maxLines: 3,
                  validator: (value) =>
                      _requiredFieldValidator(value, 'العنوان'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final selectedAddress = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectLocationScreen(),
                      ),
                    );

                    if (selectedAddress != null) {
                      setState(() {
                        _mosqueAddress = selectedAddress;
                      });
                    }
                  },
                  child: Text(
                    _mosqueAddress ?? 'موقع المسجد (العنوان الكامل)',
                    style: TextStyle(
                        color: _mosqueAddress != null
                            ? Colors.black
                            : Colors.white,
                        fontSize: 20),
                  ),
                ),
              ]),
              _buildSection('الفترة المطلوبة', [
                _buildDatePickerField(
                  context: context,
                  label: 'بداية المدة',
                  selectedDate: startDate,
                  onDateSelected: () => _selectDate(context, true),
                ),
                _buildDatePickerField(
                  context: context,
                  label: 'نهاية المدة',
                  selectedDate: endDate,
                  onDateSelected: () => _selectDate(context, false),
                ),
                if (durationDays != null) Text('عدد الأيام: $durationDays يوم'),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: submitForm,
                        child: const Text('إرسال الطلب'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField(
      String label, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: options
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'الرجاء اختيار $label' : null,
      ),
    );
  }

  String? _requiredFieldValidator(String? value, String fieldName) {
    return (value == null || value.isEmpty) ? 'الرجاء إدخال $fieldName' : null;
  }

  Widget _buildDatePickerField({
    required BuildContext context,
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onDateSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                selectedDate != null
                    ? '${selectedDate.toLocal()}'
                        .split(' ')[0] // تحويل التاريخ إلى تنسيق مناسب
                    : 'الرجاء اختيار $label',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onDateSelected,
            child: const Text('اختر التاريخ'),
          ),
        ],
      ),
    );
  }
}
