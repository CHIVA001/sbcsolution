import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CheckInSuccessBottomSheet extends StatelessWidget {
  const CheckInSuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/icons/success_animation.json',
            width: 200,
            height: 170,
            repeat: false,
          ),
          const SizedBox(height: 16),
          const Text(
            'Check-In Successful!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
