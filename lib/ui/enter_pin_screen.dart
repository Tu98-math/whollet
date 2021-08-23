import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whollet/constants/app_colors.dart';
import 'package:whollet/constants/images.dart';
import 'package:whollet/routing/routes.dart';
import 'package:whollet/widgets/pin_keyboard.dart';

class EnterPinScreen extends StatefulWidget {
  const EnterPinScreen({Key? key}) : super(key: key);

  @override
  _EnterPinScreenState createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  String _password = "", uid = '';

  void addString(String index) {
    setState(() {
      if (_password.length < 4) _password += index.toString();
      if (_password.length == 4) {
        CheckPin();
      }
    });
  }

  void removeString() {
    setState(() {
      if (_password.length > 0)
        _password = _password.substring(0, _password.length - 1);
    });
  }

  // ignore: non_constant_identifier_names
  Future<void> CheckPin() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    if (uid != '') {
      print(
          "HASH ${Crypt.sha256(_password, rounds: 10000, salt: 'anhtucute').hash}");
      await FirebaseFirestore.instance.collection('users').doc(uid).get().then(
        (DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            if (Crypt.sha256(_password, rounds: 10000, salt: 'anhtucute')
                    .hash ==
                documentSnapshot.get('pin'))
              Navigator.pushNamed(context, Routes.homeRoute);
            else {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, Routes.loginRoute);
            }
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: <Widget>[
          Text(
            "Please enter your PIN to proceed",
            style: TextStyle(
              fontSize: 15,
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
                      color: i < _password.length
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

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Verification Required"),
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: SvgPicture.asset(
              AppImages.backIcon,
              color: AppColors.kTextColor,
            ), // Put icon of your preference.
            onPressed: () {
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
