import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whollet/constants/app_colors.dart';

class DoubleText extends StatelessWidget {
  const DoubleText({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title, content;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.kTextLightColor,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: content));
              },
              icon: Icon(
                Icons.copy,
                size: 20,
              ),
            ),
          ],
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }
}
