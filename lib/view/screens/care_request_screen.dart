import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masged/model/care_model.dart';
import 'package:masged/providers/care_request_provider.dart';
import 'package:masged/view/screens/map.dart';
import 'package:masged/view/widgets/custom_field.dart';
import 'package:provider/provider.dart';

class PeriodicCareRequestScreen extends StatefulWidget {
  const PeriodicCareRequestScreen({super.key});

  @override
  _PeriodicCareRequestScreenState createState() =>
      _PeriodicCareRequestScreenState();
}

class _PeriodicCareRequestScreenState extends State<PeriodicCareRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _applicantNameController =
      TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _applicantRoleController =
      TextEditingController();
  final TextEditingController _mosqueNameController = TextEditingController();
  final TextEditingController _neighborhoodNameController =
      TextEditingController();
  final TextEditingController _donationAmountController =
      TextEditingController();
  final TextEditingController _donorExpectedontroller = TextEditingController();
  final TextEditingController donorContactNumberController =
      TextEditingController();
  String? _mosqueAddress;
  bool _isLoading = false;
  String hasDonor = '';

  final Map<String, Map<String, int>> servicesAndItems = {
    // 'كهرباء': {
    //   'مروحة شفط': 0,
    //   'افياش': 0,
    //   'اناره': 0,
    //   'سويت لايت ٢×٢٠': 0,
    //   'فيش ثلاثي': 0,
    //   'سويت لايت ١×١٥': 0,
    //   'فيش مكيف': 0,
    //   'سويت لايت ٧٦٧': 0,
    //   'مفتاح انارة': 0,
    //   'ثلاجات': 0,
    //   'شرائح': 0,
    //   'كبس خارجي': 0,
    // },
    // 'سباكة': {
    //   'خلاط': 0,
    //   'شطاف': 0,
    //   'سيفون': 0,
    //   'سخانة': 0,
    //   'كرسي افرنجي': 0,
    // },
    'صوتيات': {
      'سماعة': 0,
      'مكبر': 0,
      'مايك': 0,
    },
    'نظافة': {
      'اسبلت': 0,
      'شباك': 0,
      'دولاب': 0,
      'مركزي': 0,
      'أدوات النظافة': 0,
      'نظافة السجاد': 0,
      'نظافة دورات المياه': 0,
    },
  };

  final Map<String, int> additionalItems = {
    'التشجير': 0,
    'جهاز تعطير': 0,
    'زيوت عطرية': 0,
    'معطر سجاد': 0,
    'عبوات مياه': 0,
    'مناديل': 0,
  };

  final List<String> roles = [
    'إمام',
    'مؤذن',
    'ممثل إدارة المسجد',
    'متبرع',
    'موظف الجمعية',
    'آخر'
  ];
  final List<String> yesNoOptions = ['نعم', 'لا'];

  @override
  void dispose() {
    _applicantNameController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نموذج طلب العناية الدورية'),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSection('معلومات المُقدم للطلب', [
                  CustomTextFieldController(
                    controller: _applicantNameController,
                    label: 'اسم المُقدم',
                    validator: (value) =>
                        _requiredFieldValidator(value, 'اسم المُقدم'),
                  ),
                  _buildDropdownField(
                    'صفة المُقدم',
                    roles,
                    (value) =>
                        setState(() => _applicantRoleController.text = value!),
                  ),
                  CustomTextFieldController(
                    controller: _contactNumberController,
                    label: 'رقم التواصل',
                    inputType: TextInputType.phone,
                    validator: (value) =>
                        _requiredFieldValidator(value, 'رقم التواصل'),
                  ),
                ]),
                _buildSection('معلومات عن المسجد', [
                  CustomTextFieldController(
                    label: 'اسم المسجد',
                    controller: _mosqueNameController,
                    validator: (value) =>
                        _requiredFieldValidator(value, 'اسم المسجد'),
                  ),
                  CustomTextFieldController(
                    label: 'اسم الحي',
                    controller: _neighborhoodNameController,
                    validator: (value) =>
                        _requiredFieldValidator(value, 'اسم الحي'),
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
                _buildSection('المواد والخدمات المقدمة', _buildServicesList()),
                _buildSection('مواد إضافية', _buildAdditionalItemsList()),
                //    _buildSection('تبرع', [_buildDonationField()]),
                _buildDropdownField(
                  'هل يوجد متبرع؟',
                  yesNoOptions,
                  (value) => setState(() => hasDonor = value!),
                ),
                if (hasDonor == 'نعم')
                  CustomTextFieldController(
                    label: 'كم مبلغ التبرع',
                    controller: donorContactNumberController,
                    inputType: TextInputType.phone,
                    validator: (value) {
                      if (hasDonor == 'نعم' &&
                          (value == null || value.isEmpty)) {
                        return 'الرجاء إدخال كم مبلغ التبرع';
                      }
                      return null;
                    },
                  ),
                if (hasDonor == 'لا')
                  CustomTextFieldController(
                    label: 'القيمة المتوقعة',
                    controller: _donorExpectedontroller,
                    inputType: TextInputType.phone,
                    validator: (value) {
                      if (hasDonor == 'لا' &&
                          (value == null || value.isEmpty)) {
                        return 'الرجاء إدخال القيمة المتوقعة';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      _submitForm(user?.uid ?? '');
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('إرسال الطلب'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _requiredFieldValidator(String? value, String label) {
    return (value == null || value.isEmpty) ? 'الرجاء إدخال $label' : null;
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
        validator: (value) =>
            value == null || value.isEmpty ? 'الرجاء اختيار $label' : null,
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildServicesList() {
    return servicesAndItems.entries.map((entry) {
      return ExpansionTile(
        title: Text(entry.key,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        children: entry.value.entries.map((item) {
          return CheckboxListTile(
            title: Text(item.key),
            value: item.value > 0,
            onChanged: (newValue) {
              setState(() {
                servicesAndItems[entry.key]![item.key] = newValue! ? 1 : 0;
              });
            },
            secondary: item.value > 0
                ? SizedBox(
                    width: 60,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'العدد'),
                      initialValue: item.value.toString(),
                      onChanged: (newValue) {
                        setState(() {
                          servicesAndItems[entry.key]![item.key] =
                              int.tryParse(newValue) ?? 0;
                        });
                      },
                    ),
                  )
                : null,
          );
        }).toList(),
      );
    }).toList();
  }

  List<Widget> _buildAdditionalItemsList() {
    return additionalItems.entries.map((entry) {
      return CheckboxListTile(
        title: Text(entry.key),
        value: entry.value > 0,
        onChanged: (newValue) {
          setState(() {
            additionalItems[entry.key] = newValue! ? 1 : 0;
          });
        },
        secondary: entry.value > 0
            ? SizedBox(
                width: 60,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'العدد'),
                  initialValue: entry.value.toString(),
                  onChanged: (newValue) {
                    setState(() {
                      additionalItems[entry.key] = int.tryParse(newValue) ?? 0;
                    });
                  },
                ),
              )
            : null,
      );
    }).toList();
  }

  // Widget _buildDonationField() {
  //   return CustomTextFieldController(
  //     label: 'مقدار التبرع',
  //     controller: _donationAmountController,
  //   );
  // }

  Future<void> _submitForm(String userId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final careRequest = CareRequest(
          id: "",
          servicesAndItems: servicesAndItems,
          uid: userId,
          applicantName: _applicantNameController.text,
          contactNumber: _contactNumberController.text,
          applicantRole: _applicantRoleController.text,
          mosqueName: _mosqueNameController.text,
          neighborhoodName: _neighborhoodNameController.text,
          mosqueAddress: _mosqueAddress!,
          additionalItems: additionalItems,
          donationAmount: _donationAmountController.text,
          status: "في الانتظار",
          comment: "",
          requestTimestamp: Timestamp.now());

      await Provider.of<CareRequestProvider>(context, listen: false)
          .submitRequest(careRequest);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'شكراً لمشاركتك في خدمة بيوت الله كتب الله أجرك وشكر سعيك سنتواصل معك قريباً ياموفق'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Handle errors here
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
