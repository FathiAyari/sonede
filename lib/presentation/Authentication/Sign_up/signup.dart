import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:umbrella/models/snack_bar_types.dart';
import 'package:umbrella/presentation/components/input_field/input_field.dart';
import 'package:umbrella/presentation/components/snack_bar.dart';
import 'package:umbrella/presentation/ressources/colors.dart';
import 'package:umbrella/presentation/ressources/dimensions/constants.dart';
import 'package:umbrella/presentation/ressources/routes/router.dart';
import 'package:umbrella/services/AuthServices.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  File? _image;
  String role = 'client';
  Country? selectedCountry;
  final _formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passWordController = TextEditingController();

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
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Container(
                          height: Constants.screenHeight * 0.2,
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
                              Lottie.asset("assets/lotties/login.json", height: Constants.screenHeight * 0.2),
                            ],
                          )),
                        ),
                      ),
                      InputField(
                        label: "Nom ",
                        controller: nameController,
                        textInputType: TextInputType.text,
                        prefixWidget: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.indigo,
                        ),
                      ),
                      InputField(
                        label: "Prénom ",
                        controller: lastNameController,
                        textInputType: TextInputType.text,
                        prefixWidget: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.indigo,
                        ),
                      ),
                      InputField(
                        label: "Email",
                        controller: emailcontroller,
                        textInputType: TextInputType.emailAddress,
                        prefixWidget: Icon(
                          Icons.email,
                          color: Colors.indigo,
                        ),
                      ),
                      InputField(
                        label: "Numéro portable",
                        controller: phoneNumberController,
                        textInputType: TextInputType.phone,
                        prefixWidget: Icon(
                          Icons.phone,
                          color: Colors.indigo,
                        ),
                      ),
                      InputField(
                        label: "Mot de passe",
                        controller: passWordController,
                        textInputType: TextInputType.visiblePassword,
                        prefixWidget: Icon(
                          Icons.lock,
                          color: Colors.indigo,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Constants.screenHeight * 0.001, horizontal: Constants.screenWidth * 0.07),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary.withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10), // Adjust the value to change the border radius
                                    ),
                                  ),
                                  onPressed: () {
                                    showCountryPicker(
                                      context: context,
                                      showPhoneCode: true,
                                      onSelect: (Country country) {
                                        setState(() {
                                          selectedCountry = country;
                                        });
                                      },
                                    );
                                  },
                                  child: Text(
                                    selectedCountry == null
                                        ? "Selectionner le pays "
                                        : selectedCountry!.displayName + selectedCountry!.flagEmoji,
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      loading
                          ? CircularProgressIndicator()
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 26),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: ElevatedButton(
                                          child: Text(
                                            'S\'inscrire',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontStyle: FontStyle.italic, // fontWeight: FontWeight.bold )
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10), // Adjust the value to change the border radius
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (_formkey.currentState!.validate()) {
                                              if (selectedCountry != null) {
                                                setState(() {
                                                  loading = true;
                                                });
                                                bool check = await AuthServices().signUp(
                                                    email: emailcontroller.text,
                                                    name: nameController.text,
                                                    lastName: lastNameController.text,
                                                    phoneNumber: phoneNumberController.text,
                                                    country: selectedCountry!.flagEmoji + selectedCountry!.displayName,
                                                    password: passWordController.text);

                                                if (check) {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  AuthServices().getUserData().then((value) {
                                                    AuthServices().saveUserLocally(value);

                                                    if (value.role == 'client') {
                                                      Navigator.pushNamed(context, AppRouting.homeClient);
                                                    } else if (value.role == 'admin') {
                                                      Navigator.pushNamed(context, AppRouting.homeAdmin);
                                                    }
                                                  });
                                                } else {
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  SnackBars(
                                                          label: "Email deja existe",
                                                          type: SnackBarsTypes.alert,
                                                          onTap: () {},
                                                          actionLabel: "Fermer",
                                                          context: context)
                                                      .showSnackBar();
                                                }
                                              } else {
                                                SnackBars(
                                                        label: "Pays obligatoire",
                                                        type: SnackBarsTypes.alert,
                                                        onTap: () {},
                                                        actionLabel: "Fermer",
                                                        context: context)
                                                    .showSnackBar();
                                              }
                                            }
                                          }))
                                ],
                              )),
                    ],
                  )))),
    );
  }
}
