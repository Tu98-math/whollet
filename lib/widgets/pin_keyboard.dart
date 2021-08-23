import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whollet/constants/images.dart';

class PinKeyboard extends StatelessWidget {
  const PinKeyboard({
    Key? key,
    required this.pressAddString,
    required this.removeString,
  }) : super(key: key);

  final Function pressAddString, removeString;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          for (int j = 0; j < 3; j++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 1; i <= 3; i++)
                  NumberButton(
                    number: (i + j * 3).toString(),
                    press: pressAddString,
                  ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NumberButton(
                number: "",
                press: () {},
              ),
              NumberButton(
                number: "0",
                press: pressAddString,
              ),
              Container(
                width: 81,
                height: 81,
                child: InkWell(
                  onTap: () => removeString(),
                  child: Center(
                    child: SvgPicture.asset(
                      AppImages.deleteIcon,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  const NumberButton({
    Key? key,
    required this.press,
    required this.number,
  }) : super(key: key);

  final Function press;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 81,
      height: 81,
      child: InkWell(
        onTap: () => press(number),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(color: Color(0xFF003282), fontSize: 38.88),
          ),
        ),
      ),
    );
  }
}
