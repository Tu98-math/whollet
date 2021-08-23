import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whollet/constants/app_colors.dart';
import 'package:whollet/constants/constants.dart';
import 'package:whollet/constants/images.dart';
import 'package:whollet/routing/routes.dart';
import 'package:whollet/widgets/default_button.dart';
import 'package:whollet/widgets/nav_to_login.dart';
import 'package:whollet/widgets/top_background_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isHidden = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _status = '';
  final _formKey = GlobalKey<FormState>();

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<void> _checkLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _status = '';
      });
      print('Email ${_emailController.text}');
      print('Pass ${_passwordController.text}');
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (userCredential.user != null) {
          Navigator.pushNamed(context, Routes.enterPinRoute);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          setState(() {
            _status = 'No user found for that email.';
          });
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          setState(() {
            _status = 'Wrong password provided for that user.';
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
      appBar: buildAppBar(),
      body: Container(
        color: AppColors.kBackgroundColor,
        child: Stack(
          children: [
            TopBackgroundLogin(image: AppImages.imgSignUp),
            Positioned(
              bottom: 0,
              width: size.width,
              height: !_keyboardIsVisible()
                  ? (size.height * .5)
                  : (size.height * .40),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              validator: (val) => val!.isNotEmpty
                                  ? null
                                  : 'Please enter a email address',
                              decoration: InputDecoration(
                                hintText: 'Email address',
                                labelText: 'Email address',
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              validator: (val) => val!.length < 6
                                  ? 'Enter more than 6 char'
                                  : null,
                              obscureText: _isHidden,
                              obscuringCharacter: '●',
                              decoration: InputDecoration(
                                hintText: 'Password',
                                labelText: 'Password',
                                suffix: InkWell(
                                  onTap: _togglePasswordView,
                                  child: Icon(
                                    Icons.visibility_outlined,
                                    color: AppColors.kTextLightColor,
                                  ),
                                ),
                              ),
                            ),
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
                          ],
                        ),
                      ),
                      Spacer(),
                      DefaultButton(
                        press: _checkLogin,
                        text: 'Login',
                        outline: false,
                      ),
                      SizedBox(height: 16),
                      if (!_keyboardIsVisible())
                        NavToLogin(
                          isLogin: false,
                          isBlueBackground: false,
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Welcome Back!',
        style: TextStyle(
          color: AppColors.kTextColor,
          fontWeight: FontWeight.w600,
          fontSize: 26,
        ),
      ),
      backgroundColor: AppColors.kBackgroundColor,
      automaticallyImplyLeading: false,
      elevation: 0,
    );
  }
}
