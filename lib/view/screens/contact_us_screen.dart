// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ContactUsScreen extends StatelessWidget {
//   const ContactUsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('تواصل معنا'),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF3F51B5),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _buildHeader(),
//             _buildCompanyInfo(context),
//             _buildWebsiteContact('https://www.masajidzulfi.org.sa/'),
//             _buildEmailContact(),
//             _buildSocialMedia(),
//             _buildCustomerService(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       color: const Color(0xFF3F51B5),
//       child: const Text(
//         'يقودنا فريق يفكر دائماً ويخلق دائماً ويدفع إلى الأمام دائماً',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _buildWebsiteContact(String websiteLink) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: InkWell(
//         onTap: () => _launchUrl(websiteLink),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//           decoration: BoxDecoration(
//             color: const Color(0xFF3F51B5),
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(Icons.web, color: Colors.white, size: 28),
//               Text(
//                 "زر موقعنا الإلكتروني",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmailContact() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: InkWell(
//         onTap: () => _launchEmail('almasajid5358@gmail.com'),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//           decoration: BoxDecoration(
//             color: const Color(0xFF3F51B5),
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(Icons.email, color: Colors.white, size: 28),
//               Text(
//                 'almasajid5358@gmail.com',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCompanyInfo(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _openLocation(context),
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: const Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Icon(Icons.location_on, size: 48, color: Color(0xFF3F51B5)),
//               SizedBox(height: 8),
//               Text(
//                 '	محافظة الزلفي _ حي الفاروق',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSocialMedia() {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text(
//               'تواصل معنا عبر وسائل التواصل الاجتماعي',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildSocialButton(
//                     'assets/icons8-twitterx.svg',
//                     'https://x.com/maward_10?s=21&t=48lDJfQy9hdy6A0VmFiBnA',
//                     48),
//                 _buildSocialButton('assets/icons8-snapchat.svg',
//                     'https://snapchat.com/t/xElxOElA', 60),
//                 _buildSocialButton('assets/instagram-1-svgrepo-com.svg',
//                     'https://www.instagram.com/Mawared.10/', 48),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCustomerService() {
//     // قائمة ثابتة من العمال
//     final workers = [
//       {'name': 'تواصل معنا', 'phone': '+966505383833'},
//     ];

//     return Card(
//       margin: const EdgeInsets.all(16),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16),
//             child: Text(
//               'خدمة العملاء',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: 2,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             childAspectRatio: 0.8,
//             children: workers.map((worker) {
//               return _buildContactItem(
//                 name: worker['name']!,
//                 phone: worker['phone']!,
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContactItem({
//     required String name,
//     required String phone,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.person, size: 40, color: Color(0xFF3F51B5)),
//             const SizedBox(height: 8),
//             Text(
//               name,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: () => _launchWhatsApp(phone),
//               child: const Text('تواصل'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _launchEmail(String email) async {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: email,
//     );
//     if (await canLaunch(emailUri.toString())) {
//       await launch(emailUri.toString());
//     } else {
//       print('Could not launch $emailUri');
//     }
//   }

//   void _launchWhatsApp(String phone) async {
//     final Uri whatsappUri = Uri(
//       scheme: 'https',
//       path: 'wa.me/$phone',
//     );
//     if (await canLaunch(whatsappUri.toString())) {
//       await launch(whatsappUri.toString());
//     } else {
//       print('Could not launch $whatsappUri');
//     }
//   }

//   void _launchUrl(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       print('Could not launch $url');
//     }
//   }

//   void _openLocation(BuildContext context) async {
//     const locationUrl =
//         'https://www.google.com/maps?q=%D8%B4%D8%B1%D9%83%D9%87+%D9%85%D9%88%D8%A7%D8%B1%D8%AF+%D8%A7%D9%84%D8%AF%D9%88%D9%84%D9%8A%D8%A9';
//     if (await canLaunch(locationUrl)) {
//       await launch(locationUrl);
//     } else {
//       print('Could not launch $locationUrl');
//     }
//   }

//   Widget _buildSocialButton(String assetPath, String url, double size) {
//     return InkWell(
//       onTap: () => _launchUrl(url),
//       child: SvgPicture.asset(
//         assetPath,
//         width: size,
//         height: size,
//       ),
//     );
//   }
// }
