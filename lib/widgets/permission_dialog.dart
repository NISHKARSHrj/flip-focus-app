import 'package:flutter/material.dart';
import 'package:flip/core/constants/colors.dart';

Future<void> showPermissionDialog(
  BuildContext context, {
  required VoidCallback onContinue,
}) async {
  await showDialog( 
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.card,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        title: const Column(
          children: [
            Icon(Icons.shield_outlined, color: AppColors.primary, size: 52),
            SizedBox(height: 16),

            Text(
              "Welcome to Flip",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Before your first focus session, Flip needs a few permissions to work properly.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.secondaryText),
            ),
            SizedBox(height: 24),

            Row(
              children: [
                Icon(Icons.do_not_disturb_on, color: Colors.red),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Do Not Disturb",
                    style: TextStyle(color: AppColors.text),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.battery_saver, color: Colors.green),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Battery Optimization",
                    style: TextStyle(color: AppColors.text),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onContinue();
              },
              child: const Text("Continue"),
            ),
          ),
        ],
      );
    },
  );
}
