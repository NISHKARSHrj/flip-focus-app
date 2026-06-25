import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
// import 'package:flip/core/constants/colors.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  String phoneState = "Unknown";
  Timer? timer;
  int secondsremaining = 1500; //25 min
  bool isRunning = false;

  @override
  void initState() {
    super.initState();

    accelerometerEventStream().listen((event) {
      double z = event.z;

      if (z > 8) {
        setState(() {
          phoneState = "Face Up";
          stoptimer();
        });
      } else if (z < -8) {
        setState(() {
          phoneState = "Face Down";
          startTimer();
        });
      }
    });
  }

  void startTimer() {
    debugPrint("Timer Started");
    if (isRunning) return;
    isRunning = true;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsremaining > 0) {
        setState(() {
          secondsremaining--;
        });
      } else {
        timer.cancel();
        isRunning = false;
      }
    });
  }

  void stoptimer() {
    debugPrint("Timer Started");
    timer?.cancel();
    isRunning = false;
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;

    int remainingSeconds = seconds % 60;

    String mins = minutes.toString().padLeft(2, '0');
    String secs = remainingSeconds.toString().padLeft(2, '0');

    return '$mins:$secs';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070D),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Text(
                  phoneState,

                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              const SizedBox(height: 60),

              Container(
                height: 250,
                width: 250,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  border: Border.all(color: Colors.purple, width: 4),
                ),

                child: Center(
                  child: Text(
                    formatTime(secondsremaining),

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Text(
                isRunning ? "Focus Session Active" : "Waiting For Face Down",

                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
