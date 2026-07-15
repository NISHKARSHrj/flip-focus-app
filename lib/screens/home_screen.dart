import 'package:flutter/material.dart';
import 'package:flip/core/constants/colors.dart';
import 'package:flip/screens/focus_screen.dart';
import 'package:flip/core/services/battery_service.dart';
import 'package:flip/widgets/permission_dialog.dart';
import 'package:flip/core/services/onboarding_service.dart';
import 'package:flip/core/services/background_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:do_not_disturb/do_not_disturb.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final dndPlugin = DoNotDisturbPlugin();

  Future<void> checkDNDPermission() async {
    bool hasPermission = await dndPlugin.isNotificationPolicyAccessGranted();

    if (!hasPermission) {
      await dndPlugin.openNotificationPolicyAccessSettings();
    } else {
      debugPrint("DND Permission Already Granted");
    }
  }

  Future<void> checkNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> checkBatteryOptimization() async {
    bool isDisabled = await BatteryService.isBatteryOptimizationDisabled();

    if (!isDisabled) {
      await BatteryService.requestDisableBatteryOptimization();
    }
  }

  Future<void> completeOnboarding() async {
    await checkNotificationPermission();
    await checkDNDPermission();
    await checkBatteryOptimization();
    await OnboardingService.setOnboardingCompleted();
  }

  Future<void> checkOnboarding() async {
    bool completed = await OnboardingService.isOnboardingCompleted();

    if (!completed) {
      if (!mounted) return;

      showPermissionDialog(
        context,
        onContinue: () async {
          await completeOnboarding();
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkOnboarding();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      debugPrint("App Resumed");

      bool hasDnd = await dndPlugin.isNotificationPolicyAccessGranted();

      bool batteryDisabled =
          await BatteryService.isBatteryOptimizationDisabled();
      if (hasDnd && !batteryDisabled) {
        await checkBatteryOptimization();
        return;
      }
      if (hasDnd && batteryDisabled) {
        await OnboardingService.setOnboardingCompleted();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      //safearea notch or status bar ke liye
      body: SafeArea(
        //pure screen ko around spacing ke liye
        child: Padding(
          padding: const EdgeInsets.all(20),

          //colum widgets ko vertical direction deta hai
          child: Column(
            //sab widget left side se start
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              //header section
              Row(
                //left,center or right ko spread krega
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  //left Menu icon as UI
                  Icon(Icons.menu, color: AppColors.text),
                  //center Title
                  Text(
                    "Flip",
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Right profile icon
                  Icon(Icons.person_outline, color: AppColors.text),
                ],
              ),
              //header r bich ke section ka comment
              SizedBox(height: 40),

              //hero section
              Text(
                "Ready To Focus?",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              //descrption
              Text(
                "Flip your phone face down and start a distraction free session.",
                style: TextStyle(color: AppColors.secondaryText, fontSize: 16),
              ),
              const SizedBox(height: 30),

              //phone image
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    //phone illus
                    Center(
                      child: Image.asset(
                        'assets/images/Phone_Illus.png',
                        height: 250,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await BackgroundService.start();
                    Navigator.push(
                      context,

                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const FocusScreen(),

                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,

                                child: child,
                              );
                            },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_circle_fill, color: AppColors.text),
                      SizedBox(width: 10),
                      Text(
                        "Start Focus Session",

                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
