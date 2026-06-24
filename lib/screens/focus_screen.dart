import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flip/core/constants/colors.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  String phoneState = "Unknown";

  @override
  void initState() {
    super.initState();

    accelerometerEventStream().listen((event) {
      double z = event.z;

      if (z > 8) {
        setState(() {
          phoneState = "Face Up";
        });
      } else if (z < -8) {
        setState(() {
          phoneState = "Face Down";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Text(
                  phoneState,
                  style: const TextStyle(color: AppColors.text),
                ),
              ),

              const SizedBox(height: 50),

              Container(
                height: 250,
                width: 250,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.text, width: 4),
                ),
                child: const Center(
                  child: Text(
                    "25:00",
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
