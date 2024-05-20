import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:sonede/models/Reclamation.dart';
import 'package:sonede/presentation/client/edit_reclamation.dart';

class PendingReclamations extends StatefulWidget {
  const PendingReclamations({Key? key}) : super(key: key);

  @override
  State<PendingReclamations> createState() => _PendingReclamationsState();
}

class _PendingReclamationsState extends State<PendingReclamations> {
  var user = GetStorage().read("user");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('reclamations')
              .where("userId", isEqualTo: user['uid'])
              .where("status", isEqualTo: 0)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Reclamation> bc = [];
              for (var data in snapshot.data!.docs.toList()) {
                bc.add(Reclamation.fromJson(data.data() as Map<String, dynamic>));
              }
              if (bc.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: bc.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            width: double.infinity,
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue.withOpacity(0.4)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Slidable(
                                  startActionPane: ActionPane(
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
                                          snapshot.data!.docs[index].reference.delete();
                                          Fluttertoast.showToast(
                                            msg: "Reclamation supprimé avec succès",
                                            backgroundColor: Colors.green,
                                          );
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                      ),
                                    ],
                                  ),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.cancel,
                                        onPressed: (BuildContext ctx) {},
                                      ),
                                      SlidableAction(
                                        onPressed: (BuildContext ctx) {
                                          Get.to(EditReclamation(reclamation: bc[index]));
                                        },
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: ReadMoreText(
                                      "${bc[index].content} ",
                                      trimMode: TrimMode.Line,
                                      trimLines: 2,
                                      colorClickableText: Colors.white,
                                      trimCollapsedText: 'Afficher plus',
                                      trimExpandedText: 'Afficher moins',
                                      moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(" Creé le : ${DateFormat("yyyy/MM/dd").format(bc[index].date)} "),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Lottie.asset("assets/lotties/empty.json"), Text("Pas de reclamations en cours")],
                  ),
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
