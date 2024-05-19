import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sonede/models/Reclamation.dart';
import 'package:sonede/models/User.dart';
import 'package:sonede/presentation/ressources/colors.dart';

class Reclamations extends StatefulWidget {
  const Reclamations({Key? key}) : super(key: key);

  @override
  State<Reclamations> createState() => _ReclamationsState();
}

class _ReclamationsState extends State<Reclamations> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('reclamations').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Reclamation> bc = [];
                      for (var data in snapshot.data!.docs.toList()) {
                        bc.add(Reclamation.fromJson(data.data() as Map<String, dynamic>));
                      }
                      if (bc.isNotEmpty) {
                        return ListView.builder(
                            itemCount: bc.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10), color: AppColors.primary.withOpacity(0.5)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: StreamBuilder(
                                        stream: FirebaseFirestore.instance.collection("users").doc(bc[index].userId).snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                          Cuser client = Cuser.fromJson(snapshot.data as Map<String, dynamic>);
                                          if (snapshot.hasData) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Nom et Prénom :  ${client.name} ${client.lastName}",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                Text(
                                                  "Email: ${client.email}",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                Text(
                                                  "Compteur: ${bc[index].counterId}",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                Text(
                                                  "Date de création :${DateFormat("yyyy/MM/dd").format(bc[index].date)}",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                Text(
                                                  "Reclamation : ${bc[index].content}",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                              ],
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
                            children: [Lottie.asset("assets/lotties/empty.json"), Text("Pas de reclamation pour le moment ")],
                          ),
                        );
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }),
            ),
          ],
        ),
      )),
    );
  }
}
