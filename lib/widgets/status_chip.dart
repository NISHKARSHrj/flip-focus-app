import 'package:flutter/material.dart';
import 'package:flip/core/constants/colors.dart';

class StatusChip extends StatelessWidget {
  final bool isRunning;

  const StatusChip({
    super.key,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 10,
            color: isRunning ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            isRunning
                ? "Focus Active"
                : "Waiting For Face Down",
            style: TextStyle(
              color: AppColors.text,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}