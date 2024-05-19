import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:umbrella/models/snack_bar_types.dart';
import 'package:umbrella/presentation/components/input_field/input_field.dart';
import 'package:umbrella/presentation/components/snack_bar.dart';
import 'package:umbrella/presentation/on_boarding/on_boarding_controller.dart';
import 'package:umbrella/presentation/ressources/colors.dart';
import 'package:umbrella/presentation/ressources/dimensions/constants.dart';
import 'package:umbrella/presentation/ressources/routes/router.dart';
import 'package:umbrella/services/AuthServices.dart';

import '../Forgot_password/forgotpass.dart';
import '../Sign_up/signup.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignInScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  OnBoardingController controller = OnBoardingController();

  Future<bool> avoidReturnButton() async {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text("vous etes sur de sortir ?"),
            actions: [Negative(context), Positive()],
          );
        });
    return true;
  }

  Widget Positive() {
    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: TextButton(
          onPressed: () {
            exit(0);
          },
          child: const Text(
            " Oui",
            style: TextStyle(
              color: Color(0xffEAEDEF),
            ),
          )),
    );
  }

  Widget Negative(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context); // fermeture de dialog
        },
        child: Text(" Non"));
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: avoidReturnButton,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
                key: _formkey,
                child: Column(children: [
                  Container(
                    height: Constants.screenHeight * 0.4,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(90),
                      ),
                    ),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/lotties/login.json", height: Constants.screenHeight * 0.2),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            'Se Connecter ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                //  fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Constants.screenHeight * 0.1),
                    child: InputField(
                      label: "Email",
                      controller: emailController,
                      textInputType: TextInputType.emailAddress,
                      prefixWidget: Icon(
                        Icons.email,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  InputField(
                    label: "Mot de passe",
                    controller: passwordController,
                    textInputType: TextInputType.visiblePassword,
                    prefixWidget: Icon(
                      Icons.lock,
                      color: AppColors.primary,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(ForgotPassScreen());
                      },
                      child: Text(
                        "mot de passe oublié?",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black54,
                            //fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                      child:
                                          Text('Connexion', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      ),
                                      onPressed: () {
                                        if (_formkey.currentState!.validate()) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          AuthServices()
                                              .signIn(emailController.text, passwordController.text)
                                              .then((value) async {
                                            if (value) {
                                              AuthServices().getUserData().then((value) {
                                                AuthServices().saveUserLocally(value).then((value2) {
                                                  if (value.role == 'client') {
                                                    if (value.status != 1) {
                                                      Navigator.pushNamed(context, AppRouting.deletedAccount);
                                                    } else {
                                                      Navigator.pushNamed(context, AppRouting.homeClient);
                                                    }
                                                  } else {
                                                    Get.toNamed(AppRouting.homeAdmin);
                                                  }
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                });
                                              });
                                            } else {
                                              SnackBars(
                                                      label: "Verifier l'email et le mot de passe",
                                                      type: SnackBarsTypes.alert,
                                                      onTap: () {},
                                                      actionLabel: "Fermer",
                                                      context: context)
                                                  .showSnackBar();
                                              setState(() {
                                                print('set value');
                                                isLoading = false;
                                              });
                                            }
                                          });
                                        }
                                      }))
                            ],
                          )),
                  SizedBox(height: 20),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: Text("Besoin d'un nouveau compte?",
                                style: TextStyle(color: AppColors.primary, fontSize: 14, fontStyle: FontStyle.italic)),
                            onPressed: () {
                              Get.to(SignupScreen());
                            },
                          ))
                        ],
                      )),
                ])),
          )),
    );
  }
}
