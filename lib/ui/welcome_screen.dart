import 'package:flutter/material.dart';
import 'package:whollet/constants/app_colors.dart';
import 'package:whollet/constants/images.dart';
import 'package:whollet/routing/routes.dart';
import 'package:whollet/widgets/default_button.dart';
import 'package:whollet/widgets/nav_to_login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: AppColors.kPrimaryBlueColor,
        child: Column(
          children: [
            SizedBox(height: 120),
            Image.asset(AppImages.imgLogo),
            SizedBox(height: 30),
            Text(
              "Welcome to",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white.withOpacity(.5),
              ),
            ),
            Text(
              "WHOLLET",
              style: TextStyle(
                fontSize: 48,
                color: Colors.white,
              ),
            ),
            Spacer(),
            DefaultButton(
              press: () {
                Navigator.pushNamed(context, Routes.loginRoute);
              },
              text: "Sign In",
            ),
            SizedBox(height: 16),
            NavToLogin(
              isLogin: false,
              isBlueBackground: true,
            ),
            SizedBox(height: size.height * .08),
          ],
        ),
      ),
    );
  }
}
