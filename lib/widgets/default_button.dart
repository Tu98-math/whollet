import 'package:flutter/material.dart';
import 'package:whollet/constants/app_colors.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.press,
    required this.text,
    this.outline = true,
  }) : super(key: key);

  final Function press;
  final String text;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => press(),
      child: Container(
        width: 200,
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          border: Border.all(
            color: AppColors.kPrimaryBlueColor,
          ),
          color: outline ? Colors.white : AppColors.kPrimaryBlueColor,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: outline ? AppColors.kPrimaryBlueColor : Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
