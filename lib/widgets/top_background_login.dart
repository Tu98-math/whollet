import 'package:flutter/material.dart';

class TopBackgroundLogin extends StatelessWidget {
  const TopBackgroundLogin({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Positioned(
      top: 0,
      width: size.width,
      child: Container(
        width: size.width,
        child: Center(
          child: Image.asset(
            image,
            width: size.width - 52,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
