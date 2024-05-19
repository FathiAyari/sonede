import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:umbrella/presentation/ressources/colors.dart';
import 'package:umbrella/presentation/ressources/dimensions/constants.dart';

class Content extends StatelessWidget {
  final String title;
  final String img;
  final String description;

  const Content({Key? key, required this.title, required this.img, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.08),
                child: Text(
                  "$title",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.primary, fontSize: 30),
                ),
              ),
              Lottie.asset(img, height: Constants.screenHeight * 0.25),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.05, horizontal: Constants.screenWidth * 0.03),
                child: Text(
                  "$description",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.primary, fontSize: Constants.screenHeight * 0.03),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
