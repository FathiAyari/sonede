import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:umbrella/models/User.dart';
import 'package:umbrella/presentation/ressources/routes/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var seen = GetStorage().read("seen");
  var role = GetStorage().read("role");
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      if (seen == 1) {
        if (role != null) {
          if (role == 'client') {
            //get the status of the connected client 0 or 1
            getDataOfUser().then((value) {
              if (value.status != 1) {
                Get.toNamed(AppRouting.deletedAccount);
              } else {
                Get.toNamed(AppRouting.homeClient);
              }
            });
          } else {
            Get.toNamed(AppRouting.homeAdmin);
          }
        } else {
          Get.toNamed(AppRouting.login);
        }
      } else {
        Get.toNamed(AppRouting.onboarding);
      }
    });
  }

  Future<Cuser> getDataOfUser() async {
    var user = GetStorage().read("user");
    var userData = await FirebaseFirestore.instance.collection('users').doc(user['uid']).get();
    return Cuser.fromJson(userData.data()!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan,
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: Lottie.asset("assets/lotties/splash_screen.json", fit: BoxFit.contain),
            ),
            const Expanded(
                child: Center(
                    child: CircularProgressIndicator(
              color: Colors.white,
            )))
          ],
        ));
  }
}
