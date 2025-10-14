import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import '../../../../data/models/user_model.dart';
import '../../../../services/storage_service.dart';
import '../models/attenace_model.dart';
import '../services/attenance_service.dart';
import 'shift_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class AttendanceController extends GetxController {
  final AttendanceService _attendanceService = AttendanceService();
  final StorageService _storageService = StorageService();
  final Rx<UserModel?> userProfile = Rx<UserModel?>(null);
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var errorNetwork = false.obs;
  var isError = false.obs;
  final isCheckedIn = false.obs;
  var checkInOutData = <CheckInOutModel>[].obs;
  final shiftCtr = Get.put(ShiftController());

  String? _userId = '';
  String? _empId = '';
  String get userId => _userId ?? 'N/A';
  String get empId => _empId ?? 'N/A';
  @override
  void onInit() async {
    await _storageService.readData('user_id').then((value) {
      _userId = value;
    });
    await _storageService.readData('emp_id').then((empValue) {
      _empId = empValue;
    });
    getCheckInOut();
    super.onInit();
  }

  Future<void> getCheckInOut() async {
    _empId = await _storageService.readData('emp_id');
    try {
      isLoading(true);
      errorNetwork(false);
      isError(false);
      final response = await _attendanceService.getCheckInOutList(_empId!);
      checkInOutData.assignAll(response);
    } on SocketException {
      await Future.delayed(Duration(milliseconds: 500));
      errorNetwork(true);
    } catch (e) {
      isError(true);
    } finally {
      isLoading(false);
    }
  }

  Future<String> getAddressFromLatLng(String? lat, String? lng) async {
    if (lat == null || lng == null) return "Not available";
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(lat),
        double.parse(lng),
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.subAdministrativeArea}, ${place.country}";
      } else {
        return "Address not found";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<void> openMap(double? lat, double? lng) async {
    if (lat == null || lng == null) return;

    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    log(url.toString());

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      log('Could not open the map.');
    }
  }
}
