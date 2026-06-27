import 'package:flutter/material.dart';
import 'package:flip/core/constants/colors.dart';

class HistoryCard extends StatelessWidget {
  final String duration;
  final String sound;
  final String date;

  const HistoryCard({
    super.key,
    required this.duration,
    required this.sound,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Duration
          Row(
            children: [

              Icon(
                Icons.timer_outlined,
                color: AppColors.primary,
              ),

              const SizedBox(width: 10),

              Text(
                duration,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Sound
          Row(
            children: [

              Icon(
                Icons.music_note,
                color: AppColors.secondaryText,
              ),

              const SizedBox(width: 10),

              Text(
                sound,
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Date
          Row(
            children: [

              Icon(
                Icons.calendar_today,
                size: 18,
                color: AppColors.secondaryText,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}