import 'package:crypt/crypt.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whollet/constants/app_colors.dart';
import 'package:whollet/constants/images.dart';
import 'package:whollet/routing/routes.dart';
import 'package:whollet/widgets/pin_keyboard.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({Key? key}) : super(key: key);

  @override
  _CreatePinScreenState createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  String _input = "", uid = '';
  String _pass = "";
  // ignore: unused_field
  String _passConfirm = "";
  bool _isConfirm = false;

  void addString(String index) {
    setState(() {
      if (_input.length < 4) _input += index.toString();
      if (_input.length == 4 && _pass == "") {
        _pass = _input;
        _input = "";
        _isConfirm = true;
      }
      if (_input.length == 4 && _pass != "") {
        _passConfirm = _input;
      }
      if (_passConfirm == _pass && _pass.length == 4) {
        CheckPin();
      } else if (_passConfirm.length == 4)
        Navigator.pushNamed(context, Routes.createPinRoute);
    });
  }

  void removeString() {
    setState(() {
      if (_input.length > 0) _input = _input.substring(0, _input.length - 1);
    });
  }

  void loadID() {
    if (uid == '')
      setState(() {
        print("Set IDDD");
        uid = FirebaseAuth.instance.currentUser!.uid;
      });
  }

  // ignore: non_constant_identifier_names
  void CheckPin() {
    if (uid != '') {
      FirebaseFirestore.instance.collection('users').doc(uid).update(
        {'pin': Crypt.sha256(_pass, rounds: 10000, salt: 'anhtucute').hash},
      );
      Navigator.pushNamed(context, Routes.homeRoute);
    }
  }

  void prevToCreate() {
    setState(() {
      _input = "";
      _pass = "";
      _passConfirm = "";
      _isConfirm = false;
    });
  }

  @override
  void initState() {
    loadID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(_isConfirm, prevToCreate),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              !_isConfirm
                  ? "Enhance the security of your account by creating a PIN code"
                  : "Repeat a PIN code to continue",
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < _input.length
                          ? Color(0xFF75BF72)
                          : Color(0xFF9EA5B1),
                    ),
                  ),
                )
            ],
          ),
          Spacer(),
          PinKeyboard(
            pressAddString: addString,
            removeString: removeString,
          )
        ],
      ),
    );
  }

  AppBar buildAppBar(bool isConfirm, Function press) {
    return AppBar(
      title: Text(!isConfirm ? "Create a PIN" : "Confirm PIN"),
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: SvgPicture.asset(
              AppImages.backIcon,
              color: AppColors.kTextColor,
            ), // Put icon of your preference.
            onPressed: () {
              isConfirm ? press() : Navigator.pop(context);
            },
          );
        },
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
