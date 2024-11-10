import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:masged/model/build_model.dart';
import 'package:masged/providers/build_request_provider.dart';
import 'package:masged/view/screens/map.dart'; // تأكد من تعديل هذا المسار وفقًا لمشروعك
import 'package:masged/view/widgets/custom_field.dart'; // تأكد من تعديل هذا المسار وفقًا لمشروعك

class RequestBuildingRepairScreen extends StatefulWidget {
  const RequestBuildingRepairScreen({super.key});

  @override
  _RequestBuildingRepairScreenState createState() =>
      _RequestBuildingRepairScreenState();
}

class _RequestBuildingRepairScreenState
    extends State<RequestBuildingRepairScreen> {
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;

  // TextEditingControllers for text fields

  final TextEditingController applicantNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController mosqueNameController = TextEditingController();
  final TextEditingController neighborhoodNameController =
      TextEditingController();
  final TextEditingController constructionTypeController =
      TextEditingController();
  final TextEditingController maintenanceTypeController =
      TextEditingController();
  final TextEditingController facilitiesTypeController =
      TextEditingController();
  final TextEditingController problemDescriptionController =
      TextEditingController();
  final TextEditingController donorContactNumberController =
      TextEditingController();
  final TextEditingController _donorExpectedontroller = TextEditingController();

  String applicantRole = '';
  String serviceType = '';
  String importanceLevel = '';
  String budget = '';
  String hasDonor = '';
  String? _mosqueAddress;
  List<PlatformFile> attachments = [];
  bool isLoading = false;

  final List<String> roles = [
    'إمام',
    'مؤذن',
    'ممثل عن إدارة المسجد',
    'متبرع',
    'موظف الجمعية',
    'آخر'
  ];
  final List<String> importanceLevels = ['عالية', 'متوسطة', 'منخفضة'];
  final List<String> budgets = [
    'أقل من 5000 ريال',
    '5000-10000 ريال',
    'أكثر من 10000 ريال'
  ];
  final List<String> yesNoOptions = ['نعم', 'لا'];

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    applicantNameController.dispose();
    contactNumberController.dispose();
    mosqueNameController.dispose();
    neighborhoodNameController.dispose();
    constructionTypeController.dispose();
    maintenanceTypeController.dispose();
    facilitiesTypeController.dispose();
    problemDescriptionController.dispose();
    donorContactNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        // إضافة الملفات الجديدة بدلاً من استبدال الملفات الحالية
        attachments.addAll(result.files);
      });
    }
  }

  Future<List<String>> _uploadFiles(List<PlatformFile> files) async {
    List<String> uploadedFileUrls = [];
    for (var file in files) {
      if (file.path != null) {
        File uploadFile = File(file.path!);
        String fileName = file.name;

        // رفع الملف واسترجاع رابط التنزيل
        TaskSnapshot uploadTask = await FirebaseStorage.instance
            .ref('construction_attachments/$fileName')
            .putFile(uploadFile);

        String downloadUrl = await uploadTask.ref.getDownloadURL();
        uploadedFileUrls
            .add(downloadUrl); // تخزين رابط الملف بدلاً من الاسم فقط
      }
    }
    return uploadedFileUrls;
  }

  void _removeFile(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }

  void submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      try {
        List<String> uploadedFileUrls = [];

        // إذا كانت هناك مرفقات
        if (attachments.isNotEmpty) {
          uploadedFileUrls = await _uploadFiles(attachments);
        }

        // نموذج الطلب مع استخدام روابط الملفات
        final request = RequestBuildingRepair(
            id: "",
            uid: user!.uid,
            comment: '',
            applicantName: applicantNameController.text,
            donorExpected: _donorExpectedontroller.text,
            applicantRole: applicantRole,
            contactNumber: contactNumberController.text,
            mosqueName: mosqueNameController.text,
            neighborhoodName: neighborhoodNameController.text,
            mosqueLocation: _mosqueAddress ?? "",
            serviceType: serviceType,
            constructionType: constructionTypeController.text,
            maintenanceType: maintenanceTypeController.text,
            facilitiesType: facilitiesTypeController.text,
            problemDescription: problemDescriptionController.text,
            importanceLevel: importanceLevel,
            budget: budget,
            fundingType: hasDonor == 'نعم' ? 'متبرع' : 'غير محدد',
            hasDonor: hasDonor,
            donorContactNumber: donorContactNumberController.text,
            fundingSource:
                hasDonor == 'نعم' ? donorContactNumberController.text : '',
            mosqueAddress: _mosqueAddress!,
            attachments: uploadedFileUrls, // تخزين الروابط في فايرستور
            status: 'في الانتظار',
            requestTimestamp: Timestamp.now());

        await BuildRequestProvider().addRequest(request);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'شكراً لمشاركتك في خدمة بيوت الله كتب الله أجرك وشكر سعيك سنتواصل معك قريباً ياموفق'),
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
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('طلب البناء والترميم'),
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
                      label: 'اسم المُقدم',
                      controller: applicantNameController,
                      validator: (value) =>
                          _requiredFieldValidator(value, 'اسم المُقدم'),
                    ),
                    _buildDropdownField(
                      'صفة المُقدم',
                      roles,
                      (value) => setState(() => applicantRole = value!),
                    ),
                    CustomTextFieldController(
                      label: 'رقم التواصل',
                      controller: contactNumberController,
                      inputType: TextInputType.phone,
                      validator: (value) =>
                          _requiredFieldValidator(value, 'رقم التواصل'),
                    ),
                  ]),
                  _buildSection('معلومات عن المسجد', [
                    CustomTextFieldController(
                      label: 'اسم المسجد',
                      controller: mosqueNameController,
                      validator: (value) =>
                          _requiredFieldValidator(value, 'اسم المسجد'),
                    ),
                    CustomTextFieldController(
                      label: 'اسم الحي',
                      controller: neighborhoodNameController,
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
                  _buildSection('تفاصيل الطلب', [
                    _buildDropdownField(
                      'نوع الخدمة المطلوبة',
                      ['بناء', 'ترميم'],
                      (value) => setState(() => serviceType = value!),
                    ),
                    if (serviceType == 'ترميم') ...[
                      CustomTextFieldController(
                        label: 'الأعمال الإنشائية',
                        controller: constructionTypeController,
                      ),
                      CustomTextFieldController(
                        label: 'الواجهات',
                        controller: maintenanceTypeController,
                      ),
                      CustomTextFieldController(
                        label: 'المرافق',
                        controller: facilitiesTypeController,
                      ),
                    ],
                    CustomTextFieldController(
                      label: 'وصف الطلب',
                      controller: problemDescriptionController,
                      maxLines: 3,
                      inputType: TextInputType.multiline,
                      validator: (value) =>
                          _requiredFieldValidator(value, 'وصف الطلب'),
                    ),
                    _buildDropdownField(
                      'أهمية الطلب',
                      importanceLevels,
                      (value) => setState(() => importanceLevel = value!),
                    ),
                    // _buildDropdownField(
                    //   'الميزانية المقدرة',
                    //   budgets,
                    //   (value) => setState(() => budget = value!),
                    // ),
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
                      const Text(
                        "نعتذر عن تقديم الخدمة حاليا",
                        style: TextStyle(color: Colors.red),
                      ),
                    // CustomTextFieldController(
                    //   label: 'القيمة المتوقعة',
                    //   controller: _donorExpectedontroller,
                    //   inputType: TextInputType.phone,
                    //   validator: (value) {
                    //     if (hasDonor == 'لا' &&
                    //         (value == null || value.isEmpty)) {
                    //       return 'الرجاء إدخال القيمة المتوقعة';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: _pickFiles,
                        child: const Text('إرفاق صور أو وثائق'),
                      ),
                    ),
                    if (attachments.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('الملفات المرفقة:'),
                          ...attachments.map((file) => ListTile(
                                title: Text(file.name),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _removeFile(attachments.indexOf(file)),
                                ),
                              )),
                        ],
                      ),
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
          ],
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

  String? _requiredFieldValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال $fieldName';
    }
    return null;
  }
}
