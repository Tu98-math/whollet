import 'package:flutter/material.dart';
import 'package:whollet/constants/app_colors.dart';

class ListDot extends StatelessWidget {
  const ListDot({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 4; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == index
                    ? AppColors.kPrimaryBlueColor
                    : AppColors.kBackgroundColor,
              ),
            ),
          ),
      ],
    );
  }
}
