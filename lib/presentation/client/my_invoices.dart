import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonede/presentation/ressources/colors.dart';
import 'package:sonede/presentation/ressources/dimensions/constants.dart';

class MyInvoices extends StatefulWidget {
  const MyInvoices({Key? key}) : super(key: key);

  @override
  State<MyInvoices> createState() => _MyInvoicesState();
}

class _MyInvoicesState extends State<MyInvoices> {
  var user = GetStorage().read('user');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: Constants.screenHeight * 0.1,
                width: Constants.screenWidth,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.primary.withOpacity(0.5)),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bienvenue  : ${user['name'].toString().toUpperCase()}  ${user['lastName'].toString().toUpperCase()}",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic),
                      ),
                      Spacer(),
                      Image.asset(user['role'] == "admin" ? "assets/images/admin.png" : "assets/images/user.png")
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
