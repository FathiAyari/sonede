import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sonede/presentation/admin/invoices.dart';
import 'package:sonede/presentation/admin/my_clients.dart';
import 'package:sonede/presentation/admin/reclamations.dart';
import 'package:sonede/presentation/client/profile.dart';
import 'package:sonede/presentation/ressources/colors.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<Widget> pages = [Invoices(), MyClients(), Reclamations(), MyProfile()];
  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.picture_as_pdf,
        ),
        label: "Factures"),
    BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Mes clients"),
    BottomNavigationBarItem(icon: Icon(Icons.data_exploration_outlined), label: "Reclamations"),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile"),
  ];
  int currentIndex = 0;
  Widget positive() {
    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: TextButton(
          onPressed: () {
            exit(0);
          },
          child: Text(
            "Oui",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget negative() {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "Non",
          style: TextStyle(color: Colors.blueAccent),
        ));
  }

  Future<bool> avoidRteurnButton() async {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Vous etes sure de sortir"),
            actions: [
              negative(),
              positive(),
            ],
          );
        });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: avoidRteurnButton,
      child: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.primary,
          selectedLabelStyle: TextStyle(color: AppColors.primary),
          unselectedLabelStyle: TextStyle(color: Colors.cyan),
          unselectedItemColor: Colors.cyan,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          items: items,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
