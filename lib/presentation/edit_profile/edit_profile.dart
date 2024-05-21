import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonede/presentation/edit_profile/change_name.dart';
import 'package:sonede/presentation/edit_profile/change_password.dart';
import 'package:sonede/presentation/ressources/dimensions/constants.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.indigo, //change your color here
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Parametrage de profil',
          style: TextStyle(
            color: Colors.indigo, //change your color here
          ),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(ChangePassword());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                height: Constants.screenHeight * 0.1,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "changer votre mot de passe",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(ChangeName());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.5), borderRadius: BorderRadius.circular(5)),
                height: Constants.screenHeight * 0.1,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "changer votre nom et prénom",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
