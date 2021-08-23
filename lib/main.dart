import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_network/flutter_icon_network.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whollet/routing/route_generator.dart';
import 'package:whollet/ui/onboarding_screen/onboarding_screen.dart';
import 'package:whollet/utils/theme/themes.dart';

void main() async {
  await GetStorage.init();
  await FlutterIconNetwork.instance!
      .init(host: "https://bicon.net.solidwallet.io/api/v3", isTestNet: true);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme(),
      onGenerateRoute: RouteGenerator().onGenerateRoute,
      home: const OnboardingScreen(),
    );
  }
}
