import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_network/flutter_icon_network.dart';
import 'package:whollet/constants/app_colors.dart';
import 'package:whollet/constants/constants.dart';
import 'package:whollet/constants/images.dart';
import 'package:whollet/routing/routes.dart';
import 'package:whollet/widgets/default_button.dart';
import 'package:whollet/widgets/nav_to_login.dart';
import 'package:whollet/widgets/top_background_login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isHidden = true;
  String _status = '';
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<void> _checkSignUp() async {
    setState(() {
      _status = '';
    });
    if (_formKey.currentState!.validate()) {
      print("Email ${_emailController.text}");
      print("Email ${_passwordController.text}");
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (userCredential.user != null) {
          final wallet = await FlutterIconNetwork.instance!.createWallet;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid.toString())
              .set({
                'first_name': _firstNameController.text,
                'last_name': _lastNameController.text,
                'uid': userCredential.user!.uid.toString(),
                'email': _emailController.text,
                'address': wallet.address,
                'primary_key': wallet.privateKey,
                'pin': {
                  'pin': Crypt.sha256('1111', rounds: 10000, salt: 'anhtucute')
                      .hash
                },
              })
              .then((value) =>
                  {Navigator.pushNamed(context, Routes.createPinRoute)})
              .catchError((error) =>
                  // ignore: invalid_return_type_for_catch_error
                  print("Failed to add user: $error"));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          setState(() {
            _status = 'The password provided is too weak.';
          });
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            _status = 'The account already exists for that email.';
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _keyboardIsVisible() {
      return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Account",
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: AppColors.kBackgroundColor,
        child: Stack(
          children: [
            TopBackgroundLogin(image: AppImages.imgOffice),
            Positioned(
              bottom: 0,
              left: 0,
              width: size.width,
              height: !_keyboardIsVisible()
                  ? size.height * .6
                  : size.height * .6 - 102,
              child: Container(
                width: size.width,
                padding: EdgeInsets.all(AppConstants.kDefaultPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.kDefaultPadding),
                    topRight: Radius.circular(AppConstants.kDefaultPadding),
                  ),
                  color: Colors.white,
                ),
                child: Container(
                  width: size.width,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: !_keyboardIsVisible()
                              ? size.height * .3
                              : size.height * .3 - 50,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _firstNameController,
                                  validator: (val) => val!.isNotEmpty
                                      ? null
                                      : "Please enter first name",
                                  decoration: InputDecoration(
                                    labelText: "First name",
                                  ),
                                ),
                                TextFormField(
                                  controller: _lastNameController,
                                  validator: (val) => val!.isNotEmpty
                                      ? null
                                      : "Please enter last name",
                                  decoration: InputDecoration(
                                    labelText: "Last name",
                                  ),
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  validator: (val) => val!.isNotEmpty
                                      ? null
                                      : "Please enter a email address",
                                  decoration: InputDecoration(
                                    labelText: "Email address",
                                  ),
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  validator: (val) => val!.length < 6
                                      ? "Enter more than 6 char"
                                      : null,
                                  obscureText: _isHidden,
                                  obscuringCharacter: '●',
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    suffix: InkWell(
                                      onTap: _togglePasswordView,
                                      child: Icon(
                                        Icons.visibility_outlined,
                                        color: AppColors.kTextLightColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        SizedBox(height: 7),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              _status,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        DefaultButton(
                          press: _checkSignUp,
                          text: "Let’s Get Started",
                          outline: false,
                        ),
                        SizedBox(height: 16),
                        if (!_keyboardIsVisible())
                          NavToLogin(
                            isLogin: true,
                            isBlueBackground: false,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
