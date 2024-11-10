import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:masged/model/maintenance_model.dart';
import 'package:masged/providers/maintenance_request_provider.dart';
import 'package:masged/view/screens/map.dart';
import 'package:masged/view/widgets/custom_field.dart';

class RequestFixScreen extends StatefulWidget {
  const RequestFixScreen({super.key});

  @override
  _RequestFixScreenState createState() => _RequestFixScreenState();
}

class _RequestFixScreenState extends State<RequestFixScreen> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;

  // تعريف متغيرات TextEditingController

  final TextEditingController _applicantNameController =
      TextEditingController();
  final TextEditingController _donorExpectedontroller = TextEditingController();
  final TextEditingController _applicantRoleController =
      TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _mosqueNameController = TextEditingController();
  final TextEditingController _neighborhoodNameController =
      TextEditingController();
  final TextEditingController _problemDescriptionController =
      TextEditingController();
  final TextEditingController _donorContactNumberController =
      TextEditingController();
  final TextEditingController _hasDonorController = TextEditingController();
  final TextEditingController _maintenanceStatusController =
      TextEditingController();
  // final TextEditingController _requestTypeController = TextEditingController();

  List<String> selectedRequestTypes = [];
  List<String> uploadedFileUrls = [];

  String? _mosqueAddress;
  List<PlatformFile> attachments = [];
  bool isLoading = false;
  final Map<String, Map<String, int>> servicesAndItems = {
    'كهرباء': {
      'مروحة شفط': 0,
      'افياش': 0,
      'اناره': 0,
      'سويت لايت ٢×٢٠': 0,
      'فيش ثلاثي': 0,
      'سويت لايت ١×١٥': 0,
      'فيش مكيف': 0,
      'سويت لايت ٧٦٧': 0,
      'مفتاح انارة': 0,
      'ثلاجات': 0,
      'شرائح': 0,
      'كبس خارجي': 0,
    },
    'سباكة': {
      'خلاط': 0,
      'شطاف': 0,
      'سيفون': 0,
      'سخانة': 0,
      'كرسي افرنجي': 0,
    },
  };
  final List<String> roles = [
    'إمام',
    'مؤذن',
    'ممثل إدارة المسجد',
    'متبرع',
    'موظف الجمعية',
    'آخر'
  ];
  final List<String> maintenanceStatuses = ['طارئة', 'دورية', 'أخرى'];
  final List<String> requestTypes = ['كهرباء', 'سباكة', 'دهانات', 'أخرى'];
  final List<String> yesNoOptions = ['نعم', 'لا'];

  String? _requiredFieldValidator(String? value, String label) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال $label';
    }
    return null;
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        // دمج الملفات الجديدة مع الملفات المختارة مسبقاً
        attachments.addAll(result.files);
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }

  Future<void> _uploadFiles(List<PlatformFile> files) async {
    for (var file in files) {
      if (file.path != null) {
        File uploadFile = File(file.path!);
        String fileName = file.name;

        // رفع الملف إلى Firebase Storage
        TaskSnapshot taskSnapshot = await FirebaseStorage.instance
            .ref('maintenance_attachments/$fileName')
            .putFile(uploadFile);

        // الحصول على رابط URL للصورة بعد الرفع
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // إضافة الرابط إلى القائمة
        uploadedFileUrls.add(downloadUrl);
      }
    }
  }

  void submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        isLoading = true;
      });

      try {
        // رفع المرفقات إذا كانت موجودة
        if (attachments.isNotEmpty) {
          await _uploadFiles(attachments);
        }

        // إنشاء كائن الطلب مع روابط المرفقات
        final request = MaintenanceRequest(
          uid: user!.uid,
          id: '',
          comment: '',
          applicantName: _applicantNameController.text,
          applicantRole: _applicantRoleController.text,
          contactNumber: _contactNumberController.text,
          mosqueName: _mosqueNameController.text,
          donorExpected: _donorExpectedontroller.text,
          neighborhoodName: _neighborhoodNameController.text,
          mosqueLocation: _mosqueAddress ?? "",
          maintenanceStatus: _maintenanceStatusController.text,
          //   requestTypeM: selectedRequestTypes.join(', '),
          problemDescription: _problemDescriptionController.text,
          fundingType: _hasDonorController.text == 'نعم' ? 'متبرع' : 'غير محدد',
          hasDonor: _hasDonorController.text,
          servicesAndItems: servicesAndItems,
          donorContactNumber: _donorContactNumberController.text,
          fundingSource: _hasDonorController.text == 'نعم'
              ? _donorContactNumberController.text
              : '',
          mosqueAddress: _mosqueAddress,
          attachments: uploadedFileUrls, // إرسال روابط URL بدلاً من الأسماء فقط
          status: "في الانتظار",
          requestTimestamp: Timestamp.now(),
        );

        // إرسال الطلب إلى Firestore
        await RequestFixProvider().submitRequest(request);

        // مسح الحقول بعد الإرسال
        _applicantNameController.clear();
        _applicantRoleController.clear();
        _contactNumberController.clear();
        _mosqueNameController.clear();
        _neighborhoodNameController.clear();
        _problemDescriptionController.clear();
        _donorContactNumberController.clear();
        _donorExpectedontroller.clear();
        _mosqueAddress = null;
        attachments.clear();
        uploadedFileUrls.clear(); // إعادة تعيين قائمة URL

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال الطلب بنجاح!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في إرسال الطلب: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _applicantNameController.dispose();
    _applicantRoleController.dispose();
    _contactNumberController.dispose();
    _donorExpectedontroller.dispose();
    _mosqueNameController.dispose();
    _neighborhoodNameController.dispose();
    _problemDescriptionController.dispose();
    _donorContactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نموذج طلب صيانة'),
        ),
        body: Stack(
          children: [
            Form(
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
                      (value) => _applicantRoleController.text = value!,
                      (value) => _applicantRoleController.text = value!,
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
                      controller: _mosqueNameController,
                      label: 'اسم المسجد',
                      validator: (value) =>
                          _requiredFieldValidator(value, 'اسم المسجد'),
                    ),
                    CustomTextFieldController(
                      controller: _neighborhoodNameController,
                      label: 'اسم الحي',
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
                    _buildDropdownField(
                      'حالة الصيانة المطلوبة',
                      maintenanceStatuses,
                      (value) => setState(
                          () => _maintenanceStatusController.text = value!),
                      (value) => _maintenanceStatusController.text = value!,
                    ),
                    _buildSection(
                        'المواد والخدمات المقدمة', _buildServicesList()),
                  ]),
                  _buildSection('وصف الطلب', [
                    //    _buildMultiSelectRequestTypes(),
                    CustomTextFieldController(
                      controller: _problemDescriptionController,
                      label: 'وصف المشكلة و الطلب بشكل مُفصل',
                      maxLines: 3,
                      inputType: TextInputType.multiline,
                      validator: (value) =>
                          _requiredFieldValidator(value, 'وصف المشكلة و الطلب'),
                    ),
                    _buildDropdownField(
                      'هل يوجد متبرع؟',
                      yesNoOptions,
                      (value) =>
                          setState(() => _hasDonorController.text = value!),
                      (value) => _hasDonorController.text = value!,
                    ),
                    if (_hasDonorController.text == 'نعم')
                      CustomTextFieldController(
                        controller: _donorContactNumberController,
                        label: 'كم مبلغ التبرع',
                        inputType: TextInputType.phone,
                        validator: (value) =>
                            _requiredFieldValidator(value, 'كم مبلغ التبرع'),
                      ),
                    if (_hasDonorController.text == 'لا')
                      CustomTextFieldController(
                        controller: _donorExpectedontroller,
                        label: 'القيمة المتوقعة',
                        inputType: TextInputType.phone,
                        validator: (value) =>
                            _requiredFieldValidator(value, 'القيمة المتوقعة'),
                      ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _pickFiles,
                      child: const Text('إضافة مرفقات'),
                    ),
                    if (attachments.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: attachments.asMap().entries.map((entry) {
                          int index = entry.key;
                          PlatformFile file = entry.value;
                          return ListTile(
                            title: Text(file.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () => _removeFile(index),
                            ),
                          );
                        }).toList(),
                      ),
                  ]),
                  const SizedBox(height: 20.0),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    ElevatedButton(
                      onPressed: submitForm,
                      child: const Text('إرسال الطلب'),
                    ),
                ],
              ),
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiSelectRequestTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نوع الصيانة', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8.0),
        ...requestTypes.map((type) {
          return CheckboxListTile(
            title: Text(type),
            value: selectedRequestTypes.contains(type),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedRequestTypes.add(type);
                } else {
                  selectedRequestTypes.remove(type);
                }
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8.0),
          ...children,
          const SizedBox(height: 16.0),
        ],
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

  Widget _buildDropdownField(
    String label,
    List<String> options,
    Function(String?) onChanged,
    Function(String?) onSaved,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      onSaved: onSaved,
      validator: (value) => _requiredFieldValidator(value, label),
    );
  }
}
