import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icon_network/flutter_icon_network.dart';
import 'package:intl/intl.dart';
import 'package:whollet/constants/app_colors.dart';
import 'package:whollet/routing/routes.dart';
import 'package:whollet/widgets/default_button.dart';
import 'components/custom_user_info.dart';
import 'components/double_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String uid = '';
  double _balance = 0;
  String _firstName = '', _lastName = '', _primaryKey = '', _address = '';
  bool _isBalance = false;
  // ignore: non_constant_identifier_names
  TextEditingController _ICXController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String status = "Transfer";

  void loadID() {
    if (uid == '')
      setState(() {
        print("Set IDDD");
        uid = FirebaseAuth.instance.currentUser!.uid;
      });
  }

  void loadData() {
    if (uid != '') {
      FirebaseFirestore.instance.collection('users').doc(uid).get().then(
        (DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists && _primaryKey == '') {
            setState(() {
              print(documentSnapshot.data());
              _primaryKey = documentSnapshot.get('primary_key');
              _address = documentSnapshot.get('address');
              _firstName = documentSnapshot.get('first_name');
              _lastName = documentSnapshot.get('last_name');
            });
          }
        },
      );
    }
  }

  void loadBalance() async {
    if (_primaryKey != '') {
      final balance = await FlutterIconNetwork.instance!
          .getIcxBalance(privateKey: _primaryKey);
      if (_balance != balance.icxBalance)
        setState(() {
          _balance = balance.icxBalance;
        });
    }
  }

  void showHideBalance() {
    setState(() {
      _isBalance = !_isBalance;
    });
  }

  Future<void> transferICX() async {
    if (_formKey.currentState!.validate()) {
      print("ICX ${_ICXController.text}");
      print("Address ${_addressController.text}");
      setState(() {
        status = "Loadding";
      });
      final tHash = await FlutterIconNetwork.instance!.sendIcx(
          yourPrivateKey: _primaryKey,
          destinationAddress: _addressController.text,
          value: _ICXController.text);
      _showTransferDialog(
        idTransaction: tHash.txHash.toString(),
        from: _address,
        to: _addressController.text,
        values: _ICXController.text,
        context: context,
      );
      setState(() {
        status = "Transfer";
        _ICXController.clear();
        _addressController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    loadID();
    loadData();
    loadBalance();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Wallet ICX",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.kPrimaryBlueColor,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, Routes.loginRoute);
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomUserInfo(
              balance: _balance,
              isBalance: _isBalance,
              firstName: _firstName,
              lastName: _lastName,
              pressShowHide: showHideBalance,
            ),
            SizedBox(height: 30),
            Text(
              "Transfer ICX",
              style: TextStyle(fontSize: size.width * .06),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: size.width * .8,
                    child: TextFormField(
                      controller: _ICXController,
                      validator: (val) => double.parse(val!) > _balance
                          ? "Your balance is not enough to complete this transaction"
                          : null,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Enter ICX', labelText: 'Enter ICX'),
                    ),
                  ),
                  Container(
                    width: size.width * .8,
                    child: TextFormField(
                      controller: _addressController,
                      validator: (val) => val!.isNotEmpty
                          ? null
                          : "Please enter a email address",
                      decoration: InputDecoration(
                          hintText: 'Enter destination address',
                          labelText: 'Enter destination address'),
                    ),
                  ),
                  SizedBox(height: 30),
                  DefaultButton(
                    press: transferICX,
                    text: status,
                    outline: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 23),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: _address));
              },
              child: Text(
                "Copy my address",
                style: TextStyle(fontSize: size.width * .06),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showTransferDialog(
    {required String idTransaction,
    required String from,
    required String to,
    required String values,
    required BuildContext context}) async {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Transaction Details',
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              DoubleText(title: 'Time', content: formattedDate),
              DoubleText(title: 'Total amount', content: values),
              DoubleText(title: 'Transaction ID', content: idTransaction),
              DoubleText(title: 'From', content: from),
              DoubleText(title: 'To', content: to),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DefaultButton(
                  press: () {
                    Navigator.pop(context);
                  },
                  text: "Back to Wallet",
                  outline: false,
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
