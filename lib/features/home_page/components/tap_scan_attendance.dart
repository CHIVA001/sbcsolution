import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cyspharama_app/core/themes/app_colors.dart';
import 'package:cyspharama_app/core/themes/app_style.dart';
import 'package:cyspharama_app/features/auth/controllers/auth_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/attendance_page/controllers/attendance_controller.dart';
import 'package:cyspharama_app/features/dashboad_page/attendance_page/controllers/shift_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class TapScanAttendance extends StatefulWidget {
  const TapScanAttendance({super.key});

  @override
  State<TapScanAttendance> createState() => _TapScanAttendanceState();
}

class _TapScanAttendanceState extends State<TapScanAttendance>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  String _timeNow = "";
  String _dateNow = "";
  final _userCtr = Get.find<AuthController>();
  final attCtr = Get.find<AttendanceController>();
  final _shifCtr = Get.find<ShiftController>();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool _isLongTap = false;

  @override
  void initState() {
    super.initState();
    _updateTimeAndDate();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateTimeAndDate(),
    );

    // Initialize pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _shifCtr.getShiftId();
  }

  void _updateTimeAndDate() {
    final now = DateTime.now();
    setState(() {
      _timeNow = DateFormat('h:mm a').format(now);
      _dateNow = DateFormat('EEEE | MMMM, dd, yyyy').format(now);
    });
  }

  void _onCheckInTap() async {
    setState(() {
      _isLongTap = true;
    });
    if (_shifCtr.isLoading.value) return;
    Position? pos = await _determinePosition();
    // String location = pos != null
    //     ? '{"latitute":${pos.latitude},"longitute":${pos.longitude}}'
    //     : '{"latitute":null,"longitute":null}';
    if (pos == null) {
      setState(() {
        _isLongTap = false;
      });
      return; // stop here
    }

    String longitute = '${pos.longitude}';
    String latitute = '${pos.latitude}';
    if (latitute.isNotEmpty || longitute.isNotEmpty) {
      // await _shifCtr.handleTapCheckInOut(
      //   latitute: latitute,
      //   longitute: longitute,
      // );
      await _shifCtr.handleAttendance(
        latitute: pos.latitude.toString(),
        longitute: pos.longitude.toString(),
        fromQr: false, // 👉 tap mode
      );
      log('latitute: $latitute');
      log('longitute: $longitute');
    }
    // _shifCtr.handleTap();
    setState(() {
      _isLongTap = false;
    });
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Get.snackbar("Location", "Please enable location services");
      Get.defaultDialog(
        title: 'Location',
        radius: 2,
        titleStyle: textBold().copyWith(fontSize: 24.0),

        content: Column(
          children: [
            Text('Please enable location services', style: textdefualt()),
          ],
        ),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Ok",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      );
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.defaultDialog(
          title: 'Location',
          titlePadding: EdgeInsets.symmetric(vertical: 8.0),
          content: Column(
            children: [Text('Location permission permanently denied')],
          ),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.defaultDialog(
        title: 'Location',
        titlePadding: EdgeInsets.symmetric(vertical: 8.0),
        content: Column(
          children: [Text('Location permission permanently denied')],
        ),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgColorLight,
      appBar: AppBar(
        backgroundColor: AppColors.warningColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            size: 28.0,
            color: AppColors.bgColorLight,
          ),
        ),
        title: Text(
          "Scan Attendance",
          style: TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final label = (_shifCtr.shiftId.isEmpty) ? "Check In" : "Check Out";
        final color = _shifCtr.shiftId.isEmpty || _userCtr.isLoading.value
            ? !_isLongTap
                  ? Color(0xFFF9B838)
                  : Color(0xFFF9B838).withOpacity(0.5)
            : !_isLongTap
            ? AppColors.dangerColor
            : AppColors.dangerColor.withOpacity(0.5);

        if (_userCtr.isLoading.value || _userCtr.companies.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryDarker,
              strokeWidth: 1.5,
            ),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                const SizedBox(height: 32),
                CachedNetworkImage(
                  imageUrl: _userCtr.companies.isNotEmpty
                      ? '${_userCtr.companies.first.logo}'
                      : '',
                  placeholder: (context, url) => SizedBox.fromSize(),
                  errorWidget: (context, url, error) => SizedBox.fromSize(),
                  width: size.width * 0.3,
                ),
                SizedBox(height: 8.0),
                Text(
                  _userCtr.companies.isNotEmpty
                      ? "${_userCtr.companies.first.company}"
                      : '',
                  style: textBold().copyWith(
                    color: AppColors.primaryDarker,
                    fontSize: 18.0,
                  ),
                ),

                // Welcome Section
                const SizedBox(height: 24),

                // Time and Date (now dynamic)
                Text(
                  _timeNow,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  _dateNow,
                  style: const TextStyle(fontSize: 20, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ...List.generate(3, (index) {
                        double sizeOffset = index * 25.0;
                        double opacity = 0.3 - (index * 0.1);
                        if (opacity < 0) {
                          opacity = 0;
                        }

                        final bgColor =
                            _shifCtr.shiftId.isEmpty || _userCtr.isLoading.value
                            ? const Color(0xFFF9B838).withOpacity(opacity)
                            : AppColors.dangerColor.withOpacity(opacity);

                        return Container(
                          width: 180.0 + sizeOffset,
                          height: 180.0 + sizeOffset,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bgColor,
                          ),
                        );
                      }),
                      GestureDetector(
                        onTap: _isLongTap ? _onCheckInTap : null,

                        onTapDown: (details) => setState(() {
                          _isLongTap = true;
                        }),
                        onTapUp: (details) => setState(() {
                          _isLongTap = false;
                        }),
                        onTapCancel: () => setState(() {
                          _isLongTap = false;
                        }),
                        child: AnimatedScale(
                          duration: Duration(milliseconds: 300),
                          scale: _isLongTap ? 0.8 : 1,
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Obx(() {
                                    if (_shifCtr.isLoading.value ||
                                        _isLongTap) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.backgroundColor,
                                          strokeWidth: 1.5,
                                        ),
                                      );
                                    }
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.touch_app,
                                          color: Colors.white,
                                          size: 70,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          label,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Text(
                  _shifCtr.shiftId.isEmpty
                      ? "Tap to Check-In"
                      : "Tap to Check-Out",
                  style: textdefualt().copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: 32.0),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class IconTextColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;

  const IconTextColumn({
    super.key,
    required this.icon,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.black54),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
