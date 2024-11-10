import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  LatLng? _userLocation;
  LatLng? _selectedLocation;
  String _address = '';
  bool _isLoading = true;
  bool _isLocationSelected = false;
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar(
          'خدمات الموقع غير مفعلة. يرجى تفعيلها وإعادة المحاولة.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar(
            'تم رفض صلاحية الوصول للموقع. بعض الميزات قد لا تعمل بشكل صحيح.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar(
          'تم رفض صلاحية الوصول للموقع بشكل دائم. يرجى تفعيلها من إعدادات الجهاز.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation = _userLocation; // تخزين الموقع الحالي تلقائياً
        _isLoading = false;
        _isLocationSelected = true; // تم تحديد الموقع
      });
      _mapController.move(_userLocation!, 15);
      _getAddressFromLatLng(_userLocation!);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('حدث خطأ أثناء تحديد موقعك. يرجى المحاولة مرة أخرى.');
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        _address =
            '${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';
        _isLocationSelected = true;
      });
    } catch (e) {
      print('خطأ: $e');
      _showErrorSnackBar('حدث خطأ أثناء تحديد العنوان.');
      setState(() {
        _isLocationSelected = false;
      });
    }
  }

  Future<void> _searchLocation() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLocationSelected = false;
    });

    try {
      List<Location> locations = await locationFromAddress(
        _searchController.text,
      );
      if (locations.isNotEmpty) {
        LatLng newLocation =
            LatLng(locations.first.latitude, locations.first.longitude);
        setState(() {
          _selectedLocation = newLocation;
        });
        _mapController.move(_selectedLocation!, 15);
        await _getAddressFromLatLng(_selectedLocation!);
      } else {
        _showErrorSnackBar('لم يتم العثور على الموقع. يرجى المحاولة مرة أخرى.');
      }
    } catch (e) {
      _showErrorSnackBar(
          'حدث خطأ أثناء البحث عن الموقع. يرجى المحاولة مرة أخرى.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('حدد الموقع'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'ابحث عن موقع',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _searchLocation,
                        ),
                      ),
                      onSubmitted: (_) => _searchLocation(),
                    ),
                  ),
                  Expanded(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _userLocation ?? const LatLng(0, 0),
                        initialZoom: 15.0,
                        onTap: (tapPosition, latLng) {
                          setState(() {
                            _selectedLocation = latLng;
                            _isLocationSelected = false;
                          });
                          _getAddressFromLatLng(latLng);
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.masaged.masaged',
                        ),
                        MarkerLayer(
                          markers: [
                            if (_selectedLocation != null)
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: _selectedLocation!,
                                child: const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 50,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        if (_address.isNotEmpty)
                          Text(
                            'العنوان المحدد: $_address',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _isLocationSelected
                              ? () {
                                  final mapUrl =
                                      'https://www.google.com/maps?q=${_selectedLocation!.latitude},${_selectedLocation!.longitude}';
                                  Clipboard.setData(
                                      ClipboardData(text: mapUrl));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'تم نسخ رابط الموقع إلى الحافظة')),
                                  );
                                  Navigator.pop(context, _address);
                                }
                              : null, // الزر معطل إذا لم يتم تحديد الموقع
                          child: Text(_isLocationSelected
                              ? 'تأكيد الموقع'
                              : 'يرجى تحديد الموقع'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
/////////
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geocoding/geocoding.dart';

// class SelectLocationScreen extends StatefulWidget {
//   const SelectLocationScreen({super.key});

//   @override
//   _SelectLocationScreenState createState() => _SelectLocationScreenState();
// }

// class _SelectLocationScreenState extends State<SelectLocationScreen> {
//   LatLng _selectedLocation = const LatLng(0, 0);
//   String _address = '';
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }

//     Position position = await Geolocator.getCurrentPosition();
//     setState(() {
//       _selectedLocation = LatLng(position.latitude, position.longitude);
//       _isLoading = false;
//     });
//     _getAddressFromLatLng(_selectedLocation);
//   }

//   Future<void> _getAddressFromLatLng(LatLng latLng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         latLng.latitude,
//         latLng.longitude,
//       );
//       Placemark place = placemarks[0];
//       setState(() {
//         _address =
//             '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
//       });
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('حدد عنوان المسجد'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Expanded(
//                   child: FlutterMap(
//                     options: MapOptions(
//                       initialCenter: _selectedLocation,
//                       initialZoom: 15.0,
//                       onTap: (tapPosition, latLng) {
//                         setState(() {
//                           _selectedLocation = latLng;
//                         });
//                         _getAddressFromLatLng(latLng);
//                       },
//                     ),
//                     children: [
//                       TileLayer(
//                         urlTemplate:
//                             'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                         userAgentPackageName:
//                             'com.masaged.masaged', // استبدل هذا باسم حزمة تطبيقك
//                       ),
//                       MarkerLayer(
//                         markers: [
//                           Marker(
//                             width: 80.0,
//                             height: 80.0,
//                             point: _selectedLocation,
//                             child: const Icon(
//                               Icons.location_pin,
//                               color: Colors.red,
//                               size: 50,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       if (_address.isNotEmpty)
//                         Text(
//                           'Selected Address: $_address',
//                           style: const TextStyle(fontSize: 16),
//                           textAlign: TextAlign.center,
//                         ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           final mapUrl =
//                               'https://www.google.com/maps?q=${_selectedLocation.latitude},${_selectedLocation.longitude}';
//                           Clipboard.setData(ClipboardData(text: mapUrl));
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('Link copied to clipboard')),
//                           );

//                           Navigator.pop(context,
//                               _address); // إرسال العنوان إلى الشاشة السابقة
//                         },
//                         child: const Text('تأكيد الموقع'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
