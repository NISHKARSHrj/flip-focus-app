import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:flip/core/constants/colors.dart';

import 'package:flutter/material.dart';

import 'package:flip/widgets/status_chip.dart';
import 'package:flip/widgets/timer_circle.dart';

import 'package:flip/core/models/focus_session.dart';
import 'package:flip/core/services/storage_service.dart';

import 'package:vibration/vibration.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

import 'package:do_not_disturb/do_not_disturb.dart';
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

  bool isFaceDown = false;
  bool isSessionRunning = false;

  double previousX = 0;
  double previousY = 0;
  double previousZ = 0;

  bool isNear = false;
  late StreamSubscription<dynamic> proximitySubscription;

  final dndPlugin = DoNotDisturbPlugin();
  @override
  void initState() {
    super.initState();

    proximitySubscription = ProximitySensor.events.listen((event) {
      setState(() {
        isNear = event > 0;
      });
    });

    accelerometerEventStream().listen((event) {
      double x = event.x;
      double y = event.y;
      double z = event.z;

      if (z < -9 && x.abs() < 2 && y.abs() < 2 && isNear) {
        if (!isFaceDown) {
          isFaceDown = true;

          setState(() {
            phoneState = "Face Down";
          });

          startTimer();
        }
      } else {
        if (isFaceDown && !isNear) {
          isFaceDown = false;

          setState(() {
            phoneState = "Phone Lifted";
          });

          stoptimer();
        }
      }
    });
  }

  Future<void> vibratePhone() async {
    // Check karo ki device vibration support karta hai ya nahi
    bool? hasVibrator = await Vibration.hasVibrator();

    if (hasVibrator == true) {
      // 150 milliseconds ki vibration
      Vibration.vibrate(duration: 150);
    }
  }

  Future<void> enableDND() async {
    await dndPlugin.setInterruptionFilter(InterruptionFilter.none);
  }

  Future<void> disableDND() async {
    await dndPlugin.setInterruptionFilter(InterruptionFilter.all);
  }

  Future<void> startTimer() async {
    // debugPrint("Timer Started");
    if (isRunning) return;
    await enableDND();
    await vibratePhone();

    isRunning = true;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsremaining > 0) {
        setState(() {
          secondsremaining--;
        });
      } else {
        timer.cancel();
        isRunning = false;
        disableDND();
      }
    });
  }

  Future<void> stoptimer() async {
    // debugPrint("Timer stp")
    timer?.cancel();
    await disableDND();
    await vibratePhone();
    isRunning = false;
  }

  void resettimer() async {
    timer?.cancel();
    await disableDND();
    setState(() {
      secondsremaining = 1500;

      isRunning = false;

      phoneState = "Face Up";
      isFaceDown = false;
    });
  }

  Future<void> saveCurrentSession() async {
    if (secondsremaining == 1500) return;

    int focusedSeconds = 1500 - secondsremaining;

    FocusSession session = FocusSession(
      duration: focusedSeconds,

      date: DateTime.now().toString(),
      sound: "Rain",
    );

    await StorageService.saveSession(session);

    debugPrint("Session Saved Successfully");
  }

  void endSession() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,

          title: const Text(
            "End Focus Session",
            style: TextStyle(color: AppColors.text),
          ),

          content: const Text(
            "Your current focus session will end.",
            style: TextStyle(color: AppColors.secondaryText),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await disableDND();
                timer?.cancel();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

              child: const Text("End"),
            ),
          ],
        );
      },
    );
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
    proximitySubscription.cancel();
    timer?.cancel();
    super.dispose();
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
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new, color: AppColors.text),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Focus",
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Center(child: StatusChip(isRunning: isRunning)),

              const SizedBox(height: 60),

              Center(child: TimerCircle(time: formatTime(secondsremaining))),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: resettimer,

                  icon: const Icon(Icons.refresh),

                  label: const Text("Reset Timer"),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.text,

                    padding: const EdgeInsets.symmetric(vertical: 10),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: endSession,

                  icon: const Icon(Icons.stop_circle),

                  label: const Text("End Session"),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,

                    foregroundColor: AppColors.text,

                    padding: const EdgeInsets.symmetric(vertical: 18),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                isRunning ? "Focus Session Active" : "Waiting For Face Down",
                style: const TextStyle(color: AppColors.text, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
