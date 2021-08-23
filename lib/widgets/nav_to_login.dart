import 'package:flutter/material.dart';
import 'package:whollet/constants/app_colors.dart';
import 'package:whollet/routing/routes.dart';

class NavToLogin extends StatelessWidget {
  const NavToLogin({
    Key? key,
    this.isLogin = true,
    this.isBlueBackground = false,
  }) : super(key: key);

  final bool isLogin;
  final bool isBlueBackground;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? 'Already have an account?' : "Don’t have an account?",
          style: TextStyle(
            color: isBlueBackground ? Colors.white : Color(0xFF485068),
            fontSize: 15,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
                context, isLogin ? Routes.loginRoute : Routes.signUpRoute);
          },
          child: Text(
            isLogin ? ' Login' : " Sign Up",
            style: TextStyle(
              color:
                  isBlueBackground ? Colors.white : AppColors.kPrimaryBlueColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
