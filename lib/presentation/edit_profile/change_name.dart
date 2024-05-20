import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonede/presentation/components/input_field/input_field.dart';
import 'package:sonede/presentation/ressources/dimensions/constants.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({Key? key}) : super(key: key);

  @override
  State<ChangeName> createState() => _EditProfileState();
}

class _EditProfileState extends State<ChangeName> {
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
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
          'Changer votre nom et prénom',
          style: TextStyle(
            color: Colors.indigo, //change your color here
          ),
        ),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            InputField(label: 'Nom', textInputType: TextInputType.text, controller: nameController),
            InputField(label: 'Prénom', textInputType: TextInputType.text, controller: lastNameController),
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
                            onPressed: () async {
                              var user = GetStorage().read('user');

                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user['uid'])
                                    .update({'name': nameController.text, 'lastName': lastNameController.text});
                                user['name'] = nameController.text;
                                user['lastName'] = lastNameController.text;
                                await GetStorage().write('user', user);
                                setState(() {
                                  loading = false;
                                });
                                final snackBar = SnackBar(
                                  content: const Text('Vous avez changé votre nom et prénom'),
                                  backgroundColor: (Colors.green),
                                  action: SnackBarAction(
                                    label: 'fermer',
                                    textColor: Colors.white,
                                    onPressed: () {},
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
