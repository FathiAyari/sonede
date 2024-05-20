import 'package:flutter/material.dart';
import 'package:sonede/presentation/components/input_field/input_field.dart';
import 'package:sonede/presentation/ressources/dimensions/constants.dart';
import 'package:sonede/services/AuthServices.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _EditProfileState();
}

class _EditProfileState extends State<ChangeEmail> {
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.indigo, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Changer  votre email',
          style: TextStyle(
            color: Colors.indigo, //change your color here
          ),
        ),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            InputField(label: 'Email', textInputType: TextInputType.emailAddress, controller: emailController),
            InputField(
              label: "Mot de passe",
              controller: passwordController,
              textInputType: TextInputType.visiblePassword,
              prefixWidget: Icon(
                Icons.lock,
                color: Colors.indigo,
              ),
            ),
            Spacer(),
            loading
                ? CircularProgressIndicator()
                : Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.001, horizontal: Constants.screenWidth * 0.07),
                    child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                            onPressed: () {
                              setState(() {
                                loading = true;
                              });
                              if (_formkey.currentState!.validate()) {
                                AuthServices().changeEmail(emailController.text, passwordController.text).then((value) {
                                  setState(() {
                                    loading = false;
                                  });
                                  if (value == "done") {
                                    final snackBar = SnackBar(
                                      content: const Text('Vous avez changé votre email'),
                                      backgroundColor: (Colors.green),
                                      action: SnackBarAction(
                                        label: 'fermer',
                                        textColor: Colors.white,
                                        onPressed: () {},
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  } else {
                                    final snackBar = SnackBar(
                                      content: Text('${value}'),
                                      backgroundColor: (Colors.red),
                                      action: SnackBarAction(
                                        label: 'fermer',
                                        textColor: Colors.white,
                                        onPressed: () {},
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                });
                              }
                            },
                            child: Text(
                              "Changer",
                              style: TextStyle(color: Colors.white),
                            ))),
                  )
          ],
        ),
      ),
    );
  }
}
