import 'package:flutter/material.dart';
import 'package:flip/core/constants/colors.dart';
import 'package:flip/core/models/focus_session.dart';
import 'package:flip/core/services/storage_service.dart';
import 'package:flip/widgets/history_card.dart';
import 'package:do_not_disturb/do_not_disturb.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Future me storage se sessions load honge
  late Future<List<FocusSession>> sessions;
  final dndPlugin = DoNotDisturbPlugin();

  Future<void> checkDNDPermission() async {
    bool hasAcess = await dndPlugin.isNotificationPolicyAccessGranted();

    if (!hasAcess) {
      showDNDDialog();
    }
  }

  void showDNDDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,

          title: const Text(
            "Enable Do Not Disturb",
            style: TextStyle(color: AppColors.text),
          ),

          content: const Text(
            "Flip needs Do Not Disturb permission to silence notifications while you're focusing.",
            style: TextStyle(color: AppColors.secondaryText),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Later"),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await dndPlugin.openNotificationPolicyAccessSettings();
              },
              child: const Text("Enable"),
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

    // App khulte hi sessions load karo
    sessions = StorageService.loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "History",
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
      ),

      body: FutureBuilder<List<FocusSession>>(
        future: sessions,

        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Empty state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No Focus Sessions Yet",
                style: TextStyle(color: AppColors.text, fontSize: 18),
              ),
            );
          }

          // Data mil gaya
          final history = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(20),

            itemCount: history.length,

            itemBuilder: (context, index) {
              final session = history[index];

              return HistoryCard(
                duration: "${session.duration} sec",

                sound: session.sound,

                date: session.date,
              );
            },
          );
        },
      ),
    );
  }
}
