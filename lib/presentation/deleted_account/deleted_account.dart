import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:umbrella/presentation/ressources/dimensions/constants.dart';
import 'package:umbrella/services/AuthServices.dart';

class DeletedAccount extends StatelessWidget {
  const DeletedAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(height: Constants.screenHeight * 0.5, child: Lottie.asset("assets/lotties/alert2.json")),
              Text(
                "Votre compte a été supprimé par un administrateur veuillez vous déconnecter",
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Set the border radius here
                        ),
                      ),
                      onPressed: () {
                        AuthServices().logOut(context);
                      },
                      child: Text(
                        "Se déconnecter",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
