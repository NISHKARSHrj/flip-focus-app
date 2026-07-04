import 'package:flutter/material.dart';
import 'package:flip/core/constants/colors.dart';
import 'package:flip/screens/focus_screen.dart';

import 'package:do_not_disturb/do_not_disturb.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dndPlugin = DoNotDisturbPlugin();

  Future<void> checkDNDPermission() async {
    bool hasPermission = await dndPlugin.isNotificationPolicyAccessGranted();

    if (!hasPermission) {
      showDNDDialog();
    }
  }

  Future<void> showDNDDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Enable Do Not Disturb',
            style: TextStyle(color: AppColors.text),
          ),

          content: const Text(
            'Flip needs Do Not Disturb permission to automatically block notifications while youre focusing.',
            style: TextStyle(color: AppColors.secondaryText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await dndPlugin.openNotificationPolicyAccessSettings();
              },
              child: const Text('Enable'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkDNDPermission();
    });
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
                  onPressed: () {
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
