import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sonede/models/Invoice.dart';
import 'package:sonede/presentation/ressources/colors.dart';
import 'package:sonede/presentation/ressources/dimensions/constants.dart';

class Invoices extends StatefulWidget {
  const Invoices({Key? key}) : super(key: key);

  @override
  State<Invoices> createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
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
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('invoices').snapshots(),
                builder: (context, snapshotData) {
                  if (snapshotData.hasData) {
                    List<Invoice> bc = [];
                    for (var data in snapshotData.data!.docs.toList()) {
                      bc.add(Invoice.fromJson(data.data() as Map<String, dynamic>));
                    }
                    if (bc.isNotEmpty) {
                      return ListView.builder(
                          itemCount: bc.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10), color: AppColors.primary.withOpacity(0.5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection("users").doc(bc[index].userId).snapshots(),
                                      builder:
                                          (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                        if (snapshot.hasData) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Slidable(
                                              key: const ValueKey(0),
                                              startActionPane: ActionPane(
                                                // A motion is a widget used to control how the pane animates.
                                                motion: const ScrollMotion(),

                                                children: [
                                                  SlidableAction(
                                                    backgroundColor: Colors.blue,
                                                    foregroundColor: Colors.white,
                                                    icon: Icons.cancel,
                                                    onPressed: (BuildContext ctx) {},
                                                  ),
                                                  SlidableAction(
                                                    onPressed: (BuildContext ctx) {
                                                      snapshotData.data!.docs[index].reference.delete();
                                                    },
                                                    backgroundColor: Colors.red,
                                                    foregroundColor: Colors.white,
                                                    icon: Icons.delete,
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Nom et Prénom :  ${snapshot.data!.get("name")} ${snapshot.data!.get("lastName")}",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  Text(
                                                    "Email: ${snapshot.data!.get("email")}",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  Text(
                                                    "Date de création :${DateFormat("yyyy/MM/dd").format(bc[index].date)}",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  Text(
                                                    "Facture de : ${bc[index].trimester} trimestre ",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  Text(
                                                    "Code de facture : ${bc[index].uid}",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  Text(
                                                    "Compteur : ${bc[index].counterId}",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Text("");
                                        }
                                      }),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Column(
                          children: [Lottie.asset("assets/lotties/empty.json"), Text("Pas de facture pour le moment ")],
                        ),
                      );
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
    ));
  }
}
