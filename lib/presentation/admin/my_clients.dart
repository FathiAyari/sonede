import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sonede/models/Counter.dart';
import 'package:sonede/models/User.dart';
import 'package:sonede/presentation/admin/add_invoice.dart';
import 'package:sonede/presentation/ressources/colors.dart';

class MyClients extends StatefulWidget {
  const MyClients({Key? key}) : super(key: key);

  @override
  State<MyClients> createState() => _MyClientsState();
}

class _MyClientsState extends State<MyClients> {
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
                  stream: FirebaseFirestore.instance.collection('users').where("role", isEqualTo: "client").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Cuser> bc = [];
                      for (var data in snapshot.data!.docs.toList()) {
                        bc.add(Cuser.fromJson(data.data() as Map<String, dynamic>));
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nom et Prénom :  ${bc[index].name} ${bc[index].lastName}",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        Text(
                                          "Email: ${bc[index].email}",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        Text(
                                          "Date de création :${DateFormat("yyyy/MM/dd").format(bc[index].createdAt!)}",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        Text(
                                          "Téléphone :${bc[index].phoneNumber}",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        Container(
                                          child: ElevatedButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(bc[index].uid)
                                                    .update({"status": bc[index].status == 0 ? 1 : 0});
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: bc[index].status == 0 ? Colors.green : Colors.red,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                              ),
                                              child: bc[index].status == 0
                                                  ? Text(
                                                      "Activer",
                                                      style: TextStyle(color: Colors.white),
                                                    )
                                                  : Text(
                                                      "Désactiver",
                                                      style: TextStyle(color: Colors.white),
                                                    )),
                                          width: double.infinity,
                                        ),
                                        StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(bc[index].uid)
                                                .collection('counters')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                List<Counter> counters = [];
                                                for (var data in snapshot.data!.docs.toList()) {
                                                  counters.add(Counter.fromJson(data.data() as Map<String, dynamic>));
                                                }
                                                if (bc.isNotEmpty) {
                                                  return ExpansionTile(
                                                    title: Text(
                                                      'Les compteurs',
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                    leading: Icon(
                                                      Icons.water_drop_outlined,
                                                      color: Colors.white,
                                                    ),
                                                    children: counters
                                                        .map((e) => ListTile(
                                                              trailing: Icon(
                                                                Icons.add,
                                                                color: Colors.white,
                                                              ),
                                                              onTap: () {
                                                                Get.to(AddInvoice(counterId: e.code));
                                                              },
                                                              title: Text(
                                                                '${e.code}',
                                                                style: TextStyle(color: Colors.white),
                                                              ),
                                                            ))
                                                        .toList(),
                                                  );
                                                } else {
                                                  return Text("");
                                                }
                                              }
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Center(
                          child: Lottie.asset("assets/lotties/empty.json"),
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
      )),
    );
  }
}
