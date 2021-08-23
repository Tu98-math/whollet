import 'package:flutter/material.dart';
import 'package:whollet/constants/app_colors.dart';

class OnboardingTop extends StatelessWidget {
  const OnboardingTop({
    Key? key,
    required this.indexpage,
    required this.image,
    required this.skipPress,
  }) : super(key: key);

  final int indexpage;
  final String image;
  final Function skipPress;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height * .35,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                image,
              ),
            ),
          ),
        ),
        if (indexpage < 3)
          Positioned(
            right: 24,
            child: InkWell(
              onTap: () => skipPress(),
              child: Text(
                "Skip",
                style: TextStyle(
                  color: AppColors.kPrimaryBlueColor,
                  fontSize: 19,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
