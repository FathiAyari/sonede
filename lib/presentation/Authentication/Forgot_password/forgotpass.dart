import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:umbrella/models/snack_bar_types.dart';
import 'package:umbrella/presentation/components/input_field/input_field.dart';
import 'package:umbrella/presentation/components/snack_bar.dart';
import 'package:umbrella/presentation/ressources/colors.dart';
import 'package:umbrella/presentation/ressources/dimensions/constants.dart';
import 'package:umbrella/services/AuthServices.dart';

//import 'homescreen.dart';

final _formkey = GlobalKey<FormState>();

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({Key? key}) : super(key: key);

  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  TextEditingController emailController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ), // Change this icon to your desired back button icon
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                  child: Column(children: [
                Container(
                  height: Constants.screenHeight * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(90),
                    ),
                    color: AppColors.primary,
                  ),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/lotties/reset.json", height: Constants.screenHeight * 0.2),
                      Container(
                        child: Text(
                          'Restaurer votre mot de passe ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              //  fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                      )
                    ],
                  )),
                ),
                SizedBox(height: 30),
                Form(
                  key: _formkey,
                  child: InputField(
                      label: 'Email',
                      controller: emailController,
                      textInputType: TextInputType.emailAddress,
                      prefixWidget: Icon(Icons.email)),
                ),
                SizedBox(
                  height: 30,
                ),
                loading
                    ? CircularProgressIndicator()
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            Expanded(
                                child: CupertinoButton(
                                    child: Text('Envoyer', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
                                    color: AppColors.primary,
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        setState(() {
                                          loading = true;
                                        });
                                        AuthServices().resetPassword(emailController.text).then((value) {
                                          setState(() {
                                            loading = false;
                                          });
                                          if (value) {
                                            SnackBars(
                                                    label: "Consulter votre mail",
                                                    type: SnackBarsTypes.success,
                                                    onTap: () {},
                                                    actionLabel: "Fermer",
                                                    context: context)
                                                .showSnackBar();
                                          } else {
                                            SnackBars(
                                                    label: "compte n'existe pas",
                                                    type: SnackBarsTypes.alert,
                                                    onTap: () {},
                                                    actionLabel: "Fermer",
                                                    context: context)
                                                .showSnackBar();
                                          }
                                        });
                                      }
                                    }))
                          ],
                        )),
              ])))),
    );
  }
}
