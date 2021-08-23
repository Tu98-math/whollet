import 'package:flutter/material.dart';
import 'package:whollet/constants/app_colors.dart';

class CustomUserInfo extends StatelessWidget {
  const CustomUserInfo({
    Key? key,
    required this.firstName,
    required this.lastName,
    this.balance = .0,
    required this.isBalance,
    required this.pressShowHide,
  }) : super(key: key);

  final bool isBalance;
  final String firstName, lastName;
  final double balance;
  final Function pressShowHide;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * .20,
      child: Stack(
        children: [
          Container(
            height: size.height * .16,
            decoration: BoxDecoration(
              color: AppColors.kPrimaryBlueColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Hi, $firstName $lastName',
                    style: TextStyle(
                      fontSize: size.width * .06,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () => pressShowHide(),
                    child: isBalance
                        ? Text("HIDE", style: TextStyle(color: Colors.white))
                        : Text("SHOW", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: size.height * .08,
                  width: size.width - 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: AppColors.kPrimaryBlueColor.withOpacity(.5),
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      children: [
                        Text(
                          "${isBalance ? (balance).toStringAsFixed(4) : "********"} ICX",
                          style: TextStyle(
                            fontSize: size.width * .06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "${isBalance ? (balance * 1.49).toStringAsFixed(4) : "********"} \$",
                          style: TextStyle(
                            fontSize: size.width * .06,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
