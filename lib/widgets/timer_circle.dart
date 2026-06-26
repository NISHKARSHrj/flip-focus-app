import 'package:flutter/material.dart';
import 'package:flip/core/constants/colors.dart';

class TimerCircle extends StatelessWidget {

  final String time;

  const TimerCircle({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      
      height: 280,
      width: 280,

      child: Stack(

        
        alignment: Alignment.center,

        children: [

          SizedBox(

            height: 280,
            width: 280,

            child: CircularProgressIndicator(

              // Abhi full ring
              value: 1,

              strokeWidth: 8,

              backgroundColor: AppColors.card,

              valueColor: AlwaysStoppedAnimation(
                AppColors.primary,
              ),
            ),
          ),

          Column(

            // Column sirf jitni space chahiye utni lega
            mainAxisSize: MainAxisSize.min,

            children: [

              Text(

                time,

                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(

                "Focus Session",

                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}